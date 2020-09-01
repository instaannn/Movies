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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    // MARK: - Public methods
    
    func set(movie: Movies) {
        titleLabel.text = movie.title
        
        if let voteAverage = movie.vote_average {
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
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, yyyy"
        
        if let date = dateFormatterGet.date(from: movie.release_date ?? "") {
            releaseLabel.text = dateFormatterPrint.string(from: date)
        }
        
        if movie.original_language == "en" {
            flagImageView.image = UIImage(named: "USA")
        } else if movie.original_language == "ko" {
            flagImageView.image = UIImage(named: "KOR")
        } else if movie.original_language == "es" {
            flagImageView.image = UIImage(named: "ESP")
        }
        
        let moviePosterString = "https://image.tmdb.org/t/p/w500" + "\(movie.poster_path ?? "")"
        guard let url = URL(string: moviePosterString) else { return }
        posterImageView.load(url: url)
    }
    
    // MARK: - Private methods
    
    private func addVies() {
        addSubview(titleLabel)
        addSubview(posterImageView)
        addSubview(releaseLabel)
        addSubview(originalLanguageName)
        addSubview(flagImageView)
        addSubview(voteAverageName)
        addSubview(starImageView)
        addSubview(voteAverageLabel)
    }
    
    private func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.lineBreakMode = .byClipping
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
    }
    
    private func configurePosterImageView() {
        posterImageView.backgroundColor = .gray
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.masksToBounds = true
        posterImageView.contentMode = .scaleAspectFit
    }
    
    private func configureReleaseLabel() {
        releaseLabel.font = UIFont.boldSystemFont(ofSize: 20)
        releaseLabel.textColor = .black
    }
    
    private func configureLanguageName() {
        originalLanguageName.text = "Language:"
        originalLanguageName.font = UIFont.italicSystemFont(ofSize: 14)
        originalLanguageName.textColor = .gray
    }
    
    private func configureVoteAverageName() {
        voteAverageName.text = "Rating:"
        voteAverageName.font = UIFont.italicSystemFont(ofSize: 14)
        voteAverageName.textColor = .gray
    }
    
    private func configureVoteAverageLabel() {
        voteAverageLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private func configureStarImageView() {
        starImageView.image = UIImage(named: "star")
    }
    
    private func settingContentView() {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.13
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = CGColor(srgbRed: 16/255.0, green: 22/255.0, blue: 41/255.0, alpha: 1)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
}

//MARK: - Layout

private extension MovieTableViewCell {
    
    func layout() {
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10),
            posterImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 5),
            posterImageView.widthAnchor.constraint(
                equalToConstant: 150),
            posterImageView.heightAnchor.constraint(
                equalToConstant: 225),
            posterImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -10)])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 25),
            titleLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 20),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -30),
            titleLabel.heightAnchor.constraint(
                equalToConstant: 68)])
        
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releaseLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 3),
            releaseLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            releaseLabel.heightAnchor.constraint(
                equalToConstant: 23),
            releaseLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor)])
        
        originalLanguageName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            originalLanguageName.topAnchor.constraint(
                equalTo: releaseLabel.bottomAnchor,
                constant: 20),
            originalLanguageName.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            originalLanguageName.widthAnchor.constraint(
                equalToConstant: 100),
            originalLanguageName.heightAnchor.constraint(
                equalToConstant: 20)])
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(
                equalTo: originalLanguageName.leadingAnchor),
            flagImageView.topAnchor.constraint(
                equalTo: originalLanguageName.bottomAnchor,
                constant: 10),
            flagImageView.widthAnchor.constraint(
                equalToConstant: 40),
            flagImageView.heightAnchor.constraint(
                equalToConstant: 28)])
        
        voteAverageName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            voteAverageName.topAnchor.constraint(
                equalTo: releaseLabel.bottomAnchor,
                constant: 20),
            voteAverageName.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            voteAverageName.widthAnchor.constraint(
                equalToConstant: 100),
            voteAverageName.heightAnchor.constraint(
                equalToConstant: 20)])
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(
                equalTo: voteAverageName.bottomAnchor,
                constant: 10),
            starImageView.leadingAnchor.constraint(
                equalTo: voteAverageName.leadingAnchor),
            starImageView.heightAnchor.constraint(
                equalToConstant: 28),
            starImageView.widthAnchor.constraint(
                equalToConstant: 28)])
        
        voteAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            voteAverageLabel.topAnchor.constraint(
                equalTo: voteAverageName.bottomAnchor,
                constant: 10),
            voteAverageLabel.leadingAnchor.constraint(
                equalTo: starImageView.trailingAnchor,
                constant: 10),
            voteAverageLabel.heightAnchor.constraint(
                equalToConstant: 28),
            voteAverageLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor)])
    }
}

//MARK: - Constants

private extension MovieTableViewCell {
    
    enum Constants {
        static let anchorTop: CGFloat = 5
    }
}
