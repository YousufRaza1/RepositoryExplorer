//
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
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        switch response.statusCode {
        case 200 ... 299:
            let decodedData = try JSONDecoder().decode(type, from: data)
           // print(decodedData)

            return decodedData
        default:
            print(response)
            throw generateError(description: "A server error occured")
        }
    }
}

private func generateError(code: Int = 1, description: String) -> Error {
    NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
}


