//
//  MoviesRemoteDataSourceMock.swift
//  MovieApp
//
//  Created by AAIT on 30/08/2025.
//

import XCTest
import Combine
@testable import MovieApp

final class MockMoviesRemoteDataSource: MoviesRemoteDataSourceProtocol {
    var result: Result<MoviesDTO, NetworkError>?

    func fetchMovies(page: Int) -> AnyPublisher<MoviesDTO, NetworkError> {
        return result!.publisher.eraseToAnyPublisher()
    }
}
