//
//  BaseViewController.swift
//  swiftvd
//
//  Created by Ethan Nguyen on 6/8/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidLayoutSubviews()  {
    if self.respondsToSelector(Selector("topLayoutGuide")) {
      var viewBounds = self.view.bounds
      var topBarOffset = self.topLayoutGuide.length;
      viewBounds.origin.y = topBarOffset * -1;
      self.view.bounds = viewBounds;
    }
  }
}
