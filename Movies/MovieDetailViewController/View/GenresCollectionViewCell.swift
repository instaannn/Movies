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
        
        contentView.addSubview(genresLabel)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 0),
            contentView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: 0),
            contentView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 0),
            contentView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: 0)])
        
        NSLayoutConstraint.activate([
            genresLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 5),
            genresLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -5),
            genresLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 5),
            genresLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -5)])
        
        genresLabel.textAlignment = .center
        genresLabel.font = UIFont.italicSystemFont(ofSize: 12)
        genresLabel.adjustsFontSizeToFitWidth = true
        genresLabel.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
