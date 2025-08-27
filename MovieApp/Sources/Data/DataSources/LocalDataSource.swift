//
//  LocalDataSource.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import CoreData
import Combine


protocol MoviesLocalDataSourceProtocol {
    func fetchMovies(page: Int) -> AnyPublisher<MoviesListEntity, AppError>
    func saveMovies(_ entity: MoviesListEntity) -> AnyPublisher<Void, AppError>
    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError>
}



final class MoviesLocalDataSource: MoviesLocalDataSourceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    func fetchMovies(page: Int) -> AnyPublisher<MoviesListEntity, AppError> {
        Future<MoviesListEntity, AppError> { promise in
            self.context.perform {
                CoreDataLogger.info("Fetching movies for page \(page)")
                
                let fetchRequest: NSFetchRequest<MoviesPage> = MoviesPage.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "page == %d", page)
                
                do {
                    if let pageEntity = try self.context.fetch(fetchRequest).first,
                       let orderedMovies = pageEntity.movies?.array as? [Movie] {
                        CoreDataLogger.success("Fetched \(orderedMovies.count) movies from cache (page \(page))")
                        
                        let movieEntities = orderedMovies.map { movie in
                            MovieEntity(
                                id: Int(movie.id),
                                poster: movie.poster ?? "",
                                name: movie.name ?? "",
                                rating: movie.rating,
                                releaseDate: movie.releaseDate ?? "",
                                isFavourite: movie.isFavourite,
                                overview: movie.overview ?? "",
                                language: movie.language ?? "",
                                backgroundImage: movie.backgroundImage ?? "",
                                voters: Int(movie.voters)
                            )
                        }
                        let listEntity = MoviesListEntity(
                            movies: movieEntities,
                            page: Int(pageEntity.page),
                            totalPages: Int(pageEntity.totalPages)
                        )
                        promise(.success(listEntity))
                    } else {
                        CoreDataLogger.error("No cached movies found for page \(page)")
                        promise(.failure(.local(.notFound)))
                    }
                } catch {
                    CoreDataLogger.error("Failed to fetch cached movies for page \(page): \(error)")
                    promise(.failure(.local(.fetchError)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func saveMovies(_ entity: MoviesListEntity) -> AnyPublisher<Void, AppError> {
        Future<Void, AppError> { promise in
            self.context.perform {
                CoreDataLogger.info("Saving \(entity.movies.count) movies for page \(entity.page)")
                
                let fetchRequest: NSFetchRequest<MoviesPage> = MoviesPage.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "page == %d", entity.page)
                
                do {
                    if let existingPage = try self.context.fetch(fetchRequest).first {
                        CoreDataLogger.info("Deleting old cache for page \(entity.page)")
                        self.context.delete(existingPage)
                    }

                    let pageEntity = MoviesPage(context: self.context)
                    pageEntity.page = Int64(entity.page)
                    pageEntity.totalPages = Int64(entity.totalPages)

                    for movieEntity in entity.movies {
                        let movie = Movie(context: self.context)
                        movie.id = Int64(movieEntity.id)
                        movie.poster = movieEntity.poster
                        movie.name = movieEntity.name
                        movie.rating = movieEntity.rating
                        movie.releaseDate = movieEntity.releaseDate
                        movie.isFavourite = movieEntity.isFavourite
                        movie.overview = movieEntity.overview
                        movie.language = movieEntity.language
                        movie.backgroundImage = movieEntity.backgroundImage
                        movie.voters = Int64(movieEntity.voters)
                        pageEntity.addToMovies(movie)
                    }

                    try self.context.save()
                    CoreDataLogger.success("Successfully saved \(entity.movies.count) movies for page \(entity.page)")
                    promise(.success(()))
                } catch {
                    CoreDataLogger.error("Failed to save movies for page \(entity.page): \(error)")
                    promise(.failure(.local(.savingError)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func setMovieFavStatus(movieId: Int, isFavourite: Bool) -> AnyPublisher<Void, AppError> {
        Future<Void, AppError> { promise in
            self.context.perform {
                CoreDataLogger.info("Updating favourite status for movieId=\(movieId) → \(isFavourite)")
                
                let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(movieId))
                
                do {
                    if let movie = try self.context.fetch(fetchRequest).first {
                        movie.isFavourite = isFavourite
                        try self.context.save()
                        CoreDataLogger.success("Favourite status updated for movieId=\(movieId)")
                        promise(.success(()))
                    } else {
                        CoreDataLogger.error("Movie not found in cache (id=\(movieId))")
                        promise(.failure(.local(.notFound)))
                    }
                } catch {
                    CoreDataLogger.error("Failed to update favourite for movieId=\(movieId): \(error)")
                    promise(.failure(.local(.updateError)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
