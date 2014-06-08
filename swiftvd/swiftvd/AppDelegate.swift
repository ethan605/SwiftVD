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
    
    ServerHelper.sharedHelper.getNewTopics(atPage: 1) {
      (data: MTopic[]?, errorMessage: String?) -> Void in
      
      if errorMessage {
        NSLog("Error: \(errorMessage)")
      } else {
        NSLog("Data: \(data!.count)")
        let topic: MTopic? = data![0]
        
        NSLog("\(topic!.title) - \(topic!.photos)")
        
        if let user: MUser = topic!.user {
          NSLog("\(user.absUserUrl) - \(user.displayName)")
        }
      }
      
      dispatch_after(1, dispatch_get_main_queue()) {
        ServerHelper.sharedHelper.getNewTopics(atPage: 2) {
          (data: MTopic[]?, errorMessage: String?) -> Void in
          
          if errorMessage {
            NSLog("Error: \(errorMessage)")
          } else {
            NSLog("Data: \(data!.count)")
            let topic: MTopic? = data![0]
            
            NSLog("\(topic!.title) - \(topic!.photos)")
            
            if let user: MUser = topic!.user {
              NSLog("\(user.absUserUrl) - \(user.displayName)")
            }
          }
        }
      }
    }
    
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

