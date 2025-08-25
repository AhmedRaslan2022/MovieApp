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
}
 
