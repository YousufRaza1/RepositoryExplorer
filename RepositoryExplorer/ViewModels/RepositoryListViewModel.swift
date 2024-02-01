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
    @Published var sortingIndex: Int = 1
    @Published var pageNaumber = 1
    @Published var loadedPages: [Int] = []

    let repository: Repository

    nonisolated init(
        repository: Repository = Repository(
            cache: DiskCache<RepositoryResponse>(
                filename: "repository_list",
                expirationInterval: 30 * 60 // cache persistance 30 min
            )
        )
    ) {
        self.repository = repository
        NetworkMonitor.shared.startMonitoring()
    }

    func initDefault() {
        if let sortingIndex = UserDefaults.standard.object(forKey: "sortingIndex") as? Int {
            self.sortingIndex = sortingIndex
            print("init user default")
        } else {
            UserDefaults.standard.setValue(sortingIndex, forKey: "sortingIndex")
            print("set newValue")
        }
    }

    func getRepos() async {
        if !loadedPages.contains(pageNaumber) {
            loadedPages.append(pageNaumber)
            do {
                let data = try await repository.getRepositoryList(
                    for: .getAllProduct(
                        page: pageNaumber,
                        perPage: 10,
                        sort: sortBy.rawValue,
                        order: sortingProcess.rawValue
                    )
                )

                let newReposotories = data?.items ?? []
                repositorys.append(contentsOf: newReposotories)

                state = .success
                pageNaumber += 1

            } catch {
                loadedPages.removeAll { $0 == pageNaumber }
                print(error.localizedDescription)
                state = .failure(error: error.localizedDescription)
            }
        }

        if repositorys.count == 0 {
            state = .empty
        }
    }

    func sortRepos(sortBy: SortBy, sortingProcess: SortingProcess) async {
        self.sortBy = sortBy
        self.sortingProcess = sortingProcess
        repositorys.removeAll()
        pageNaumber = 1
        loadedPages.removeAll()
        await getRepos()

        if sortBy == .stars, sortingProcess == .asc {
            sortingIndex = 1
        } else if sortBy == .stars, sortingProcess == .desc {
            sortingIndex = 2
        } else if sortBy == .updated, sortingProcess == .asc {
            sortingIndex = 3
        } else {
            sortingIndex = 4
        }

        UserDefaults.standard.setValue(sortingIndex, forKey: "sortingIndex")
        print("set newValue")
    }

    func retry() async {
        state = .loading
        repositorys.removeAll()
        pageNaumber = 1
        loadedPages.removeAll()
        await getRepos()
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
