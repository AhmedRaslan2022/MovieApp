//
//  DataBaseError.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation

public enum DataBaseError: LocalizedError {
    case savingError
    case fetchError
    case deleteError
    case updateError
    case notFound

   public var errorDescription: String? {
        switch self {
        case .savingError: return "savingError"
        case .fetchError: return "fetchError"
        case .deleteError: return "deleteError"
        case .updateError: return "updateError"
        case .notFound: return "NotFoundError"

        }
    }
}
