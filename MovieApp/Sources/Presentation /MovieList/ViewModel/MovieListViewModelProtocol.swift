//
//  MovieListViewModelProtocol.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation
import Combine

///MovieList Input & Output
///
typealias MovieListViewModelType = MovieListViewModelInput & MovieListViewModelOutput &
MovieListViewModelActions

///MovieList ViewModel Input
///
///
@MainActor
protocol MovieListViewModelInput {
    func viewDidLoad()
}

///MovieList ViewModel Output
///
@MainActor
protocol MovieListViewModelOutput {
    var viewState: PassthroughSubject<MovieListViewState, Never> {get}
 }


///MovieListViewModelActions
///
@MainActor
protocol MovieListViewModelActions {
    func refresh()
    func favWasPressed(movieId: Int)
}


enum MovieListViewState {
    case loading
    case error(String)
    case populated([MovieCellViewModel])
}
