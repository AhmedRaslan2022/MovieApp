//
//  UIViewController.swift
//  MovieApp
//
//  Created by Ahmed Raslan on 27/08/2025.
//

import UIKit

public protocol Loadable {
    func showLoadingView()
    func hideLoadingView()
}


extension UIViewController: Loadable {
    private static let loadingViewTag = 99999

    public func showLoadingView() {
        guard view.viewWithTag(UIViewController.loadingViewTag) == nil else { return }
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.tag = UIViewController.loadingViewTag
        
        let loadingView = LoadingView()
        containerView.addSubview(loadingView)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 130),
            loadingView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }

    public func hideLoadingView() {
        DispatchQueue.main.async {
            self.view.viewWithTag(UIViewController.loadingViewTag)?.removeFromSuperview()
        }
    }
}
