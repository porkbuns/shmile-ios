//
//  NSObject+Extension.swift
//  Shmile
//
//  Created by Glen Wong on 8/1/15.
//  Copyright (c) 2015 Porkbuns. All rights reserved.
//

import Foundation

extension NSObject {
  func delay(delay:Double, closure:()->()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
  }
}