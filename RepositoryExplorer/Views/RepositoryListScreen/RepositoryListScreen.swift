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
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()

                case .failure(let error):
                    VStack {
                        Text("\(error)")
                            .padding()

                        Button {
                            Task {
                                await viewModel.retry()
                            }
                        } label: {
                            Text("Retry")
                        }
                    }
                    .padding()

                case .empty:
                    VStack {
                        Text("There are no repository right now")

                        Button {
                            Task {
                                await viewModel.retry()
                            }
                        } label: {
                            Text("Retry sometime later")
                        }
                    }

                case .success:
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.repositorys) { repo in
                                NavigationLink {
                                    RepoDetailsScreen(item: repo)
                                } label: {
                                    RepoItemView(repo: repo)
                                        .padding(.vertical, 1)
                                }
                            }
                        }
                        .multilineTextAlignment(.leading)
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
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Repository List")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.systemGroupedBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort by") {
                        Button {
                            Task {
                                await viewModel.sortRepos(
                                    sortBy: .stars,
                                    sortingProcess: .asc
                                )
                            }

                        } label: {
                            HStack {
                                Text("Star Ascending")
                                Spacer()
                                if viewModel.sortingIndex == 1 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }

                        Button {
                            Task {
                                await viewModel.sortRepos(
                                    sortBy: .stars,
                                    sortingProcess: .desc
                                )
                            }
                        } label: {
                            HStack {
                                Text("Star Descending")
                                Spacer()
                                if viewModel.sortingIndex == 2 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }

                        Button {
                            Task {
                                await viewModel.sortRepos(
                                    sortBy: .updated,
                                    sortingProcess: .asc
                                )
                            }
                        } label: {
                            HStack {
                                Text("Updated Ascending")
                                Spacer()
                                if viewModel.sortingIndex == 3 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }

                        Button {
                            Task {
                                await viewModel.sortRepos(
                                    sortBy: .updated,
                                    sortingProcess: .desc
                                )
                            }
                        } label: {
                            HStack {
                                Text("Updated Descending")
                                Spacer()
                                if viewModel.sortingIndex == 4 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            .task {
                viewModel.initDefault()
                await viewModel.getRepos(pageNumber: 1)
            }
        }
    }
}

#Preview {
    RepositoryListScreen()
}
