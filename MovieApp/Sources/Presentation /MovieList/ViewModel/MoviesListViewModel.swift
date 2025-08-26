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
    }
    
    let viewState = CurrentValueSubject<MoviesListViewState, Never>(.loading)
    
    private var movies: [MovieEntity] = []
    private let fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    private let coordinator: MoviesCoordinatorProtocol
    
    // Pagination
    private var currentPage = 1
    private var totalPages = 1
    
    
    // Input Subject
    private let inputSubject = PassthroughSubject<Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()

    
    init(coordinator: MoviesCoordinatorProtocol,
         fetchMoviesUseCase: FetchMoviesUseCaseProtocol) {
        self.coordinator = coordinator
        self.fetchMoviesUseCase = fetchMoviesUseCase
        
        bindInput()
    }
    
    func viewDidLoad() {
        inputSubject.send(.refresh)
    }
    
    func refresh() {
        inputSubject.send(.refresh)
    }
    
    func loadNextPage() {
        inputSubject.send(.loadNextPage)
    }
    
    func favWasPressed(movieId: Int) {}
    
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
                }
            }
            .sink { [weak self] newMovies in
                guard let self = self else { return }
                
                self.movies.append(contentsOf: newMovies)
                self.currentPage += 1
                self.totalPages = max(self.totalPages, self.currentPage)
                
                let cellVMs = self.movies.map { MovieCellViewModel(movie: $0) }
                cellVMs.isEmpty ?  self.viewState.send(.populated(cellVMs)) :  self.viewState.send(.populated(cellVMs)) 
            }
            .store(in: &cancellables)
    }
    
    private func fetch(page: Int) -> AnyPublisher<[MovieEntity], Never> {
        fetchMoviesUseCase.execute(page: page)
            .map { $0.movies }
            .catch { [weak self] error -> Just<[MovieEntity]> in
                self?.viewState.send(.error(error.localizedDescription))
                return Just([])
            }
            .eraseToAnyPublisher()
    }
}
