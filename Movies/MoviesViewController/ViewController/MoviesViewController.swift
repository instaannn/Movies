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
    
    var coordinator: Coordinator?
    var selectIdOne: Int?
    
    // MARK: - Private properties
    
    private lazy var results = Results()
    private lazy var moviesTableView = UITableView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJson()
        setupVies()
    }
}

//MARK: - downloadJson

private extension MoviesViewController {
    
    func downloadJson() {
        let urlString = UrlString.urlString
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { ( data, _, error ) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                self.results = try JSONDecoder().decode(Results.self, from: data)
                DispatchQueue.main.async {
                    self.moviesTableView.reloadData()
                }
                print(self.results)
            } catch {
                print(Constants.jsonError)
            }
        } .resume()
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
        return results.results?.count ?? Constants.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = moviesTableView.dequeueReusableCell(withIdentifier: Cells.movieCell,
                                                             for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        guard let movie = results.results?[indexPath.row] else { return UITableViewCell() }
        cell.set(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = results.results?[indexPath.row].id else { return }
        selectIdOne = id
        coordinator?.goToMovieDetailViewController(id: selectIdOne ?? Constants.zero)
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
        static let jsonError: String = "Json Error"
        static let title: String = "Популярное"
    }
    
    enum UrlString {
        static let urlString: String = "https://api.themoviedb.org/3/movie/popular?api_key=799ad00db48f25949a3aaea920d756d6"
    }
    
    enum Cells {
        static let movieCell: String = "movieCell"
    }
}
