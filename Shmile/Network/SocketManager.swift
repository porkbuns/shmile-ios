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
  static let serverPath = "http://localhost:3000"
  static let sharedInstance = SocketManager()
  let socket = SocketIOClient(socketURL: serverPath)

  func setupSocket() {
    socket.connect()
  }
  
  static func startCapture() {
    sharedInstance.socket.emitWithAck("snap")(timeout: 0) { data in
      NSLog("Data: " + data!.description)
    }
  }
}