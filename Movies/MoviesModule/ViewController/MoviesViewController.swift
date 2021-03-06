//
//  MoviesViewController.swift
//  Movies
//
//  Created by Анна Сычева on 26.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - MoviesViewController

final class MoviesViewController: UIViewController {
    
    // MARK: - Public properties
    
    public var coordinator: IMoviesCoordinator?
    
    // MARK: - Private properties
    
    private var results: Results?
    private lazy var moviesTableView = UITableView()
    private var networkLayer: INetworkLayer?
    private var selectIdOne: Int?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVies()
        setupBinding()
    }
    
    // MARK: Private methods
    
    private func loadData() {
        networkLayer = NetworkLayer()
        networkLayer?.fetchResult(complition: { [weak self] item in
            guard let self = self else { return }
            print(Thread.current)
            DispatchQueue.main.async {
                switch item {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self.results = data
                    self.moviesTableView.reloadData()
                }
                print(Thread.current)
            }
        })
    }
    
    private func goTMoviesDetailViewController(indexPath: Int) {
        guard let id = results?.results[indexPath].id else { return }
        selectIdOne = id
        coordinator?.goToMovieDetailViewController(id: selectIdOne ?? Constants.zero)
    }
}

// MARK: - Setupe

private extension MoviesViewController {
    
    func setupVies() {
        addVies()
        setupTableView()
        configureNavigationController()
        layout()
    }
    
    func setupBinding() {
        loadData()
    }
}

//MARK: - Setup Elements

private extension MoviesViewController {
    
    func addVies() {
        view.addSubview(moviesTableView)
    }
    
    func setupTableView() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.separatorColor = .clear
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Cells.movieCell)
    }
    
    func configureNavigationController() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

//MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {}

//MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.results.count ?? Constants.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = moviesTableView.dequeueReusableCell(
                withIdentifier: Cells.movieCell,
                for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        guard let movie = results?.results[indexPath.row] else { return UITableViewCell() }
        
        cell.set(movie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goTMoviesDetailViewController(indexPath: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
}

//MARK: - Layout

private extension MoviesViewController {
    
    func layout() {
        
        moviesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        moviesTableView.topAnchor.constraint(
                                            equalTo: view.safeAreaLayoutGuide.topAnchor),
                                        moviesTableView.bottomAnchor.constraint(
                                            equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                        moviesTableView.leadingAnchor.constraint(
                                            equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                        moviesTableView.trailingAnchor.constraint(
                                            equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
}

//MARK: - Constants

private extension MoviesViewController {
    
    enum Constants {
        static let zero: Int = 0
        static let title: String = "Популярное"
    }
    
    enum Cells {
        static let movieCell: String = "movieCell"
    }
    
}
