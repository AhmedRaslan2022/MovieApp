//
//  FavouriteUseCase.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//


import Combine


protocol UpdateFavouriteUseCaseProtocol {
    func execute(for movie: MovieEntity, isFavourite: Bool) -> AnyPublisher<MovieEntity, Error>
}

final class UpdateFavouriteUseCase: UpdateFavouriteUseCaseProtocol {
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(for movie: MovieEntity, isFavourite: Bool) -> AnyPublisher<MovieEntity, Error> {
        repository.setMovieFavStatus(movieId: movie.id, isFavourite: isFavourite)
    }
}
 
 
