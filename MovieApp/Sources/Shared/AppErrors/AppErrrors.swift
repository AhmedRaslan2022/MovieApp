//
//  AppErrrors.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//


import Foundation

public enum AppError: LocalizedError {
    case remote(NetworkError)
    case local(DataBaseError)

    public var errorDescription: String? {
        switch self {
        case .remote(let error): return error.errorDescription
        case .local(let error): return error.errorDescription
        }
    }
}
 
