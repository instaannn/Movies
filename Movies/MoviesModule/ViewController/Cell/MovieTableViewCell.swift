//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Анна Сычева on 26.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - MovieTableViewCell

final class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private lazy var posterImageView = UIImageView()
    private lazy var originalLanguageName = UILabel()
    private lazy var flagImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var voteAverageLabel = UILabel()
    private lazy var voteAverageName = UILabel()
    private lazy var starImageView = UIImageView()
    private lazy var releaseLabel = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupVies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: Constants.frameInset,
                                                                     left: Constants.frameInset,
                                                                     bottom: Constants.frameInset,
                                                                     right: Constants.frameInset))
    }
    
    // MARK: - Public methods
    
    func set(movie: Movies) {
        setTitle(movie: movie)
        setFlag(movie: movie)
        setVoteAverage(movie: movie)
        setRelease(movie: movie)
        setPoster(movie: movie)
    }
    
    // MARK: - Private methods
    
    private func setTitle(movie: Movies) {
        titleLabel.text = movie.title
    }
    
    private func setFlag(movie: Movies) {
        
        enum FlagName {
            static var en = Constants.flagEn
            static var ko = Constants.flagKo
            static var es = Constants.flagEs
        }
        
        switch movie.originalLanguage {
        case FlagName.en:
            flagImageView.image = UIImage(named: Constants.flagImageNameEn)
        case FlagName.ko:
            flagImageView.image = UIImage(named: Constants.flagImageNameKo)
        case FlagName.es:
            flagImageView.image = UIImage(named: Constants.flagImageNameEs)
        default:
            break
        }
    }
    
    private func setVoteAverage(movie: Movies) {
        let average = String(format: Constants.doubleFormate, movie.voteAverage)
        voteAverageLabel.text = average
        if movie.voteAverage <= Constants.voteAverageTextColor {
            voteAverageLabel.textColor = .red
        } else {
            voteAverageLabel.textColor = .black
        }
    }
    
    private func setRelease(movie: Movies) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Constants.dateFormatterGet
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Constants.dateFormatterPrint
        
        if let date = dateFormatterGet.date(from: movie.releaseDate) {
            releaseLabel.text = dateFormatterPrint.string(from: date)
        }
    }
    
    private func setPoster(movie: Movies) {
        let moviePosterString = Url.urlPoster + "\(movie.posterPath)"
        guard let url = URL(string: moviePosterString) else { return }
        posterImageView.load(url: url)
    }
}

// MARK: - Setupe

private extension MovieTableViewCell {
    
    func setupVies() {
        settingContentView()
        
        addVies()
        
        configureTitleLabel()
        configurePosterImageView()
        configureReleaseLabel()
        configureLanguageName()
        configureVoteAverageName()
        configureVoteAverageLabel()
        configureStarImageView()
        
        layout()
    }
}

//MARK: - Setup Elements

private extension MovieTableViewCell {
    
    func addVies() {
        addSubview(titleLabel)
        addSubview(posterImageView)
        addSubview(releaseLabel)
        addSubview(originalLanguageName)
        addSubview(flagImageView)
        addSubview(voteAverageName)
        addSubview(starImageView)
        addSubview(voteAverageLabel)
    }
    
    func configureTitleLabel() {
        titleLabel.numberOfLines = Constants.titleLabelNumberOfLines
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelFont)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = Colors.grafit
        titleLabel.textAlignment = .left
    }
    
    func configurePosterImageView() {
        posterImageView.backgroundColor = .gray
        posterImageView.layer.cornerRadius = Constants.cornerRadius
        posterImageView.layer.masksToBounds = true
        posterImageView.contentMode = .scaleAspectFit
    }
    
    func configureReleaseLabel() {
        releaseLabel.font = UIFont.boldSystemFont(ofSize: Constants.voteAndReleaseLabelFont)
        releaseLabel.textColor = Colors.grafit
    }
    
    func configureLanguageName() {
        originalLanguageName.text = Constants.originalLanguageNameText
        originalLanguageName.font = UIFont.italicSystemFont(ofSize: Constants.voteAndLanguageNameFont)
        originalLanguageName.textColor = .gray
    }
    
    func configureVoteAverageName() {
        voteAverageName.text = Constants.voteAverageNameText
        voteAverageName.font = UIFont.italicSystemFont(ofSize: Constants.voteAndLanguageNameFont)
        voteAverageName.textColor = .gray
    }
    
    func configureVoteAverageLabel() {
        voteAverageLabel.font = UIFont.boldSystemFont(ofSize: Constants.voteAndReleaseLabelFont)
    }
    
    func configureStarImageView() {
        starImageView.image = UIImage(named: Constants.starImageName)
    }
    
    func settingContentView() {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowColor = Colors.shadowDarkGray
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerRadius
    }
}

//MARK: - Layout

private extension MovieTableViewCell {
    
