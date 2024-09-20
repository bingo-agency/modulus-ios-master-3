//
//  MDPhoneVerificationVC.swift
//  Modulus
//
//  Created by Rahul on 06/01/22.
//  Copyright © 2022 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTabs
class MDPhoneVerificationVC: UIViewController {
    /**Enable Phone Verification Outlets*/
    /**Select Country*/
    @IBOutlet weak var selectCountryBgView: UIView!
    @IBOutlet weak var selectCountryView: UIView!
    @IBOutlet weak var selectCountryLabel: UILabel!
    @IBOutlet weak var selectCountryTF: UITextField!
    /**Mobile Number*/
    @IBOutlet weak var smsOtpBgView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var getOTPReqBTN: UIButton!
    @IBOutlet weak var arrowDownImg: UIImageView!
    /**Mobile OTP*/
    @IBOutlet weak var mobileOtpBgView: UIView!
    @IBOutlet weak var mobileOTPView: UIView!
    @IBOutlet weak var mobileOTPLabel: UILabel!
    @IBOutlet weak var mobileOTPTF: UITextField!
    /**Confirm Enable/Disable Button*/
    @IBOutlet weak var confirmBTN: UIButton!
    /**Helper var*/
    var isPhoneVerified: Bool = (UIApplication.shared.delegate as! AppDelegate).isMobileVerified
    var countryCode: String = "IN"
    var token : String = ""
    
    var bottomSheet : MDCBottomSheetController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPhoneVerificationVC()
        self.setLocalisedLabels()
        self.setColours()
    }
    
    private
    func setPhoneVerificationVC(){
        self.selectCountryView.isHidden = self.isPhoneVerified
        self.mobileNumberTF.isUserInteractionEnabled = !self.isPhoneVerified
        switch self.isPhoneVerified{
        case true:
            if let profile = UserDefaults.standard.value(forKey: "profile") as? NSDictionary,let mobile = profile.value(forKey: "mobileNumber") as? String{
                self.mobileNumberTF.text = mobile
                self.selectCountryTF.text = profile.value(forKey: "country") as? String ?? ""
            }else{
                MDHelper.shared.showErrorAlert(message: "Mobile Number Not Found", viewController: self)
            }
            self.confirmBTN.setTitle(localised("Disable"), for: .normal)
            
        case false:
          
            self.confirmBTN.setTitle(localised("Enable"), for: .normal)
        }
    }
    
    private
    func setColours(){
        self.view.backgroundColor = Theme.current.backgroundColor
        self.selectCountryLabel.textColor = Theme.current.titleTextColor
        self.mobileNumberTF.textColor = Theme.current.titleTextColor
        self.mobileNumberTF.placeHolderColorCustom = Theme.current.subTitleColor

        self.mobileNumberLabel.textColor = Theme.current.titleTextColor
        self.mobileOTPLabel.textColor = Theme.current.titleTextColor
        
        self.mobileOTPTF.textColor = Theme.current.titleTextColor
        self.mobileOTPTF.placeHolderColorCustom = Theme.current.subTitleColor
        self.arrowDownImg.tintColor = Theme.current.titleTextColor
        
        self.selectCountryTF.textColor = Theme.current.titleTextColor
        self.selectCountryTF.placeHolderColorCustom = Theme.current.subTitleColor

        self.confirmBTN.setTitleColor(Theme.current.btnTextColor, for: .normal)
        self.confirmBTN.backgroundColor = Theme.current.primaryColor
        
        self.getOTPReqBTN.setTitleColor(Theme.current.btnTextColor, for: .normal)
        self.getOTPReqBTN.backgroundColor = Theme.current.primaryColor
        
        self.smsOtpBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        self.mobileOtpBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        self.selectCountryBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
      
        
    }
    
    private
    func setLocalisedLabels(){
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = localised("Phone Verification")
        label.textColor = Theme.current.titleTextColor
        self.navigationItem.titleView = label
        
        self.title = localised("Phone Verification")
        
        self.selectCountryLabel.text = localised("Select Country")
        self.selectCountryTF.placeholder = localised("Select")
        
        self.mobileNumberLabel.text = localised("Mobile Number")
        self.mobileNumberTF.placeholder = localised("Mobile Number")
        self.getOTPReqBTN.setTitle("  " + localised("Request OTP") + "  ", for: .normal)
        
        self.mobileOTPLabel.text = localised("Mobile OTP")
        self.mobileOTPTF.placeholder = localised("Mobile OTP")
    }
    
    private func resetFields(){
        self.mobileNumberTF.text = ""
        self.mobileOTPTF.text = ""
        self.selectCountryTF.text = ""
    }
    
//MARK:-------- IBActions ----------
    @IBAction func selectCountyBTNTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
        let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
        dropDownVC.type = .countryCode
        dropDownVC.delegate = self
        dropDownVC.selectedCountry = self.selectCountryTF.text ?? ""
        dropDownVC.searchBarPlaceHolder = localised("Search Country")
        bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
        bottomSheet?.delegate = self
        bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: self.view.frame.size.height)
        present(bottomSheet!, animated: true, completion: nil)
    }
    
    @IBAction func requestOTPTapped(_ sender: UIButton) {
        self.getOTPForSelectedMobile()
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        self.phoneVerificationAPI()
    }
    
