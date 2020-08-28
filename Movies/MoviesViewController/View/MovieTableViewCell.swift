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
    private lazy var originalLanguageName = UILabel()
    private lazy var titleLabel = UILabel()
    private lazy var voteAverageLabel = UILabel()
    private lazy var voteAverageName = UILabel()
    private lazy var releaseLabel = UILabel()
    private lazy var releaseDataName = UILabel()
    private lazy var voteCountLabel = UILabel()
    private lazy var voteCountName = UILabel()
    private lazy var posterImageView = UIImageView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addVies()
        configureTitleLabel()
        configurePosterImageView()
        configureReleaseDateLabel()
        configureReleaseLabel()
        configureLanguageName()
        configureLanguageLabel()
        configureVoteAverageName()
        configureVoteAverageLabel()
        configureVoteCountName()
        configureVoteCountLabel()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func set(movie: Movies) {
        titleLabel.text = movie.title
        originalLanguageLabel.text = movie.original_language
        
        if let voteAverage = movie.vote_average {
            let b: String = String(format: "%.1f", voteAverage)
            voteAverageLabel.text = b
        }
        
        if let voteCount = movie.vote_count {
            let a: String = String(voteCount)
            voteCountLabel.text = a
        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, yyyy"
        
        if let date = dateFormatterGet.date(from: movie.release_date ?? "") {
            releaseLabel.text = dateFormatterPrint.string(from: date)
        }
        
        let moviePosterString = "https://image.tmdb.org/t/p/w500" + "\(movie.poster_path ?? "")"
        let url = URL(string: moviePosterString)
        posterImageView.load(url: url!)
    }
    
    // MARK: - Private methods
    
    private func addVies() {
        addSubview(titleLabel)
        addSubview(posterImageView)
        addSubview(releaseDataName)
        addSubview(releaseLabel)
        addSubview(originalLanguageName)
        addSubview(originalLanguageLabel)
        addSubview(voteAverageName)
        addSubview(voteAverageLabel)
        addSubview(voteCountName)
        addSubview(voteCountLabel)
    }
    
    private func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.lineBreakMode = .byClipping
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
        releaseDataName.text = "Release Date:"
        releaseDataName.font = UIFont.italicSystemFont(ofSize: 15)
        releaseDataName.textColor = .gray
    }
    
    private func configureReleaseLabel() {
        releaseLabel.font = UIFont.boldSystemFont(ofSize: 15)
        releaseLabel.textColor = .black
    }
    
    private func configureLanguageName() {
        originalLanguageName.text = "Language:"
        originalLanguageName.font = UIFont.italicSystemFont(ofSize: 15)
        originalLanguageName.textColor = .gray
    }
    
    private func configureLanguageLabel() {
        originalLanguageLabel.font = UIFont.boldSystemFont(ofSize: 15)
        originalLanguageLabel.textColor = .black
    }
    
    private func configureVoteAverageName() {
        voteAverageName.text = "Rating:"
        voteAverageName.font = UIFont.italicSystemFont(ofSize: 15)
        voteAverageName.textColor = .gray
    }
    
    private func configureVoteAverageLabel() {
        voteAverageLabel.font = UIFont.boldSystemFont(ofSize: 17)
        voteAverageLabel.textColor = .red
    }
    
    private func configureVoteCountName() {
        voteCountName.text = "Vote count:"
        voteCountName.font = UIFont.italicSystemFont(ofSize: 15)
        voteCountName.textColor = .gray
    }
    
    private func configureVoteCountLabel() {
        voteCountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        voteCountLabel.textColor = .black
    }
}

//MARK: - Layout

private extension MovieTableViewCell {
    
    func layout() {
        
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
                equalToConstant: 50)])
        
        releaseDataName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releaseDataName.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10),
            releaseDataName.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            releaseDataName.widthAnchor.constraint(
                equalToConstant: 100),
            releaseDataName.heightAnchor.constraint(
                equalToConstant: 20)])
        
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releaseLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10),
            releaseLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            releaseLabel.heightAnchor.constraint(
                equalToConstant: 20),
            releaseLabel.leadingAnchor.constraint(
                equalTo: releaseDataName.trailingAnchor,
                constant: 10)])
        
        originalLanguageName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            originalLanguageName.topAnchor.constraint(
                equalTo: releaseDataName.bottomAnchor,
                constant: 10),
            originalLanguageName.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            originalLanguageName.widthAnchor.constraint(
                equalToConstant: 100),
            originalLanguageName.heightAnchor.constraint(
                equalToConstant: 20)])
        
        originalLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            originalLanguageLabel.topAnchor.constraint(
                equalTo: releaseLabel.bottomAnchor,
                constant: 10),
            originalLanguageLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor),
            originalLanguageLabel.heightAnchor.constraint(
                equalToConstant: 20),
            originalLanguageLabel.leadingAnchor.constraint(
                equalTo: originalLanguageName.trailingAnchor,
                constant: 10)])
        
        voteAverageName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            voteAverageName.topAnchor.constraint(
                equalTo: originalLanguageName.bottomAnchor,
                constant: 10),
            voteAverageName.leadingAnchor.constraint(
                equalTo: originalLanguageName.leadingAnchor),
            voteAverageName.widthAnchor.constraint(
                equalToConstant: 100),
            voteAverageName.heightAnchor.constraint(
                equalToConstant: 20)])
        
        voteAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            voteAverageLabel.centerYAnchor.constraint(
                equalTo: voteAverageName.centerYAnchor),
            voteAverageLabel.leadingAnchor.constraint(
                equalTo: voteAverageName.trailingAnchor,
                constant: 10),
            voteAverageLabel.heightAnchor.constraint(
                equalToConstant: 20),
            voteAverageLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor)])
        
        voteCountName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            voteCountName.topAnchor.constraint(
                equalTo: voteAverageName.bottomAnchor,
                constant: 10),
            voteCountName.leadingAnchor.constraint(
                equalTo: voteAverageName.leadingAnchor),
            voteCountName.widthAnchor.constraint(
                equalToConstant: 100),
            voteCountName.heightAnchor.constraint(
                equalToConstant: 20)])

        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            voteCountLabel.centerYAnchor.constraint(
                equalTo: voteCountName.centerYAnchor),
            voteCountLabel.leadingAnchor.constraint(
                equalTo: voteCountName.trailingAnchor,
                constant: 10),
            voteCountLabel.heightAnchor.constraint(
                equalToConstant: 20),
            voteCountLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor)])
    }
}

//MARK: - Constants

private extension MovieTableViewCell {
    
    enum Constants {
        static let anchorTop: CGFloat = 5
    }
}
