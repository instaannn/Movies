//
//  Row.swift
//  Movies
//
//  Created by Анна Сычева on 01.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - Row

final class Row {
    
    // MARK: - Public properties
    
    var attributes = [UICollectionViewLayoutAttributes]()
    
    // MARK: - Private properties
    
    private lazy var spacing: CGFloat = 0
    
    // MARK: - Init
    
    init(spacing: CGFloat) {
        self.spacing = spacing
    }
    
    // MARK: - Public methods
    
    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }
    
    func tagLayout(collectionViewWidth: CGFloat) {
        let padding = 10
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = CGFloat(offset)
            offset += Int(attribute.frame.width + spacing)
        }
    }
}
