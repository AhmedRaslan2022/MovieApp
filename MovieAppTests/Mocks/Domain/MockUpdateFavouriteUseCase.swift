//
//  MockUpdateFavouriteUseCase.swift
//  MovieApp
//
//  Created by AAIT on 31/08/2025.
//

import XCTest
import Combine
@testable import MovieApp

class MockUpdateFavouriteUseCase: UpdateFavouriteUseCaseProtocol {
    var result: Result<Void, AppError>?
    var lastMovieID: Int?
    var lastIsFavourite: Bool?
    var callCount = 0
    
    func execute(movieID: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError> {
        lastMovieID = movieID
        lastIsFavourite = isFavourite
        callCount += 1
        
        if let result = result {
            return result.publisher
                .delay(for: .milliseconds(10), scheduler: RunLoop.main)  
                .eraseToAnyPublisher()
        }
        
        return Fail(error: .local(.updateError))
            .eraseToAnyPublisher()
    }
}
