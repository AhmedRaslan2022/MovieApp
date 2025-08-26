//
//  CoordinatorDependencies.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

@MainActor
protocol MoviesCoordinatorProtocol: UIKitNavigationCoordinator {
    func navigate(to step: MoviesStep)
}
// MARK: - Coordinator Dependencies
@MainActor
protocol MoviesDependencies {
    func makeMoviesListViewController(coordinator: MoviesCoordinatorProtocol) -> MoviesListViewController
    func makeMovieDetailsViewController(movie: MovieEntity) -> MovieDetailsViewController
}

// MARK: - MoviesSteps
 enum MoviesStep: Step {
    case moviesList
    case movieDetails(movie: MovieEntity)
}
