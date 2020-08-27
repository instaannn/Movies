//
//  Coordinator.swift
//  Movies
//
//  Created by Анна Сычева on 26.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - Coordinator

final class Coordinator: ICoordinator {
    
    // MARK: - Public properties
    
    var navigationController: UINavigationController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public methods
    
    func start() {
        goToMoviesViewController()
    }
    
    // MARK: - Private methods
    
    private func goToMoviesViewController() {
        let viewController = MoviesViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
