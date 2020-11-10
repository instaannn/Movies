//
//  AppDelegate.swift
//  Movies
//
//  Created by Анна Сычева on 26.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - AppDelegate

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - Private properties
    
    private let navigationController = UINavigationController()
   
    // MARK: - Public methods
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let coordinator = Coordinator(navigationController: navigationController)
        coordinator.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
