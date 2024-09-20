//
//  MDNetworkManager.swift
//  Modulus
//
//  Created by Pathik  on 11/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import Alamofire
//import SweetHMAC.Swift

struct API {
    /**
     Base URls
     */
//    static let web_site = "https://demo.modulusexchange.com/assets/cryptocurrency-icons/color/"
    static let web_site = "https://trade.pressx.com/assets/cryptocurrency-icons/color/"
    
    static let chartsDataURL = "https://goesoteric.com/"
    static var supportURL = "https://modulushelp.freshdesk.com/support/login"
    
    /***leaser bytes Default*/
//    static var webSocket_url = UserDefaults.standard.value(forKey: "ws_baseURL") as? String ?? "wss://node1.ledgerbytes.tech/ws"
//    static var baseURL = UserDefaults.standard.value(forKey: "baseURL") as? String ?? "https://node1.ledgerbytes.tech/"
    
//    static var webSocket_url = UserDefaults.standard.value(forKey: "ws_baseURL") as? String ?? "wss://api-stage.pressx.com/ws"
//    static var baseURL = UserDefaults.standard.value(forKey: "baseURL") as? String ?? "https://api-stage.pressx.com/"
    
    /***Modulus*/
    static var webSocket_url = UserDefaults.standard.value(forKey: "ws_baseURL") as? String ?? "wss://node1.modulusexchange.com/ws"
    static var baseURL = UserDefaults.standard.value(forKey: "baseURL") as? String ?? "https://node1.modulusexchange.com/"
    
    
    
    /***Dmeo5 Dex*/
    //static var baseURL = "https://demo5api.modulusexchange.com/"
    //static var webSocket_url = "wss://demo5api.modulusexchange.com/ws"
    
    /*** Eksit ***/
//    static var webSocket_url = "wss://node1.eksit.com/ws"
//    static var baseURL = "https://node1.eksit.com/"
    
    /***Byte Dex*/
    //static var baseURL = UserDefaults.standard.value(forKey: "baseURL") as? String ?? "https://nodes.bytedex.io/"
    //static var webSocket_url = UserDefaults.standard.value(forKey: "ws_baseURL") as? String ?? "wss://nodes.bytedex.io/ws"
    
    /***Capex*/
    //static var webSocket_url = "wss://bff.capex.mn/ws"
    //static var baseURL = "https://bff.capex.mn/"
    
    /***Capex Staging*/
    //static var webSocket_url = "wss://st-bff.capex.mn/ws"
    //static var baseURL = "https://st-bff.capex.mn/"
    
    /***  Pepezi */
    //static var webSocket_url = UserDefaults.standard.value(forKey: "ws_baseURL") as? String ?? "wss://nodes.pipezi.com/ws"
    //static var baseURL = UserDefaults.standard.value(forKey: "baseURL") as? String ?? "https://nodes.pipezi.com/"

    static let marketSummary = "market/get-market-summary"
    static let orderList = "market/get-open-orders"
    static let getCurrencyUSD  = "market/get-currency-usd-rate"
    static let tradeHistory = "market/get-trade-history"
    static let getCoinsInfo = "api/GetCoinInfo"
    static let getDepthChart = "market/depth"
    static let getChartData = "market/get-chart-data"
    static let getCurrencySetting = "api/CurrencySettings"
    static let checkGoogleAuth = "api/GAuth_Check_Status"
    static let profile = "api/GetProfile"
    static let pendingOrders = "api/GetPendingOrders"
    static let googleAuthEnableStep1 = "api/GAuth_Enable_Request"
    static let googleAuthEnableStep2 = "api/GAuth_Set_Enable"
    static let googleAuthDisable = "api/GAuth_Disable_Request"
    static let resendOTP = "api/AuthenticateUser_Resend_EmailOTP"
    static let marketListAddress = "json/settings.json"
    static let getSettings = "api/GetSettings"
    static let getTranslations = "api/language"
    static let getSecurityTokenGroups = "api/getSecurityTokenGroups"
    //merchant apis
    static let getAddressForCurrency = "merchant-api/get-new-address"
    static let merchantAPIKey = "87dc9d77-12b2-4ce5-90ec-fe10506a453hh"
    static let getAddressBalance = "merchant-api/get-address-balance"
    static let getWalletBalance = "api/GetBalance"
    static let changePassword = "api/ChangePassword"
    static let requestChangePasswordOtp = "api/RequestChangePasswordOTP"
    static let getDepositHistory = "api/GetDeposits"
    static let getWithdrawHistory = "api/GetWithdrawals"
    static let withdrawRequest = "api/RequestWithdraw"
    static let requestWithdrawConfirmation = "api/RequestWithdrawConfirmation"
    static let getWithdrawAddress = "api/GenerateAddress"
    static let getListOfAllAddress = "api/ListAllAddresses"
    static let placeOrder = "api/PlaceOrder"
    static let cancelOrder = "api/CancelOrder"
    
