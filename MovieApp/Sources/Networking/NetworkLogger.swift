//
//  NetworkLogger.swift
//  MovieApp
//
//  Created by Rasslan on 25/08/2025.
//

import Foundation
 
struct NetworkLogger {
    static func log(request: URLRequest) {
        #if DEBUG
        print("\n🛰 [REQUEST] -----------------------------")
        if let url = request.url { print("URL: \(url)") }
        if let method = request.httpMethod { print("Method: \(method)") }
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("----------------------------------------\n")
        #endif
    }
    
    static func log(response: URLResponse?, data: Data?) {
        #if DEBUG
        print("\n📡 [RESPONSE] ---------------------------")
        if let httpResponse = response as? HTTPURLResponse {
            print("URL: \(httpResponse.url?.absoluteString ?? "")")
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        if let data = data,
           let bodyString = String(data: data, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("----------------------------------------\n")
        #endif
    }
    
    static func log(error: Error) {
        #if DEBUG
        print("\n❌ [ERROR] ------------------------------")
        print(error.localizedDescription)
        print("----------------------------------------\n")
        #endif
    }
}
