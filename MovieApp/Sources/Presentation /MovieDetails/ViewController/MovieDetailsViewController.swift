//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import UIKit
import Combine

final class MovieDetailsViewController: UIViewController {
    
  @IBOutlet private weak var backgroundImageView: UIImageView!
  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var ratingLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var favButton: UIButton!
  @IBOutlet private weak var overviewLabel: UILabel!
  @IBOutlet private weak var votersLabel: UILabel!
  @IBOutlet private weak var languageLabel: UILabel!
  @IBOutlet private weak var infoStack: UIStackView!

    private let viewModel: MovieDetailsViewModelType
    private var stateModel: MovieDetailsState?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MovieDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "MovieDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    @IBAction private func addToFavoritesWasPressed(_ sender: Any) {
        guard let stateModel = stateModel else {return}
        viewModel.favWasPressed(movieId: stateModel.id, isFavourite: !stateModel.isFavorite)
    }
}

// MARK: - UISetup

private extension MovieDetailsViewController {
    private func setupUI(){
        title = "Movie Details"
        infoStack.clipsToBounds = true
        infoStack.layer.cornerRadius = 8.0
    }
}

// MARK: - Binding
private extension MovieDetailsViewController {
    func bindViewModel() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleViewState(state)
            }
            .store(in: &cancellables)
    }
    
    func handleViewState(_ state: MovieDetailsViewState) {
        switch state {
        case .loading:
            break
        case .error(let message):
            print("Error: \(message)")
        case .populated(let model):
            configureUI(with: model)
        case .favIsUpdated:
            stateModel?.isFavorite.toggle()
            favButton.isSelected.toggle()
            favButton.tintColor = favButton.isSelected ?  .red : .white
        }
    }
    
    func configureUI(with model: MovieDetailsState) {
        stateModel = model
        posterImageView.setWith(model.posterURL)
        backgroundImageView.setWith(model.backgroundUrl)
        nameLabel.text = model.title
        ratingLabel.text = model.ratingText
        dateLabel.text = model.releaseDate
        favButton.isSelected = model.isFavorite
        favButton.tintColor = model.isFavorite ? .red : .white
        overviewLabel.text = model.overview
        languageLabel.text = model.language
        votersLabel.text = model.voters
    }
}