    func layout() {
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        posterImageView.topAnchor.constraint(
                                            equalTo: topAnchor,
                                            constant: Constants.tenAnchor),
                                        posterImageView.leadingAnchor.constraint(
                                            equalTo: leadingAnchor,
                                            constant: Constants.posterImageViewLeadingAnchor),
                                        posterImageView.widthAnchor.constraint(
                                            equalToConstant: Constants.posterImageViewWidthAnchor),
                                        posterImageView.heightAnchor.constraint(
                                            equalToConstant: Constants.posterImageViewHeightAnchor),
                                        posterImageView.bottomAnchor.constraint(
                                            equalTo: bottomAnchor, constant: Constants.posterImageViewBottomAnchor)])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        titleLabel.topAnchor.constraint(
                                            equalTo: topAnchor,
                                            constant: Constants.titleLabelTopAnchor),
                                        titleLabel.leadingAnchor.constraint(
                                            equalTo: posterImageView.trailingAnchor,
                                            constant: Constants.twentyAnchor),
                                        titleLabel.trailingAnchor.constraint(
                                            equalTo: trailingAnchor,
                                            constant: Constants.titleLabelTrailingAnchor),
                                        titleLabel.heightAnchor.constraint(
                                            equalToConstant: Constants.titleLabelHeightAnchor)])
        
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        releaseLabel.topAnchor.constraint(
                                            equalTo: titleLabel.bottomAnchor,
                                            constant: Constants.releaseLabelTopAnchor),
                                        releaseLabel.trailingAnchor.constraint(
                                            equalTo: titleLabel.trailingAnchor),
                                        releaseLabel.heightAnchor.constraint(
                                            equalToConstant: Constants.releaseLabelHeightAnchor),
                                        releaseLabel.leadingAnchor.constraint(
                                            equalTo: titleLabel.leadingAnchor)])
        
        originalLanguageName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        originalLanguageName.topAnchor.constraint(
                                            equalTo: releaseLabel.bottomAnchor,
                                            constant: Constants.twentyAnchor),
                                        originalLanguageName.leadingAnchor.constraint(
                                            equalTo: titleLabel.leadingAnchor),
                                        originalLanguageName.widthAnchor.constraint(
                                            equalToConstant: Constants.widthHundredAnchor),
                                        originalLanguageName.heightAnchor.constraint(
                                            equalToConstant: Constants.twentyAnchor)])
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        flagImageView.leadingAnchor.constraint(
                                            equalTo: originalLanguageName.leadingAnchor),
                                        flagImageView.topAnchor.constraint(
                                            equalTo: originalLanguageName.bottomAnchor,
                                            constant: Constants.tenAnchor),
                                        flagImageView.widthAnchor.constraint(
                                            equalToConstant: Constants.flagImageWidthAnchor),
                                        flagImageView.heightAnchor.constraint(
                                            equalToConstant: Constants.sizeImage)])
        
        voteAverageName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        voteAverageName.topAnchor.constraint(
                                            equalTo: releaseLabel.bottomAnchor,
                                            constant: Constants.twentyAnchor),
                                        voteAverageName.trailingAnchor.constraint(
                                            equalTo: titleLabel.trailingAnchor),
                                        voteAverageName.widthAnchor.constraint(
                                            equalToConstant: Constants.widthHundredAnchor),
                                        voteAverageName.heightAnchor.constraint(
                                            equalToConstant: Constants.twentyAnchor)])
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        starImageView.topAnchor.constraint(
                                            equalTo: voteAverageName.bottomAnchor,
                                            constant: Constants.tenAnchor),
                                        starImageView.leadingAnchor.constraint(
                                            equalTo: voteAverageName.leadingAnchor),
                                        starImageView.heightAnchor.constraint(
                                            equalToConstant: Constants.sizeImage),
                                        starImageView.widthAnchor.constraint(
                                            equalToConstant: Constants.sizeImage)])
        
        voteAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        voteAverageLabel.topAnchor.constraint(
                                            equalTo: voteAverageName.bottomAnchor,
                                            constant: Constants.tenAnchor),
                                        voteAverageLabel.leadingAnchor.constraint(
                                            equalTo: starImageView.trailingAnchor,
                                            constant: Constants.tenAnchor),
                                        voteAverageLabel.heightAnchor.constraint(
                                            equalToConstant: Constants.sizeImage),
                                        voteAverageLabel.trailingAnchor.constraint(
                                            equalTo: titleLabel.trailingAnchor)])
    }
}

//MARK: - Constants

private extension MovieTableViewCell {
    
    enum Constants {
        static let frameInset: CGFloat = 10
        static let flagEn: String = "en"
        static let flagKo: String = "ko"
        static let flagEs: String = "es"
        static let flagImageNameEn: String = "USA"
        static let flagImageNameKo: String = "KOR"
        static let flagImageNameEs: String = "ESP"
        static let voteAverageTextColor: Double = 7.0
        static let doubleFormate: String = "%.1f"
        static let dateFormatterPrint: String = "MMM d, yyyy"
        static let dateFormatterGet: String = "yyyy-MM-dd"
        static let voteAndReleaseLabelFont: CGFloat = 20
        static let voteAndLanguageNameFont: CGFloat = 14
        static let titleLabelFont: CGFloat = 35
        static let titleLabelNumberOfLines: Int = 0
        static let voteAverageNameText: String = "Rating:"
        static let originalLanguageNameText: String = "Language:"
        static let starImageName: String = "star"
        static let cornerRadius: CGFloat = 8
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Float = 0.13
        static let anchorTop: CGFloat = 5
        static let sizeImage: CGFloat = 28
        static let tenAnchor: CGFloat = 10
        static let twentyAnchor: CGFloat = 20
        static let widthHundredAnchor: CGFloat = 100
        static let flagImageWidthAnchor: CGFloat = 40
        static let releaseLabelHeightAnchor: CGFloat = 23
        static let releaseLabelTopAnchor: CGFloat = 3
        static let titleLabelHeightAnchor: CGFloat = 68
        static let titleLabelTrailingAnchor: CGFloat = -30
        static let titleLabelTopAnchor: CGFloat = 25
        static let posterImageViewBottomAnchor: CGFloat = -10
        static let posterImageViewHeightAnchor: CGFloat = 225
        static let posterImageViewWidthAnchor: CGFloat = 150
        static let posterImageViewLeadingAnchor: CGFloat = 5
    }
    
}
