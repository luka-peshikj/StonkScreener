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
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

}

