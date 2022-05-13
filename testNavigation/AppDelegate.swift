//
//  AppDelegate.swift
//  testNavigation
//
//  Created by Justin on 2022-05-11.
//

import UIKit
import Test

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {

        print("AppDelegate")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = FlowController(navigationController: UINavigationController())
        return true
    }
}
