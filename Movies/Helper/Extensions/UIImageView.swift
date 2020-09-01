//
//  UIImageView.swift
//  Movies
//
//  Created by Анна Сычева on 27.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

extension UIImageView {

    func load(url: URL) {
        DispatchQueue.global().async { [ weak self ] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}