//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

//
//  MoviesListViewController.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import UIKit
import Combine

import UIKit
import Combine

final class MoviesListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let viewModel: MoviesListViewModel
    private var cancellables = Set<AnyCancellable>()
    private var movies: [MovieCellViewModel] = []
    
    // Scroll events for pagination
    private let scrollSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MoviesListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        bindScroll()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Movies List"
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: MovieCollectionViewCell.self)
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView.contentInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        collectionView.collectionViewLayout = layout
        
        collectionView.addRefresh(action: #selector(refresh))
        collectionView.register(LoadingFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: LoadingFooterView.identifier)
    }
    
    private func bindViewModel() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .loading:
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                case .populated(let movies):
                    self.movies = movies
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                case .empty:
                    self.movies.removeAll()
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                case .error:
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindScroll() {
        scrollSubject
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.loadNextPage()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func refresh() {
        viewModel.refresh()
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: MovieCollectionViewCell.self, for: indexPath)
        let movie = movies[indexPath.row]
        cell.configCell(with: movie)
        cell.favAction = { [weak self] id in
            self?.viewModel.favWasPressed(movieId: id)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter,
           let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.identifier,
                for: indexPath) as? LoadingFooterView {
            
            if viewModel.viewState.value == .loading {
                footer.isHidden = false
                footer.startAnimating()
            } else {
                footer.isHidden = true
                footer.stopAnimating()
            }
            
            return footer
        }
        return UICollectionReusableView()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            scrollSubject.send(())
        }
    }
}
