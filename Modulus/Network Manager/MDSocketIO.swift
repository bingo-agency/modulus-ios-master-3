//
//  MDSocketIO.swift
//  Modulus
//
//  Created by Pranay on 02/03/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import SocketIO
import Starscream


@available(iOS 13.0, *)
class SocketHelper {
    
    static let shared = SocketHelper()
    
    var webSocket : URLSessionWebSocketTask!
    var loggedInConnected = false
    
    //Data Helpers
    var marketSummery:NSArray? = nil
    var orderBookBuy:NSArray? = nil
    var orderBookSell:NSArray? = nil
    var myPendingOrders:NSArray? = nil
    var tradeHistory:NSArray? = nil
    var chartData:NSArray? = nil
    var currentCoin = ""
    
    var delegate:signalRDataDelegates? = nil
    var socketURl : String = "wss://node1.modulusexchange.com/ws" // "wss://bff.bitsz.in/ws"
    func connectSocket(){
        
        let urlSession = URLSession(configuration: .default)
        webSocket = urlSession.webSocketTask(with: URL(string: API.webSocket_url)!)
        if let token = UserDefaults.standard.value(forKey: "AccessToken") as? String{
            
            self.checkUserLoggedIn(token: token)
            
        }else{
            self.subscribeToBaseEvents()
        }
    }
    
    
    func checkUserLoggedIn(token : String){
        if loggedInConnected == true{
            return
        }
        loggedInConnected = true
        let dictionary = ["method": "login", "token": token]
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            // print("JSON string = \(theJSONText!)")
            
            let message = URLSessionWebSocketTask.Message.string(theJSONText!)
            
            webSocket.send(message) { error in
                if let error = error {
                    print("WebSocket sending error: \(error)")
                }
            }
            self.subscribeToBaseEvents()
            self.webSocket.resume()
            self.sendPing()
        }
    }
    
    
    func subscribeToBaseEvents(){
        let events = ["MK"]
        let eventDict = ["method": "subscribe", "events": events] as [String : Any]
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: eventDict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            let message = URLSessionWebSocketTask.Message.string(theJSONText!)
            
            webSocket.send(message) { error in
                if let error = error {
                    print("WebSocket sending error: \(error)")
                }
            }
            webSocket.resume()
            webSocket.receive { result in
                switch result {
                case .failure(let error):
                    print("Failed to receive message: \(error)")
                case .success(let message):
                    switch message {
                    case .string(let text):
                        print("Received text message: \(text)")
                    case .data(let data):
                        print("Received binary message: \(data)")
                    @unknown default:
                        fatalError()
                    }
                }
            }
            self.sendPing()
        }
        
    }
    
    func unsubscribeToBaseEvents(){
        let events = ["MK"]
        let eventDict = ["method": "unsubscribe", "events": events] as [String : Any]
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: eventDict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            // print("JSON string = \(theJSONText!)")
            
            let message = URLSessionWebSocketTask.Message.string(theJSONText!)
            
            webSocket.send(message) { error in
                if let error = error {
                    print("WebSocket sending error: \(error)")
                }
            }
            
            webSocket.resume()
        }
    }
    
    
    func subscribeToSpecificEvents(coin : String){
        
        if let token = UserDefaults.standard.value(forKey: "AccessToken") as? String{
            
            self.checkUserLoggedIn(token: token)
            
        }
        
        self.currentCoin = coin
        let events = ["OB.\(coin)","RT.\(coin)","PO.\(coin)","CH.\(coin).1"]
        let eventDict = ["method": "subscribe", "events": events] as [String : Any]
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: eventDict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            //print("JSON string = \(theJSONText!)")
            
            let message = URLSessionWebSocketTask.Message.string(theJSONText!)
            
            webSocket.send(message) { error in
                if let error = error {
                    print("WebSocket sending error: \(error)")
                }
            }
            webSocket.resume()
            webSocket.receive { result in
                switch result {
                case .failure(let error):
                    print("Failed to receive message: \(error)")
                case .success(let message):
                    switch message {
                    case .string(let text):
                        self.handleResponse(text: text)
                        print("Received text message: FOR Specified \(text)")
                    case .data(let data):
                        print("Received binary message: \(data)")
                    @unknown default:
                        fatalError()
                    }
                }
            }
            self.sendPing()
        }else{
            print("N/A")
        }
    }
    
    func unsubscribeToSpecificEvents(){
        
        //self.currentCoin = coin
        let events = ["OB.\(self.currentCoin)","RT.\(self.currentCoin)","PO.\(self.currentCoin)","CH.\(self.currentCoin).1"]
        let eventDict = ["method": "unsubscribe", "events": events] as [String : Any]
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: eventDict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            // print("JSON string = \(theJSONText!)")
            
            let message = URLSessionWebSocketTask.Message.string(theJSONText!)
            
            webSocket.send(message) { error in
                if let error = error {
                    print("WebSocket sending error: \(error)")
                }
            }
            webSocket.resume()
        }
    }
    
    func joinGrp(marketType:String,currency:String){
        
        
    }
    
    func sendPing() {
        webSocket.sendPing { (error) in
            if let error = error {
                print("Sending PING failed: \(error)")
            }else{
                //print("Ping sent")
                self.receiveMsg()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //print("Schedule Next")
                self.sendPing()
            }
        }
    }
    
    func receiveMsg(){
        
        webSocket.receive { result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    //              print("Received string: \(text)")
                    self.handleResponse(text: text)
                case .data(let data):
                    print("Received data: ")
                }
            }
            //self.receiveMsg()
        }
        
    }
    
    func stopConnection(){
        webSocket.cancel(with: .goingAway, reason: nil)
    }
    
    func handleResponse(text : String){
        //self.orderBookBuy = []
        let string = text
        let data = string.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? NSDictionary{
                // print(jsonArray) // use the json here
                if let eventName = jsonArray.value(forKey: "event") as? String{
                    if eventName == "MK"{
                        if let args = jsonArray.value(forKey: "data") as? [Any]{
                            if args != nil, (args.count) > 0{
                                self.updateMarketSummeryData(data: args.first as! NSDictionary)
                            }
                            if args != nil, (args.count) > 0{
                                // print("Data received for pushDataAllMarket")
                                self.marketSummery = (args as! NSArray)
                                if self.delegate != nil{
                                    self.delegate?.marketSummeryDataReceived!(response: args as! NSArray)
                                }
                            }
                        }
                        
                    }
                    if eventName == "OB.\(self.currentCoin)"{
                        if let args = jsonArray.value(forKey: "data") as? NSDictionary{
                            
                            
                            if let bids = args.value(forKey: "bids") as? NSArray{
                                //green
                                //self.updateOrderBookBuy(data: args)
                                if let asks = args.value(forKey: "asks") as? NSArray{
                                    //red
                                    var askMutableArray = NSMutableArray()
                                    var bidMutableArray = NSMutableArray()
                                    //mutableArray = NSMutableArray(array:bids)
                                    for items in asks{
                                        if var dictData = items as? NSArray{
                                            var inneerMutableArray = NSMutableArray()
                                            inneerMutableArray = NSMutableArray(array:dictData)
                                            inneerMutableArray.add("sell")
                                            //dictData["execution_side"] = "sell"
                                            askMutableArray.add(inneerMutableArray)
                                        }
                                        
                                    }
                                    for items in bids{
                                        if var dictData = items as? NSArray{
                                            var inneerMutableArray = NSMutableArray()
                                            inneerMutableArray = NSMutableArray(array:dictData)
                                            inneerMutableArray.add("buy")
                                            //dictData["execution_side"] = "sell"
                                            bidMutableArray.add(inneerMutableArray)
                                        }
                                        
                                    }
                                    
                                    self.orderBookSell = askMutableArray as NSArray
                                    self.orderBookBuy = bidMutableArray as NSArray
                                    if self.delegate != nil{
                                        self.delegate?.orderBookBuyDataReceived!(response: self.orderBookBuy ?? NSArray())
                                    }
                                }
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                    }
                    if eventName == "RT.\(self.currentCoin)"{
                        print("RT.BTC_USD")
                        //if tradeHistory == nil {//
                        if let args = jsonArray.value(forKey: "data") as? NSArray{
                            self.tradeHistory = args
                            if self.delegate != nil{
                                self.delegate?.tradeHistoryDataReceived!(response: args)
                            }
                        }
                    }
                    if eventName == "CH"{
                        //print("Data received for pushDataAllChart")
                        if self.chartData?.count == 0 {
                            if let args = jsonArray.value(forKey: "data") as? NSArray{
                                self.chartData = args
                                self.delegate?.chartDataReceived!(response: self.chartData!)
                            }
                        }
                        
                    }
                    if eventName == "PO.\(self.currentCoin)"{
                        // print("Data received for pushDataAllPendingOrders")
                        if let args = jsonArray.value(forKey: "data") as? NSArray{
                            let array : NSMutableArray = .init(array: self.myPendingOrders ?? [])
                            array.addObjects(from: args as! [Any])
                            self.myPendingOrders = array
                            if args != nil, (args.count) > 0{
                                print("Data received for pushDataAllPendingOrders")
                                //print(args?.first is NSDictionary )
                                
                                if self.myPendingOrders != nil {
                                    let mutableArray = NSMutableArray()
                                    if let item = args.first as? NSDictionary{
                                        //if let newOrder = item.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary {
                                        let isAlreadyExist = self.myPendingOrders?.filter({ (element) -> Bool in
                                            //print(element)
                                            if let OrderID = (element as! [String:Any])["order_id"] as? Double,
                                               let newOrderID = item.valueForCaseInsensativeKey(forKey: "order_id") as? Double,
                                               OrderID == newOrderID{
                                                return true
                                            }
                                            return false
                                        })
                                        
                                        if isAlreadyExist?.count == 0 {
                                            mutableArray.add(item)
                                        }
                                        //}
                                    }
                                    
                                    for item in self.myPendingOrders!{
                                        mutableArray.add(item)
                                    }
                                    self.myPendingOrders = mutableArray
                                }else {
                                    // myPendingOrders = NSArray.init(array: [args.first ])
                                }
                                //print(self.myPendingOrders!)
                                self.delegate?.pendingOrdersReceived?(response: self.myPendingOrders!)
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
        
    }
}


@available(iOS 13.0, *)
extension SocketHelper{
    
    func updateMarketSummeryData(data:NSDictionary){
        if let triggerType = data.valueForCaseInsensativeKey(forKey: "TriggerType") as? String{
            if triggerType.lowercased() == "update"{
                // Update marke summery
                if let updateData = (data.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary){
                    if marketSummery != nil{
                        let mutableMarketSummery = marketSummery?.mutableCopy() as! NSMutableArray
                        let filteredData = mutableMarketSummery.filter { (element) -> Bool in
                            if ((element as! NSDictionary).valueForCaseInsensativeKey(forKey: "id") as! NSNumber) == ((updateData.valueForCaseInsensativeKey(forKey: "id")) as! NSNumber){
                                return true
                            }
                            return false
                        }
                        
                        if filteredData.count > 0{
                            mutableMarketSummery.replaceObject(at: mutableMarketSummery.index(of: filteredData.first!), with: updateData)
                            marketSummery = mutableMarketSummery.copy() as? NSArray
                            self.delegate?.marketSummeryDataReceived!(response: marketSummery!)
                        }
                    }
                }
            }
        }
    }
    
    func updateOrderBookBuy(data:NSDictionary){
        
        if orderBookBuy != nil{
            let mutableOrderBookBuy = orderBookBuy?.mutableCopy() as! NSMutableArray
            if let newRate = data.valueForCaseInsensativeKey(forKey: "rate") as? NSNumber, let newVolume = data.valueForCaseInsensativeKey(forKey: "volume") as? NSNumber{
                let filteredData = mutableOrderBookBuy.filter { (element) -> Bool in
                    let order = element as! NSDictionary
                    if let rate = order.valueForCaseInsensativeKey(forKey: "rate") as? NSNumber , let volume = order.valueForCaseInsensativeKey(forKey: "volume") as? NSNumber{
                        
                        if rate == newRate , volume == newVolume{
                            return true
                        }
                    }
                    return false
                }
                
                if filteredData.count > 0{
                    mutableOrderBookBuy.replaceObject(at: mutableOrderBookBuy.index(of: filteredData.first!), with: data)
                }else{
                    if newVolume.doubleValue > Double(0) {
                        mutableOrderBookBuy.add(data)
                        orderBookBuy = mutableOrderBookBuy.copy() as! NSArray
                        self.delegate?.orderBookBuyDataUpdatesReceived?(response: orderBookBuy!)
                    }else{
                        //                        mutableOrderBookBuy.remo
                    }
                }
                
            }
        }
        
    }
    
    func updateOrderBookSell(data:NSDictionary){
        
        if orderBookSell != nil{
            let mutableOrderBookSell = orderBookSell?.mutableCopy() as! NSMutableArray
            if let newRate = data.valueForCaseInsensativeKey(forKey: "rate") as? NSNumber, let newVolume = data.valueForCaseInsensativeKey(forKey: "volume") as? NSNumber{
                let filteredData = mutableOrderBookSell.filter { (element) -> Bool in
                    let order = element as! NSDictionary
                    if let rate = order.valueForCaseInsensativeKey(forKey: "rate") as? NSNumber , let volume = order.valueForCaseInsensativeKey(forKey: "volume") as? NSNumber{
                        
                        if rate == newRate , volume == newVolume{
                            return true
                        }
                    }
                    return false
                }
                
                if filteredData.count > 0{
                    mutableOrderBookSell.replaceObject(at: mutableOrderBookSell.index(of: filteredData.first!), with: data)
                }else{
                    if newVolume.doubleValue > Double(0) {
                        mutableOrderBookSell.add(data)
                        orderBookSell = mutableOrderBookSell.copy() as! NSArray
                        self.delegate?.orderBookSellDataUpdatesReceived?(response: orderBookSell!)
                    }else{
                        //                        mutableOrderBookBuy.remo
                    }
                }
                
            }
        }
        
    }
}
