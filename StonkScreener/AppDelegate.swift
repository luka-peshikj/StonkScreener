//
//  AppDelegate.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let stocksViewController = ViewController()
        stocksViewController.title = "Stocks"

        let favoriteViewController = ViewController()
        favoriteViewController.title = "My Stocks"

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [stocksViewController, favoriteViewController]
        tabBarController.view.backgroundColor = .white
        
        let navigationController = UINavigationController(rootViewController: tabBarController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .darkGray
        appearance.titleTextAttributes = [.font:UIFont.boldSystemFont(ofSize: 24.0), .foregroundColor: UIColor.white]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        tabBarController.title = "Stonks"
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

