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
                    Text("\(error), ")
                        .padding()
                    
                case .empty:
                    Text("There are no repository right now")
                    
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
            .navigationTitle("Repository List")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.systemGroupedBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort by") {
                        Button {
                            //
                        } label: {
                            Text("Name asc")
                        }

                        Button {
                            //
                        } label: {
                            Text("Name desc")
                        }

                        Button {
                            //
                        } label: {
                            Text("last update asc")
                        }

                        Button {
                            //
                        } label: {
                            Text("last update desc")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RepositoryListScreen()
}
