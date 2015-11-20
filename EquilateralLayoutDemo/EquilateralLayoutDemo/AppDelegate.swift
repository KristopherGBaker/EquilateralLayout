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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let horizontalDemo = DemoViewController(numberOfItems: 80, strokeColor: UIColor.greenColor(), scrollDirection: .Horizontal)
        horizontalDemo.tabBarItem.image = UIImage(named: "horizontal")
        horizontalDemo.tabBarItem.title = "Horizontal"
        
        let verticalDemo = DemoViewController(numberOfItems: 80, strokeColor: UIColor.redColor(), scrollDirection: .Vertical)
        verticalDemo.tabBarItem.image = UIImage(named: "vertical")
        verticalDemo.tabBarItem.title = "Vertical"
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([horizontalDemo, verticalDemo], animated: false)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.blackColor()
        
        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

