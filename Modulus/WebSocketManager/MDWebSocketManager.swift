//
//  MDWebSocketManager.swift
//  Modulus
//
//  Created by Pathik  on 03/10/18.
//  Copyright © 2018 Inspeero Technologies. All rights reserved.
//

//import UIKit
//import SwiftWebSocket
//typealias CompletionBlock = (_ result: String,_ error: Bool) -> Void
//
//class MDWebSocketManager: NSObject {
//
//
//    internal var socketCompletion: CompletionBlock?
//
//    static let sharedInstance = MDWebSocketManager()
//
//    static let webSocketURL = "ws://vps3.inspeero.com:9060"//"wss://api.moduluscoin.com/ws_real_time"
//    let webSocketManager = WebSocket.init(webSocketURL)
//    override init() {
//        super.init()
//    }
//
//    func firstTimeMessageToSend() {
//
//        let stringToSend = "{\"authorization\":\"\",\"streams\":[{\"orderBookStreamParams\":{\"baseCurrency\":\"BTC\",\"quoteCurrency\":\"USD\"}},{\"tradesStreamParams\":{\"baseCurrency\":\"BTC\",\"quoteCurrency\":\"USD\"}},{\"chartStreamParams\":{\"baseCurrency\":\"BTC\",\"quoteCurrency\":\"USD\",\"interval\":0}},{\"priceStreamParams\":{}}]}"
//        webSocketManager.send(text: stringToSend)
//
//    }
//    func startWebSocket(_ completionBlock : CompletionBlock?) {
//        //connection open handlet
//        webSocketManager.event.open = {
//            print("websocket opened")
//            self.firstTimeMessageToSend()
//            completionBlock?("websocket opened",false)
//        }
//        //connection closed handler
//        webSocketManager.event.close = { code, reason, clean in
//            print("websocket closed")
//             completionBlock?("websocket closed",false)
//        }
//        webSocketManager.event.error = { error in
//            print("websocket error :\(error)")
//              completionBlock?("websocket error :\(error)",true)
//        }
//
//        webSocketManager.event.message = { message in
//            if let text = message as? String {
//                print("recv from websocket : \(text)")
//                completionBlock?(text,false)
//            }
//        }
//
//    }
//
//    func closeWebsocket() {
//        webSocketManager.close()
//    }
//
//
//
//}
