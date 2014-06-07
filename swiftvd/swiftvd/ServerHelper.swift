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
  
  func verifyKey(completion block: (success: Bool) -> Void) -> Void {
    NSLog("Verify API with key \(kServerApiKey)")
    
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
  
  func getNewTopics(atPage page: Int, callback block: (data: Dictionary<String, AnyObject>?, errorMessage: String?) -> Void) {
    self.GET("Topic/GetNewTopics",
      parameters: ["page" : page],
      success: {
        (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        
        if let codeNumber : AnyObject? = responseObject.valueForKey("code") {
          if let code = codeNumber!.integerValue {
            if code == 200 {
              block(data: ["content" : "topics"], errorMessage: nil)
            } else if code == 401 {
              self.verifyKey() {
                (success: Bool) -> Void in
                
                if success {
                  self.getNewTopics(atPage: page, callback: block)
                } else {
                  NSLog("error!")
                }
              }
            } else {
              block(data: nil, errorMessage: "Invalid response code: \(code)")
            }
          } else {
            block(data: nil, errorMessage: "Invalid response code format: \(codeNumber)")
          }
        } else {
          block(data: nil, errorMessage: "Invalid response body: \(responseObject)")
        }
      }, failure: {
        (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        NSLog("\(error)");
        block(data: nil, errorMessage: "\(error.localizedDescription)")
      })
  }
}
