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
    private let favMovieUseCase: UpdateFavouriteUseCaseProtocol

    let viewState: CurrentValueSubject<MovieDetailsViewState, Never> = .init(.loading)
    private var cancellables = Set<AnyCancellable>()

    
    init(
        movie: MovieEntity,
        favMovieUseCase: UpdateFavouriteUseCaseProtocol
        
    ) {
        self.movie = movie
        self.favMovieUseCase = favMovieUseCase
    }
    
    
    func viewDidLoad() {
        viewState.send(
            .populated(
              .init(
                  id: movie.id,
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
    
    
    
    func favWasPressed(movieId: Int, isFavourite: Bool) {
        favMovieUseCase.execute(movieID: movieId, isFavourite: isFavourite)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.viewState.send(.error(error.localizedDescription))
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                viewState.send(.favIsUpdated)
                var updatedMovie = movie
                updatedMovie.isFavourite.toggle()
                NotificationCenter.default.post(
                    name: .movieUpdated,
                    object: nil,
                    userInfo: ["updatedMovie": updatedMovie]
                )
            }
            .store(in: &cancellables)
    }
    
}
 
