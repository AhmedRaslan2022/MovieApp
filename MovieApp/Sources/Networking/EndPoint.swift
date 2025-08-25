//
//  EndPoint.swift
//  MovieApp
//
//  Created by Rasslan on 25/08/2025.
//


import Foundation

public protocol Endpoint {
    associatedtype Response: Codable
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethodType { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

public extension Endpoint {
    var urlRequest: URLRequest? {
        guard let url = URL(string: baseURL + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
