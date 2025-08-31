//
//  MoviesLocalDataSourceMock.swift
//  MovieApp
//
//  Created by AAIT on 30/08/2025.
//

import XCTest
import Combine
@testable import MovieApp

// MARK: - Mock Local Data Source
final class MockMoviesLocalDataSource: MoviesLocalDataSourceProtocol {
    var fetchResult: Result<MoviesListEntity, AppError> = .failure(.remote(.invalidURL))
    var saveResult: Result<Void, AppError> = .success(())
    var favResult: Result<Void, AppError> = .success(())

    func fetchMovies(page: Int) -> AnyPublisher<MoviesListEntity, AppError> {
        return fetchResult.publisher.eraseToAnyPublisher()
    }

    func saveMovies(_ entity: MoviesListEntity) -> AnyPublisher<Void, AppError> {
        return saveResult.publisher.eraseToAnyPublisher()
    }

    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError> {
        return favResult.publisher.eraseToAnyPublisher()
    }
}
