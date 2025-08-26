//
//  LocalDataSource.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Combine

protocol MoviesLocalDataSourceProtocol {
     func setMovieFavStatus(movieId: Int, isFavourite: Bool)-> AnyPublisher<MovieEntity, Error>
}
