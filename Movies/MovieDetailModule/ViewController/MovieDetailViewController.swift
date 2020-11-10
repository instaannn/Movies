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
    
    private var movieDetail: MovieDetail?
    private var trailers: Trailers?
    private var networkLayer: INetworkLayer?
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGenresCollectionView()
        setupVies()
        setupBinding()
    }
    
    // MARK: - Private methods
    
    private func loadTrailers() {
        networkLayer = NetworkLayer()
        networkLayer?.fetchTrailer(for: selectIdTwo, complition: { [weak self] item in
            guard let self = self else { return }
            print(Thread.current)
            DispatchQueue.main.async {
                switch item {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self.trailers = data
                }
                print(Thread.current)
            }
        })
    }
    
    private func loadDetails() {
        networkLayer = NetworkLayer()
        networkLayer?.fetchDetails(for: selectIdTwo, complition: { [weak self] item in
            guard let self = self else { return }
            print(Thread.current)
            DispatchQueue.main.async {
                switch item {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self.movieDetail = data
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
                print(Thread.current)
            }
        })
    }
    
    @objc
    private func actionButton() {
        guard let key = trailers?.results.first?.key,
            let url = URL(string: "\(Url.urlYoutube)\(key)") else {
                showAlert(title: Constants.alertTitle, message: Constants.alertMessage)
                return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: .none)
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
    
    func setupBinding() {
        loadTrailers()
        loadDetails()
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
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func loadImage() {
        let moviePosterString = Url.urlPoster + "\(movieDetail?.posterPath ?? "")"
        guard let url = URL(string: moviePosterString) else { return }
        posterBackground.load(url: url)
        posterImageView.load(url: url)
    }
    
    func configurePosterBackground() {
        loadImage()
        posterBackground.addBlurEffect()
        
        let path = UIBezierPath(roundedRect: posterBackground.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: Constants.cornerRadiusBackground,
                                                    height: Constants.cornerRadiusBackground))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        posterBackground.layer.mask = maskLayer
    }
    
    func configurePosterImageView() {
        loadImage()
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = Constants.cornerRadius
        posterImageView.clipsToBounds = true
        posterImageView.layer.masksToBounds = true
    }
    
    func configureTitleLabel() {
        titleLabel.text = movieDetail?.title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelFont)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = Constants.zero
    }
    
    func configureStarImageView() {
        starImageView.image = UIImage(named: Constants.starImageViewName)
    }
    
    func configureVoteLabel() {
        if let voteAverage = movieDetail?.voteAverage {
            let average = String(format: Constants.doubleFormat, voteAverage)
            voteAverageLabel.text = average
            if voteAverage <= Constants.doubleVoteAverage {
                voteAverageLabel.textColor = .red
            } else {
                voteAverageLabel.textColor = .black
            }
        }
        voteAverageLabel.font = UIFont.boldSystemFont(ofSize: Constants.boldFont)
    }
    
    func configureClockImageView() {
        clockImageView.image = UIImage(named: Constants.clockImageViewName)
    }
    
    func configureRunTimeLabel() {
        guard let time = movieDetail?.runtime else { return }
        let hour = time / Constants.hour
        let minute = time - (hour * Constants.hour)
        runTimeLabel.text = "\(hour)h \(minute)min"
        runTimeLabel.font = UIFont.boldSystemFont(ofSize: Constants.boldFont)
    }
    
    func configureGenresCollectionView() {
        let flowLayout = ExecutorViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: Constants.one, height: Constants.one)
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
        overviewLabel.text = movieDetail?.overview
        overviewLabel.numberOfLines = Constants.zero
        overviewLabel.adjustsFontSizeToFitWidth = true
        overviewLabel.font = UIFont.boldSystemFont(ofSize: Constants.boldFont)
        overviewLabel.textColor = UIColor.gray
    }
    
    func configureTrailerButton() {
        trailerButton.setTitle(Constants.railerButtonSetTitle, for: .normal)
        trailerButton.layer.cornerRadius = Constants.cornerRadius
        trailerButton.clipsToBounds = true
        trailerButton.setGradient(colorOne: Colors.darkPurple,
                                  colorTwo: Colors.lightPurple)
        trailerButton.setTitleColor(.black, for: .normal)
    }
}

//MARK: - UICollectionViewDelegate

extension MovieDetailViewController: UICollectionViewDelegate {}

