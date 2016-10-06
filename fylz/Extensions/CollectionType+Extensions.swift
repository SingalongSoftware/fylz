//
//  CollectionType+Extensions.swift
//  fylz
//
//  Created by asu on 2016-10-05.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension CollectionType {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Generator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}