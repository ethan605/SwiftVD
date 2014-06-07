// Playground - noun: a place where people can play

import Cocoa
import Foundation

class MTopic: NSObject {
  var title: String?
  var absWidgetImage: String?
  var photos: String[] = []
}

var m = MTopic()
var d1 = NSDictionary(object: "http://photo.depvd.com/14/124/13/ph_WMuMK5wY8w_zJFxJzJ3_no.jpg", forKey: "absNormal")
var d = NSDictionary(
  objects: ["Giận rồi :!!", "http://photo.depvd.com/14/124/13/ph_WMuMK5wY8w_zJFxJzJ3_wi.jpg", []],
  forKeys: ["title", "absWidgetImage", "photos"])

var normalizedDict: NSDictionary = d

if let photosData: NSArray = d["photos"] as NSArray! {
  if let photoURLs : NSArray = photosData.valueForKey("absNormal") as NSArray! {
    normalizedDict.setValue(photoURLs, forKey: "photos")
  }
}
