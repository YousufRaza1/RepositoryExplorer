//
//  RepoItemView.swift
//  RepositoryExplorer
//
//  Created by Yousuf on 1/31/24.
//

import SwiftUI

struct RepoItemView: View {
    private let repo: RepoItem

    init(repo: RepoItem) {
        self.repo = repo
    }

    private var ownerName: String {
        let str = repo.fullName ?? "/"
        let parts = str.split(separator: "/")

        if parts.count == 2 {
            let firstPart = String(parts[0])
            return firstPart
        } else {
            return ""
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(ownerName)
                Spacer()
                Text(repo.getPushedAt(), style: .date)
            }

            Text(repo.name ?? "Unknown name")
                .font(.headline)
                .bold()

            Text(repo.description ?? "Empty description")
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            HStack {
                Image(systemName: "star")

                Text("\(repo.stargazersCount ?? 0)")
                    .padding(.trailing, 8)

                Image(systemName: "circle.fill")
                    .foregroundColor(.systemOrange)

                Text(repo.language ?? "Unknown")
            }
        }
        .foregroundColor(.label)
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(8)
    }
}

// #Preview {
//    RepoItemView(repo: <#T##RepoItem#>)
// }
