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
  let socket = SocketIOClient(socketURL: "localhost:3000")
  var collageView:UICollageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let size = self.view.frame.size
    buttonView = SpringButton(frame: CGRectMake((size.width - 300) / 2, (size.height - 100) / 2, 300, 100))
    buttonView.backgroundColor = UIColor.blueColor()
    buttonView.layer.cornerRadius = 25
    buttonView.layer.borderWidth = 2
    buttonView.setTitle("Begin", forState: UIControlState.Normal)
    buttonView.addTarget(self, action: "onBeginClicked", forControlEvents: UIControlEvents.TouchUpInside)
    buttonView.enabled = false
    self.view.addSubview(buttonView)
  }
  
  override func viewDidAppear(animated: Bool) {
    setupSocket()
    self.buttonView.animation = "slideUp"
    self.buttonView.animateNext { () -> () in
      self.buttonView.enabled = true
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupSocket() {
    println("Setup Socket")
    socket.on("connect") { data, ack in
      println("Socket Connected")
    }
    socket.connect()
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
    collageView = UICollageView(frame: self.view.bounds.rectByInsetting(dx: 20, dy: 20))
    self.view.addSubview(collageView)
    collageView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.collageView.transform = CGAffineTransformMakeTranslation(0, 0)
      }, completion: { (value: Bool) in
              NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeZoom:"), userInfo: 0, repeats: false)
    })
  }
  
  func changeZoom(timer: NSTimer) {
    let index = timer.userInfo as? Int
    if (index < 4) {
      collageView.zoomOnImage(index!)
      NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("changeZoom:"), userInfo: index! + 1, repeats: false)
    }
    else {
      collageView.unzoom()
    }
  }
}

