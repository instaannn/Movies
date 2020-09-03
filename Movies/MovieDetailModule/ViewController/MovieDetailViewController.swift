//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Анна Сычева on 28.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit
import SafariServices

//MARK: - MovieDetailViewController

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Public properties
    
    var selectIdTwo = Int()
    
    // MARK: - Private properties
    
    private lazy var movieDetail = MovieDetail()
    private lazy var trailers = Trailers()
    private lazy var posterBackground = UIImageView()
    private lazy var posterImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var starImageView = UIImageView()
    private lazy var voteAverageLabel = UILabel()
    private lazy var clockImageView = UIImageView()
    private lazy var runTimeLabel = UILabel()
    private lazy var genresCollectionView = UICollectionView()
    private lazy var overviewLabel = UILabel()
    private lazy var trailerButton = UIButton()
    private lazy var token = Constants.token
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        requestDetails(for: selectIdTwo)
        requestTrailer(for: selectIdTwo)
        configureGenresCollectionView()
        setupVies()
    }
    
    @objc
    private func actionButton() {
        guard let key = trailers.results?.first?.key,
            let url = URL(string: "https://www.youtube.com/watch?v=\(key)") else {
                let alert = UIAlertController(title: "Oops!", message: "Trailer unavailable", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: .none)
                alert.addAction(action)
                present(alert, animated: true, completion: .none)
                return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: .none)
    }
}

//MARK: - requestDetails

private extension MovieDetailViewController {
    
    func requestDetails(for id: Int) {
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
                self.configureOverviewLabel()
                self.configureTrailerButton()
                self.genresCollectionView.reloadData()
            }
        } catch {
            print("Json Error")
        }
    }
    
    //MARK: - requestTrailer
    
    func requestTrailer(for id: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=\(token)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error)  in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                print(data)
                self?.parseTrailer(from: data)
            } else {
                print("Network error")
            }
        }
        dataTask.resume()
    }
    
    func parseTrailer(from data: Data) {
        do {
            trailers = try JSONDecoder().decode(Trailers.self, from: data)
            DispatchQueue.main.async {
            }
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
        addActions()
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
        view.addSubview(overviewLabel)
        view.addSubview(trailerButton)
    }
    
    func addActions() {
        trailerButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
    }
    
    func setView() {
        view.backgroundColor = .white
    }
    
    func loadImage() {
        let moviePosterString = "https://image.tmdb.org/t/p/w500" + "\(movieDetail.poster_path ?? "")"
        guard let url = URL(string: moviePosterString) else { return }
        posterBackground.load(url: url)
        posterImageView.load(url: url)
    }
    
    func configurePosterBackground() {
        loadImage()
        posterBackground.addBlurEffect()
        
        let path = UIBezierPath(roundedRect: posterBackground.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 30, height: 30))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        posterBackground.layer.mask = maskLayer
    }
    
    func configurePosterImageView() {
        loadImage()
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
            let average: String = String(format: "%.1f", voteAverage)
            voteAverageLabel.text = average
            if voteAverage <= 7.0 {
                voteAverageLabel.textColor = .red
            } else {
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
        genresCollectionView = UICollectionView(frame: CGRect.zero,
                                                collectionViewLayout: flowLayout)
        genresCollectionView.register(GenresCollectionViewCell.self,
                                      forCellWithReuseIdentifier: Cells.collectionViewCell)
        genresCollectionView.collectionViewLayout = flowLayout
        genresCollectionView.backgroundColor = UIColor.white
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
    }
    
    func configureOverviewLabel() {
        overviewLabel.text = movieDetail.overview
        overviewLabel.numberOfLines = 0
        overviewLabel.adjustsFontSizeToFitWidth = true
        overviewLabel.font = UIFont.boldSystemFont(ofSize: 18)
        overviewLabel.textColor = UIColor.gray
    }
    
    func configureTrailerButton() {
        trailerButton.setTitle("Show trailer", for: .normal)
        trailerButton.layer.cornerRadius = 8
        trailerButton.clipsToBounds = true
        trailerButton.setGradient(colorOne: UIColor(red: 170/255.0, green: 147/255.0, blue: 214/255.0, alpha: 1),
                                  colorTwo: UIColor(red: 207/255.0, green: 206/255.0, blue: 245/255.0, alpha: 1))
        trailerButton.setTitleColor(.black, for: .normal)
    }
}

//MARK: - UICollectionViewDelegate

extension MovieDetailViewController: UICollectionViewDelegate {}

//MARK: - UICollectionViewDataSource

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetail.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = genresCollectionView.dequeueReusableCell(withReuseIdentifier: Cells.collectionViewCell,
                                                                  for: indexPath) as? GenresCollectionViewCell else { return UICollectionViewCell() }
        cell.genresLabel.text = movieDetail.genres?[indexPath.row].name
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = UIColor(red: 207/255.0, green: 206/255.0, blue: 245/255.0, alpha: 1)
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
        NSLayoutConstraint.activate([
            genresCollectionView.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor,
                constant: -10),
            genresCollectionView.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            genresCollectionView.heightAnchor.constraint(
                equalToConstant: 30),
            genresCollectionView.topAnchor.constraint(
                equalTo: starImageView.bottomAnchor,
                constant: 10)])
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overviewLabel.leadingAnchor.constraint(
                equalTo: posterImageView.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            overviewLabel.topAnchor.constraint(
                equalTo: posterImageView.bottomAnchor,
                constant: 20),
            overviewLabel.heightAnchor.constraint(
                equalToConstant: 150)])
        
        trailerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailerButton.topAnchor.constraint(
                equalTo: overviewLabel.bottomAnchor,
                constant: 20),
            trailerButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 100),
            trailerButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -100),
            trailerButton.heightAnchor.constraint(
                equalToConstant: 50)])
    }
}

//MARK: - Constants

private extension MovieDetailViewController {
    
    enum Constants {
        static let token: String = "799ad00db48f25949a3aaea920d756d6"
    }
    
    enum Cells {
        static let collectionViewCell: String = "genresCell"
    }
}
