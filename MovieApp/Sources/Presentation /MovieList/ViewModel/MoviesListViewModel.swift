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
   
 
    
    enum Input {
        case loadNextPage
        case refresh
        case retry
    }
    
    let viewState = CurrentValueSubject<MoviesListViewState, Never>(.loading)
    
    private var movies: [MovieEntity] = []
    private let fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    private let favMovieUseCase: UpdateFavouriteUseCaseProtocol
    private let coordinator: MoviesCoordinatorProtocol
    
    // Pagination
    private var currentPage = 1
    private var totalPages = 1
    
    
    // Input Subject
    private let inputSubject = PassthroughSubject<Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()

    
    init(
         coordinator: MoviesCoordinatorProtocol,
         fetchMoviesUseCase: FetchMoviesUseCaseProtocol,
         favMovieUseCase: UpdateFavouriteUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.favMovieUseCase = favMovieUseCase
        
        bindInput()
        observeMovieUpdates()
    }
    
    private func observeMovieUpdates() {
            NotificationCenter.default.publisher(for: .movieUpdated)
                .compactMap { $0.userInfo?["updatedMovie"] as? MovieEntity }
                .sink { [weak self] updated in
                    self?.handleMovieUpdate(updated)
                }
                .store(in: &cancellables)
        }

        private func handleMovieUpdate(_ updated: MovieEntity) {
            if let index = movies.firstIndex(where: { $0.id == updated.id }) {
                movies[index].isFavourite = updated.isFavourite
                let cellVMs = self.movies.map { MovieCellViewModel(movie: $0) }
                viewState.send(.populated(cellVMs))
            }
        }

    
    func viewDidLoad() {
        inputSubject.send(.refresh)
    }
    
    func refresh() {
        inputSubject.send(.refresh)
    }
    
    func retry() {
        inputSubject.send(.retry)
    }
    
    func loadNextPage() {
        inputSubject.send(.loadNextPage)
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
                   if let index = self.movies.firstIndex(where: { $0.id == movieId }) {
                       self.movies[index].isFavourite.toggle()
                       let cellVMs = self.movies.map { MovieCellViewModel(movie: $0) }
                       self.viewState.send(.populated(cellVMs))
                   } else {
                       self.viewState.send(.error("Movie not found"))
                   }
               }
               .store(in: &cancellables)
       }
    
    func navigateToMovieDetails(movieId: Int) {
        guard let movie = movies.first(where: { $0.id == movieId }) else { return }
        coordinator.navigate(to: .movieDetails(movie: movie))
    }
    
    // MARK: - Private
    
    private func bindInput() {
        inputSubject
            .flatMap { [weak self] input -> AnyPublisher<[MovieEntity], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                
                switch input {
                case .refresh:
                    self.currentPage = 1
                    self.totalPages = 1
                    self.movies.removeAll()
                    self.viewState.send(.loading)
                    return self.fetch(page: self.currentPage)
                    
                case .loadNextPage:
                    guard self.currentPage <= self.totalPages else { return Just([]).eraseToAnyPublisher() }
                    self.viewState.send(.loading)
                    return self.fetch(page: self.currentPage)
                        
                    case .retry:
                        guard self.currentPage <= self.totalPages else { return Just([]).eraseToAnyPublisher() }
                        self.viewState.send(.loading)
                        return self.fetch(page: self.currentPage)
                }
            }
            .sink { [weak self] newMovies in
                guard let self = self else { return }
                
                if !newMovies.isEmpty {
                       self.movies.append(contentsOf: newMovies)
                       self.currentPage += 1
                   }
                
                self.totalPages = max(self.totalPages, self.currentPage)
                
                let cellVMs = self.movies.map { MovieCellViewModel(movie: $0) }
                cellVMs.isEmpty ?  self.viewState.send(.populated(cellVMs)) :  self.viewState.send(.populated(cellVMs)) 
            }
            .store(in: &cancellables)
    }
    
    private func fetch(page: Int) -> AnyPublisher<[MovieEntity], Never> {
        
        viewState.send(.loading)
        
        return fetchMoviesUseCase.execute(page: page)
            .map { $0.movies }
            .catch { [weak self] error -> Just<[MovieEntity]> in
                self?.viewState.send(.error(error.localizedDescription))
                return Just([])
            }
            .eraseToAnyPublisher()
    }
}
