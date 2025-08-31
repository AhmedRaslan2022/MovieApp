//
//  FavouriteUseCaseTests.swift
//  MovieApp
//
//  Created by AAIT on 28/08/2025.
//

import XCTest
import Combine
@testable import MovieApp

 
 
final class UpdateFavouriteUseCaseTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    private var mockRepository: MockMoviesRepository!
    private var useCase: UpdateFavouriteUseCase!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockRepository = MockMoviesRepository()
        useCase = UpdateFavouriteUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        cancellables = nil
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() {

        mockRepository.favResult = .success(())
        
        let expectation = XCTestExpectation(description: "Update favourite success")
        var successCalled = false
        
 
        useCase.execute(movieID: 1, isFavourite: true)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { _ in
                successCalled = true
                expectation.fulfill()
            })
            .store(in: &cancellables)
        

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(successCalled)
    }
    
    func testExecute_Failure() {
 
        let expectedError = AppError.remote(.serverError(500))
        mockRepository.favResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Update favourite failure")
        var receivedError: AppError?
        
         
        useCase.execute(movieID: 1, isFavourite: false)
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
