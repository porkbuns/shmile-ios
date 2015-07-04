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
  static let sharedInstance = SocketManager()
  let socket = SocketIOClient(socketURL: "localhost:3000")

  func setupSocket() {
    println("Setup Socket")
    socket.on("connect") { data, ack in
      println("Socket Connected")
    }
    socket.connect()
  }
}