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
    
    private lazy var originalLanguageLabel = UILabel()
    private lazy var titleLabel = UILabel()
    private lazy var voteAverageLabel = UILabel()
    private lazy var releaseLabel = UILabel()
    private lazy var releaseDataLabel = UILabel()
    private lazy var voteCountLabel = UILabel()
    private lazy var posterImageView = UIImageView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addVies()
        configureTitleLabel()
        configurePosterImageView()
        configureReleaseDateLabel()
        configureReleaseLabel()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func set(movie: Movies) {
        titleLabel.text = movie.title
        releaseLabel.text = movie.release_date
        
        let moviePosterString = "https://image.tmdb.org/t/p/w500" + "\(movie.poster_path ?? "")"
        let url = URL(string: moviePosterString)
        posterImageView.load(url: url!)
    }
    
    // MARK: - Private methods
    
    private func addVies() {
        addSubview(titleLabel)
        addSubview(posterImageView)
        addSubview(releaseDataLabel)
        addSubview(releaseLabel)
    }
    
    private func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
    }
    
    private func configurePosterImageView() {
        posterImageView.backgroundColor = .gray
        posterImageView.layer.cornerRadius = 5
        posterImageView.layer.masksToBounds = true
        posterImageView.contentMode = .scaleAspectFit
    }
    
    private func configureReleaseDateLabel() {
        releaseDataLabel.text = "Release Date:"
        releaseDataLabel.font = UIFont.italicSystemFont(ofSize: 15)
        releaseDataLabel.textColor = .gray
    }
    
    private func configureReleaseLabel() {
        releaseLabel.font = UIFont.boldSystemFont(ofSize: 10)
        releaseLabel.textColor = .black
    }
}

//MARK: - Layout

private extension MovieTableViewCell {
    
    func layout() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 5),
            titleLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 20),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20),
            titleLabel.heightAnchor.constraint(
                equalToConstant: 48)])
        
        releaseDataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releaseDataLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10),
            releaseDataLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            releaseDataLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            releaseDataLabel.heightAnchor.constraint(
                equalToConstant: 15)])
        
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([releaseLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                                     releaseLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                                     releaseLabel.heightAnchor.constraint(equalToConstant: 15),
                                     releaseLabel.leadingAnchor.constraint(equalTo: releaseDataLabel.trailingAnchor, constant: -5)])
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 5),
            posterImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 5),
            posterImageView.widthAnchor.constraint(
                equalToConstant: 150),
            posterImageView.heightAnchor.constraint(
                equalToConstant: 225),
            posterImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -5)])
    }
}

//MARK: - Constants

private extension MovieTableViewCell {
    
    enum Constants {
        static let anchorTop: CGFloat = 5
    }
}
