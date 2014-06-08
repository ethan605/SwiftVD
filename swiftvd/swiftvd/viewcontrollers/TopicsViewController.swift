//
//  TopicsViewController.swift
//  swiftvd
//
//  Created by Ethan Nguyen on 6/8/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

import UIKit

class TopicsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
  var topicsData: MTopic[]?
  @IBOutlet var tblTopics : UITableView = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.automaticallyAdjustsScrollViewInsets = false
    self.adjustTableViewFrame()
    
    var nib = UINib(nibName: TopicCell.cellIdentifier(), bundle: nil)
    self.tblTopics.registerNib(nib, forCellReuseIdentifier: TopicCell.cellIdentifier())
    self.getAllTopicsAtCurrentPage()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    if topicsData {
      return topicsData!.count
    }
    
    return 0
  }
  
  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    let cellIdentifier = "TopicCell"
    var cell: TopicCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as TopicCell!
    
    if !cell {
      cell = TopicCell()
    }
    
    if let topic = self.topicsData![indexPath.row] as MTopic! {
      cell!.reloadCellWithData(topic)
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
//    if let topic = self.topicsData![indexPath.row] as MTopic! {
//      if let photoURLString = topic.photos![0] as String! {
//        UIApplication.sharedApplication().openURL(NSURL(string: photoURLString))
//      }
//    }
  }
  
  func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return TopicCell.heightToFit()
  }
  
  func getAllTopicsAtCurrentPage() {
    ServerHelper.sharedHelper.getNewTopics(atPage: 1) {
      (data: MTopic[]?, errorMessage: String?) -> Void in
      
      if errorMessage {
        Utils.showAlertWithErrorMessage(errorMessage!)
        return
      }
      
      self.topicsData = data
      self.tblTopics.reloadData()
    }
  }
  
  func adjustTableViewFrame() {
    var frame = self.tblTopics.frame
    frame.size.height = UIScreen.mainScreen().bounds.size.height - 20
    self.tblTopics.frame = frame
  }
}
