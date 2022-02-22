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
        let stocksViewController = StocksViewController()
        stocksViewController.title = "Stocks"

        let favoriteViewController = StocksViewController()
        favoriteViewController.title = "My stocks"

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
        
        let tabBarAppearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20.0)]
        tabBarAppearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        tabBarController.title = "Stocks"
        tabBarController.tabBar.tintColor = .white
        
        let myTabBarItem = (tabBarController.tabBar.items?[1])! as UITabBarItem
        myTabBarItem.image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal)
        myTabBarItem.selectedImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal)
        myTabBarItem.title = "My stocks"
        myTabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

