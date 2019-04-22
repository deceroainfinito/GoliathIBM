//
//  AppDelegate.swift
//  GoliathIBM
//
//  Created by Raul Martinez Padilla on 22/04/2019.
//  Copyright © 2019 Raul Martinez Padilla. All rights reserved.
//

import UIKit

let environment: NetworkServiceEnvironment = {
  #if targetEnvironment(simulator)
    return NetworkServiceEnvironment.simulator
  #else
    return NetworkServiceEnvironment.mobile
  #endif
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let viewController = ViewController()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()

    window?.rootViewController = LightNavController(rootViewController: viewController)

    setup()

    return true
  }

  func setup() {
  }
}
