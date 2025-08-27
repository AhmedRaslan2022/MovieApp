//
//  MoviesPage+CoreDataProperties.swift
//  MovieApp
//
//  Created by Rasslan on 27/08/2025.
//
//

import Foundation
import CoreData


extension MoviesPage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesPage> {
        return NSFetchRequest<MoviesPage>(entityName: "MoviesPage")
    }

    @NSManaged public var page: Int64
    @NSManaged public var totalPages: Int64
    @NSManaged public var movies: NSOrderedSet?

}

// MARK: Generated accessors for movies
extension MoviesPage {

    @objc(insertObject:inMoviesAtIndex:)
    @NSManaged public func insertIntoMovies(_ value: Movie, at idx: Int)

    @objc(removeObjectFromMoviesAtIndex:)
    @NSManaged public func removeFromMovies(at idx: Int)

    @objc(insertMovies:atIndexes:)
    @NSManaged public func insertIntoMovies(_ values: [Movie], at indexes: NSIndexSet)

    @objc(removeMoviesAtIndexes:)
    @NSManaged public func removeFromMovies(at indexes: NSIndexSet)

    @objc(replaceObjectInMoviesAtIndex:withObject:)
    @NSManaged public func replaceMovies(at idx: Int, with value: Movie)

    @objc(replaceMoviesAtIndexes:withMovies:)
    @NSManaged public func replaceMovies(at indexes: NSIndexSet, with values: [Movie])

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: Movie)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: Movie)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSOrderedSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSOrderedSet)

}

extension MoviesPage : Identifiable {

}
