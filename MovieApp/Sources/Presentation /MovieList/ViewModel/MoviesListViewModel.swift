//
//  MoviesListViewModel.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation
import Combine

// MARK: MoviesListViewModel
@MainActor
final class MoviesListViewModel: MoviesListViewModelType {
   
    let  viewState =  PassthroughSubject<MoviesListViewState, Never>()
    private var movies: [MovieEntity] = []
    private let fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    private let coordinator: MoviesCoordinatorProtocol
    private var currentPage = 1
    private var canLoadMorePages = true
    private var cancellables = Set<AnyCancellable>()

     init(
        coordinator: MoviesCoordinatorProtocol,
        fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    ) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.coordinator = coordinator
    }
    
    func viewDidLoad() {
        loadMovies()
    }
    
    
    func loadNextPage() {
        loadMovies(page: currentPage + 1)
    }
    
    
    func refresh() {
        currentPage = 1
        canLoadMorePages = true
        movies.removeAll()
        loadMovies(page: 1)
    }
    
    
    func favWasPressed(movieId: Int) {
        
    }
    
    func navigateToMovieDetails(movieId: Int) {
        guard let movie = movies.first(where: {$0.id == movieId}) else {return}
        coordinator.navigate(to: .movieDetails(movie: movie))
    }
    
  
}
 

private extension MoviesListViewModel {
    
    private func loadMovies(page: Int = 1) {
        guard canLoadMorePages else {return}
        self.viewState.send(.loading)
        fetchMoviesUseCase.execute(page: page)
             .receive(on: DispatchQueue.main)
             .sink { [weak self] completion in
                 guard let self = self else { return }
                 if case .failure(let error) = completion {
                     self.viewState.send(.error(error.localizedDescription))
                 }
             } receiveValue: { [weak self] newMovies in
                 guard let self = self else { return }
                 if newMovies.isEmpty {
                     self.canLoadMorePages = false
                 } else {
                     if page == 1 {
                         self.movies = newMovies
                     } else {
                         self.movies.append(contentsOf: newMovies)
                     }
                     self.currentPage = page

                     let cellViewModels = self.movies.map { movie in
                         MovieCellViewModel(
                            movie: movie
                         )
                     }
                     
                     self.viewState.send(.populated(cellViewModels))
                 }
             }
             .store(in: &cancellables)
     }
}
