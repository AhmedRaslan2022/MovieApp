//
//  FavouriteUseCase.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//


import Combine


protocol UpdateFavouriteUseCaseProtocol {
    func execute(movieID: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError>
}

final class UpdateFavouriteUseCase: UpdateFavouriteUseCaseProtocol {
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(movieID: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError> {
        repository.setMovieFavStatus(movieId: movieID, isFavourite: isFavourite)
    }
}
 
 
