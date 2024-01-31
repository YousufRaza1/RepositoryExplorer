//
//  RepoDetailsScreen.swift
//  RepositoryExplorer
//
//  Created by Yousuf on 1/31/24.
//

import SwiftUI

struct RepoDetailsScreen: View {
    private let item: RepoItem
    
    init(item: RepoItem) {
        self.item = item
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    if let url = item.owner?.avatarURL {
                        AsyncImage(url: URL(string: url)) { image in
                            image
                                .resizable()
                                .frame(width: 45, height: 45)
                                .scaledToFit()
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .strokeBorder(
                                            .gray.opacity(0.5),
                                            lineWidth: 1
                                        )
                                }
                               
                        } placeholder: {}
                    } else {
                        Image("github-mark")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .contentShape(Circle())
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .strokeBorder(
                                        .gray.opacity(0.5),
                                        lineWidth: 1
                                    )
                            }
                    }
                 
                    Text(item.name ?? "Unknown Name")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.label)
                        .lineLimit(1)
                }
                .accessibilityElement(children: .combine)
                
                Text(item.language ?? "Unknown language")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.label)
                    .multilineTextAlignment(.leading)
                
                Text(item.description ?? "")
                    .font(.body)
                    .foregroundColor(.label)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 6) {
                    Image(systemName: "star")
                    
                    Text("\(item.stargazersCount ?? 0) stars")
                        .padding(.trailing, 6)

                    Image(systemName: "arrow.triangle.branch")
                  
                    Text("\(item.forksCount ?? 0) forks")
                        .padding(.trailing, 6)
                    
                    Link(destination: URL(string: item.htmlURL ?? "https://github.com")!, label: {
                        Text("GitHub")
                            .foregroundColor(.blue)
                    })
                }
                .font(.body)
                .foregroundColor(.label.opacity(0.85))
                
                HStack(spacing: 6) {
                    Image(systemName: "eye")
                    
                    Text("\(item.watchers ?? 0) watchers")
                        .padding(.trailing, 6)
                    
                    Image(systemName: "thermometer.sun")
                        .foregroundColor(.systemRed)
                    
                    Text("\(item.openIssuesCount ?? 0) open issues")
                        .padding(.trailing, 6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}
