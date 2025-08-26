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
    var queryItems: [URLQueryItem]? { get }
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


public struct MoviesEndpoint<Response: Codable>: Endpoint {
 
    public let baseURL: String = NetworkConfig.baseUrl
    public let path: String
    public let method: HTTPMethodType
    public let headers: [String: String]? =  [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(NetworkConfig.apiKey)"
    ]
    public let body: Data?
    public let queryItems: [URLQueryItem]?
    
    init(path: String,
         method: HTTPMethodType ,
         queryItems: [URLQueryItem]? = nil,
         body: Data? = nil) {
        
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
     }
    
    var urlRequest: URLRequest? {
        guard var components = URLComponents(string: baseURL + path) else { return nil }
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
 
