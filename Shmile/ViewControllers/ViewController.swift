//
//  ViewController.swift
//  Shmile
//
//  Created by Glen Wong on 6/27/15.
//  Copyright (c) 2015 Porkbuns. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import Spring

class ViewController: UIViewController {
  var buttonView:SpringButton!
  let socketManager = SocketManager.sharedInstance
  let socket = SocketManager.sharedInstance.socket
  var collageView:UICollageView!
  var countdownLabel:UICountdownLabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let size = self.view.frame.size
    buttonView = SpringButton(frame: CGRectMake((size.width - 400) / 2, (size.height - 100) / 2, 400, 100))
    buttonView.backgroundColor = UIColor(hex: "F5BE1B")
    buttonView.layer.cornerRadius = 25
    buttonView.layer.borderWidth = 2
    buttonView.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 40)
    buttonView.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    buttonView.setTitle("Click to Start!", forState: UIControlState.Normal)
    buttonView.addTarget(self, action: "onBeginClicked", forControlEvents: UIControlEvents.TouchUpInside)
    buttonView.enabled = false
    self.view.addSubview(buttonView)
    
    countdownLabel = UICountdownLabel(frame: CGRectMake(0, 0, size.width, size.height))
    countdownLabel.backgroundColor = UIColor.clearColor()
    countdownLabel.textColor = UIColor.whiteColor()
    countdownLabel.textAlignment = NSTextAlignment.Center
    countdownLabel.font = UIFont(name: "HelveticaNeue", size: 96)
    countdownLabel.text = "Hello"
    countdownLabel.alpha = 0
    self.view.addSubview(countdownLabel)
  }
  
  override func viewDidAppear(animated: Bool) {
    socket.on("connect") { data, ack in
      println("Socket Connected")
      self.buttonView.enabled = true
    }
    
    socket.on("photo_saved") { data, ack in
      if let photoData = data?[0] as? NSDictionary {
        println("Photo Data: \(photoData)")
        self.collageView.setZoomedImage(SocketManager.serverPath + (photoData["web_url"] as! String)) { done in
          if let index = self.collageView.zoomedIndex {
            let nextIndex = index + 1
            if (nextIndex < 4) {
              self.collageView.zoomOnImage(nextIndex, callback: { iv in
                self.countdownLabel.countdown(3) { done in
                  SocketManager.startCapture()
                }
              })
            }
            else {
              println("Capture done")
              self.collageView.unzoom({
                self.postCapture()
              })
            }
          }
        }
      }
    }
    
    socket.onAny { (event: SocketAnyEvent) -> Void in
      println("Socket Event: \(event.event!), Data: \(event.items)")
    }
    
    SocketManager.sharedInstance.setupSocket()
    self.buttonView.animation = "slideUp"
    self.buttonView.animate()
  }

  func postCapture() {
    // Composite the image
    collageView.showOverlay { (Bool) -> Void in
      self.postComposite()
    }
  }
  
  func postComposite() {
    let alert = UIAlertController(title: "Send Photo", message: "Enter your email below to receive a copy of your photo!", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Email Address"
    }
    
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
      let tf = alert.textFields![0] as! UITextField
      NSLog("Send email to " + tf.text)
      self.reset()
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
      self.reset()
    }))
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func reset() {
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      self.collageView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)
      }) { done in
        self.buttonView.animation = "slideUp"
        self.buttonView.animate()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func onBeginClicked() {
    NSLog("Begin clicked!")
    UIView.animateWithDuration(0.15, animations: {
        self.buttonView.transform = CGAffineTransformMakeScale(1.2, 1.2)
      }, completion: { (value: Bool) in
        UIView.animateWithDuration(0.3, animations: {
          self.buttonView.transform = CGAffineTransformMakeScale(0.01, 0.01)
          self.buttonView.alpha = 0
          }, completion: { (value: Bool) in
            self.createCollageView()
        })
    })
  }
  
  func createCollageView() {
    // Collage view needs to be 4x6 so we find the largest fitting size
    let availHeight = self.view.bounds.height - 40
    let availWidth = self.view.bounds.width - 40
    
    
    // We are height limited
    var width:CGFloat = 0
    var height:CGFloat = 0
    if (availWidth / availHeight > 1.5) {
      width = availHeight * 1.5
      height = availHeight
    }
    else {
      width = availWidth
      height = (2 * availWidth) / 3
    }
    
    collageView = UICollageView(frame: CGRectMake((self.view.bounds.width - width) / 2, (self.view.bounds.height - height) / 2, width, height))
    self.view.addSubview(collageView)
    self.view.bringSubviewToFront(countdownLabel)
    collageView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.collageView.transform = CGAffineTransformMakeTranslation(0, 0)
      }, completion: { (value: Bool) in
        self.collageView.zoomOnImage(0, callback: { iv in
          self.countdownLabel.countdown(3) { done in
            SocketManager.startCapture()
          }
        })
    })
  }
}

