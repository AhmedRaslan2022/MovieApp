//
//  NetworkLogger.swift
//  MovieApp
//
//  Created by Rasslan on 25/08/2025.
//

import Foundation


enum NetworkLogger {
    
    // MARK: - Request
    static func log(request: URLRequest) {
        #if DEBUG
        print("\n🛰 [REQUEST] =============================")
        
        if let url = request.url {
            print("\n\n➡️ URL:\n\(url)\n")
            
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems, !queryItems.isEmpty {
                print("\n\n➡️ QUERY PARAMETERS:")
                for item in queryItems {
                    print("   \(item.name): \(item.value ?? "nil")")
                }
                print("")
            }
        }
        
        if let method = request.httpMethod {
            print("\n\n➡️ METHOD:\n\(method)\n")
        }
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("\n\n➡️ HEADERS:\n\(headers)\n")
        }
        
        if let body = request.httpBody, !body.isEmpty {
            print("\n\n➡️ BODY:")
            print(prettyJSONString(from: body) ?? String(data: body, encoding: .utf8) ?? "⚠️ Cannot decode body")
            print("")
        }
        
        print("=========================================\n")
        #endif
    }
    
    // MARK: - Response
    static func log(response: URLResponse?, data: Data?) {
        #if DEBUG
        print("\n📡 [RESPONSE] ===========================")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("\n\n⬅️ URL:\n\(httpResponse.url?.absoluteString ?? "")\n")
            print("\n\n⬅️ STATUS CODE:\n\(httpResponse.statusCode)\n")
            print("\n\n⬅️ HEADERS:\n\(httpResponse.allHeaderFields)\n")
        }
        
        if let data = data, !data.isEmpty {
            print("\n\n⬅️ BODY:")
            print(prettyJSONString(from: data) ?? String(data: data, encoding: .utf8) ?? "⚠️ Cannot decode response body")
            print("")
        }
        
        print("=========================================\n")
        #endif
    }
    
    // MARK: - Error
    static func log(error: Error) {
        #if DEBUG
        print("\n❌ [ERROR] ===============================")
        print("\n\n\(error.localizedDescription)\n")
        print("=========================================\n")
        #endif
    }
    
    // MARK: - JSON Helper
    private static func prettyJSONString(from data: Data) -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return nil
        }
        return prettyString
    }
}
