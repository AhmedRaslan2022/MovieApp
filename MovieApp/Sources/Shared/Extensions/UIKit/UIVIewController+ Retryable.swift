//
//  UIVIewController+ Retryable.swift
//  MovieApp
//
//  Created by AAIT on 28/08/2025.
//

import UIKit

public protocol Retryable {
    func showErrorView(message: String, retryHandler: @escaping () -> Void)
    func hideErrorView()
}



extension UIViewController: Retryable {
    private static let errorViewTag = 88888
    
    public func showErrorView(message: String, retryHandler: @escaping () -> Void) {
        guard view.viewWithTag(UIViewController.errorViewTag) == nil else { return }
        
        let errorView = ErrorView(message: message, retryHandler: retryHandler)
        errorView.tag = UIViewController.errorViewTag
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    public func hideErrorView() {
        DispatchQueue.main.async {
            self.view.viewWithTag(UIViewController.errorViewTag)?.removeFromSuperview()
        }
    }
}
