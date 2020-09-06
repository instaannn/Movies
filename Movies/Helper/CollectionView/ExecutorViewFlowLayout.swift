//
//  ExecutorViewFlowLayout.swift
//  Movies
//
//  Created by Анна Сычева on 01.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - ExecutorViewFlowLayout

final class ExecutorViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        var rows = [Row]()
        var currentRowY = Constants.currentRowY
        for attribute in attributes {
            if currentRowY != attribute.frame.origin.y {
                currentRowY = attribute.frame.origin.y
                rows.append(Row(spacing: Constants.spacing))
            }
            rows.last?.add(attribute: attribute)
        }
        rows.forEach { $0.tagLayout(collectionViewWidth: collectionView?.frame.width ?? Constants.zeroValue) }
        return rows.flatMap { $0.attributes }
    }
}

//MARK: - Constants

private extension ExecutorViewFlowLayout {
    
    enum Constants {
        static let currentRowY: CGFloat = -1
        static let spacing: CGFloat = 10
        static let zeroValue: CGFloat = 0
    }
    
}
