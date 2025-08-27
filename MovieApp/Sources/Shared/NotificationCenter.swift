//
//  NotificationCenter.swift
//  MovieApp
//
//  Created by Rasslan on 27/08/2025.
//

import Foundation

extension Notification.Name {
    static let movieUpdated = Notification.Name("movieUpdated")
}


extension NotificationCenter {
    func postMovieUpdated(_ movie: Movie) {
        post(name: .movieUpdated, object: nil, userInfo: ["movieUpdated": movie])
    }

    func publisherForMovieUpdated() -> NotificationCenter.Publisher {
        publisher(for: .movieUpdated, object: nil)
    }
}
