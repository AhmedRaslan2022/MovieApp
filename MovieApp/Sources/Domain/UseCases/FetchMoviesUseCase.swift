//
//  FetchMoviesUseCase.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Combine

protocol FetchMoviesUseCaseProtocol {
    func execute(page: Int) -> AnyPublisher<[MovieEntity], AppError>
}


final class FetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int) -> AnyPublisher<[MovieEntity], AppError> {
       return  repository.fetchMovies(page: page)
    }
}
