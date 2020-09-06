//
//  ICoordinator.swift
//  Movies
//
//  Created by Анна Сычева on 26.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - iCoordinator

protocol ICoordinator {
    var navigationController: UINavigationController { get }
    func start()
}
