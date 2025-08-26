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
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingError(let error): return "Data parsing error: \(error.localizedDescription)"
        case .serverError(let code): return "Server error with code \(code)"
        case .unknown(let error): return "Unknown error: \(error.localizedDescription)"
        }
    }
    
}
