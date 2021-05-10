//
//  AppDelegate.swift
//  EcoNews
//
//  Created by Никита Ткаченко on 07.11.2020.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // main
        FirebaseApp.configure()
        return true
    }
}

