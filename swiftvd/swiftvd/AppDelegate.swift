//
//  AppDelegate.swift
//  swiftvd
//
//  Created by Ethan Nguyen on 6/7/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    
//    ServerHelper.sharedHelper.verifyKey() {
//      (success: Bool) -> () in
//      ServerHelper.sharedHelper.getNewTopics(atPage: 1)
//    }
    
    ServerHelper.sharedHelper.getNewTopics(atPage: 1)
    
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
  }
  
  func applicationWillTerminate(application: UIApplication) {
  }
}

