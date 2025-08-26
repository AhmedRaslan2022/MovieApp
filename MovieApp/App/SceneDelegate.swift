//
//  SceneDelegate.swift
//  MovieApp
//
//  Created by Ahmed Raslan on 25/08/2025.
//
 
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var moviesCoordinator: MoviesCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
         let window = UIWindow(windowScene: windowScene)
        
         let navController = UINavigationController()
        
         let dependencies = MoviesDIContainer()
        
         let coordinator = MoviesCoordinator(
            navigationController: navController,
            dependencies: dependencies
        )
        self.moviesCoordinator = coordinator
        
         coordinator.start()
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
    }
}
