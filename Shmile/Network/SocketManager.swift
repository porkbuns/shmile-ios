//
//  SocketManager.swift
//  Shmile
//
//  Created by Glen Wong on 7/4/15.
//  Copyright (c) 2015 Porkbuns. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift

class SocketManager {
  static let serverPath = "http://192.168.1.151:3000"
  static let sharedInstance = SocketManager()
  let socket = SocketIOClient(socketURL: serverPath)

  func setupSocket() {
    socket.connect(timeoutAfter: 1) { () -> Void in
      NSLog("Socket connect timed out...")
      let alert = UIAlertView(title: "Connection Error", message: "Could not connect to server at \(SocketManager.serverPath). Please ensure it is running.", delegate: self, cancelButtonTitle: "OK")
      alert.show()
    }
  }
  
  static func startCapture() {
    sharedInstance.socket.emitWithAck("snap")(timeout: 0) { data in
      NSLog("Data: " + data!.description)
    }
  }
}