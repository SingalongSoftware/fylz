//
//  Date+Extensions.swift
//  fylz
//
//  Created by asu on 2016-10-05.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

extension NSDate {
  func years(from date: NSDate) -> Int {
    return NSCalendar.currentCalendar().components([.Year], fromDate: date, toDate:self, options:NSCalendarOptions()).year ?? 0
  }
  func months(from date: NSDate) -> Int {
    return NSCalendar.currentCalendar().components([.Month], fromDate: date, toDate:self, options:NSCalendarOptions()).month ?? 0
  }
  func weeks(from date: NSDate) -> Int {
    return NSCalendar.currentCalendar().components([.WeekOfYear], fromDate: date, toDate:self, options:NSCalendarOptions()).weekOfYear ?? 0
  }
  func days(from date: NSDate) -> Int {
    return NSCalendar.currentCalendar().components([.Day], fromDate: date, toDate:self, options:NSCalendarOptions()).day ?? 0
  }
  func hours(from date: NSDate) -> Int {
    return NSCalendar.currentCalendar().components([.Hour], fromDate: date, toDate:self, options:NSCalendarOptions()).hour ?? 0
  }
  func minutes(from date: NSDate) -> Int {
    return NSCalendar.currentCalendar().components([.Minute], fromDate: date, toDate:self, options:NSCalendarOptions()).minute ?? 0
  }
  func seconds(from date: NSDate) -> Int {
    return NSCalendar.currentCalendar().components([.Second], fromDate: date).second ?? 0
  }
  var relativeTime: String {
    let now = NSDate()
    if now.years(from: self)   > 0 {
      return now.years(from: self).description  + " year"  + { return now.years(from: self)   > 1 ? "s" : "" }() + " ago"
    }
    if now.months(from: self)  > 0 {
      return now.months(from: self).description + " month" + { return now.months(from: self)  > 1 ? "s" : "" }() + " ago"
    }
    if now.weeks(from:self)   > 0 {
      return now.weeks(from: self).description  + " week"  + { return now.weeks(from: self)   > 1 ? "s" : "" }() + " ago"
    }
    if now.days(from: self)    > 0 {
      if now.days(from:self) == 1 { return "Yesterday" }
      return now.days(from: self).description + " days ago"
    }
    if now.hours(from: self)   > 0 {
      return "\(now.hours(from: self)) hour"     + { return now.hours(from: self)   > 1 ? "s" : "" }() + " ago"
    }
    if now.minutes(from: self) > 0 {
      return "\(now.minutes(from: self)) minute" + { return now.minutes(from: self) > 1 ? "s" : "" }() + " ago"
    }
    if now.seconds(from: self) > 0 {
      if now.seconds(from: self) < 15 { return "Just now"  }
      return "\(now.seconds(from: self)) second" + { return now.seconds(from: self) > 1 ? "s" : "" }() + " ago"
    }
    return ""
  }
  
}
