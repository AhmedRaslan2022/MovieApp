//
//  MoviesListViewModelProtocol.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation
import Combine

///MovieList Input & Output
///
typealias MoviesListViewModelType = MoviesListViewModelInput & MoviesListViewModelOutput &
MoviesListViewModelActions

///MovieList ViewModel Input
///
///
@MainActor
protocol MoviesListViewModelInput {
    func viewDidLoad()
}

///MovieList ViewModel Output
///
@MainActor
protocol MoviesListViewModelOutput {
    var viewState: CurrentValueSubject<MoviesListViewState, Never> {get}
 }


///MovieListViewModelActions
///
@MainActor
protocol MoviesListViewModelActions {
    func refresh()
    func favWasPressed(movieId: Int)
    func navigateToMovieDetails(movieId: Int)
}


enum MoviesListViewState : Equatable{
    case loading
    case empty
    case error(String)
    case populated([MovieCellViewModel])
    
    
    static func == (lhs: MoviesListViewState, rhs: MoviesListViewState) -> Bool {
           switch (lhs, rhs) {
           case (.loading, .loading):
               return true
           case let (.error(lMsg), .error(rMsg)):
               return lMsg == rMsg
           case let (.populated(lMovies), .populated(rMovies)):
               return lMovies == rMovies
           default:
               return false
           }
       }
}