    //login
    static let loginStep1 = "api/AuthenticateUser"
    static let loginStep2 = "token"
    static let Request_Device_Verification_OTP = "api/Request_Device_Verification_OTP"
    //
    //    static let loginStep1 = "api/AuthenticateUser/v2"
    //    static let loginStep2 = "token/v2"
    static let signUp = "api/SignUp"
    static let forgotPassword = "api/ForgotPassword"
    
    
    //PHASE 2
    static let currencySetings = "api/CurrencySettings"
    static let getKycForm = "api/GOKYC_Get_Kyc_Form"
    static let submitKyc = "api/GOKYC_Submit_KYC_Form"
    static let getBankList = "api/List_Fiat_BanksList"
    // static let tradeHistoryGrouped = "api/TradeHistory_Grouped"
    static let tradeHistoryGrouped = "api/OrderHistory"
    
    //PHASE 2 deposite
    static let addFiatManualDepositRequest = "api/Add_Fiat_Manual_Deposit_Request"
    static let addFiatPGDepositRequest = "api/Add_Fiat_PG_Deposit_Request"
    
    static let addFiatManualWithdrwalRequest = "api/Add_Fiat_Manual_Withdrawal_Request"
    
    //PHASE 2 : Fiat estimation
    static let getFiatPrice = "api/get_fiat_price"
    static let getCryptoPrice = "api/get_crypto_price"
    static let ListFiatManualDepositRequests = "api/List_Fiat_Manual_Deposit_Requests"
    
    //White listed Device
    static let getwhitelisted = "api/list-whitelisted-devices"
    static let deletedwhitelisted = "api/delete-whitelisted-device"
    
    //InstaTrade
    static let request_insta_trade = "api/request_insta_trade"

    static let get_insta_pairs = "api/get_insta_pairs"
    static let get_insta_trades = "api/get_insta_trades"

    //Exchange Token
    static let getDiscountTier = "api/GetDiscountTiers"
    static let GetExchangeTokenDiscountEnrollmentStatus = "api/GetExchangeTokenDiscountEnrollmentStatus"
    static let setExchangeTokenDiscountEnrollment = "api/SetExchangeTokenDiscountEnrollment"
    static let dis_Enroll_ExchangeTokenDiscount = "api/Dis_Enroll_ExchangeTokenDiscount"
    static let renew_token = "renew-token"
    
    //IP White Listing
    static let Get_IP_Whitelist = "api/Get_IP_Whitelist"
    static let Delete_IP_Whitelist = "api/Delete_IP_Whitelist"
    static let Add_IP_Whitelist = "api/Add_IP_Whitelist"
    
    //Coins Stats
    static let get_coin_stats = "api/get_coin_stats"

    
    //Withdrawal
    static let requestWithdraw_EmailOTP = "api/RequestWithdraw_EmailOTP"

    //Volume Discount
    static let get_User_Volume_Discount_Limits = "api/Get_User_Volume_Discount_Limits"
    //Cyrpto Address whitelisting
    static let Enable_Withdrawal_Address_Whitelisting = "api/Enable_Withdrawal_Address_Whitelisting"
    static let Disable_Withdrawal_Address_Whitelisting = "api/Disable_Withdrawal_Address_Whitelisting"
    static let Get_AddressBook = "api/Get_AddressBook"
    static let Delete_AddressBook = "api/Delete_AddressBook"
    static let Add_AddressBook = "api/Add_AddressBook"
    static let Get_Withdrawal_Address_Whitelisting_Status = "api/Get_Withdrawal_Address_Whitelisting_Status"
    
