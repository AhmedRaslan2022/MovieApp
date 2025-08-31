//
//  MoviesRepositoryTests.swift
//  MovieApp
//
//  Created by AAIT on 30/08/2025.
//

import XCTest
import Combine
@testable import MovieApp
 

final class MoviesRepositoryTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    private var mockRemote: MockMoviesRemoteDataSource!
    private var mockLocal: MockMoviesLocalDataSource!
    private var repository: MoviesRepository!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockRemote = MockMoviesRemoteDataSource()
        mockLocal = MockMoviesLocalDataSource()
        repository = MoviesRepository(remote: mockRemote, local: mockLocal)
    }
    
    override func tearDown() {
        cancellables = nil
        mockRemote = nil
        mockLocal = nil
        repository = nil
        super.tearDown()
    }
    
    // MARK: - Fetching Movies Tests
    
    func test_fetchMovies_successFromRemote() {
        let dto = MoviesDTO(
            page: 1,
            results: [MovieDTO(
                adult: false,
                backdropPath: "/path.jpg",
                genreIds: [12, 14],
                id: 1,
                originalLanguage: "en",
                originalTitle: "Origin",
                overview: "overview",
                popularity: 100.0,
                posterPath: "/poster.jpg",
                releaseDate: "2025-08-30",
                title: "Test Movie",
                video: false,
                voteAverage: 8.5,
                voteCount: 200)],
            totalPages: 1
        )
        
        mockLocal.fetchResult = .failure(.local(.notFound))
        mockRemote.result = .success(dto)
        
        let expectation = XCTestExpectation(description: "Fetch movies from remote")
        
        repository.fetchMovies(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion { XCTFail("Should not fail") }
            }, receiveValue: { entity in
                XCTAssertEqual(entity.movies.count, 1)
                XCTAssertEqual(entity.movies.first?.id, 1)
                XCTAssertEqual(entity.movies.first?.name, "Test Movie")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
    func test_fetchMovies_fallbackToLocalOnRemoteFailure() {

        mockRemote.result = .failure(.serverError(500))
        
        let dto = MoviesDTO(page: 1, results: [], totalPages: 1)
        mockLocal.fetchResult = .success(MoviesMapper.map(dto))
        
        let expectation = XCTestExpectation(description: "Fetch movies from local")
        
        repository.fetchMovies(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion { XCTFail("Should not fail") }
            }, receiveValue: { entity in
                XCTAssertEqual(entity.movies.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    func test_fetchMovies_successFromLocal() {
        let dto = MoviesDTO(
            page: 1,
            results: [MovieDTO(
                adult: false,
                backdropPath: nil,
                genreIds: [],
                id: 2,
                originalLanguage: "en",
                originalTitle: "Local Movie",
                overview: "local overview",
                popularity: 50.0,
                posterPath: nil,
                releaseDate: "2025-08-31",
                title: "Local Movie",
                video: false,
                voteAverage: 7.0,
                voteCount: 100)],
            totalPages: 1
        )
        
        mockLocal.fetchResult = .success(MoviesMapper.map(dto))
        
        let expectation = XCTestExpectation(description: "Fetch movies from local directly")
        
        repository.fetchMovies(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion { XCTFail("Should not fail") }
            }, receiveValue: { entity in
                XCTAssertEqual(entity.movies.count, 1)
                XCTAssertEqual(entity.movies.first?.id, 2)
                XCTAssertEqual(entity.movies.first?.name, "Local Movie")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
    

    func test_fetchMovies_localFailureNotFound_propagatesError() {
        mockLocal.fetchResult = .failure(.local(.savingError))
        mockRemote.result = .success(MoviesDTO(page: 1, results: [], totalPages: 1))
        
        let expectation = XCTestExpectation(description: "Local error propagates")
        
        repository.fetchMovies(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if case .local(.savingError) = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Unexpected error: \(error)")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Should not succeed")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
    
    
    func test_fetchMovies_remoteSuccess_localSaveFails() {
        let dto = MoviesDTO(page: 1, results: [], totalPages: 1)
        
        mockLocal.fetchResult = .failure(.local(.notFound))
        mockRemote.result = .success(dto)
        mockLocal.saveResult = .failure(.local(.savingError))  
        
        let expectation = XCTestExpectation(description: "Remote success but local save fails")
        
        repository.fetchMovies(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if case .local(.savingError) = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Unexpected error: \(error)")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Should not succeed when local save fails")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }

    
    
    // MARK: - Fav Movies Tests

    func test_setMovieFavStatus_success() {
        mockLocal.favResult = .success(())
        
        let expectation = XCTestExpectation(description: "Set favourite status success")
        
        repository.setMovieFavStatus(movieId: 1, isFavourite: true)
            .sink(receiveCompletion: { completion in
                if case .failure = completion { XCTFail("Should not fail") }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    func test_setMovieFavStatus_failure() {
        mockLocal.favResult = .failure(.local(.savingError))
        
        let expectation = XCTestExpectation(description: "Set favourite status failure")
        
        repository.setMovieFavStatus(movieId: 1, isFavourite: true)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if case .local(.savingError) = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Unexpected error: \(error)")
                    }
                }
            }, receiveValue: {
                XCTFail("Should not succeed on failure")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
