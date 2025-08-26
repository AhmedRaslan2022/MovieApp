
//
//  Coordinator.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//


import UIKit

@MainActor
public protocol Coordinator: AnyObject {
  func start(with step: Step)
  func start()
}

@MainActor
public extension Coordinator {
  func start(with step: Step) { }
  func start() { }
}

@MainActor
public protocol UIKitNavigationCoordinator: Coordinator {
  var navigationController: UINavigationController { get }
}



// MARK: - Step Protocol
 
public protocol Step { }


