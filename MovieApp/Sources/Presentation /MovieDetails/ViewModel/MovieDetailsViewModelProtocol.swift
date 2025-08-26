//
//  MovieDetailsViewModelProtocol.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation
import Combine

///MovieList Input & Output
///
typealias MovieDetailsViewModelType = MovieDetailsViewModelInput & MovieDetailsViewModelOutput &
MovieDetailsViewModelActions

///MovieList ViewModel Input
///
///
@MainActor
protocol MovieDetailsViewModelInput {
    func viewDidLoad()
}

///MovieList ViewModel Output
///
@MainActor
protocol MovieDetailsViewModelOutput {
    var viewState: CurrentValueSubject<MovieDetailsViewState, Never> {get}
 }


///MovieListViewModelActions
///
@MainActor
protocol MovieDetailsViewModelActions {
     func favWasPressed(movieId: Int)
}


enum MovieDetailsViewState : Equatable{
    case loading
    case error(String)
    case populated(MovieDetailsState)
    
    
    static func == (lhs: MovieDetailsViewState, rhs: MovieDetailsViewState) -> Bool {
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


struct MovieDetailsState: Equatable {
    let posterURL: String
    let backgroundUrl: String
    let title: String
    let ratingText: String
    let releaseDate: String
    let isFavorite: Bool
    let overview: String
    let language: String
    let voters: String
}
