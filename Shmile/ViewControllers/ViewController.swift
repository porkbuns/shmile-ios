//
//  ViewController.swift
//  Shmile
//
//  Created by Glen Wong on 6/27/15.
//  Copyright (c) 2015 Porkbuns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var buttonView:UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let size = self.view.frame.size
    buttonView = UIButton(frame: CGRectMake((size.width - 300) / 2, (size.height - 100) / 2, 300, 100))
    buttonView.backgroundColor = UIColor.blueColor()
    buttonView.layer.cornerRadius = 25
    buttonView.layer.borderWidth = 2
    buttonView.setTitle("Begin", forState: UIControlState.Normal)
    buttonView.addTarget(self, action: "onBeginClicked", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(buttonView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func onBeginClicked() {
    NSLog("Begin clicked!")
  }
}

