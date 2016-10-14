//
//  Date+Extensions.swift
//  fylz
//
//  Created by asu on 2016-10-05.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

extension Date {
  func years(from date: Date) -> Int {
    return (Calendar.current as NSCalendar).components([.year], from: date, to:self, options:NSCalendar.Options()).year ?? 0
  }
  func months(from date: Date) -> Int {
    return (Calendar.current as NSCalendar).components([.month], from: date, to:self, options:NSCalendar.Options()).month ?? 0
  }
  func weeks(from date: Date) -> Int {
    return (Calendar.current as NSCalendar).components([.weekOfYear], from: date, to:self, options:NSCalendar.Options()).weekOfYear ?? 0
  }
  func days(from date: Date) -> Int {
    return (Calendar.current as NSCalendar).components([.day], from: date, to:self, options:NSCalendar.Options()).day ?? 0
  }
  func hours(from date: Date) -> Int {
    return (Calendar.current as NSCalendar).components([.hour], from: date, to:self, options:NSCalendar.Options()).hour ?? 0
  }
  func minutes(from date: Date) -> Int {
    return (Calendar.current as NSCalendar).components([.minute], from: date, to:self, options:NSCalendar.Options()).minute ?? 0
  }
  func seconds(from date: Date) -> Int {
    return (Calendar.current as NSCalendar).components([.second], from: date).second ?? 0
  }
  var relativeTime: String {
    let now = Date()
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
  
  func isBefore(_ otherDate:Date) -> Bool
  {
    return self.compare(otherDate) == .orderedAscending;
  }
  
  func isAfter(_ otherDate:Date) -> Bool
  {
    return self.compare(otherDate) == .orderedDescending;
  }
}
