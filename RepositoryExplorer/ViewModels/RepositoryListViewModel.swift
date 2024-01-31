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

    nonisolated init() {
        Task {
            await self.getRepos(pageNumber: 1)
        }
    }

    func getRepos(pageNumber: Int) async {
        do {
            let data = try await DataSource.fetch(
                api: EndpointCases.getAllProduct(
                    page: pageNumber,
                    perPage: 10,
                    sort: "updated",
                    order: "asc"
                ),
                type: RepositoryResponse.self
            )
            let newReposotories = data.items ?? []
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
}
