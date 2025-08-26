//
//  NetworkExecutor.swift
//  MovieApp
//
//  Created by Rasslan on 25/08/2025.
//

import Foundation
import Combine
 

public protocol NetworkExecutor {
    func execute<E: Endpoint>(_ endpoint: E) -> AnyPublisher<E.Response, NetworkError>
}

public final class DefaultNetworkExecutor: NetworkExecutor {
    public func execute<E: Endpoint>(_ endpoint: E) -> AnyPublisher<E.Response, NetworkError> {
        guard let request = endpoint.urlRequest else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        NetworkLogger.log(request: request)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { result in
                 NetworkLogger.log(response: result.response, data: result.data)
            })
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse,
                   !(200..<300).contains(response.statusCode) {
                    throw NetworkError.serverError(response.statusCode)
                }
                return result.data
            }
            .decode(type: E.Response.self, decoder: JSONDecoder())
            .mapError { error in
                 if let decodingError = error as? DecodingError {
                    NetworkLogger.log(error: decodingError)
                    return .decodingError(decodingError)
                } else if let networkError = error as? NetworkError {
                    NetworkLogger.log(error: networkError)
                    return networkError
                } else {
                    NetworkLogger.log(error: error)
                    return .unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
