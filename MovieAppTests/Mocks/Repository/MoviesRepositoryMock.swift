//
//  MoviesRepositoryMock.swift
//  MovieApp
//
//  Created by AAIT on 30/08/2025.
//

import XCTest
import Combine
@testable import MovieApp

 

// MARK: - Mock Repository
final class MockMoviesRepository: MoviesRepositoryProtocol {
    
    var result: Result<MoviesListEntity, AppError>?
    var favResult: Result<Void, AppError>?
    
    func fetchMovies(page: Int) -> AnyPublisher<MoviesListEntity, AppError> {
        guard let result = result else {
            return Fail(error: AppError.remote(.unknown(NSError(domain: "no result", code: -1))))
                .eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
    
    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError> {
        guard let favResult = favResult else {
            return Fail(error: AppError.remote(.unknown(NSError(domain: "no result", code: -1))))
                .eraseToAnyPublisher()
        }
        return favResult.publisher.eraseToAnyPublisher()
    }
}
