//
//  MDChangePasswordVC.swift
//  Modulus
//
//  Created by Pathik  on 24/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MDChangePasswordVC: UIViewController {
    
    //MARK: - StoryBoard outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textFieldsStackView: UIStackView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var oldPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var otpTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var resenOTPLabel: UILabel!
    @IBOutlet weak var resendOtpButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    //MARK: - Automation Identifiers
    func addAutomationIdentifiers(){
        //For Automation
        oldPassTextField.accessibilityIdentifier = "oldPassword"
        oldPassTextField.accessibilityLabel = "oldPassword"
        
        newPassTextField.accessibilityLabel = "newPassword"
        newPassTextField.accessibilityIdentifier = "newPassword"
        
        confirmPassTextField.accessibilityIdentifier = "confirmPassword"
        confirmPassTextField.accessibilityLabel = "confirmPassword"
        
        otpTextField.accessibilityIdentifier = "confirmPassword"
        otpTextField.accessibilityLabel = "confirmPassword"
        
        submitButton.accessibilityLabel = "submitButton"
        submitButton.accessibilityIdentifier = "submitButton"
    }
    
    //MARK: - Set all titles
    private func setAllTextOnScreenWithLocalisation(){
        
        warningLabel.text = localised("* For security purposes no withdrawals are permitted for 24 hours after modification of security methods.")
        infoTextLabel.text = localised("* For security purposes no withdrawals are permitted for 24 hours after modification of security methods.")
        
        
        oldPassTextField.placeholder = localised("Old Password")
        oldPassTextField.selectedTitle = localised("Old Password")
        oldPassTextField.title = localised("Old Password")

        newPassTextField.placeholder = localised("New Password")
        newPassTextField.selectedTitle = localised("New Password")
        newPassTextField.title = localised("New Password")

        confirmPassTextField.placeholder = localised("Confirm Password")
        confirmPassTextField.selectedTitle = localised("Confirm Password")
        confirmPassTextField.title = localised("Confirm Password")
        
        submitButton.setTitle(localised("SUBMIT"), for: .normal)
        
    }
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpColors()
        reframeTextField()
        addAutomationIdentifiers()
        self.setAllTextOnScreenWithLocalisation()
        // Do any additional setup after loading the view.
        oldPassTextField.delegate = self
        newPassTextField.delegate = self
        confirmPassTextField.delegate = self
        
        let receiveOtp = localised("Didn't Receive OTP ?")
        let sendAgainText = localised(" Send again")
        let attributedString = receiveOtp+sendAgainText
        let myMutableString = NSMutableAttributedString(string: attributedString)
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.current.titleTextColor, range: NSRange(location:0,length:receiveOtp.count))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.current.primaryColor, range: NSRange(location:receiveOtp.count,length:sendAgainText.count))
        resenOTPLabel.attributedText = myMutableString
        
        
        // Check if google autheticator has been enabled or not
        if let profile = UserDefaults.standard.value(forKey: "profile") as? NSDictionary {
            var twoFA = false
            if let twoFactorEnabled = UserDefaults.standard.value(forKey: "is2FAEnabled") as? Bool {
                twoFA = twoFactorEnabled
            }
            if twoFA == true{
                resendOtpButton.isHidden = true
                resenOTPLabel.isHidden = true
                otpTextField.placeholder = localised("Input your 6-digit authenticator code")
            }else{
                otpTextField.placeholder = localised("Please enter OTP")
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       TSMessage.dismissActiveNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationbar()
        setUpColors()
    }
    
    //MARK: - Textfield  UI Helpers
    /// This will change textField Ui and add the left side icons in to the textField
    func reframeTextField()  {
        oldPassTextField.addPaddingView(mode: .right,paddingWidthPercent:0.4, image: UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.titleTextColor)) { (button) in
            // print("eye clicked")
    
            if let rightView = self.oldPassTextField.rightView as? UIButton {
                
                //For Automation
                rightView.isAccessibilityElement = true
                rightView.accessibilityLabel = "oldPasswordViewButton"
                rightView.accessibilityIdentifier = "oldPasswordViewButton"
                
                if !self.oldPassTextField.isSecureTextEntry {
                    rightView.setImage(UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.titleTextColor), for: .normal)
                }else{
                    rightView.setImage( UIImage.init(named: "password-eye")!.imageWithColor(color1: Theme.current.titleTextColor), for: .normal)
                    
                }
            }
            self.oldPassTextField.isSecureTextEntry = !self.oldPassTextField.isSecureTextEntry
        }
        newPassTextField.addPaddingView(mode: .right,paddingWidthPercent:0.4, image: UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.titleTextColor)) { (button) in
            // print("eye clicked")
            
            if let rightView = self.newPassTextField.rightView as? UIButton {
               
                //For Automation
                rightView.isAccessibilityElement = true
                rightView.accessibilityLabel = "newPasswordViewButton"
                rightView.accessibilityIdentifier = "newPasswordViewButton"
                
                
                if !self.newPassTextField.isSecureTextEntry {
                    rightView.setImage(UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.titleTextColor), for: .normal)
                }else{
                    rightView.setImage( UIImage.init(named: "password-eye")!.imageWithColor(color1: Theme.current.titleTextColor), for: .normal)
                    
                }
            }
            self.newPassTextField.isSecureTextEntry = !self.newPassTextField.isSecureTextEntry
        }
        confirmPassTextField.addPaddingView(mode: .right,paddingWidthPercent:0.4, image: UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.titleTextColor)) { (button) in
            // print("eye clicked")
            
            
            if let rightView = self.confirmPassTextField.rightView as? UIButton {
            
                //For Automation
                rightView.isAccessibilityElement = true
                rightView.accessibilityLabel = "confirmPasswordViewButton"
                rightView.accessibilityIdentifier = "confirmPasswordViewButton"
                
                if !self.confirmPassTextField.isSecureTextEntry {
                    rightView.setImage(UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.subTitleColor), for: .normal)
                }else{
                    rightView.setImage( UIImage.init(named: "password-eye")!.imageWithColor(color1: Theme.current.titleTextColor), for: .normal)
                    
                }
            }
            self.confirmPassTextField.isSecureTextEntry = !self.confirmPassTextField.isSecureTextEntry
        }
    }

    //MARK: - Navigation bar helpers
    func setNavigationbar(){
        //For Automation
        self.navigationItem.backBarButtonItem?.isAccessibilityElement = true
        self.navigationItem.backBarButtonItem?.accessibilityIdentifier = "NavigationBackButton"
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "NavigationBackButton"
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = localised("Change Password")
        self.navigationItem.titleView = label
    }
    
    //MARK:- setup appeareance
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        backgroundView.backgroundColor  = Theme.current.backgroundColor
        
        
        oldPassTextField.placeholderColor = Theme.current.subTitleColor
        oldPassTextField.titleColor = Theme.current.titleTextColor
        oldPassTextField.lineColor = Theme.current.subTitleColor
        oldPassTextField.selectedLineColor  = Theme.current.subTitleColor
        oldPassTextField.selectedTitleColor = Theme.current.subTitleColor
        oldPassTextField.textColor = Theme.current.titleTextColor
        
        newPassTextField.placeholderColor = Theme.current.subTitleColor
        newPassTextField.titleColor = Theme.current.titleTextColor
        newPassTextField.lineColor = Theme.current.subTitleColor
        newPassTextField.selectedLineColor  = Theme.current.subTitleColor
        newPassTextField.selectedTitleColor = Theme.current.subTitleColor
        newPassTextField.textColor = Theme.current.titleTextColor
        
        confirmPassTextField.placeholderColor = Theme.current.subTitleColor
        confirmPassTextField.titleColor = Theme.current.titleTextColor
        confirmPassTextField.lineColor = Theme.current.subTitleColor
        confirmPassTextField.selectedLineColor  = Theme.current.subTitleColor
        confirmPassTextField.selectedTitleColor = Theme.current.subTitleColor
        confirmPassTextField.textColor = Theme.current.titleTextColor
        
        submitButton.backgroundColor = Theme.current.primaryColor
        submitButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        
        infoTextLabel.textColor = Theme.current.titleTextColor
        
        
        self.otpTextField.placeholderColor = Theme.current.subTitleColor
        self.otpTextField.titleColor = Theme.current.titleTextColor
        self.otpTextField.lineColor = Theme.current.subTitleColor
        self.otpTextField.selectedLineColor  = Theme.current.subTitleColor
        self.otpTextField.selectedTitleColor = Theme.current.subTitleColor
        self.otpTextField.textColor = Theme.current.titleTextColor
    //    headerView.backgroundColor = Theme.current.navigationBarColor
    //    nameInitialLabel.backgroundColor = MDAppearance.Colors.initialLabelColor
    //    self.accountTableView.backgroundColor = .clear
        
    }
    
    //MARK: - Button Actions
    @IBAction func submitButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if validateInputs() == true{
            changePassword()
        }
        
    }
    
    //MARK: - Input validation
    func validateInputs()->Bool{
        if oldPassTextField.isEmpty() == false , newPassTextField.isEmpty() == false,confirmPassTextField.isEmpty() == false{
            return true
            
        }else{
            MDHelper.shared.showErrorAlert(message: localised("Please Enter Values for all fields"), viewController: self)
        }
        return false
    }
    
    func validateTextFields() -> Bool {
        var result = false
        var message = ""
        
        
        if newPassTextField.text!.count >= 7 {
            if newPassTextField.text!.isValidPassword() {
                if confirmPassTextField.text != "" {
                    if otpTextField.text != ""{
                        if newPassTextField.text == confirmPassTextField.text {
                            return true
                        }else{
                            result = false
                            message = localised("New Password and confirm password do not match")
                        }
                    }else{
                        result = false
                        message = localised("Please enter OTP")
                    }
                }else{
                    result = false
                    message = localised("Please enter confirm password")
                }
            }else{
                result = false
                message = localised("Password must be no less than 7 characters including uppercase and lowercase letters")
            }
        }else{
            result = false
            message = localised("New Password must be no less than 7 characters")
        }
        
        
        if message != "" {
            MDHelper.shared.showErrorAlert(message:message, viewController:self)
        }
        return result
    }
    
    //MARK: - Network Calls
    func changePassword(){
        if validateTextFields() {
        let param = [
            "oldPassword" : (oldPassTextField.text)!,
            "newPassword" : newPassTextField.text!,
            "otp": (otpTextField.text)!,
            "timestamp" : "\(MDNetworkManager.shared.getCurrentTimeStamp())",
            "recvWindow" : "10000"
            ]
        
//        let hmac = MDNetworkManager.shared.generateHmacForParams(params: param as NSDictionary)
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: param as NSDictionary)] as [String : Any]
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .post,
                                            apiName: API.changePassword,
                                            parameters: param as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
