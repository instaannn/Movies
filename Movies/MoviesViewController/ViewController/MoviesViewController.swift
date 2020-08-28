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
                print("Json Error")
            }
        } .resume()
    }
}

// MARK: - Setupe

private extension MoviesViewController {
    
    func setupVies() {
        addVies()
        setupTableView()
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
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Cells.movieCell)
        
    }
}

//MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {}

//MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: Cells.movieCell,
                                                       for: indexPath) as! MovieTableViewCell
        let movie = results.results![indexPath.row]
        cell.set(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.goToMovieDetailViewController()
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

//MARK: - Enums

private extension MoviesViewController {
    
    enum UrlString {
        static let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=799ad00db48f25949a3aaea920d756d6"
    }
    
    enum Cells {
        static let movieCell = "movieCell"
    }
    
}
