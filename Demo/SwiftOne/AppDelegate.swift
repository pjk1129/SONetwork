//
//  AppDelegate.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/17.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupRootContoller()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK:- 公共属性
    var navRootController:UINavigationController?
    
    //MARK:- 懒加载属性
    fileprivate lazy var homeViewController: SOHomeViewController = SOHomeViewController()
    fileprivate lazy var userViewController: SOUserViewController = SOUserViewController()
    fileprivate lazy var tabController:UITabBarController = UITabBarController()
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension AppDelegate{

    fileprivate func setupRootContoller(){
        let homeNav = UINavigationController(rootViewController: homeViewController)
        homeNav.isNavigationBarHidden = true
        homeNav.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        
        let userNav = UINavigationController(rootViewController: userViewController)
        userNav.isNavigationBarHidden = true
        userNav.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "super"), selectedImage: UIImage(named: "super_1"))
        
        tabController.viewControllers = [homeNav,userNav]
        tabController.tabBar.tintColor = UIColor.so_withHex(hexString: "ff4800")
        tabController.tabBar.barTintColor = UIColor.so_withHex(hexString: "f8f8f8")
        navRootController = UINavigationController(rootViewController: tabController)
        navRootController?.isNavigationBarHidden = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = navRootController
        window?.makeKeyAndVisible()
        
    }
    
}

