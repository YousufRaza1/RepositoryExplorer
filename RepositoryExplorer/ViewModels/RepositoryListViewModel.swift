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
            await self.getRepos()
        }
    }

    func getRepos() async {
        do {
            let data = try await DataSource.fetch(
                api: EndpointCases.getAllProduct(
                    page: 1,
                    perPage: 10,
                    sort: "updated",
                    order: "asc"
                ),
                type: RepositoryResponse.self
            )

            if let repositorys = data.items {
                self.repositorys = repositorys
            }

        } catch {
            print(error.localizedDescription)
        }
    }
}
