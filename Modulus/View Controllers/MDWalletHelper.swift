//
//  MDWalletHelper.swift
//  Modulus
//
//  Created by Pathik  on 14/11/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDWalletHelper: NSObject {
    
    
    static let shared = MDWalletHelper()
    private override init() {}
    
    
    
    
    func getWalletBalanceForCurrency(currency: String)->NSDictionary?{
        var walletBalanceArray : NSArray? = nil
        let params = [
            "currency": currency,
            "timestamp":"\(MDNetworkManager.shared.getCurrentTimeStamp())",
            "recvWindow": "1000"
        ]
        let group = DispatchGroup()
        group.enter()
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as! NSDictionary)] as [String : Any]
  
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .post,
                                            apiName: API.getWalletBalance,
                                            parameters: params as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
                                                
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray{
                                                            print(data)
                                                            DispatchQueue.global(qos: .default).async {
                                                                walletBalanceArray = data
                                                                
                                                            }
                                                            group.leave()
                                                        }
                                                    }else{
                                                        group.leave()
                                                        if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                                                            print("Error fetching all balance"+message)
                                                        }
                                                    }
                                                }else{
                                                    if  error != nil{
                                                   print("Error fetching all balance"+(error?.localizedDescription)!)
                                                    }
                                                }
                                               
                        }
        // wait ...
        group.wait()
        //will execute only if response is succeed
        return walletBalanceArray?.firstObject as? NSDictionary
        
    }
  

    
}
