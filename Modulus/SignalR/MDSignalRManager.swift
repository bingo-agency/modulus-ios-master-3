//
//  MDSignalRManager.swift
//  Modulus
//
//  Created by Pathik  on 28/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import SwiftR


@objc protocol signalRDataDelegates {
    @objc optional func marketSummeryDataReceived(response:NSArray)
    @objc optional func orderBookBuyDataReceived(response:NSArray)
    @objc optional func orderBookBuyDataUpdatesReceived(response:NSArray)
    @objc optional func orderBookSellyDataReceived(response:NSArray)
    @objc optional func orderBookSellDataUpdatesReceived(response:NSArray)
    @objc optional func tradeHistoryDataReceived(response:NSArray)
    @objc optional func chartDataReceived(response:NSArray)
    @objc optional func pendingOrdersReceived(response:NSArray)
}

class MDSignalRManager: NSObject {
    
    
    
    //HUB Collected data center
    var marketSummery:NSArray? = nil
    var orderBookBuy:NSArray? = nil
    var orderBookSell:NSArray? = nil
    var myPendingOrders:NSArray? = nil
    var tradeHistory:NSArray? = nil
    var chartData:NSArray? = nil
    
    
//    var groupedAlreadyJoined
    
    var delegate:signalRDataDelegates? = nil
    
    
    
    static let shared = MDSignalRManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private override init() {}
    
    var hub: Hub?
    var connection: SignalR?
    var error:[String:Any]?

    public typealias responseModel = (_ response: NSArray? ) -> Void
    public typealias connectionStatus = (_ state: Bool ) -> Void
//    public typealias responseUrlConnection  = (_ data:Data?,_ response: NSDictionary? , _ error:Error?) -> Void

    func initializeConnection(url:String = API.baseURL, completionHandler: @escaping connectionStatus) {
        
        
//        self.connection = nil
//        self.hub = nil
//
//        connection = SignalR(url)
//        connection?.useWKWebView = true
//        hub = connection?.createHubProxy("dataTickerHub")
//
//        connection?.addHub(hub!)
//        connection?.start()
//        connection?.starting = {
//            print("Starting....")
//        }
//
//        connection?.reconnecting = {
//            print("Reconnecting....")
//        }
//
//        connection?.connected = { [weak self] in
//            if self!.connection?.connectionID != nil {
//                completionHandler(true)
//                print("Connection ID: \(self!.connection!.connectionID!)")
////                self!.connection?.addHub(self!.hub!)
//
//            }else{
//                completionHandler(false)
//                //disconnected ,restarting
//                    self!.connection?.start()
//                 print("SignalR disconnected ,restarting...")
//            }
//            print("Connected")
//            //            try? hub.invoke("joinGroup")
//
////            if let token = UserDefaults.standard.value(forKey: "AccessToken") as? String{
////                try? self?.hub.invoke("subscribeTo_PendingOrderData", arguments: [token,"ETH","BTC"], callback: { (r, e) in
////                    if e == nil{
////                        print("Method invoked subscribeTo_PendingOrderData")
////                    }
////                })
////            }
////
//
//            try? self?.hub?.invoke("getDataAllMarket", arguments: nil, callback: { (r, e) in
//                if e == nil{
//                    print("Method invoked getDataAllMarket")
//                }
//            })
//        }
//
//        connection?.reconnected = {
//
//            print("Stop")
//            completionHandler(false)
//        }
//
//        connection?.disconnected = {
//            print("Disconnected")
//            completionHandler(false)
//        }
//        connection?.error = { error in
//            print("Error: \(String(describing: error))")
//            self.error = error
//            completionHandler(false)
//            if let source = error?["source"] as? String, source == "TimeoutException" {
//                print("Connection timed out. Restarting...")
//                self.connection?.start()
//            }
//        }
//
        

        
    }
    
