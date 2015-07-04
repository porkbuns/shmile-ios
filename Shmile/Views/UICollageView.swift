//
//  UICollageView.swift
//  Shmile
//
//  Created by Glen Wong on 6/28/15.
//  Copyright (c) 2015 Porkbuns. All rights reserved.
//

import UIKit
import Spring

class UICollageView: SpringView {
  let aspectRatio:CGFloat = 1.5
  let padding:CGFloat = 20
  var zoomedIndex:Int?
  var imageViews = [UIImageView]()
  var imageFrames = [CGRect]()

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
  
  convenience init() {
    self.init(frame: CGRectZero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.whiteColor()
    
    let imageWidth = (frame.size.width - 3 * padding) / 2
    let imageHeight = (frame.size.height - 3 * padding) / 2
    
    // top left picture
    self.addSubview(genImageView(CGRectMake(padding, padding, imageWidth, imageHeight)))
    self.addSubview(genImageView(CGRectMake(padding * 2 + imageWidth, padding, imageWidth, imageHeight)))
    self.addSubview(genImageView(CGRectMake(padding, padding * 2 + imageHeight, imageWidth, imageHeight)))
    self.addSubview(genImageView(CGRectMake(padding * 2 + imageWidth, padding * 2 + imageHeight, imageWidth, imageHeight)))
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func genImageView(frame: CGRect) -> UIImageView {
    var imageView = UIImageView(frame: frame)
    imageView.backgroundColor = UIColor.blackColor()
    imageViews.append(imageView)
    imageFrames.append(frame)
    return imageView
  }
  
  private func translationForIndex(index: Int) -> CGPoint {
    let translateX = (index % 2 == 0) ? (self.frame.size.width - self.frame.origin.x) / 2 : (self.frame.origin.x - self.frame.size.width) / 2
    let translateY = (index < 2) ? (self.frame.size.height - self.frame.origin.y) / 2 : (self.frame.origin.y - self.frame.size.height) / 2
    return CGPointMake(translateX, translateY)
  }
  
  func unzoom() {
    if (zoomedIndex != nil) {
      UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
        self.transform = CGAffineTransformMakeScale(1, 1)
      }), completion: nil)
    }
  }
  
  func zoomOnImage(index: Int) {
    let scale:CGFloat = 2
    
    if (zoomedIndex != nil) {
      UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
        self.transform = CGAffineTransformMakeScale(1, 1)
      }), completion: { (done: Bool) in
        let t = self.translationForIndex(index)
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
        let translate = CGAffineTransformMakeTranslation(t.x, t.y)
        self.transform = CGAffineTransformScale(translate, scale, scale)
        }), completion: nil)
      })
      return
    }
    
    let t = translationForIndex(index)
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
      let translate = CGAffineTransformMakeTranslation(t.x, t.y)
      self.transform = CGAffineTransformScale(translate, scale, scale)
    }), completion: nil)

    zoomedIndex = index
  }
  
  func zoomImage(index: Int) {
    if (zoomedIndex != nil) {
      let rect = imageFrames[zoomedIndex!]
      let imageView = imageViews[zoomedIndex!]
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        imageView.frame = rect
      })
    }
    
    let imageView = imageViews[index]
    UIView.animateWithDuration(0.3) { () -> Void in
      imageView.frame = CGRectMake(self.padding, self.padding, self.frame.size.width - 2 * self.padding, self.frame.size.height - 2 * self.padding)
    }
    zoomedIndex = index
  }
}
