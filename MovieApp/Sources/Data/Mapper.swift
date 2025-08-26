//
//  Untitled.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation

enum MovieMapper {

    static func map(_ dto: MovieDTO) -> MovieEntity {
        MovieEntity(
            id: dto.id,
            poster: dto.posterPath,
            name: dto.title,
            rating: dto.voteAverage,
            releaseDate: dto.releaseDate,
            isFavourite: false,
            overview: dto.overview,
            language: dto.originalLanguage
        )
    }
    
    static func map(_ dtos: [MovieDTO]) -> [MovieEntity] {
        return dtos.map { map($0) }
    }
}


 
