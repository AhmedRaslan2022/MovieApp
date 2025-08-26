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
    
    func fetchMovies(page: Int) -> AnyPublisher<[MovieEntity], AppError> {
        return remote.fetchMovies(page: page)
            .mapError { AppError.remote(($0 as NetworkError)) }
            .map { dto in
                dto.results.map { movieDTO in
                    return MovieMapper.map(movieDTO)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - TODO: Implement saving favorite status to local data source
    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError> {
        return Fail(error: AppError.local(.updateError))
            .eraseToAnyPublisher()
    }
 
}
