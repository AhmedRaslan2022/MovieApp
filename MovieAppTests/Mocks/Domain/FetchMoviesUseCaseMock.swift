//
//  FetchMoviesUseCaseMock.swift
//  MovieApp
//
//  Created by AAIT on 31/08/2025.
//

import XCTest
import Combine
@testable import MovieApp

class MockFetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    var result: Result<MoviesListEntity, AppError>?
    var lastPage: Int?
    var callCount = 0
    
    func execute(page: Int) -> AnyPublisher<MoviesListEntity, AppError> {
        lastPage = page
        callCount += 1
        
        if let result = result {
            return result.publisher
                .delay(for: .milliseconds(10), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: .local(.fetchError))
            .eraseToAnyPublisher()
    }
}
