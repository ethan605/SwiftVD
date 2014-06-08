//
//  TopicCell.swift
//  swiftvd
//
//  Created by Ethan Nguyen on 6/8/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

import UIKit

struct SingletonTopicCell {
  static var sharedInstance: TopicCell? = nil
  static var token: dispatch_once_t = 0
}

class TopicCell: UITableViewCell {
  @IBOutlet var lblTitle : UILabel = nil
  @IBOutlet var imgFirstImage : UIImageView = nil
  
  class func heightToFit() -> Float {
    return 320
  }
  
  class func cellIdentifier() -> String {
    return "TopicCell"
  }
  
  class func sharedCell() -> TopicCell {
    dispatch_once(&SingletonTopicCell.token,
      {
        SingletonTopicCell.sharedInstance = TopicCell()
      })
    
    return SingletonTopicCell.sharedInstance!
  }
  
  func reloadCellWithData(topicData: MTopic) {
    lblTitle.text = topicData.title
    
    var sizeThatFits = lblTitle.sizeThatFits(CGSizeMake(lblTitle.frame.size.width, Float(Int32.max)))
    lblTitle.frame.size.height = sizeThatFits.height
    lblTitle.superview.frame.size.height = lblTitle.frame.origin.y*2 + lblTitle.frame.size.height
    
    imgFirstImage.setImageWithURL(NSURL(string: topicData.coverPhoto))
  }
}
