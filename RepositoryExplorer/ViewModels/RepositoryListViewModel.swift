//
//  RepositoryListViewModel.swift
//  RepositoryExplorer
//
//  Created by Yousuf on 1/30/24.
//

import Foundation

@MainActor
class RepositoryListViewModel: ObservableObject {
    @Published var repositorys: [RepoItem] = []
    @Published var state: UIState = .loading
    @Published var sortBy = SortBy.stars
    @Published var sortingProcess = SortingProcess.desc
    @Published var sortingIndex = 1

    let repository: Repository

    nonisolated init(
        repository: Repository = Repository(
            cache: DiskCache<RepositoryResponse>(
                filename: "repository_list",
                expirationInterval: 3 * 60
            )
        )
    ) {
        self.repository = repository
        NetworkMonitor.shared.startMonitoring()
    }

    func getRepos(pageNumber: Int) async {
        do {
            let data = try await repository.getRepositoryList(
                for: .getAllProduct(
                    page: pageNumber,
                    perPage: 10,
                    sort: sortBy.rawValue,
                    order: sortingProcess.rawValue
                )
            )

            let newReposotories = data?.items ?? []
            repositorys.append(contentsOf: newReposotories)

            state = .success

        } catch {
            print(error.localizedDescription)
            state = .failure(error: error.localizedDescription)
        }

        if repositorys.count == 0 {
            state = .empty
        }
    }

    func sortRepos(sortBy: SortBy, sortingProcess: SortingProcess) async {
        self.sortBy = sortBy
        self.sortingProcess = sortingProcess
        repositorys.removeAll()
        await getRepos(pageNumber: 1)

        if sortBy == .stars, sortingProcess == .asc {
            sortingIndex = 1
        } else if sortBy == .stars, sortingProcess == .desc {
            sortingIndex = 2
        } else if sortBy == .updated, sortingProcess == .asc {
            sortingIndex = 3
        } else {
            sortingIndex = 4
        }
    }

    func retry() async {
        state = .loading
        repositorys.removeAll()
        await getRepos(pageNumber: 1)
    }
}

enum SortBy: String {
    case stars
    case updated
}

enum SortingProcess: String {
    case asc
    case desc
}
