//
//  CollectionViewFooter.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import UIKit


final class LoadingFooterView: UICollectionReusableView {
    static let identifier = "LoadingFooterView"

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.tintColor = .red
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        spinner.startAnimating()
    }

    func stopAnimating() {
        spinner.stopAnimating()
    }
}