//MARK:-------- Validation checks ----------
    private
    func validateInput(isGetOTPRequest:Bool)->Bool{
        guard self.selectCountryTF.text != "" else {
            MDHelper.shared.showErrorAlert(message: localised("Country field can't be empty"), viewController: self)
            return false
        }
        guard self.mobileNumberTF.text != "" else {
            MDHelper.shared.showErrorAlert(message: localised("Mobile Number field can't be empty"), viewController: self)
            return false
        }
        if isGetOTPRequest{
            return true
        }
        
        guard self.mobileOTPTF.text != "" else {
            MDHelper.shared.showErrorAlert(message: localised("Mobile OTP field can't be empty"), viewController: self)
            return false
        }
        return true
    }
    
    
    //MARK:-------- API CALL ----------
    private
    func getOTPForSelectedMobile(){
        guard let mobileNumber : String = self.mobileNumberTF.text else {return}
        let headers : NSDictionary = ["Content-Type": "application/json",
                                      "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"]
        let params : NSDictionary?
        let api : String
        if self.isPhoneVerified{
            params = nil
            api = API.delete_phone_verification_step1
        }else{
            guard self.validateInput(isGetOTPRequest: true) else {return}
            params = ["country_code":countryCode,"mobile_number":mobileNumber]
            api = API.add_phone_verification_step1
        }
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: api, parameters: params, headers: headers) { (response, error) in 
            if let e = error{
                MDHelper.shared.showErrorAlert(message: e.localizedDescription, viewController: self)
                return
            }
            MDHelper.shared.hideHudOnWindow()
            if let status = response?.value(forKey: "status") as? String , status == "Success" ,
               let data = response?.value(forKey: "data") as? NSDictionary , let token = data.value(forKey: "token") as? String{
                MDHelper.shared.showSucessAlert(message: localised("Success"), viewController: self)
                self.token = token
            }else{
                let message = response?.value(forKey: "message") as? String ?? "Error occured"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
            }
        }
    }
    
    
    private
    func phoneVerificationAPI(){
        guard let mobile_number : String = self.mobileNumberTF.text else {return}
        guard let sms_OTP : String = self.mobileOTPTF.text else {return}
        let headers : NSDictionary = ["Content-Type": "application/json",
                                      "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"]
        let params : NSDictionary
        let api : String
        guard self.validateInput(isGetOTPRequest: false) else {return}
        if self.isPhoneVerified{
            params = ["sms_otp":sms_OTP,"token":self.token]
            api =  API.delete_phone_verification_step2
        }else{
            api = API.add_phone_verification_step2
            params = ["country_code":self.countryCode,"mobile_number":mobile_number,"sms_otp":sms_OTP,"token":self.token]
        }
      
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: api, parameters: params, headers: headers) { (response, error) in
            if let e = error{
                MDHelper.shared.showErrorAlert(message: e.localizedDescription, viewController: self)
                return
            }

            if let status = response?.value(forKey: "status") as? String , status == "Success" {
                self.resetFields()
                self.isPhoneVerified.toggle()
                (UIApplication.shared.delegate as! AppDelegate).isMobileVerified = self.isPhoneVerified
                self.setPhoneVerificationVC()
                self.fetchProfile()
            }else{
                MDHelper.shared.hideHudOnWindow()
                let message = response?.value(forKey: "message") as? String ?? "Error occured"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
            }
        }
    }
    
    func fetchProfile(){
        let header = ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"]
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .get,
                                            apiName: API.profile,
                                            parameters: nil,
                                            headers: header as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if response != nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!) == true{
                    if let data = response!.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
                        let profile:NSMutableDictionary = NSMutableDictionary()
                        for key in data.allKeys as! [String]{
                            profile.setValue("\((data.value(forKey: key))!)", forKey: key)
                        }
                        UserDefaults.standard.setValue(profile.copy() as! NSDictionary, forKey: "profile")
                        UserDefaults.standard.setValue(data.value(forKey: "is2FAEnabled") as? Bool , forKey: "is2FAEnabled")
                        self.isPhoneVerified = data.value(forKey: "isMobileVerified") as? Bool ?? false
                        self.setPhoneVerificationVC()
                    }
                }
            }
        }
    }
}

extension MDPhoneVerificationVC : MDCBottomSheetControllerDelegate{
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        self.bottomSheet = nil
    }
}

extension MDPhoneVerificationVC : customDropDownDelegates{
    func dropDownSelected(title: String, data: NSDictionary) {
        if let countryCode = data.value(forKey: "countryCode") as? String{
            self.selectCountryTF.text = title
            self.countryCode = countryCode
        }else{
            MDHelper.shared.showErrorAlert(message: "Country Code Not Found!!!", viewController: self)
        }
    }
}
