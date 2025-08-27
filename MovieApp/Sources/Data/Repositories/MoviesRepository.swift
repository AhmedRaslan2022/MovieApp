//
//  MoviesRepository.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation
import Combine

final class MoviesRepository: MoviesRepositoryProtocol {
    private let remote: MoviesRemoteDataSourceProtocol
    private let local: MoviesLocalDataSourceProtocol

    init(remote: MoviesRemoteDataSourceProtocol, local: MoviesLocalDataSourceProtocol) {
        self.remote = remote
        self.local = local
    }

    func fetchMovies(page: Int) -> AnyPublisher<MoviesListEntity, AppError> {
        local.fetchMovies(page: page)
            .catch { error -> AnyPublisher<MoviesListEntity, AppError> in
                guard case .local(.notFound) = error else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                
                return self.remote.fetchMovies(page: page)
                    .mapError { AppError.remote($0) }
                    .map(MoviesMapper.map)
                    .flatMap { entity in
                        self.local.saveMovies(entity)
                            .map { entity }
                            .mapError { _ in AppError.local(.savingError) }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError> {
        local.setMovieFavStatus(movieId: movieId, isFavourite: isFavourite)
    }
}
