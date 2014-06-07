//
//  MTopic.swift
//  swiftvd
//
//  Created by Ethan Nguyen on 6/8/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

import Foundation

class MTopic: NSObject {
  var title: String = "Topic title"
  var absWidgetImage: String?
  var photos: String[]?
  var user: MUser?
  
  override func assignProperties(dict: NSDictionary!) {
    var normalizedDict: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
    
    if let photosData: NSArray = dict["photos"] as NSArray! {
      if let photoURLs : NSArray = photosData.valueForKey("absNormal") as NSArray! {
        normalizedDict.setValue(photoURLs, forKey: "photos")
      }
    }
    
    self.assignProperties(normalizedDict)
    
    if let userData: NSDictionary = normalizedDict["user"] as NSDictionary! {
      var mUser = MUser()
      mUser.displayName = String(userData["displayName"] as NSString)
      mUser.absUserUrl = String(userData["absUserUrl"] as NSString)
      self.user = mUser
    }
  }
}
