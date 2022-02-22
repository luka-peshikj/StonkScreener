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
        
        let tabBarAppearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20.0)]
        tabBarAppearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        tabBarController.title = "Stonks"
        tabBarController.tabBar.tintColor = .white
        
        let myTabBarItem2 = (tabBarController.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal)
        myTabBarItem2.title = "My stocks"
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

