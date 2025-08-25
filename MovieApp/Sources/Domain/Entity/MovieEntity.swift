//
//  MovieEntity.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

struct MovieEntity: Equatable {
    let id: Int
    let poster: String
    let name: String
    let rating: String
    let releaseDate: String
    var isFavourite: Bool = false
    let overview: String
    let voteAverage: String
    let language: String
}
