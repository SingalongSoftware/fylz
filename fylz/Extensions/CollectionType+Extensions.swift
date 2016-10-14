//
//  CollectionType+Extensions.swift
//  fylz
//
//  Created by asu on 2016-10-05.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension Collection {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  
  subscript (safe index: Index) -> Iterator.Element?
  {
    return indices.filter { $0 as! Self.Index == index }.count > 0 ? self[index] : nil
  }
}
