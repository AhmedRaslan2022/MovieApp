//
//  MoviesDI.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation
import UIKit

// MARK: - Movies DI Container
@MainActor
final class MoviesDIContainer: MoviesDependencies {
    
    
    private let networkExecutor: NetworkExecutor
 
    init(networkExecutor: NetworkExecutor = DefaultNetworkExecutor()) {
        self.networkExecutor = networkExecutor
    }
    
    // MARK: - Data Sources
    
    func makeRemoteDataSource() -> MoviesRemoteDataSourceProtocol {
        return MoviesRemoteDataSource(executor: networkExecutor)
    }
    
    func makeLocalDataSource() -> MoviesLocalDataSourceProtocol {
        return MoviesLocalDataSource()
    }
    
    // MARK: - Repository
    
    func makeRepository() -> MoviesRepositoryProtocol {
        return MoviesRepository(
            remote: makeRemoteDataSource(), local: makeLocalDataSource())
    }
    
    // MARK: - Use Cases
    
    func makeFetchMoviesUseCase() -> FetchMoviesUseCaseProtocol {
        return FetchMoviesUseCase(repository: makeRepository())
    }
    
    func makeSetFavouriteUseCase() -> UpdateFavouriteUseCaseProtocol {
        return UpdateFavouriteUseCase(repository: makeRepository())
    }
    
     
    
    // MARK: - ViewControllers
    
    func makeMoviesListViewController(coordinator: any MoviesCoordinatorProtocol) -> MoviesListViewController {
        let vm = MoviesListViewModel(
            coordinator: coordinator,
            fetchMoviesUseCase: makeFetchMoviesUseCase(),
            favMovieUseCase: makeSetFavouriteUseCase()
        )
        let vc = MoviesListViewController(viewModel: vm)
        return vc
    }
    
    func makeMovieDetailsViewController(movie: MovieEntity) -> MovieDetailsViewController {
        let vm = MovieDetailsViewModel(movie: movie, favMovieUseCase: makeSetFavouriteUseCase())
        let vc = MovieDetailsViewController(viewModel: vm)
        return vc
    }
}
