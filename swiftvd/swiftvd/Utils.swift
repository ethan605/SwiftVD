//
//  Utils.swift
//  swiftvd
//
//  Created by Ethan Nguyen on 6/8/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

import UIKit

class Utils: NSObject {
  class func showAlertWithErrorMessage(message: String) {
    var alert = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
    alert.show()
  }
}
