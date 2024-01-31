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
            self.repositorys += newReposotories

        } catch {
            print(error.localizedDescription)
        }
    }
}
