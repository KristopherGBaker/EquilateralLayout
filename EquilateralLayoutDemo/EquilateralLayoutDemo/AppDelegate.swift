//
//  AppDelegate.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let horizontalDemo = DemoViewController(numberOfItems: 80, strokeColor: .green, scrollDirection: .horizontal)
        horizontalDemo.tabBarItem.image = UIImage(named: "horizontal")
        horizontalDemo.tabBarItem.title = "Horizontal"
        
        let verticalDemo = DemoViewController(numberOfItems: 80, strokeColor: .red, scrollDirection: .vertical)
        verticalDemo.tabBarItem.image = UIImage(named: "vertical")
        verticalDemo.tabBarItem.title = "Vertical"
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([horizontalDemo, verticalDemo], animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