    /**
     Creates a personalized greeting for a recipient.
     
     - Parameter recipient: The person being greeted.
     
     - Throws: `MyError.invalidRecipient`
     if `recipient` is "Derek"
     (he knows what he did).
     
     - Returns: A new string saying hello to `recipient`.
     */
    
    
    func joinGroups(marketType:String,currency:String){
        orderBookSell = nil
        orderBookBuy = nil
        tradeHistory = nil
        try? self.hub?.invoke("subscribeToChartTicker", arguments:[currency,marketType,1], callback: { (r, e) in
            if e == nil{
                print("method invoked Subscribing chartticker marketType:\(marketType) , currency :\(currency)")
            }else {
                print(e!)
            }
        })
        try? self.hub?.invoke("joinGroup", arguments:[currency,marketType], callback: { (r, e) in
            if e == nil{
                print("method invoked joining group marketType:\(marketType) , currency :\(currency)")
            }else {
                print(e!)
            }
        })

        
        if let token = UserDefaults.standard.value(forKey: "AccessToken") as? String{
            try? self.hub?.invoke("subscribeTo_PendingOrderData", arguments: [token,currency,marketType], callback: { (r, e) in
                if e == nil{
                    print("Method invoked subscribeTo_PendingOrderData")
                    
                    //Pending orders
//                    self.hub.on("pushDataAllPendingOrders") { args in
//                        if args != nil, (args?.count)! > 0{
//                            print("Data received for pushDataAllPendingOrders")
//
//                        }
//                    }
                }
            })
        }
    }
    
    func startDataConnectionWithoutLogin(){

        self.initializeConnection { (state) in
        }
        addDataObservers()

    }

    func addDataObservers(){
        
        //Trade history
        hub?.on("pushDataAllMatched") { args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllMatched")
                self.tradeHistory = (args?.first! as! NSArray)
                if self.delegate != nil{
                    self.delegate?.tradeHistoryDataReceived!(response: args?.first! as! NSArray)
                }
            }
            
        }
        //TradeHistory update
        hub?.on("pushDataTickerMatched") { args in
            if args != nil, (args?.count)! > 0{
                
                
                print("Data received for pushDataTickerMatched")
               
                
                if self.tradeHistory != nil {
                    let mutableArray = NSMutableArray()
                    if let item = args?.first as? NSDictionary{
                        if let newOrder = item.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary {
                            mutableArray.add(newOrder)
                        }
                    }else if let items = args?.first as? NSArray{
                        mutableArray.addObjects(from: items as! [Any])
                    }
                    for item in self.tradeHistory!{
                        mutableArray.add(item)
                    }
                    self.tradeHistory = mutableArray
                }else {
                    if let item = args?.first as? NSDictionary{
                         self.tradeHistory = NSArray.init(array: [item ])
                    }else  if let items = args?.first as? NSArray{
                          self.tradeHistory = items
                    }
                   
                }
               
                //print(tradeHistory!)
                self.delegate?.pendingOrdersReceived?(response: self.tradeHistory!)
                
            }
            
        }
        
