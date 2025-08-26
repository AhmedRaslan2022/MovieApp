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
    
    init(remote: MoviesRemoteDataSourceProtocol) {
        self.remote = remote
    }
    
    func fetchMovies(page: Int) -> AnyPublisher<MoviesListEntity, AppError> {
        return remote.fetchMovies(page: page)
            .map { MoviesMapper.map($0) }                
            .mapError { AppError.remote($0) }
            .eraseToAnyPublisher()
    }
    
    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError> {
        // TODO: implement local update
        return Fail(error: AppError.local(.updateError))
            .eraseToAnyPublisher()
    }
}

