//
//  RemoteDataSource.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation
import Combine

protocol MoviesRemoteDataSourceProtocol {
    func fetchMovies(page: Int) -> AnyPublisher<MoviesDTO, NetworkError>
}



// MARK: - Remote Data Source Impl

final class MoviesRemoteDataSource: MoviesRemoteDataSourceProtocol {
    private let executor: NetworkExecutor
    
    init(executor: NetworkExecutor = DefaultNetworkExecutor()) {
        self.executor = executor
    }
    
    func fetchMovies(page: Int) -> AnyPublisher<MoviesDTO, NetworkError> {
        let endpoint = MoviesEndpoint<MoviesDTO>(
            path: "3/discover/movie",
            method: .get,
            queryItems: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "include_adult", value: "\(false)")
            ]
        )
        return executor.execute(endpoint)
    }
}
