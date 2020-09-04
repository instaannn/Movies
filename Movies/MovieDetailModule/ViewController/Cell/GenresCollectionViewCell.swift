//
//  GenresCollectionViewCell.swift
//  Movies
//
//  Created by Анна Сычева on 01.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - GenresCollectionViewCell

final class GenresCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    var genresLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setupe

private extension GenresCollectionViewCell {
    
    func setupVies() {
        addVies()
        settingLabel()
        layout()
    }
}

//MARK: - Setup Elements

private extension GenresCollectionViewCell {
    
    func addVies() {
        contentView.addSubview(genresLabel)
    }
    
    func settingLabel() {
        genresLabel.textAlignment = .center
        genresLabel.font = UIFont.italicSystemFont(ofSize: Constants.genresLabelFont)
        genresLabel.adjustsFontSizeToFitWidth = true
        genresLabel.numberOfLines = Constants.numberOfLines
    }
}

//MARK: - Layout

private extension GenresCollectionViewCell {
    
    func layout() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.zeroAnchor),
            contentView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: Constants.zeroAnchor),
            contentView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.zeroAnchor),
            contentView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: Constants.zeroAnchor)])
        
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genresLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.genresLabelLeadingAnchor),
            genresLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Constants.genresLabelTrailingAnchor),
            genresLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.genresLabelLeadingAnchor),
            genresLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: Constants.genresLabelTrailingAnchor)])
    }
}

//MARK: - Constants

private extension GenresCollectionViewCell {
    
    enum Constants {
        static let genresLabelLeadingAnchor: CGFloat = 5
        static let genresLabelTrailingAnchor: CGFloat = -5
        static let zeroAnchor: CGFloat = 0
        static let numberOfLines: Int = 0
        static let genresLabelFont: CGFloat = 12
    }
    
}