        // Order Book Buy
        hub?.on("pushDataAllBuy") { args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllBuyGrouped")
                self.orderBookBuy = (args?.first! as! NSArray)
                if self.delegate != nil{
                    self.delegate?.orderBookBuyDataReceived!(response: args?.first! as! NSArray)
                }
            }
            
        }
        //Order Book Sell
        hub?.on("pushDataAllSell") { args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllSellGrouped")
                self.orderBookSell = (args?.first! as! NSArray)
                if self.delegate != nil{
                    self.delegate?.orderBookSellyDataReceived!(response: args?.first! as! NSArray)
                }
            }
        }
        // Orderbook update Buy
        hub?.on("pushDataTickerBuy") { args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllBuyGrouped")
                self.updateOrderBookBuy(data: (args?.first as! NSDictionary).valueForCaseInsensativeKey(forKey: "data") as! NSDictionary)
            }
            
        }
        //Tikcker update for order book Sell
        hub?.on("pushDataTickerSell") { args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllBuyGrouped")
                self.updateOrderBookSell(data: (args?.first as! NSDictionary).valueForCaseInsensativeKey(forKey: "data") as! NSDictionary)

            }
        }

        
        
        //Market Updatations
        hub?.on("pushDataTickerMarket") { args in
            print("Data received for pushDataTickerMarket")
            if args != nil, (args?.count)! > 0{
                self.updateMarketSummeryData(data: args?.first as! NSDictionary)
            }
        }
        //market initially
        hub?.on("pushDataAllMarket") { args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllMarket")
                self.marketSummery = (args?.first! as! NSArray)
                if self.delegate != nil{
                    self.delegate?.marketSummeryDataReceived!(response: args?.first! as! NSArray)
                }
            }
        }
        
        
        
        //Pending orders
        hub?.on("pushDataAllPendingOrders") { [unowned self] args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllPendingOrders")
                self.myPendingOrders = args?.first as? NSArray
            }
        }
        
        
        
        //Pending orders updates
        hub?.on("pushDataTickerPendingOrders") { [unowned self] args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllPendingOrders")
                //print(args?.first is NSDictionary )
                //self.myPendingOrders = args?.first as? NSArray
                if self.myPendingOrders != nil {
                    let mutableArray = NSMutableArray()
                    if let item = args?.first as? NSDictionary{
                        if let newOrder = item.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary {
                            let isAlreadyExist = self.myPendingOrders?.filter({ (element) -> Bool in
                                print(element)
                                if let OrderID = (element as! [String:Any])["OrderID"] as? Double,
                                    let newOrderID = newOrder.valueForCaseInsensativeKey(forKey: "OrderID") as? Double,
                                    OrderID == newOrderID{
                                    return true
                                }
                                return false
                            })
                            
                            if isAlreadyExist?.count == 0 {
                                mutableArray.add(newOrder)
                            }
                        }
                    }

                    for item in self.myPendingOrders!{
                        mutableArray.add(item)
                    }
                    self.myPendingOrders = mutableArray
                }else {
                    self.myPendingOrders = NSArray.init(array: [args?.first ])
                }
                //print(self.myPendingOrders!)
               self.delegate?.pendingOrdersReceived?(response: self.myPendingOrders!)
                
            }
        }
        
        //ChartData
        hub?.on("pushDataAllChart") { [unowned self] args in
            if args != nil, (args?.count)! > 0{
                print("Data received for pushDataAllChart")
                self.chartData = args?.first as? NSArray
                self.delegate?.chartDataReceived!(response: self.chartData!)
            }
        }
        //ChartData
        hub?.on("chartTicker") { [unowned self] args in
            if args != nil, (args?.count)! > 0{
                print("Data received for CHartTicker")
                self.chartData = args?.first as? NSArray
                if self.chartData != nil{
                self.delegate?.chartDataReceived?(response: self.chartData!)
                }
            }
        }
    }
    
    
    
    
    
    
    
    //MARK:- Updation
    
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
    
    
    //MARK:- MARKET DATA HELPERS
    
    func getMarketData(completionHandler:@escaping responseModel){
        hub?.on("pushDataAllMarket") { args in
            print("Data received for pushDataAllMarket")
            completionHandler(args! as NSArray)
        }
    }
    
    func getMarketDataUpdates(completionHandler:@escaping responseModel){
        hub?.on("pushDataTickerMarket") { args in
            print("Data received for pushDataTickerMarket")
            completionHandler(args! as NSArray)
        }
    }

    
    //MARK:- ORDERBOOK DATA HELPERS
    func getOrderBookBuyAllGroupedData(completionHandler:@escaping responseModel){
        hub?.on("pushDataAllBuyGrouped") { args in
            print("Data received for pushDataAllBuyGrouped")
            completionHandler(args! as NSArray)
        }
    }
    
    func getChartData(completionHandler:@escaping responseModel){
        
        self.initializeConnection { (state) in
        }
       
        hub?.on("pushDataAllChart") { args in
                    print("Data received for pushDataAllChart")
        //            print(args!)
                    completionHandler(args! as NSArray)
                }
    }
}
