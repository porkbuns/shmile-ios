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
                SocketManager.startCapture()
              })
            }
            else {
              println("Capture done")
              self.collageView.unzoom({
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                  self.collageView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)
                  }) { done in
                    println("DONE")
                    self.buttonView.animation = "slideUp"
                    self.buttonView.animate()
                }
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
    collageView = UICollageView(frame: self.view.bounds.rectByInsetting(dx: 20, dy: 20))
    self.view.addSubview(collageView)
    collageView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.collageView.transform = CGAffineTransformMakeTranslation(0, 0)
      }, completion: { (value: Bool) in
        self.collageView.zoomOnImage(0, callback: { iv in
          SocketManager.startCapture()
        })
    })
  }
}

