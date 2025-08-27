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
    func favWasPressed(movieId: Int, isFavourite: Bool)
}


enum MovieDetailsViewState : Equatable{
    case loading
    case error(String)
    case populated(MovieDetailsState)
    case favIsUpdated
    
    
    static func == (lhs: MovieDetailsViewState, rhs: MovieDetailsViewState) -> Bool {
           switch (lhs, rhs) {
           case (.loading, .loading):
               return true
           case let (.error(lMsg), .error(rMsg)):
               return lMsg == rMsg
           case let (.populated(lMovies), .populated(rMovies)):
               return lMovies == rMovies
               
           case (.favIsUpdated, .favIsUpdated):
               return true

           default:
               return false
           }
       }
}


struct MovieDetailsState: Equatable {
    let id: Int
    let posterURL: String
    let backgroundUrl: String
    let title: String
    let ratingText: String
    let releaseDate: String
    var isFavorite: Bool
    let overview: String
    let language: String
    let voters: String
}
