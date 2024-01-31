//
//  ContentView.swift
//  RepositoryExplorer
//
//  Created by Yousuf on 1/30/24.
//

import SwiftUI

struct RepositoryListScreen: View {
    @StateObject private var viewModel = RepositoryListViewModel()
    @State var pageNumber = 1
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.repositorys) { repo in
                        RepoItemView(repo: repo)
                            .padding(.vertical, 1)
                    }
                }
                .padding(16)
            }
            .simultaneousGesture(
                DragGesture().onChanged {
                    let isScrollDown = $0.translation.height < 0
                    if isScrollDown {
                        Task {
                            self.pageNumber += 1
                            await viewModel.getRepos(pageNumber: pageNumber)
                        }
                    }
                })
        }
        .navigationTitle("Repository List")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.systemGroupedBackground)
    }
}

#Preview {
    RepositoryListScreen()
}
