//
//  AppDelegate.swift
//  Menu
//
//  Created by Александр Хлебников on 28.10.2018.
//  Copyright © 2018 IceRockDev💎. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let menuWireframe = MenuWireframe(firstScreenIndex: 0)
    menuWireframe.present(inWindow: window!)
    return true
  }

}

