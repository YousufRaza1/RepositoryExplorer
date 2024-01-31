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
                                    shortingProcess: .asc
                                )
                            }

                        } label: {
                            Text("Star Ascending")
                        }

                        Button {
                            Task {
                                await viewModel.sortRepos(
                                    sortBy: .stars,
                                    shortingProcess: .desc
                                )
                            }
                        } label: {
                            Text("Star Descending")
                        }

                        Button {
                            Task {
                                await viewModel.sortRepos(
                                    sortBy: .updated,
                                    shortingProcess: .asc
                                )
                            }
                        } label: {
                            Text("Updated Ascending")
                        }

                        Button {
                            Task {
                                await viewModel.sortRepos(
                                    sortBy: .updated,
                                    shortingProcess: .desc
                                )
                            }
                        } label: {
                            Text("Updated Descending")
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.getRepos(pageNumber: 1)
                }
            }
        }
    }
}

#Preview {
    RepositoryListScreen()
}
