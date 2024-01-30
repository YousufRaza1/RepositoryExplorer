//
//  NetworkManager.swift
//  RepositoryExplorer
//
//  Created by Yousuf on 1/30/24.
//

import Foundation

enum DataSource {
    static func fetch<T: Decodable>(api: Endpoint, type: T.Type) async throws -> T {
        var request = URLRequest(url: URL(string: api.url)!)
        request.httpMethod = api.httpMethod.rawValue

        let (data, response) = try await URLSession.shared.data(for: request)

        let decodedData = try JSONDecoder().decode(type, from: data)

        print(decodedData)
        return decodedData
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "Delete"
    case patch = "Patch"
    case put = "Put"
}
