//
//  MoviesRepositoryProtocol.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Combine

protocol MoviesRepositoryProtocol {
    func fetchMovies(page: Int) -> AnyPublisher<[MovieEntity], Error>
    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<MovieEntity, Error>
}

