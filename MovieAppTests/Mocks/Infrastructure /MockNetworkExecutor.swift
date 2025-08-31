//
//  MockNetworkExecutor.swift
//  MovieApp
//
//  Created by AAIT on 31/08/2025.
//

import Combine
import Foundation
@testable import MovieApp


 final class  MockNetworkExecutor: NetworkExecutor {
    var result: Result<MoviesDTO, NetworkError>?
    private(set) var lastEndpoint: (any Endpoint)?
    
    func execute<E: Endpoint>(_ endpoint: E) -> AnyPublisher<E.Response, NetworkError> {
        lastEndpoint = endpoint
        
        return Future<E.Response, NetworkError> { promise in
            switch self.result {
            case .success(let value):
                if let value = value as? E.Response {
                    promise(.success(value))
                } else {
                    promise(.failure(.invalidURL))
                }
            case .failure(let error):
                promise(.failure(error))
            case .none:
                    promise(.failure(.invalidURL))
            }
        }
        .eraseToAnyPublisher()
    }
}