//                                                        if let _ = response?.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
//                                                        MDHelper.shared.hideHudOnWindow()
                                                        self.navigationController?.popViewController(animated: true);
                                                        MDHelper.shared.showSucessAlert(message: localised("Password changed successfully"), viewController: self)
//                                                        }
                                                    }else{
                                                        if let message = response?.valueForCaseInsensativeKey(forKey: "data") as? String{
                                                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                            return
                                                        }
                                                        if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                                                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                        }
                                                    }
                                                }else{
                                                    if  error != nil{
                                                        //                                                        MDHelper.shared.showErrorAlert(message: (error?.localizedDescription)!, viewController: self)
//                                                        self.resendChangePasswordOTP()
                                                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                    }
                                                }
                                                //                                                print("Get wallet details")
        }
        }
//        print(hmac)
    }
    @IBAction func resendOtpAction(_ sender: Any) {
        resendChangePasswordOTP()
    }
    

    func resendChangePasswordOTP(){
        if let accountVC = self.navigationController?.viewControllers.filter({$0 is MDAccountVC}).first as? MDAccountVC{
            accountVC.changePassword(shouldMovetoChangePassword: false)
        }else{
            MDHelper.shared.showErrorAlert(message: localised("Something Went Wrong while resending Change password OTP"), viewController: self)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MDChangePasswordVC : UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPassTextField{
            textField.resignFirstResponder()
            newPassTextField.becomeFirstResponder()
        }else  if textField == newPassTextField{
            textField.resignFirstResponder()
            confirmPassTextField.becomeFirstResponder()
        }else  if textField == confirmPassTextField{
            textField.resignFirstResponder()

        }
     
//        self.view.endEditing(true)
        return false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " "{
            return false
        }
        return true
        
    }
    
}
