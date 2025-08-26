//
//  MoviesRepositoryProtocol.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Combine

protocol MoviesRepositoryProtocol {
    func fetchMovies(page: Int) -> AnyPublisher<MoviesListEntity, AppError>
    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError>
}

