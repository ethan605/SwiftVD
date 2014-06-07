//
//  ServerHelper.swift
//  swiftvd
//
//  Created by Ethan Nguyen on 6/7/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

import Foundation

let kServerUrl = "http://open-api.depvd.com"
let kServerApiKey = "8FDON-OH3JX-H4XYF-TBFGV-YFNGR"

class ServerHelper: AFHTTPSessionManager {
  class var sharedHelper: ServerHelper {
    get {
      
      struct Static {
        static var sharedInstance: ServerHelper? = nil
        static var token: dispatch_once_t = 0
      }
      
      dispatch_once(&Static.token, {
        Static.sharedInstance = ServerHelper(baseURL: NSURL(string: kServerUrl))
        })
      
      return Static.sharedInstance!
  }
  }
  
  func verifyKey(completion block: (success: Bool) -> ()) {
    self.GET("VerifyKey",
      parameters: ["key" : kServerApiKey],
      success: {
        (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        block(success: true)
      }, failure: {
        (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        NSLog("\(error)")
        
        block(success: false)
      })
  }
  
  func getNewTopics(atPage page: Int) {
    self.GET("Topic/GetNewTopics",
      parameters: ["page" : page],
      success: {
        (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        
        let responseDict = responseObject as Dictionary<String, String>

        if let codeStr: String? = responseDict["code"] {
          if let code: Int? = codeStr!.toInt() {
            if code == 200 {
              NSLog("\(responseDict)")
            } else {
              NSLog("\(code)")
//              self.verifyKey(completion: {
//                (success: Bool) -> () in
//                self.getNewTopics(atPage: page)
//                })
            }
          } else {
            NSLog("no integer code")
//            self.verifyKey(completion: {
//              (success: Bool) -> () in
//              self.getNewTopics(atPage: page)
//              })
          }
        } else {
          NSLog("no code")
//          self.verifyKey(completion: {
//            (success: Bool) -> () in
//            self.getNewTopics(atPage: page)
//            })
        }
      }, failure: {
        (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        NSLog("\(error)");
      })
  }
}
