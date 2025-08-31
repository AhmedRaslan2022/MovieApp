//
//  LocalDataSourceTests.swift
//  MovieApp
//
//  Created by AAIT on 31/08/2025.
//

import XCTest
import Combine
import CoreData
@testable import MovieApp

class MoviesLocalDataSourceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var dataSource: MoviesLocalDataSource!
    private var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        
        // Set up in-memory Core Data stack
        let persistentContainer = NSPersistentContainer(name: "MovieApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Core Data setup")
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        mockContext = persistentContainer.viewContext
        dataSource = MoviesLocalDataSource(context: mockContext)
    }
    
    override func tearDown() {
        cancellables = nil
        dataSource = nil
        mockContext = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Movies Tests
    
    func testFetchMoviesSuccess() {
        // Given
        let page = 1
        let movieEntities = [
            MovieEntity(
                id: 1,
                poster: "/poster1.jpg",
                name: "Movie 1",
                rating: 8.0,
                releaseDate: "2023-01-01",
                isFavourite: false,
                overview: "Overview 1",
                language: "en",
                backgroundImage: "/background1.jpg",
                voters: 100
            ),
            MovieEntity(
                id: 2,
                poster: "/poster2.jpg",
                name: "Movie 2",
                rating: 7.5,
                releaseDate: "2023-02-01",
                isFavourite: true,
                overview: "Overview 2",
                language: "en",
                backgroundImage: "/background2.jpg",
                voters: 200
            )
        ]
        
        let moviesListEntity = MoviesListEntity(
            movies: movieEntities,
            page: page,
            totalPages: 10
        )
        
        let saveExpectation = expectation(description: "Save movies")
        dataSource.saveMovies(moviesListEntity)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { saveExpectation.fulfill() })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0)
        
        // When
        let fetchExpectation = expectation(description: "Fetch movies")
        var receivedResult: Result<MoviesListEntity, AppError>?
        
        dataSource.fetchMovies(page: page)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    receivedResult = .failure(error)
                    fetchExpectation.fulfill()
                }
            }, receiveValue: {
                receivedResult = .success($0)
                fetchExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        switch receivedResult {
        case .success(let entity):
            XCTAssertEqual(entity.page, page)
            XCTAssertEqual(entity.movies.count, 2)
            XCTAssertEqual(entity.movies[0].id, 1)
            XCTAssertEqual(entity.movies[1].id, 2)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        case .none:
            XCTFail("No result received")
        }
    }
    
    func testFetchMoviesNotFound() {
        // Given
        let page = 999
        
        // When
        let expectation = self.expectation(description: "Fetch movies not found")
        var receivedError: AppError?
        
        dataSource.fetchMovies(page: page)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        if case .local(.notFound) = receivedError {
            // Expected error
        } else {
            XCTFail("Expected notFound error but got: \(String(describing: receivedError))")
        }
    }
    
    // MARK: - Save Movies Tests
    
    func testSaveMoviesSuccess() {
        // Given
        let movieEntities = [
            MovieEntity(
                id: 1,
                poster: "/poster1.jpg",
                name: "Movie 1",
                rating: 8.0,
                releaseDate: "2023-01-01",
                isFavourite: false,
                overview: "Overview 1",
                language: "en",
                backgroundImage: "/background1.jpg",
                voters: 100
            )
        ]
        
        let moviesListEntity = MoviesListEntity(
            movies: movieEntities,
            page: 1,
            totalPages: 10
        )
        
        // When
        let expectation = self.expectation(description: "Save movies")
        var receivedError: AppError?
        
        dataSource.saveMovies(moviesListEntity)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNil(receivedError)
        
        // Verify the data was actually saved
        let fetchRequest: NSFetchRequest<MoviesPage> = MoviesPage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "page == %d", 1)
        
        do {
            let results = try mockContext.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first?.movies?.count, 1)
        } catch {
            XCTFail("Failed to verify saved data: \(error)")
        }
    }
    
    func testSaveMoviesOverwritesExistingPage() {
        // Given
        let initialMovie = MovieEntity(
            id: 1,
            poster: "/poster1.jpg",
            name: "Movie 1",
            rating: 8.0,
            releaseDate: "2023-01-01",
            isFavourite: false,
            overview: "Overview 1",
            language: "en",
            backgroundImage: "/background1.jpg",
            voters: 100
        )
        
        let initialList = MoviesListEntity(
            movies: [initialMovie],
            page: 1,
            totalPages: 10
        )
        
        let saveExpectation = expectation(description: "Save initial movies")
        dataSource.saveMovies(initialList)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { saveExpectation.fulfill() })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0)
        
        // When - save different movies for the same page
        let updatedMovie = MovieEntity(
            id: 2,
            poster: "/poster2.jpg",
            name: "Movie 2",
            rating: 7.5,
            releaseDate: "2023-02-01",
            isFavourite: true,
            overview: "Overview 2",
            language: "en",
            backgroundImage: "/background2.jpg",
            voters: 200
        )
        
        let updatedList = MoviesListEntity(
            movies: [updatedMovie],
            page: 1,
            totalPages: 10
        )
        
        let updateExpectation = expectation(description: "Save updated movies")
        dataSource.saveMovies(updatedList)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { updateExpectation.fulfill() })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0)
        
        // Then - verify only the updated movie exists
        let fetchRequest: NSFetchRequest<MoviesPage> = MoviesPage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "page == %d", 1)
        
        do {
            let results = try mockContext.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            
            if let movies = results.first?.movies?.array as? [Movie] {
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.id, 2)
                XCTAssertEqual(movies.first?.name, "Movie 2")
            } else {
                XCTFail("Failed to fetch movies")
            }
        } catch {
            XCTFail("Failed to verify saved data: \(error)")
        }
    }
    
    // MARK: - Set Favorite Status Tests
    
    func testSetMovieFavStatusSuccess() {
        // Given
        let movieEntity = MovieEntity(
            id: 1,
            poster: "/poster1.jpg",
            name: "Movie 1",
            rating: 8.0,
            releaseDate: "2023-01-01",
            isFavourite: false,
            overview: "Overview 1",
            language: "en",
            backgroundImage: "/background1.jpg",
            voters: 100
        )
        
        let moviesListEntity = MoviesListEntity(
            movies: [movieEntity],
            page: 1,
            totalPages: 10
        )
        
        let saveExpectation = expectation(description: "Save movies")
        dataSource.saveMovies(moviesListEntity)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { saveExpectation.fulfill() })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0)
        
        // When
        let favExpectation = expectation(description: "Set favorite status")
        var receivedError: AppError?
        
        dataSource.setMovieFavStatus(movieId: 1, isFavourite: true)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    receivedError = error
                }
                favExpectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNil(receivedError)
        
        // Verify the favorite status was updated
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", 1)
        
        do {
            let results = try mockContext.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            XCTAssertTrue(results.first?.isFavourite ?? false)
        } catch {
            XCTFail("Failed to verify favorite status: \(error)")
        }
    }
    
    func testSetMovieFavStatusNotFound() {
        // Given - no movies saved
        
        // When
        let expectation = self.expectation(description: "Set favorite status not found")
        var receivedError: AppError?
        
        dataSource.setMovieFavStatus(movieId: 999, isFavourite: true)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        if case .local(.notFound) = receivedError {
            // Expected error
        } else {
            XCTFail("Expected notFound error but got: \(String(describing: receivedError))")
        }
    }
}
