//
//  AppDelegate.swift
//  ASPingTest
//
//  Created by PC Gamer on 18/09/20.
//  Copyright © 2020 Avadhesh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Adding Console
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TinyConsole.createViewController(rootViewController: UINavigationController(rootViewController: ViewController())
)
        window?.makeKeyAndVisible()
        return true
    }
}

