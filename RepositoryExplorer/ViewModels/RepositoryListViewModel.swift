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
    @Published var shortingProcess = SortingProcess.desc

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
    }

    func getRepos(pageNumber: Int) async {
        do {
            let data = try await repository.getRepositoryList(
                for: .getAllProduct(
                    page: pageNumber,
                    perPage: 10,
                    sort: sortBy.rawValue,
                    order: shortingProcess.rawValue
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

    func sortRepos(sortBy: SortBy, shortingProcess: SortingProcess) async {
        self.sortBy = sortBy
        self.shortingProcess = shortingProcess
        repositorys.removeAll()
        await getRepos(pageNumber: 1)
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
