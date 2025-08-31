//
//  FetchMoviesUseCaseTests.swift
//  MovieApp
//
//  Created by AAIT on 28/08/2025.
//
 
import XCTest
import Combine
@testable import MovieApp

final class FetchMoviesUseCaseTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    private var mockRepository: MockMoviesRepository!
    private var useCase: FetchMoviesUseCase!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockRepository = MockMoviesRepository()
        useCase = FetchMoviesUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        cancellables = nil
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() {
        
        let expectedMovies = MoviesListEntity(
            movies: [
                MovieEntity(
                    id: 1,
                    poster: "poster1",
                    name: "Inception",
                    rating: 8.8,
                    releaseDate: "2010",
                    overview: "A dream within a dream",
                    language: "en",
                    backgroundImage: "bg1",
                    voters: 20000
                )
            ],
            page: 1,
            totalPages: 100
        )
        
        mockRepository.result = .success(expectedMovies)
        
        let expectation = XCTestExpectation(description: "Fetch movies success")
        var receivedMovies: MoviesListEntity?
        

        useCase.execute(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { movies in
                receivedMovies = movies
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedMovies?.page, expectedMovies.page)
        XCTAssertEqual(receivedMovies?.totalPages, expectedMovies.totalPages)
        XCTAssertEqual(receivedMovies?.movies, expectedMovies.movies)
    }
    
    func testExecute_Failure() {

        let expectedError = AppError.remote(.serverError(500))
        mockRepository.result = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Fetch movies failure")
        var receivedError: AppError?
        

        useCase.execute(page: 2)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedError)
        
        if case .remote(.serverError(let code)) = receivedError {
            XCTAssertEqual(code, 500)
        } else {
            XCTFail("Expected server error")
        }
    }
}
