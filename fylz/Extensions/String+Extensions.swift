//
//  String+Extensions.swift
//  fylz
//
//  Created by asu on 2016-10-06.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

extension String
{

  func caselessGreaterThan(other:String) -> Bool
  {
    return self.lowercaseString > other.lowercaseString
  }
  
  func caselessLesserThan(other:String) -> Bool
  {
    return self.lowercaseString < other.lowercaseString
  }
  
}