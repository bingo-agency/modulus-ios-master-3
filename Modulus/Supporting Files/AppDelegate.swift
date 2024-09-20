//
//  AppDelegate.swift
//  Modulus
//
//  Created by Pathik  on 09/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
//import HockeySDK
import IQKeyboardManagerSwift
import TSMessages
import Alamofire

@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var currencyUSDValues:NSDictionary = NSDictionary()
    @objc dynamic var coinsInfo = NSArray()
    var currencySettings:[Currency] = []
    @objc dynamic var walletData = NSArray()
    @objc dynamic var listOfMarket = NSArray()
    var tempAuthToken = ""
    var grant_Type = ""
    var accessToken:String? = nil
    var expiresIn:Int? = nil
    var tokenType:String? = nil
    var secretKey = "03c06dd7-4982-441a-910d-5fd2cbb3f1c6"
    var customPopupWindow : MDPopupView?
    var customAlertPopupWindow : MDAlertPopupView?
    var customMessagePopupWindow : MDAlertMessageView?
    var isConnected : Bool? = true
    var isMobileVerified : Bool = false
    var enable_phone_verification : Bool = false
    var signup_mobile_verfication : Bool = false
    
    var byPassLogin = false
    var translatedDict:NSDictionary = NSDictionary()
    
    var rateList:[Rates] = []
    var cryptoRateList:[Rates] = []
    var tdM_Token_Name : String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.value(forKey: "isLT") as? Bool ?? false{
            Theme.current = MDLightTheme()
        }else{
            Theme.current = MDDarkTheme()
        }
        

        
        setTabBarAndNavigationColors()
        fetchCurrencyValuesinUSD()
        checkIfAlredyLoginAndRedirect()
        
        //        MDNetworkManager.shared.generateHmacForParams(params: NSDictionary())
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
        isConnected = NetworkReachabilityManager()?.isReachable ?? false
        startListingNetworkReachability()
        
        
        
        
        
        
        // Custom rechability
        let networkTimer = Timer.scheduledTimer(timeInterval: 2,
                                                target: self,
                                                selector: #selector(checkInternetConnectionByPingingGoogle),
                                                userInfo: nil,
                                                repeats: true)
        networkTimer.fire()
        
        //        fetchInternationalisationData()
        fetchCurrencySettings()
        fetchFiatPrices()
        fetchCryptoPrices()
        if let selectedCurrencyDetails = UserDefaults.standard.value(forKey: "fiatSelectedCurrency") as? [String:Any],
           let currencyName = selectedCurrencyDetails["currency"] as? String{
        }else{
            UserDefaults.standard.setValue(["currency":"USD"], forKey: "fiatSelectedCurrency")
        }
        // Override point for customization after application launch.
        //Socket Helper
        
        if #available(iOS 13.0, *) {
            SocketHelper.shared.connectSocket()
        } else {
            // Fallback on earlier versions
        }
        
        //SocketHelper1.shared.connectSocket()
        return true
    }
    
    func setTabBarAndNavigationColors(){
        // remove broder and shadow from navigation bar
        UINavigationBar.appearance().backgroundColor = Theme.current.navigationBarColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().tintColor = Theme.current.titleTextColor
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = Theme.current.backgroundColor
        UITabBar.appearance().tintColor = Theme.current.primaryColor
        UITabBar.appearance().unselectedItemTintColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.current.titleTextColor
                                                         ], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.current.primaryColor], for: .selected)
        
        UITextField.appearance().tintColor = Theme.current.titleTextColor
        //        UITabBar.appearance().b
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- Global network call
    
    func fetchInternationalisationData(){
        MDNetworkManager.shared.frequentlyRefreshingRequest(interval: 10,
                                                            methodType: .get, apiName:"\(API.getTranslations)?code=fr&namespace=translation", parameters:nil,
                                                            headers: nil) { (response, error) in
            
            if response != nil && error == nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    if let translationString = response?.valueForCaseInsensativeKey(forKey: "data") as? String{
                        if let translatedStringsDict = self.convertToDictionary(text: translationString) as? NSDictionary
                        {
                            self.translatedDict = translatedStringsDict.valueForCaseInsensativeKey(forKey: "translation") as! NSDictionary
                        }
                    }
                    //                                                                        self.handleCurrencyValueUSDResponse(response: response!)
                }else if let errorMessage = response?.valueForCaseInsensativeKey(forKey: "errorMessage"){
                    print("Get translations values network call failed")
                    print("error: \(errorMessage)")
                }
            }else{
                print("Get Traslations values network call failed")
                print("error: \(error?.localizedDescription ?? "Error message not available")")
            }
            
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func fetchCurrencyValuesinUSD(){
        
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.getCurrencyUSD, parameters: nil,
                                            headers: nil) { (response, error) in
            
            if response != nil && error == nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    //self.handleCurrencyValueUSDResponse(response: response!)
                }else if let errorMessage = response?.valueForCaseInsensativeKey(forKey: "errorMessage"){
                    print("Get currency USD values network call failed")
                    print("error: \(errorMessage)")
                }
            }else{
                print("Get currency USD values network call failed")
                print("error: \(error?.localizedDescription ?? "Error message not available")")
            }
            
        }
        
        
        
    }
    
    
    func fetchFiatPrices(){
        MDNetworkManager.shared.frequentlyRefreshingRequest(interval: 20.0,methodType: .get, apiName: API.getFiatPrice, parameters: nil,
                                                            headers: nil) { (response, error) in
            
            if response != nil && error == nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    //                    self.handleCurrencyValueUSDResponse(response: response!)
                    self.handleRateList(response: response!)
                    self.fetchCryptoPrices()
                }else if let errorMessage = response?.valueForCaseInsensativeKey(forKey: "errorMessage"){
                    print("Get currency USD values network call failed")
                    print("error: \(errorMessage)")
                }
            }else{
                print("Get currency USD values network call failed")
                print("error: \(error?.localizedDescription ?? "Error message not available")")
            }
        }
        
        
    }
    
    func fetchCryptoPrices(){
        MDNetworkManager.shared.sendRequest(
            methodType: .get, apiName: API.getCryptoPrice, parameters: nil,
            headers: nil) { (response, error) in
                
                if response != nil && error == nil{
                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                        //                    self.handleCurrencyValueUSDResponse(response: response!)
                        self.handleRateList(response: response!,isCryptoRateList: true)
                        NotificationCenter.default.post(Notification.init(name:Notification.Name(rawValue: "coinsrefresh") ))
                    }else if let errorMessage = response?.valueForCaseInsensativeKey(forKey: "errorMessage"){
                        print("Get currency USD values network call failed")
                        print("error: \(errorMessage)")
                    }
                }else{
                    print("Get currency USD values network call failed")
                    print("error: \(error?.localizedDescription ?? "Error message not available")")
                }
            }
    }
    
    func getListOfMarket()  {
        if let markets = UserDefaults.standard.value(forKey: "ListOfMarket") as? NSArray {
            self.listOfMarket = markets
        }
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .get,
                                            apiName: API.getSettings,
                                            parameters: nil,
                                            headers: nil) { (response, error) in
            if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
                if let markets = data.valueForCaseInsensativeKey(forKey: "markets") as? [String]{
                    self.listOfMarket = markets as NSArray
                    let market_group = data["market_groups"] as?
                    [[String:Any]] ?? []
                    self.parseMarketGroup(markets: markets, market_group: market_group)
                }
                if let fiatEstimatesCurrencyList = data.valueForCaseInsensativeKey(forKey: "fiat_List") as? String{
                    UserDefaults.standard.setValue(fiatEstimatesCurrencyList, forKey: "fiat_List")
                }
                if let tdM_Token_Name = data.value(forKey: "tdM_Token_Name") as? String{
                    self.tdM_Token_Name = tdM_Token_Name
                }
                if let enable_PhoneVerification = data.value(forKey: "enable_PhoneVerification") as? Bool{
                    self.enable_phone_verification = enable_PhoneVerification
                }else{
                    if let enable_PhoneVerification = data.value(forKey: "enable_PhoneVerification") as? String,enable_PhoneVerification == "True"{
                        self.enable_phone_verification = true
                    }else{
                        self.enable_phone_verification = false
                    }
                }
                
                if let signup_mobile_verfication = data.value(forKey: "signup_mobile_verfication") as? Bool{
                    self.signup_mobile_verfication = signup_mobile_verfication
                }else{
                    if let signup_mobile_verfication = data.value(forKey: "signup_mobile_verfication") as? String,signup_mobile_verfication == "True"{
                        self.signup_mobile_verfication = true
                    }else{
                        self.signup_mobile_verfication = false
                    }
                }
                
                if let trade_settings = data.value(forKey: "trade_setting") as? NSArray{
                    var tradeSettings : [MDTradeSettings] = []
                    for each in trade_settings{
                        if each is NSDictionary{
                            tradeSettings.append(MDTradeSettings.init(dict: each as! NSDictionary))
                        }
                    }
                    MDHelper.shared.tradeSettings = tradeSettings
                }
                MDHelper.shared.saveAppSetting(dict: data)
                
            }else{
                MDHelper.shared.saveAppSetting(dict: nil)
            }
            
        }
    }
    func setup_MenuOptionFilter(dict:[String:Any] , i : Int){
        if let label = dict["label"] as? String{
            let marketName = dict["markets"] as? [String] ?? []
            let model = Market(id: i+1, market_name:label, market_list: marketName, displayQuoteCurrency: false, market_group: Market_Groups(market_group_title:  Market.fiat_option))
            Market_Tabbar.shared_instance.list.append(model)
        }
        NotificationCenter.default.post(name: .init("refreshTabbar"), object: self)
    }
    
    func fetchCoinsInfo(){
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .get,
                                            apiName: API.currencySetings,
                                            parameters: nil,
                                            headers: nil) { (response, error) in
            if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray{
                self.coinsInfo = data
            }
            
        }
    }
    
    func fetchProfile(isFromWithoutLogin:Bool = false){
        if isFromWithoutLogin == true {
            MDHelper.shared.showHudOnWindow()
        }
        let header = ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"]
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .get,
                                            apiName: API.profile,
                                            parameters: nil,
                                            headers: header as NSDictionary) { (response, error) in
            if response != nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!) == true{
                    if let data = response!.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
                        let profile:NSMutableDictionary = NSMutableDictionary()
                        for key in data.allKeys as! [String]{
                            profile.setValue("\((data.value(forKey: key))!)", forKey: key)
                        }
                        UserDefaults.standard.setValue(profile.copy() as! NSDictionary, forKey: "profile")
                        UserDefaults.standard.setValue(data.value(forKey: "is2FAEnabled") as? Bool , forKey: "is2FAEnabled")
                        self.isMobileVerified = data.value(forKey: "isMobileVerified") as? Bool ?? false
                        NotificationCenter.default.post(name: NSNotification.Name.init("profileUpdated"), object: nil)
                        
                        if isFromWithoutLogin == true{
                            MDHelper.shared.hideHudOnWindow()
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name.init("Login_BroadcastNotification"), object: nil)
                            }
                            
                            UIApplication.shared.topMostViewController()?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    func fetchCurrencySettings(){
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .get,
                                            apiName: API.currencySetings,
                                            parameters: nil,
                                            headers: nil) { (response, error) in
            if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray{
                self.currencySettings =  data.compactMap({Currency(data: $0 as! NSDictionary)})
            }
            
        }
    }
    
    
    func checkIfAlredyLoginAndRedirect(){
        if let _ = UserDefaults.standard.value(forKey: "AccessToken") as? String{
            fetchCoinsInfo()
            fetchProfile()
            getListOfMarket()
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewc = storyboard.instantiateViewController(withIdentifier: "baseTabBarNavigationController")
        self.window?.rootViewController = viewc
    }
    
    //MARK:- Response handler
    
    func handleRateList(response:NSDictionary,isCryptoRateList :Bool = false){
        if let rateListArray = response.value(forKeyPath: "data.rateList")  as? NSArray{
            for currencyRate in rateListArray{
                do{
                    let fieldData = try JSONSerialization.data(withJSONObject:currencyRate, options: .prettyPrinted)
                    let showDetails = try JSONDecoder().decode(Rates.self, from: fieldData)
                    if isCryptoRateList == false{
                        if self.rateList.contains(where: {$0.currency == showDetails.currency}){
                            self.rateList.removeAll(where: {$0.currency == showDetails.currency})
                            self.rateList.append(showDetails)
                        }else{
                            self.rateList.append(showDetails)
                        }
                    }else{
                        if self.cryptoRateList.contains(where: {$0.currency == showDetails.currency}){
                            self.cryptoRateList.removeAll(where: {$0.currency == showDetails.currency})
                            self.cryptoRateList.append(showDetails)
                        }else{
                            self.cryptoRateList.append(showDetails)
                        }
                    }
                }catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    
    func handleCurrencyValueUSDResponse(response:NSDictionary){
        if let data = response.valueForCaseInsensativeKey(forKey: "data"){
            currencyUSDValues = data as! NSDictionary
            if UIApplication.shared.topMostViewController() is UINavigationController{
                if (UIApplication.shared.topMostViewController() as! UINavigationController).visibleViewController is MarketListVC{
                    ((UIApplication.shared.topMostViewController() as! UINavigationController).visibleViewController as! MarketListVC).tableView.reloadData()
                }
            }
        }
    }
    //MARK:- Internet connectivity by pinging google
    
    @objc func checkInternetConnectionByPingingGoogle(){
        let pingGoogleUrl = "https://www.googleapis.com/customsearch/v1?q=a"
        if(UIApplication.shared.applicationState != .background){
            DispatchQueue.global(qos: .background).async {
                
                let manager = Alamofire.SessionManager.default
                manager.session.configuration.timeoutIntervalForRequest = 7
                
                manager.request(pingGoogleUrl, method: .get, parameters: nil)
                    .responseJSON {
                        response in
                        switch (response.result) {
                        case .success:
                            self.internetConnected()
                            break
                        case .failure(let error):
                            print(error)
                            if response.response != nil{
                                self.internetConnected()
                            }else{
                                // if self.isAppAwaked == true{
                                self.connectionLost()
                                //}
                            }
                            break
                        }
                    }
                
            }
        }
    }
    
    
    func startListingNetworkReachability(){
        
        // Rechability Observers started
        let net = NetworkReachabilityManager()
        net?.startListening()
        net?.listener = { status in
            if net?.isReachable ?? false {
                
                switch status {
                    
                case .reachable(.ethernetOrWiFi):
                    print("The network is reachable over the WiFi connection")
                    self.internetConnected()
                    
                case .reachable(.wwan):
                    print("The network is reachable over the WWAN connection")
                    self.internetConnected()
                    
                case .notReachable:
                    print("The network is not reachable")
                    self.connectionLost()
                    
                case .unknown :
                    print("It is unknown whether the network is reachable,trying by pinging google")
                    self.checkInternetConnectionByPingingGoogle()
                }
            }
        }
    }
    
    func isConnectedToInternet() -> Bool {
        
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    //MARK:- Internet connectivity status helpers
    func internetConnected(){
        self.isConnected = true
    }
    
    func connectionLost (){
        self.isConnected = false
    }
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    
    
}



struct Rates:Decodable{
    
    let currency: String?
    let rate: Double?
    enum CodingKeys: String, CodingKey {
        
        case currency = "currency"
        case rate = "rate"
    }
}


struct MDTradeSettings {
    let coinName : String
    let marketName : String
    private let minTickSize : Double
    //    let minTradeAmount : Double
    //    let minOrderValue : Double
    //    let makerFee : Double
    //    let takerFee : Double
    //    let tradeEnabled : Bool
    //    let maxSize : Double
    //    let maxOrderAmount : Double
    //    let maxMarketOrderSize : Double
    let decisionPrecisionPrice : Int
    let decimalPrecisionVoulme : Int
    
    init(dict : NSDictionary) {
        coinName = dict.value(forKey: "coinName") as! String
        marketName = dict.value(forKey: "marketName") as! String
        minTickSize = dict.value(forKey: "minTickSize") as! Double
        //        minTradeAmount = dict.value(forKey: "minTradeAmount") as! Double
        //        minOrderValue = dict.value(forKey: "minOrderValue") as! Double
        //        makerFee = dict.value(forKey: "makerFee") as! Double
        //        takerFee = dict.value(forKey: "takerFee") as! Double
        //        tradeEnabled = (dict.value(forKey: "tradeEnabled") != nil)
        //        maxSize = dict.value(forKey: "maxSize") as! Double
        //        maxOrderAmount = dict.value(forKey: "maxOrderAmount") as! Double
        //        maxMarketOrderSize = dict.value(forKey: "maxMarketOrderSize") as! Double
        
        self.decisionPrecisionPrice = MDHelper.shared.getNumberOFDecimals(double: self.minTickSize)
        let minTradeAmount : Double = dict.value(forKey: "minTradeAmount") as? Double ?? 0.0
        self.decimalPrecisionVoulme = MDHelper.shared.getNumberOFDecimals(double: minTradeAmount)
    }
}


//MARK:------------ MARKET GROUP PARSING --------------
extension AppDelegate{
    private
    func parseMarketGroup(markets : [String] , market_group : [[String:Any]]){
        print("")
        print("markets\n\(markets)")
        print("Market Group \n\(market_group)")
        print("")
        var modifiedMarketList : [String] = markets
        var marketHeaderArray : [MDMarketTabModel] = [MDMarketTabModel.init(title: localised("Favorites"), markest: [], isSecurityGroup: false, isNonGroup: false)]
        
        var marketGroupHeaderArray : [MDMarketTabModel] = []
        
        var marketNonGroupHeaderArray : [MDMarketTabModel] = []
        
        for eachMarketGroup in market_group{
            if let label = eachMarketGroup["label"] as? String , let marketsOfGroup = eachMarketGroup["markets"] as? [String]{
                
                let marketHeader = MDMarketTabModel.init(title: label, markest: marketsOfGroup, isSecurityGroup: false, isNonGroup: false)
                marketGroupHeaderArray.append(marketHeader)
                for each in marketsOfGroup{
                    if let index = modifiedMarketList.firstIndex(where: { $0 == each }) {
                        modifiedMarketList.remove(at: index)
                    }
                }
            }
        }
        
        if modifiedMarketList.count > 0{
            for each in modifiedMarketList{
                let marketHeader = MDMarketTabModel.init(title: each, markest: [each], isSecurityGroup: false, isNonGroup: true)
                marketNonGroupHeaderArray.append(marketHeader)
            }
            marketHeaderArray.append(contentsOf: marketNonGroupHeaderArray)
        }
        
        marketHeaderArray.append(contentsOf: marketGroupHeaderArray)
        MDHelper.shared.setMarketetData(marketData: marketHeaderArray)
        self.getSecurityGroups()
        NotificationCenter.default.post(.init(name: NSNotification.Name.init("market_group_added")))
    }
    
    private
    func getSecurityGroups(){
        let url = API.baseURL + API.getSecurityTokenGroups
        MDNetworkManager.shared.call_emptyRequestApi(urlstring: url) { (dict) in
            if let data = dict?["data"] as? [String:Any] , let tradingPairGroups = data["tradingPairGroups"] as? [[String:Any]] {
                var marketLists = MDHelper.shared.getMarketetData()
                marketLists.removeAll(where: {$0.isSecurityGroup})
                for each in tradingPairGroups{
                    if let label = each["label"] as? String,
                       let tradingPairs = each["tradingPairs"]  as? [[String:String]],
                       let displayQuoteCurrency = each["displayQuoteCurrency"] as? Bool{
                        var securities : [String] = []
                        if displayQuoteCurrency{
                            
                        }else{
                            for each in tradingPairs{
                                let baseCurrency : String = each["baseCurrency"] ?? ""
                                let quoteCurrency : String = each["quoteCurrency"] ?? ""
                                securities.append(baseCurrency)
                                let pair : String = "\(baseCurrency)/\(quoteCurrency)"
                                if  !MDHelper.shared.notDisplayQuoteCurrencyPairs.contains(pair){                              MDHelper.shared.notDisplayQuoteCurrencyPairs.append(pair)
                                }
                                
                            }
                            let marketHeader : MDMarketTabModel = .init(title: label, markest: securities, isSecurityGroup: true, isNonGroup: false)
                            marketLists.append(marketHeader)
                        }
                    }
                }
                print(marketLists)
                MDHelper.shared.setMarketetData(marketData: marketLists)
                NotificationCenter.default.post(.init(name: NSNotification.Name.init("market_group_added")))
            }
        }
    }
}

struct MDMarketTabModel{
    let title : String
    let markest : [String]
    let isSecurityGroup : Bool
    let isNonGroup : Bool
}
