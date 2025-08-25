//
//  FetchMoviesUseCase.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Combine

protocol FetchMoviesUseCaseProtocol {
    func execute(page: Int) -> AnyPublisher<[MovieEntity], Error>
}
