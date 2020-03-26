//
//  AppDelegate.swift
//  SpotShare
//
//  Created by 김희중 on 28/04/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()

        window = UIWindow()
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: MainController())
        
        if #available(iOS 13.0, *) {
            // opt out Darkmode
            // https://stackoverflow.com/questions/56537855/is-it-possible-to-opt-out-of-dark-mode-on-ios-13
            // 일시적으로 darkmode, lightmode 구분하지 않고 statusBar, textColor 바뀌는거 막아놓음.
            // darkmode일 경우에 statusBar text가 흰색으로 나오고, textColor를 설정하지 않으면 흰색으로 나오는 현상 방지.
            // 나중에 따로 darkmode용 theme(color)를 만들어야할 듯.
            // 이렇게 해서 appstore reject 걸리는 사례가 있는데 그 이유가 xCode 11 아니라서 그렇다는 경우도 있으니, 나중에 찾아볼것..
            window?.overrideUserInterfaceStyle = .light
            
        }
        GMSServices.provideAPIKey("AIzaSyDTAPVMioqdfYA7yHY4JYdDpK2laLDurCY")
        
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


}

