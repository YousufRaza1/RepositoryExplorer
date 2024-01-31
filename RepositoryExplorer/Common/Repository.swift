
//
//  RepositoryExplorer
//
//  Created by Yousuf on 1/30/24.
//

import Foundation

class Repository {
    private let cache: DiskCache<RepositoryResponse>
    private var isFirstTime = true

    init(
        cache: DiskCache<RepositoryResponse>
    ) {
        self.cache = cache
    }

    func getRepositoryList(for endPoint: EndpointCases) async throws -> RepositoryResponse? {
        if isFirstTime {
            isFirstTime = false
            try await cache.saveToDisk()

            try await cache.loadFromDisk()
        }

        if Task.isCancelled { return nil }

        let result: RepositoryResponse?

        if shouldLoadFromNetwork() {
            result = try await DataSource.fetch(api: endPoint, type: RepositoryResponse.self)

            if Task.isCancelled { return nil }

            await cache.removeValue(forKey: endPoint.keyForCache)
            await cache.setValue(result, forKey: endPoint.keyForCache)

            print("CACHE SET")

            try await cache.saveToDisk()

            print("CACHE SET TO DISK")

        } else {
            result = await cache.value(forKey: endPoint.keyForCache)

            print("CACHE HIT")
        }

        return result
    }

    private func shouldLoadFromNetwork() -> Bool {
        return NetworkMonitor.shared.isReachable
    }
}
