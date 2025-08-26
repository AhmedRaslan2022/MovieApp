//
//  MoviesCoordinator.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import UIKit
 
@MainActor
public class MoviesCoordinator: MoviesCoordinatorProtocol {

    public  let navigationController: UINavigationController
    private let dependencies: MoviesDependencies
    
    // MARK: - Initializer
    
     init(navigationController: UINavigationController , dependencies: MoviesDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        navigateToMoviesList()
    }
    
    
 
    
    func navigate(to step: MoviesStep) {
        switch step {
        case .moviesList:
            navigateToMoviesList()
        case .movieDetails(movie: let movie):
            break
        }
    }
    
    
    fileprivate func navigateToMoviesList() {
        let vc = dependencies.makeMoviesListViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
