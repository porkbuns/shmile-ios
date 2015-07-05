//
//  UICountdownText.swift
//  Shmile
//
//  Created by Glen Wong on 7/4/15.
//  Copyright (c) 2015 Porkbuns. All rights reserved.
//

import Foundation
import Spring

class UICountdownLabel:SpringLabel {
  convenience init() {
    self.init(frame: CGRectZero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func countdown(seconds: Int, completion: ((Bool) -> ())?) {
    if (self.alpha == 0) {
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.alpha = 1
      })
    }
    
    if (seconds == 0) {
      screenFlash(completion)
      return
    }
    
    self.text = "\(seconds)"
    self.alpha = 0
    self.transform = CGAffineTransformMakeScale(3, 3)
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      self.alpha = 1
      self.transform = CGAffineTransformMakeScale(1, 1)
    }, completion: nil)

    delay(1, closure: { () -> () in
      self.countdown(seconds - 1, completion: completion)
    })
  }
  
  private func screenFlash(completion: ((Bool) -> ())?) {
    self.backgroundColor = UIColor.whiteColor()
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      self.alpha = 0
      }) { done in
      self.backgroundColor = UIColor.clearColor()
      completion?(done)
    }
  }
  
  func delay(delay:Double, closure:()->()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
  }
}