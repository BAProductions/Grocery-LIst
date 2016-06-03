//
//  AppDelegate.swift
//  G List
//
//  Created by BAProductions on 5/12/16.
//  Copyright © 2016 BAProductions. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Changing th/Users/kevin/Downloads/CameraApp/Grocery LIst/G List/AppDelegate.swifte navigation controller's background colour
        let color:UIColor = hexStringToUIColor("#39544a")
        let colorInv:UIColor = hexStringToUIColor("#ffffff")
        UINavigationBar.appearance().barTintColor = color
        UIToolbar.appearance().barTintColor = color
        UISwitch.appearance().tintColor = UIColor.grayColor()
        UISwitch.appearance().thumbTintColor = colorInv
        UISwitch.appearance().onTintColor = color
        UISearchBar.appearance().barTintColor = hexStringToUIColor("f1f1f1")
        // Changing the navigation controller's title colour
        
        //let navBackgroundImage:UIImage! = UIImage(named: "nav-bg.png")
        //[UINavigationBar .appearance().setBackgroundImage(navBackgroundImage, forBarMetrics:.Default)]
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Changing the colour of the bar button items
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIToolbar.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // Changing the tint colour of the tab bar icons
        return true
    }
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Split view}
    
}

