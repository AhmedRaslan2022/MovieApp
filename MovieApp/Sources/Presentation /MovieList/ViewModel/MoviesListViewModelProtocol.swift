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
    var viewState: PassthroughSubject<MoviesListViewState, Never> {get}
 }


///MovieListViewModelActions
///
@MainActor
protocol MoviesListViewModelActions {
    func refresh()
    func favWasPressed(movieId: Int)
    func navigateToMovieDetails(movieId: Int)
}


enum MoviesListViewState {
    case loading
    case error(String)
    case populated([MovieCellViewModel])
}