    //Cyrpto Address whitelisting
    static let Get_Fiat_CustomerAccounts = "api/Get_Fiat_CustomerAccounts"
    static let  Add_Fiat_CustomerAccount = "api/Add_Fiat_CustomerAccount?Module=Fiat%20Manual"
    //Favourite
    static let Customer_Favourite_Coins = "api/Customer_Favourite_Pairs"
    
    static let requestOTP = "api/Request_Mobile_Verification_OTP"
    /***Trade History screen*/
    static let trade_history = "api/TradeHistory"
    /***Phone Veriification*/
    static let add_phone_verification_step1 = "api/add-phone-verification-step1"
    static let add_phone_verification_step2 = "api/add-phone-verification-step2"
    
    static let delete_phone_verification_step1 = "api/delete-phone-verification-step1"
    static let delete_phone_verification_step2 = "api/delete-phone-verification-step2"
    
    /***KYC SDK sum Sub*/
    static let KYC_OnSite_AccessToken = "api/KYC_OnSite_AccessToken"
}



/**
 *  深度数据元
 */
class demo{}


class MDNetworkManager: NSObject {
    
    public typealias responseModel = (_ response: NSDictionary? , _ error:Error?) -> Void
    public typealias responseUrlConnection  = (_ data:Data?,_ response: NSDictionary? , _ error:Error?) -> Void
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let shared = MDNetworkManager()
    static let urlEncoding = URLEncoding(destination: .httpBody, arrayEncoding: .brackets, boolEncoding: .literal)
    var refreshingRequestTimer:[[String:Any]] = [[:]]
    var tabBarVC = MDHomeTabBarControllerViewController()
    
    
    public let AlamofireManager : Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://api-cs-exchange.modulusexchange.com": .disableEvaluation,
            API.chartsDataURL:.disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let man = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return man
    }()
    
    private override init() {}
    //    let baseURL = "https://goesoteric.com/"
    
    var authToken = {
        return "Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as? String ?? "")"
    }()
    
    func sendRequest(baseUrl:String = API.baseURL,methodType:HTTPMethod , apiName:String , parameters:NSDictionary? , headers:NSDictionary?,encoding:ParameterEncoding = JSONEncoding.prettyPrinted,isRefreshRequest: Bool = false, completionHandler:@escaping responseModel){
        
        
            
        
        
        
        if appDelegate.isConnected == true {
            let urlstring = baseUrl + apiName
            
            let request = AlamofireManager.request(urlstring,
                                                   method: methodType,
                                                   parameters: parameters as? [String:Any],
                                                   encoding: encoding,
                                                   headers: headers as? [String:String])
            
            
            request.responseJSON { (response:DataResponse<Any>) in
                
                let message = (response.result.value as? NSDictionary ?? NSDictionary()).valueForCaseInsensativeKey(forKey: "Message") as? String ?? ""
                
                if message.lowercased().contains("invalid token"){
                    //logout user
                    UserDefaults.standard.removeObject(forKey: "AccessToken")
                    UserDefaults.standard.removeObject(forKey: "profile")
                    UserDefaults.standard.removeObject(forKey: "grantType")
                    DispatchQueue.main.async { [weak self] in
                        self?.tabBarVC.selectedIndex = 0
                    }
                }
                
                completionHandler(response.result.value as? NSDictionary, response.error)
                switch response.result{
                case .success(let success):
                    //                    print(success)
                    self.check_for_tokenExpire(dict: success as! [String : Any])
                case .failure(let error):
                    print(error.localizedDescription)
                    print("\n\n===========Error============\n For URL=> \(apiName)\n\n")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription)")
                    if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                        print("Server Error: " + str)
                    }
                    debugPrint(error as Any)
                    print("===========================\n\n")
                }
            }
            
            request.response { (data) in
                //print(data.data!)
            }
            
            request.responseString { (data2) in
                //print(data2)
            }
            
        }else {
            if isRefreshRequest == false {
                completionHandler(nil,nil)
                MDSnackBarHelper.shared.showErroMessage(message: localised("The internet appears to be offline"))
            }
        }
    }
    func check_for_tokenExpire(dict:[String:Any]){
        if let message = dict["Message"] as? String , message.lowercased().contains("ip mismatched") {
            MDHelper.shared.logOut()
        }
    }
    
    func sendJSONRequest(baseUrl:String = API.baseURL,
                         methodType:HTTPMethod ,
                         apiName:String ,
                         parameters:NSDictionary? ,
                         headers:NSDictionary?,
                         completionHandler:@escaping responseModel){
        
        let baseUrl = "\(baseUrl)\(apiName)"
        
        //Make first url from this queryStringParam using URLComponents
        let urlComponent = URLComponents(string: baseUrl)!
        
        //Now make `URLRequest` and set body and headers with it
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = methodType == .post ? "POST" : "GET"
        if let param = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: param)
        }
        request.allHTTPHeaderFields = (headers as! [String : String])
        
        MDHelper.shared.showHudOnWindow()
        //Now use this URLRequest with Alamofire to make request
        Alamofire.request(request).responseJSON { response in
            MDHelper.shared.hideHudOnWindow()
            //Your code
            switch (response.result) {
            case .success:
                if let responseDict = response.result.value as? NSDictionary{
                    completionHandler(responseDict,nil)
                    self.check_for_tokenExpire(dict: responseDict as! [String : Any])
                }
                break
            //success code here
            
            case .failure(let error):
                completionHandler(nil,error)
                break
            }
        }
    }
    
    
    
    func getDepthChartData(currencyPair: String,limit:String,completionHandler:@escaping responseModel) {
        
        let url = "\(API.baseURL)\(API.getDepthChart)?symbol=\(currencyPair)&limit=\(limit)"
        Alamofire.request(url, method:.get, parameters:nil,encoding: JSONEncoding.default).responseJSON { response in
            completionHandler(response.result.value as? NSDictionary, response.error)
        }
    }
    func getChartData(baseCurrency: String,qouteCurrency:String,completionHandler:@escaping responseModel) {
        
        let url = "\(API.baseURL)\(API.getChartData)?baseCurrency=\(baseCurrency)&quoteCurrency=\(qouteCurrency)&interval=1&limit=1&timestamp=\(Date().millisecondsSince1970)"
        Alamofire.request(url, method:.get, parameters:nil,encoding: JSONEncoding.default).responseJSON { response in
            completionHandler(response.result.value as? NSDictionary, response.error)
        }
    }
    func isResponseSucced(response:NSDictionary)->Bool{
        if let status = response.valueForCaseInsensativeKey(forKey: "status") as? String, status == "Success"{
            return true
        }else{
            if appDelegate.byPassLogin == false{
                if let message = response.valueForCaseInsensativeKey(forKey: "message") as? String, message.contains("Authorization has been denied"){
                    MDHelper.shared.logOut()
                    return false
                }
            }
        }
        return false
    }
    
    func frequentlyRefreshingRequest(interval:TimeInterval,
                                     methodType:HTTPMethod ,
                                     apiName:String ,
                                     parameters:NSDictionary? ,
                                     headers:NSDictionary?,
                                     completionHandler:@escaping responseModel){
        
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
            self.sendRequest(methodType: methodType,
                             apiName: apiName,
                             parameters: parameters,
                             headers: headers,isRefreshRequest: true,
                             completionHandler: completionHandler)
        }
        timer.fire()
        refreshingRequestTimer.append(["timerRequestApi":"",
                                       "timeInterval":interval,
                                       "timer":timer])
    }
    
    
    
    func sendRequestURLConnection(methodType:HTTPMethod , apiName:String , parameters:NSDictionary? , headers:NSDictionary?, responseHandler:@escaping responseUrlConnection){
        
        //        let headers = [
        //            "Content-Type": "application/x-www-form-urlencoded",
        //            "cache-control": "no-cache",
        //            "Postman-Token": "b44ea0f6-76c2-43eb-a8fe-ad070c501d1f"
        //        ]
        let postData = NSMutableData()
        if parameters != nil{
            
            for key in (parameters?.allKeys)!{
                if postData.length == 0{
                    postData.append("\(key)=\((parameters?.valueForCaseInsensativeKey(forKey: key as! String))!)".data(using: String.Encoding.utf8)!)
                }else{
                    postData.append("&\(key)=\((parameters?.valueForCaseInsensativeKey(forKey: key as! String))!)".data(using: String.Encoding.utf8)!)
                }
            }
        }
        
        //        let postData = NSMutableData(data: "email=bhavesh7sarwar@gmail.com".data(using: String.Encoding.utf8)!)
        //        postData.append("&password=qwerty".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://api-cs-exchange.modulusexchange.com/api/AuthenticateUser")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard
                let data = data,
                let dict = (try? JSONSerialization.jsonObject(with: data)) as? NSDictionary
            else {
                print("error:", error ?? "nil")
                responseHandler(nil,nil,error)
                return
            }
            self.check_for_tokenExpire(dict: dict as! [String : Any])
            responseHandler(data,dict,error)
        })
        
        dataTask.resume()
        
    }
    
    
    
    func generateHmacForParams(params:NSDictionary)->String{
        //        let cParams = ["currency":"BTC",
        //                       "timestamp" : "1539860858653",
        //                       "recvWindow" : "10000"]
        
        var paramString = ""
        
        for key in (params.allKeys as! [String]).sorted(by: { (first, secound) -> Bool in
            first.lowercased() < secound.lowercased()
        }){
            if paramString.count == 0{
                paramString = "\(key)=\(params.valueForCaseInsensativeKey(forKey: key) as! String)"
            }else{
                paramString = paramString + "&\(key)=\(params.valueForCaseInsensativeKey(forKey: key) as! String)"
            }
        }
        
        
        return (paramString.replacingOccurrences(of: " ", with: "+") as! NSString).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!.hmac(algorithm: .SHA512, key: appDelegate.secretKey)
        //        let sh512 = SweetHMAC(message: paramString, secret: appDelegate.secretKey).HMAC(.SHA512)
        //        print(paramString)
        
        
    }
    func getCurrentTimeStamp() -> String {
        return String(Int(Date().timeIntervalSince1970))
    }
    
    
    
    
    
    
    
    func fetchStyleSheetFromServer(){
        
        if let themeServerDict = UserDefaults.standard.value(forKey: "themeFromServer") as? NSDictionary{
            MDHelper.shared.setUpTheme(response: themeServerDict)
        }else{
            
            //            let headers = [
            //                "Content-Type": "application/json",
            //                "JsonStub-User-Key": "208bce9c-5f65-44ce-8af4-d852cbf63cae",
            //                "JsonStub-Project-Key": "778eb064-1806-4122-8350-c4b4b6e44ccc",
            //                ]
            
            sendRequest(baseUrl:"https://demo9799400.mockable.io/" ,
                        methodType: .get,
                        apiName: "getStyleSheet",
                        parameters: nil,
                        headers: nil) {(response, error) in
                MDHelper.shared.hideHudOnWindow()
                if error == nil && response != nil{
                    //                    print(response!)
                    UserDefaults.standard.setValue(response, forKey: "themeFromServer")
                    MDHelper.shared.setUpTheme(response: response!)
                }else{
                    MDHelper.shared.showErrorPopup(message:(error?.localizedDescription ?? localised("Some thing went wrong")))
                }
                
                
            }
        }
        
    }
    func call_emptyRequestApi(urlstring:String,completion:@escaping([String:Any]?)->()){
        AlamofireManager.request(urlstring).responseJSON { (response) in
            completion(response.result.value as? [String : Any] ?? [:] )
        }
    }
}



enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate(capacity: digestLen)
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        var hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
    
}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
