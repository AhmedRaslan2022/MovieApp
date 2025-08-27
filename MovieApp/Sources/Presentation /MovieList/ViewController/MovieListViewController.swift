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
 

final class MoviesListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel: MoviesListViewModelType
    private var cancellables = Set<AnyCancellable>()
    private var movies: [MovieCellViewModel] = []
    
    // Scroll events for pagination
    private let scrollSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(viewModel: MoviesListViewModelType) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Movies List"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.register(cellType: MovieTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.addRefresh(action: #selector(refresh))
    }
    
    private func bindViewModel() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .loading:
                    self.tableView.reloadData()
                case .populated(let movies):
                    self.movies = movies
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                case .empty:
                    self.movies.removeAll()
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                case .error:
                    self.tableView.refreshControl?.endRefreshing()
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

// MARK: - UITableViewDataSource
extension MoviesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieTableViewCell.self, for: indexPath)
        let movie = movies[indexPath.row]
        cell.configCell(with: movie)
        cell.favAction = { [weak self] id in
            self?.viewModel.favWasPressed(movieId: id, isFavourite: !movie.isFavourite)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.navigateToMovieDetails(movieId: movies[indexPath.row].id)
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
