//
//  UIViewController+extensions.swift
//  Movies
//
//  Created by Анна Сычева on 04.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - UIViewController

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alercAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(alercAction)
        present(alert, animated: true)
    }
    
}
