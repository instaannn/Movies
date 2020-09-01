//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Анна Сычева on 28.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - MovieDetailViewController

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Public properties
    
    public var selectIdTwo = Int()
    
    // MARK: - Private properties
    
    private lazy var idLabel = UILabel()
    private lazy var movieDetail = MovieDetail()
    private lazy var posterImageView = UIImageView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDetails(for: selectIdTwo)
        
        setupVies()

        
        view.addSubview(idLabel)
        
        
        
        idLabel.text = String(selectIdTwo)
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([idLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     idLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     idLabel.widthAnchor.constraint(equalToConstant: 100),
                                     idLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
}

//MARK: - requestDetails

private extension MovieDetailViewController {
    
    func requestDetails(for id: Int) {
        let token = "799ad00db48f25949a3aaea920d756d6"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(token)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [ weak self] (data, response, error)  in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                print(data)
                self?.parseDetails(from: data)
            } else {
                print("Network error")
            }
        }
        dataTask.resume()
    }
    
    func parseDetails(from data: Data) {
        do {
            self.movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
            DispatchQueue.main.async {
                self.configurePosterImageView()
            }
            
            print(movieDetail)
        } catch {
            print("Json Error")
        }
    }
    
}

// MARK: - Setupe

private extension MovieDetailViewController {
    
    func setupVies() {
        addVies()
        setView()
        layout()
    }
}

//MARK: - Setup Elements

private extension MovieDetailViewController {
    
    func addVies() {
        view.addSubview(posterImageView)
    }
    
    func setView() {
        view.backgroundColor = .white
    }
    
    func configurePosterImageView() {
        guard let stringImage = movieDetail.poster_path else { return }
        let moviePosterString = "https://image.tmdb.org/t/p/w500" + "\(stringImage)"
        guard let url = URL(string: moviePosterString) else { return }
        posterImageView.load(url: url)
        posterImageView.contentMode = .scaleAspectFit
    }
}

//MARK: - Layout

private extension MovieDetailViewController {
    
    func layout() {
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            posterImageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            posterImageView.widthAnchor.constraint(
                equalToConstant: 350),
            posterImageView.heightAnchor.constraint(
                equalToConstant: 350)])
    }
}


