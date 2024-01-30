//
//  ContentView.swift
//  RepositoryExplorer
//
//  Created by Yousuf on 1/30/24.
//

import SwiftUI

struct RepositoryListScreen: View {
    @StateObject private var viewModel = RepositoryListViewModel()
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
        }
        .background(Color.systemGroupedBackground)
    }
}

#Preview {
    RepositoryListScreen()
}
