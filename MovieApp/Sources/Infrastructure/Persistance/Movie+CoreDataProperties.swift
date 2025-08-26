//
//  Movie+CoreDataProperties.swift
//  MovieApp
//
//  Created by Rasslan on 27/08/2025.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var poster: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var overview: String?
    @NSManaged public var language: String?
    @NSManaged public var backgroundImage: String?
    @NSManaged public var voters: Int64
    @NSManaged public var isFavourite: Bool
    @NSManaged public var page: MoviesPage?

}

extension Movie : Identifiable {

}
