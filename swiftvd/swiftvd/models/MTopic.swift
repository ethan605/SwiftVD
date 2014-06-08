//
//  MTopic.swift
//  swiftvd
//
//  Created by Ethan Nguyen on 6/8/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

import Foundation

extension NSObject {
  convenience init(dictionary dict: NSDictionary) {
    self.init()
    self.assignPropertiesFromDict(dict)
  }
  
  func assignPropertiesFromDict(dict: NSDictionary) {
    for (key: AnyObject, value: AnyObject) in dict {
      var keyStr: String = String(key as NSString)
      
      if let iVar = class_getInstanceVariable(object_getClass(self), (key as NSString).UTF8String) as Ivar! {
        if iVar == Ivar.null() { continue }
        
        if value is NSString || value is NSNumber {
          self.setValue(value, forKey: keyStr)
        } else if value is NSArray {
          self.setValue(Array(value as NSArray), forKey: keyStr)
        } else if value is NSDictionary {
          // ivar_getTypeEncoding always return NULL,
          // need some other ways to initiate instance variable from iVar
        }
      }
    }
  }
}

class MTopic: NSObject {
  var title: String = "Topic title"
  var absWidgetImage: String?
  var photos: String[]?
  var user: MUser?
  
  override func assignPropertiesFromDict(dict: NSDictionary) {
    var normalizedDict: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
    
    if let photosData: NSArray = dict["photos"] as NSArray! {
      if let photoURLs : NSArray = photosData.valueForKey("absNormal") as NSArray! {
        normalizedDict.setValue(photoURLs, forKey: "photos")
      }
    }
    
    super.assignPropertiesFromDict(normalizedDict)
    
    if let userData: NSDictionary = normalizedDict["user"] as NSDictionary! {
      self.user = MUser(dictionary: userData)
    }
  }
}
