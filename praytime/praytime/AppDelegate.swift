//
//  AppDelegate.swift
//  praytime
//
//  Created by Sameer on 11/8/18.
//  Copyright © 2018 praytime. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DataManager.configure()
        return true
    }
}

