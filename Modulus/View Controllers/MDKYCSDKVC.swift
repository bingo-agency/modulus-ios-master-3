//
//  MDKYCSDKVC.swift
//  Modulus
//
//  Created by Rahul on 03/02/22.
//  Copyright © 2022 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import IdensicMobileSDK
class MDKYCSDKVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUpOfKYCSDKVC()
        self.fetchKYC_OnSite_AccessToken()
    }
    
    private
    func initialSetUpOfKYCSDKVC(){
        if let settings = MDHelper.shared.getAppSetting() , let kyc_info = settings.value(forKey: "kyc") as? NSDictionary {
            let webSDK_Provider_Url = kyc_info.value(forKey: "webSDK_Provider_Url") as? String
            let webSDK_Provider_Name = kyc_info.value(forKey: "webSDK_Provider_Name") as? String
        
        }
    }
    
    private
    func fetchKYC_OnSite_AccessToken(){
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: [:] as NSDictionary)] as NSDictionary
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: API.KYC_OnSite_AccessToken, parameters: [:], headers: headers) { (response, error) in
            print("MY Access Token \(response)")
            if error != nil{
                MDHelper.shared.showErrorAlert(message: error!.localizedDescription, viewController: self)
            }
            guard let response = response else {return}
            if MDNetworkManager.shared.isResponseSucced(response: response){
                if let onSiteTokenData = response.value(forKey: "data") as? NSDictionary{
                    if let accessToken = onSiteTokenData.value(forKey: "accessToken") as? String{ ///"_act-sbx-c80b0f55-4b5b-4130-81f9-c16d8818b139";
                        let applicantID = onSiteTokenData.value(forKey: "applicantID")  ///NA;
                        let flowName = onSiteTokenData.value(forKey: "flowName")   ///"basic-kyc-level";
                        let scriptUrl = onSiteTokenData.value(forKey: "scriptUrl")   ///"https://api.sumsub.com";
                        self.initialiseSDKParameter(accessToken: accessToken)
                    }
                }
            }else{
                let message = response.valueForCaseInsensativeKey(forKey: "Message") as? String ?? "Error occured"
                  MDHelper.shared.showErrorAlert(message: message, viewController: self)
            }
        }
    }
    
    private
    func initialiseSDKParameter(accessToken : String){
        let sdk = SNSMobileSDK(accessToken: accessToken)
        
        guard sdk.isReady else {
            print("Initialization failed: " + sdk.verboseStatus)
            return
        }
        
        self.listenToTokenExpiration(sdk: sdk)
        self.listenToDismissHandler(sdk: sdk)
        sdk.present()
    }
    
    private
    func listenToTokenExpiration(sdk : SNSMobileSDK){
        sdk.tokenExpirationHandler { (onComplete) in
            self.fetchKYC_OnSite_AccessToken()
        }
    }
    
    private
    func listenToDismissHandler(sdk : SNSMobileSDK){
        sdk.dismissHandler { (sdk, mainVC) in
            mainVC.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
