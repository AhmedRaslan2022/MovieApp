//
//  Laodingview.swift
//  MovieApp
//
//  Created by Ahmed Raslan on 28/08/2025.
//


import UIKit

public class LoadingView: NiblessView {
    
    
    public static var defaultView: LoadingView = {
      let recommendedFrame: CGRect = CGRect(x: 0, y: 0,
                                            width: UIScreen.main.bounds.width,
                                            height: 100)
      let defaultLoadingView = LoadingView(frame: recommendedFrame)
      return defaultLoadingView
    }()

    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        startLoadingAnimation()
    }
 
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 8.0
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        addSubview(loadingLabel)

        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func startLoadingAnimation() {
        var dotCount = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            dotCount = (dotCount + 1) % 4 // Cycle between 0, 1, 2, 3
            let dots = String(repeating: ".", count: dotCount)
            self.loadingLabel.text = "Loading" + dots
        }
    }

    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}
