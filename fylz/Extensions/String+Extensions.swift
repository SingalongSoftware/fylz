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

  func caselessGreaterThan(_ other:String) -> Bool
  {
    return self.lowercased() > other.lowercased()
  }
  
  func caselessLesserThan(_ other:String) -> Bool
  {
    return self.lowercased() < other.lowercased()
  }
  
}
