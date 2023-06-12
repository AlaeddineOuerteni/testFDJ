//
//  AppDelegate.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: SearchViewController())
        window?.makeKeyAndVisible()
        return true
    }
}
