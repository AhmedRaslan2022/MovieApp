//
//  RemoteDataSourceTests.swift
//  MovieApp
//
//  Created by AAIT on 31/08/2025.
//

import XCTest
import Combine
@testable import MovieApp

final class MoviesRemoteDataSourceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Success Case
    
    func testFetchMoviesSuccess() {

        let mockExecutor = MockNetworkExecutor()
        let dataSource = MoviesRemoteDataSource(executor: mockExecutor)
        let expectedMoviesDTO = MoviesDTO(
            page: 1,
            results: [MovieDTO(
                adult: false,
                backdropPath: "/path",
                genreIds: [1, 2],
                id: 123,
                originalLanguage: "en",
                originalTitle: "Title",
                overview: "Overview",
                popularity: 7.5,
                posterPath: "/poster",
                releaseDate: "2023-01-01",
                title: "Title",
                video: false,
                voteAverage: 8.0,
                voteCount: 100
            )],
            totalPages: 10
        )
        
        mockExecutor.result = .success(expectedMoviesDTO)
        
        let expectation = self.expectation(description: "Fetch movies success")
        var receivedMoviesDTO: MoviesDTO?
        

        dataSource.fetchMovies(page: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                receivedMoviesDTO = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)
        

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedMoviesDTO, expectedMoviesDTO)
        XCTAssertEqual(mockExecutor.lastEndpoint?.path, "3/discover/movie")
        XCTAssertEqual(mockExecutor.lastEndpoint?.method, .get)
        XCTAssertEqual(mockExecutor.lastEndpoint?.queryItems?.count, 3)
    }
    
    // MARK: - Failure Case
    
    func testFetchMoviesFailure() {
         
        let mockExecutor = MockNetworkExecutor()
        let dataSource = MoviesRemoteDataSource(executor: mockExecutor)
        let expectedError = NetworkError.invalidURL
        
        mockExecutor.result = .failure(expectedError)
        
        let expectation = self.expectation(description: "Fetch movies failure")
        var receivedError: NetworkError?
        

        dataSource.fetchMovies(page: 1)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }
}
