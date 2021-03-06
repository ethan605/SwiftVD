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

struct SingletonServerHelper {
  static var sharedInstance: ServerHelper? = nil
  static var token: dispatch_once_t = 0
}

class ServerHelper: AFHTTPSessionManager {
  class func sharedHelper() -> ServerHelper {
    dispatch_once(&SingletonServerHelper.token,
      {
        SingletonServerHelper.sharedInstance = ServerHelper(baseURL: NSURL(string: kServerUrl))
      })
    
    return SingletonServerHelper.sharedInstance!
  }
  
  func verifyKey(completionBlock: (success: Bool, errorMessage: String?) -> Void) {
    NSLog("Verify API with key \(kServerApiKey)")
    
    self.GET("VerifyKey",
      parameters: ["key" : kServerApiKey],
      success: {
        (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        
        self.handleResponse(response: responseObject) {
          (authenticated: Bool, errorMessage: String?) -> Void in
          
          if errorMessage {
            completionBlock(success: false, errorMessage: errorMessage)
          } else if !authenticated {
            completionBlock(success: false, errorMessage: "Authentication failed!")
          } else {
            completionBlock(success: true, errorMessage: nil)
          }
        }
      }, failure: {
        (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        completionBlock(success: false, errorMessage: "\(error.localizedDescription)")
      })
  }
  
  func getNewTopics(atPage page: Int, callback block: (data: MTopic[]?, errorMessage: String?) -> Void) {
    self.GET("Topic/GetNewTopics",
      parameters: ["page" : page],
      success: {
        (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in

        self.handleResponse(response: responseObject) {
          (authenticated: Bool, errorMessage: String?) -> Void in
          
          if errorMessage {
            block(data: nil, errorMessage: errorMessage)
          } else if authenticated {
            var allTopics = MTopic[]()
            
            if let content = responseObject.valueForKey("content") as NSDictionary! {
              if let topics = content["topics"] as NSArray! {
                for dict : AnyObject in topics {
                  var mTopic = MTopic(dictionary: dict as NSDictionary)
                  allTopics += mTopic
                }
                
                block(data: allTopics, errorMessage: nil)
              } else {
                block(data: nil, errorMessage: "Invalid response format \(content)")
              }
            } else {
              block(data: nil, errorMessage: "Invalid response format")
            }
          } else {
            self.verifyKey() {
              (success: Bool, errorMessage: String?) -> Void in
              
              if success {
                self.getNewTopics(atPage: page, callback: block)
              } else {
                block(data: nil, errorMessage: errorMessage)
              }
            }
          }
        }
      }, failure: {
        (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        block(data: nil, errorMessage: "\(error.localizedDescription)")
      })
  }
  
  func handleResponse(response responseObject: AnyObject!, callback block:(authenticated: Bool, errorMessage: String?) -> Void) {
    if let codeNumber = responseObject.valueForKey("code") as NSNumber! {
      if let code = codeNumber.integerValue as Int! {
        switch code {
        case 200:
          block(authenticated: true, errorMessage: nil)
          break
          
        case 401:
          block(authenticated: false, errorMessage: nil)
          break
          
        default:
          block(authenticated: false, errorMessage: "Invalid response code: \(code)")
          break
        }
      } else {
        block(authenticated: false, errorMessage: "Invalid response code format: \(codeNumber)")
      }
    } else {
      block(authenticated: false, errorMessage: "Invalid response body: \(responseObject)")
    }
  }
}
