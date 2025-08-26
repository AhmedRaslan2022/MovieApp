//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//


import Foundation
import Combine


// MARK: MovieDetailsViewModel
@MainActor
final class MovieDetailsViewModel: MovieDetailsViewModelType {
   
    private let movie: MovieEntity
    let viewState: CurrentValueSubject<MovieDetailsViewState, Never> = .init(.loading)

    
    init(movie: MovieEntity) {
        self.movie = movie
    }
    
    
    func viewDidLoad() {
        viewState.send(
            .populated(
              .init(
                  posterURL: movie.poster,
                  backgroundUrl: movie.backgroundImage,
                  title: movie.name,
                  ratingText:  String(format: "%.1f/10", movie.rating),
                  releaseDate: movie.releaseDate,
                  isFavorite: movie.isFavourite,
                  overview: movie.overview,
                  language: movie.language,
                  voters: "\(movie.voters) voters"
                )
            )
        )
    }
    
    
    
    func favWasPressed(movieId: Int) {
        
    }
    
}
