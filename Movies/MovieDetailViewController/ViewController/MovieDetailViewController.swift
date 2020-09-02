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
    
    private lazy var movieDetail = MovieDetail()
    private lazy var posterBackground = UIImageView()
    private lazy var posterImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var starImageView = UIImageView()
    private lazy var voteAverageLabel = UILabel()
    private lazy var clockImageView = UIImageView()
    private lazy var runTimeLabel = UILabel()
    private lazy var genresCollectionView = UICollectionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestDetails(for: selectIdTwo)
        setupVies()
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
                self.configurePosterBackground()
                self.configureTitleLabel()
                self.configureStarImageView()
                self.configureVoteLabel()
                self.configureClockImageView()
                self.configureRunTimeLabel()
                self.configureGenresCollectionView()
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
        view.addSubview(posterBackground)
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(starImageView)
        view.addSubview(voteAverageLabel)
        view.addSubview(clockImageView)
        view.addSubview(runTimeLabel)
        view.addSubview(genresCollectionView)
    }
    
    func setView() {
        view.backgroundColor = .white
    }
    
    func configurePosterBackground() {
        let moviePosterString = "https://image.tmdb.org/t/p/w500" + "\(movieDetail.poster_path ?? "")"
        guard let url = URL(string: moviePosterString) else { return }
        posterBackground.load(url: url)
        posterBackground.addBlurEffect()
        
        let path = UIBezierPath(roundedRect: posterBackground.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 30, height: 30))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        posterBackground.layer.mask = maskLayer
    }
    
    func configurePosterImageView() {
        let moviePosterString = "https://image.tmdb.org/t/p/w500" + "\(movieDetail.poster_path ?? "")"
        guard let url = URL(string: moviePosterString) else { return }
        posterImageView.load(url: url)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        posterImageView.layer.masksToBounds = true
    }
    
    func configureTitleLabel() {
        titleLabel.text = movieDetail.title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
    }
    
    func configureStarImageView() {
        starImageView.image = UIImage(named: "star")
    }
    
    func configureVoteLabel() {
        if let voteAverage = movieDetail.vote_average {
            if voteAverage <= 7.0 {
                let average: String = String(format: "%.1f", voteAverage)
                voteAverageLabel.text = average
                voteAverageLabel.textColor = .red
            } else {
                let average: String = String(format: "%.1f", voteAverage)
                voteAverageLabel.text = average
                voteAverageLabel.textColor = .black
            }
        }
        voteAverageLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func configureClockImageView() {
        clockImageView.image = UIImage(named: "clock")
    }
    
    func configureRunTimeLabel() {
        guard let time = movieDetail.runtime else { return }
        
        let hour = time / 60
        let minute = time - (hour * 60)
        
        runTimeLabel.text = "\(hour)h \(minute)min"
        runTimeLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func configureGenresCollectionView() {
        let flowLayout = ExecutorViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        flowLayout.scrollDirection = .horizontal
        genresCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        genresCollectionView.register(GenresCollectionViewCell.self, forCellWithReuseIdentifier: "wordsCell")
        genresCollectionView.collectionViewLayout = flowLayout
        genresCollectionView.backgroundColor = UIColor.white
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
    }
}

//MARK: - UICollectionViewDelegate

extension MovieDetailViewController: UICollectionViewDelegate {}

//MARK: - UICollectionViewDataSource

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (movieDetail.genres?.id)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genresCollectionView.dequeueReusableCell(withReuseIdentifier: "wordsCell",
                                                       for: indexPath) as! GenresCollectionViewCell
//        cell.genresLabel.text = movieDetail.genres![indexPath.row]
        cell.genresLabel.text = "Ghbdtn"
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = UIColor(red: 236/255.0, green: 226/255.0, blue: 221/255.0, alpha: 1)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {}

//MARK: - Layout

private extension MovieDetailViewController {
    
    func layout() {
        
        posterBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterBackground.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            posterBackground.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            posterBackground.heightAnchor.constraint(
                equalToConstant: 150),
            posterBackground.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor)])
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 25),
            posterImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 60),
            posterImageView.widthAnchor.constraint(
                equalToConstant: 150),
            posterImageView.heightAnchor.constraint(
                equalToConstant: 230)])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 15),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -15),
            titleLabel.topAnchor.constraint(
                equalTo: posterBackground.bottomAnchor,
                constant: 15),
            titleLabel.heightAnchor.constraint(
                equalToConstant: 55)])
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10),
            starImageView.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            starImageView.widthAnchor.constraint(
                equalToConstant: 20),
            starImageView.heightAnchor.constraint(
                equalToConstant: 20)])
        
        voteAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            voteAverageLabel.leadingAnchor.constraint(
                equalTo: starImageView.trailingAnchor,
                constant: 5),
            voteAverageLabel.centerYAnchor.constraint(
                equalTo: starImageView.centerYAnchor),
            voteAverageLabel.widthAnchor.constraint(
                equalToConstant: 30),
            voteAverageLabel.heightAnchor.constraint(
                equalToConstant: 20)])
        
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clockImageView.leadingAnchor.constraint(
                equalTo: voteAverageLabel.trailingAnchor,
                constant: 15),
            clockImageView.centerYAnchor.constraint(
                equalTo: starImageView.centerYAnchor),
            clockImageView.widthAnchor.constraint(
                equalToConstant: 20),
            clockImageView.heightAnchor.constraint(
                equalToConstant: 20)])
        
        runTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            runTimeLabel.leadingAnchor.constraint(
                equalTo: clockImageView.trailingAnchor,
                constant: 5),
            runTimeLabel.centerYAnchor.constraint(
                equalTo: starImageView.centerYAnchor),
            runTimeLabel.widthAnchor.constraint(
                equalToConstant: 90),
            runTimeLabel.heightAnchor.constraint(
                equalToConstant: 20)])
        
        genresCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([genresCollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                                     genresCollectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                                     genresCollectionView.heightAnchor.constraint(equalToConstant: 30),
                                     genresCollectionView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor)])
    }
}