//MARK: - UICollectionViewDataSource

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetail?.genres.count ?? Constants.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = genresCollectionView.dequeueReusableCell(
            withReuseIdentifier: Cells.collectionViewCell,
            for: indexPath) as? GenresCollectionViewCell else { return UICollectionViewCell() }
        cell.genresLabel.text = movieDetail?.genres[indexPath.row].name
        cell.layer.cornerRadius = Constants.cornerRadius
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = Colors.lightPurple
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
                equalToConstant: Constants.posterBackgroundHeightAnchor),
            posterBackground.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor)])
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.posterImageViewLeadingAnchor),
            posterImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.posterImageViewTopAnchor),
            posterImageView.widthAnchor.constraint(
                equalToConstant: Constants.posterImageViewWidthAnchor),
            posterImageView.heightAnchor.constraint(
                equalToConstant: Constants.posterImageViewHeightAnchor)])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: Constants.fifteenAnchor),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.titleLabelTrailingAnchor),
            titleLabel.topAnchor.constraint(
                equalTo: posterBackground.bottomAnchor,
                constant: Constants.fifteenAnchor),
            titleLabel.heightAnchor.constraint(
                equalToConstant: Constants.titleLabelHeightAnchor)])
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.tenAnchor),
            starImageView.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            starImageView.widthAnchor.constraint(
                equalToConstant: Constants.twentyAnchor),
            starImageView.heightAnchor.constraint(
                equalToConstant: Constants.twentyAnchor)])
        
        voteAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            voteAverageLabel.leadingAnchor.constraint(
                equalTo: starImageView.trailingAnchor,
                constant: Constants.fiveAnchor),
            voteAverageLabel.centerYAnchor.constraint(
                equalTo: starImageView.centerYAnchor),
            voteAverageLabel.widthAnchor.constraint(
                equalToConstant: Constants.voteAverageLabelWidthAnchor),
            voteAverageLabel.heightAnchor.constraint(
                equalToConstant: Constants.twentyAnchor)])
        
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clockImageView.leadingAnchor.constraint(
                equalTo: voteAverageLabel.trailingAnchor,
                constant: Constants.fifteenAnchor),
            clockImageView.centerYAnchor.constraint(
                equalTo: starImageView.centerYAnchor),
            clockImageView.widthAnchor.constraint(
                equalToConstant: Constants.twentyAnchor),
            clockImageView.heightAnchor.constraint(
                equalToConstant: Constants.twentyAnchor)])
        
        runTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            runTimeLabel.leadingAnchor.constraint(
                equalTo: clockImageView.trailingAnchor,
                constant: Constants.fiveAnchor),
            runTimeLabel.centerYAnchor.constraint(
                equalTo: starImageView.centerYAnchor),
            runTimeLabel.widthAnchor.constraint(
                equalToConstant: Constants.runTimeLabelWidthAnchor),
            runTimeLabel.heightAnchor.constraint(
                equalToConstant: Constants.twentyAnchor)])
        
        genresCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genresCollectionView.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor,
                constant: Constants.genresCollectionViewLeadingAnchor),
            genresCollectionView.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            genresCollectionView.heightAnchor.constraint(
                equalToConstant: Constants.genresCollectionViewHeightAnchor),
            genresCollectionView.topAnchor.constraint(
                equalTo: starImageView.bottomAnchor,
                constant: Constants.tenAnchor)])
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overviewLabel.leadingAnchor.constraint(
                equalTo: posterImageView.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            overviewLabel.topAnchor.constraint(
                equalTo: posterImageView.bottomAnchor,
                constant: Constants.twentyAnchor),
            overviewLabel.heightAnchor.constraint(
                equalToConstant: Constants.overviewLabelHeightAnchor)])
        
        trailerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailerButton.topAnchor.constraint(
                equalTo: overviewLabel.bottomAnchor,
                constant: Constants.twentyAnchor),
            trailerButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.trailerButtonLeadingAnchor),
            trailerButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constants.trailerButtonTrailingAnchor),
            trailerButton.heightAnchor.constraint(
                equalToConstant: Constants.trailerButtonHeightAnchor)])
    }
}

//MARK: - Constants

private extension MovieDetailViewController {
    
    enum Constants {
        static let alertTitle: String = "Oops!"
        static let alertMessage: String = "Trailer unavailable"
        static let cornerRadiusBackground: CGFloat = 30
        static let doubleVoteAverage: Double = 7.0
        static let doubleFormat: String = "%.1f"
        static let titleLabelFont: CGFloat = 30
        static let clockImageViewName: String = "clock"
        static let starImageViewName: String = "star"
        static let hour: Int = 60
        static let one: Int = 1
        static let boldFont: CGFloat = 18
        static let zero: Int = 0
        static let railerButtonSetTitle: String = "Show trailer"
        static let cornerRadius: CGFloat = 8
        static let twentyAnchor: CGFloat = 20
        static let posterBackgroundHeightAnchor: CGFloat = 150
        static let posterImageViewLeadingAnchor: CGFloat = 25
        static let posterImageViewTopAnchor: CGFloat = 60
        static let posterImageViewWidthAnchor: CGFloat = 150
        static let posterImageViewHeightAnchor: CGFloat = 230
        static let fifteenAnchor: CGFloat = 15
        static let tenAnchor: CGFloat = 10
        static let fiveAnchor: CGFloat = 5
        static let titleLabelTrailingAnchor: CGFloat = -15
        static let titleLabelHeightAnchor: CGFloat = 55
        static let voteAverageLabelWidthAnchor: CGFloat = 30
        static let runTimeLabelWidthAnchor: CGFloat = 90
        static let genresCollectionViewLeadingAnchor: CGFloat = -10
        static let genresCollectionViewHeightAnchor: CGFloat = 30
        static let overviewLabelHeightAnchor: CGFloat = 150
        static let trailerButtonLeadingAnchor: CGFloat = 100
        static let trailerButtonTrailingAnchor: CGFloat = -100
        static let trailerButtonHeightAnchor: CGFloat = 50
    }
    
    enum Cells {
        static let collectionViewCell: String = "genresCell"
    }
    
}

