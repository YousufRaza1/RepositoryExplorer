
//
//  ApiEndpoint.swift
//  CodeForces
//
//  Created by Yousuf on 9/30/23.
//

import Foundation
import SwiftUI

protocol Endpoint {
    var httpMethod: HttpMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: Any]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    // a default extension that creates the full URL
    var url: String {
        return baseURLString + path
    }
}

enum EndpointCases: Endpoint {
    case getAllProduct(
        page: Int,
        perPage: Int,
        sort: String,
        order: String
    )
    case none

    var httpMethod: HttpMethod {
        switch self {
        case .getAllProduct:
            return .get
        default:
            return .get
        }
    }

    var baseURLString: String {
        switch self {
        default:
            return "https://api.github.com"
        }
    }

    var path: String {
        switch self {
        case let .getAllProduct(page, perPage, sort, order):
            return "/search/repositories?q=iOS&page=\(page)&per_page=\(perPage)&sort=\(sort)&order=\(order)"
        default:
            return ""
        }
    }

    var headers: [String: Any]? {
        return nil
    }

    var body: [String: Any]? {
        return nil
    }
}

// enum Response<T: Codable> {
//    case error(details: AFError)
//    case success(data: T)
// }
