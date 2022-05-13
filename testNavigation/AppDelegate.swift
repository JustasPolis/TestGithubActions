//
//  AppDelegate.swift
//  testNavigation
//
//  Created by Justin on 2022-05-11.
//

import Test
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // sdsadssddddasdadadadadsadsaqweqweqweqweqeqeqwweqeqeqeqeqeqwewqeqwweqeqweqeqwweqwweqweqeqwweqeqewqeqwwewqeqweqweqwewqeqwewqeeq
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        print("AppDelegate")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = FlowController(navigationController: UINavigationController())
        return true
    }
}
