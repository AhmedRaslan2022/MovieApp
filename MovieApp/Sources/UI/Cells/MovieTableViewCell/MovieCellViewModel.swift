//
//  MovieCellViewModel.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import  Foundation


protocol MovieCellViewModelType {
    var id: Int { get }
    var title: String { get }
    var posterURL: String { get }
    var rating: Double { get }
    var ratingText: String { get }
    var releaseDate: String { get }
    var isFavourite: Bool { get }
}

final class MovieCellViewModel: MovieCellViewModelType, Equatable {
    
    
    private let movie: MovieEntity
    
    init(movie: MovieEntity) {
        self.movie = movie
    }
    
    var id: Int { movie.id }
    var title: String { movie.name }
    var posterURL: String { movie.poster }
    var rating: Double { movie.rating}
    var ratingText: String { String(format: "%.1f/10", movie.rating) }
    var isFavourite: Bool { movie.isFavourite }
    var releaseDate: String { "Release Date: \(movie.releaseDate)" }

    
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
            return lhs.id == rhs.id
        }
}
