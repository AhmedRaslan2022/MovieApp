//
//  NetworkError.swift
//  MovieApp
//
//  Created by Rasslan on 25/08/2025.
//


import Foundation

public enum NetworkError: Error {
    case invalidURL
    case decodingError(Error)
    case serverError(Int)
    case unknown(Error)
    
public  var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingError(let error): return "Data parsing error: \(error.localizedDescription)"
        case .serverError(let code): return "Server error with code \(code)"
        case .unknown(let error): return "Unknown error: \(error.localizedDescription)"
        }
    }
    
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.serverError(let lcode), .serverError(let rcode)):
            return lcode == rcode
        case (.decodingError, .decodingError):
            return true
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
