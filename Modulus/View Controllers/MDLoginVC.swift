//
//  MDLoginVC.swift
//  Modulus
//
//  Created by Pathik  on 12/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MaterialComponents.MaterialTabs
import SwiftyRSA
import Alamofire

protocol MDLoginVCDelegate : class{
    func loginInSuccessfully()
}
class MDLoginVC: UIViewController , UITextFieldDelegate{

    
    //MARK: - Storyboard outlets
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldsStackView: UIStackView!
    @IBOutlet weak var appLogog: UIImageView!
    @IBOutlet weak var notNowButton: UIButton!
    
    //MARK: - Variables
    var tempAuthToken = ""
    var deviceID = ""
    var tapCountToOpenSettingScreen = 0
    weak var delegate : MDLoginVCDelegate?
    //MARK: - Constants
    let loginSegue = "loggedIn"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let openSettingsSegueId = "openSettings"
    
    let devModePrefilledEmail       = "inspeerodev2@gmail.com"
    let devModePrefilledPassword    = "Qwerty1234"
    
    
    
    //MARK: - Automation identifiers
    func addAutomationIdentifiers(){
        
        emailTextField.accessibilityIdentifier  = "email"
        emailTextField.accessibilityLabel       = "email"
    
        loginButton.accessibilityLabel          = "loginButton"
        loginButton.accessibilityIdentifier     = "loginButton"
        loginButton.accessibilityValue          = "loginButton"
        
        signUpButton.accessibilityIdentifier    = "signUpButton"
        signUpButton.accessibilityLabel         = "signUpButton"
        signUpButton.accessibilityValue         = "signUpButton"
        
        forgotPasswordButton.accessibilityIdentifier    = "forgotPasswordButton"
        forgotPasswordButton.accessibilityLabel         = "forgotPasswordButton"
        forgotPasswordButton.accessibilityValue         = "forgotPasswordButton"
        
        self.view.accessibilityIdentifier               = "loginScreen"
    }
    
    //MARK: - View controller life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reDesignTextFields()
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        addAutomationIdentifiers()
        
        self.loginButton.isMultipleTouchEnabled = false
        self.setAllTextOnScreenWithLocalisation()
        
        #if DEBUG
            self.emailTextField.text = "inspeerodev@gmail.com"
            self.passwordTextField.text = "Qwerty123"
        #else
          print("Nope")
        #endif
    

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpColors()
        if self.tabBarController != nil{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
////            if MDSignalRManager.shared.marketSummery != nil{
//                    MDSignalRManager.shared.connection?.stop()
//                    MDSignalRManager.shared.marketSummery = nil
//                    MDSignalRManager.shared.connection = nil
////            }
//        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
           // if SocketHelper.shared.marketSummery != nil{
               // SocketHelper.shared.stopConnection()
               // SocketHelper.shared.marketSummery = nil
                //SocketHelper.shared.connection = nil
            //}
        } else {
            // Fallback on earlier versions
        }
    }

    //MARK: - Touch Delegates
    /// This will be used to dismiss the keyboard when you click anywhere on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - translations strings
    func updateTranslations(){
//        self.loginButton.
    }
    
    
    //MARK:- View  Helpers Methods
    func setUpColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        self.scrollContentView.backgroundColor = Theme.current.backgroundColor
        loginButton.backgroundColor = Theme.current.primaryColor
        
        emailTextField.placeholderColor = Theme.current.subTitleColor
        emailTextField.titleColor = Theme.current.titleTextColor
        emailTextField.lineColor = Theme.current.subTitleColor
        emailTextField.selectedLineColor  = Theme.current.subTitleColor
        emailTextField.selectedTitleColor = Theme.current.subTitleColor
        emailTextField.textColor = Theme.current.titleTextColor

        passwordTextField.placeholderColor = Theme.current.subTitleColor
        passwordTextField.titleColor = Theme.current.titleTextColor
        passwordTextField.lineColor = Theme.current.subTitleColor
        passwordTextField.selectedLineColor  = Theme.current.subTitleColor
        passwordTextField.selectedTitleColor = Theme.current.subTitleColor
        passwordTextField.textColor = Theme.current.titleTextColor
        
        loginButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        signUpButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        forgotPasswordButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        
//        appLogog.tintColor = Theme.current.primaryColor
        
    }
    
    //MARK: - Set all titles
    private func setAllTextOnScreenWithLocalisation(){
        emailTextField.placeholder = localised("Email")
        emailTextField.selectedTitle = localised("Email")
        emailTextField.title = localised("Email")
        
        
        passwordTextField.placeholder = localised("Password")
        passwordTextField.selectedTitle = localised("Password")
        passwordTextField.title = localised("Password")
        
        
        loginButton.setTitle(localised("LOGIN"), for: .normal)
        signUpButton.setTitle(localised("Sign up"), for: .normal)
        forgotPasswordButton.setTitle(localised("Forgot password?"), for: .normal)
        
        notNowButton.setTitle(localised("NOT NOW"), for: .normal)
    }
    

    
    
    
    /// Dismiss Keyboard for all the textFields presented
    func reDesignTextFields() {
        
        emailTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "email")!.imageWithColor(color1: Theme.current.textFieldIconsTintColorInActive).withRenderingMode(.alwaysOriginal)){ (button) in
            self.emailTextField.becomeFirstResponder()
        }
        passwordTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "padlock")!.imageWithColor(color1: Theme.current.textFieldIconsTintColorInActive).withRenderingMode(.alwaysOriginal)){ (button) in
           self.passwordTextField.becomeFirstResponder()
        }
        passwordTextField.addPaddingView(mode: .right,paddingWidthPercent:0.4, image: UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.textFieldIconsTintColorInActive).withRenderingMode(.alwaysOriginal)) { (button) in
           // print("eye clicked")
            
            if let rightView = self.passwordTextField.rightView as? UIButton {
                if !self.passwordTextField.isSecureTextEntry {
                    rightView.setImage(UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.textFieldIconsTintColorInActive).withRenderingMode(.alwaysOriginal), for: .normal)
                }else{
                    rightView.setImage( UIImage.init(named: "password-eye")!.imageWithColor(color1: Theme.current.textFieldIconsTintColorActive).withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
             self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        }
    }
    
    
    //MARK: - Helper Methods
    
    /// This will validates the user inputs
    ///
    /// - Parameters:
    ///   - email: it should be valid email
    ///   - password: Password can not be empty
    /// - Returns: this will return true if inputs are valid
    
    func validateEmailAndPassword(email:String,password:String) -> Bool {
        var result = false
        var message = ""
        if MDHelper.shared.isValidEmail(testStr: emailTextField.text!){
            if passwordTextField.text != ""{
                result = true
            }else{
                result = false
                message = localised("Please enter password")
            }
        }else{
            result = false
            message = localised("Please enter valid email")
        }
        if message != "" {
            passwordTextField.text = ""
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
        }
        return result
    }
    
    
    //MARK: - Button Actions
    @IBAction func loginButtonAction(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "loginStep2", sender: false)
//        self.encryptionLogin()
//        return
        
        if appDelegate.byPassLogin == true{
            /*
             * By pass login due to server is not stable
             */
            self.performSegue(withIdentifier: "loginStep2", sender: self)
            return
        }
        
        
        #if DEBUG
            if emailTextField.text == "" && passwordTextField.text == ""{
                emailTextField.text = devModePrefilledEmail
                passwordTextField.text = devModePrefilledPassword
            }
        #endif
        self.view.endEditing(true)
//        "mobile_session" : true
        let password_encrptyData = passwordTextField.text!.data(using: .utf16LittleEndian)!
        let password_base64Str = password_encrptyData.base64EncodedString()
        if self.validateEmailAndPassword(email: emailTextField.text!, password: passwordTextField.text!){
            MDHelper.shared.showHudOnWindow()
            
            do {
                
                let justkey = try PublicKey(pemNamed: "public")
                let password = try ClearMessage(string: "\(passwordTextField.text!)", using: .utf16LittleEndian)
                let passwordEncrypted = try password.encrypted(with: justkey, padding: .OAEP)
              
                let headers = [
                                "Content-Type": "application/json",
                            ]
                self.deviceID = UIDevice.current.identifierForVendor!.uuidString
                MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                                    methodType: .post,
                                                    apiName: API.loginStep1 + "/v2",
                                                    parameters: ["mobile_session" : true,
                                                                 "email": emailTextField.text!,
                                                                 "password":passwordEncrypted.base64String,
                                                                 "dvc_id":self.deviceID],
                                                    headers: headers as NSDictionary,
                                                    encoding: JSONEncoding.default) { (response, error) in
                                                        self.passwordTextField.text = ""
                                                        MDHelper.shared.hideHudOnWindow()
                                                        if response != nil && error == nil{
                                                            if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                            self.handleLoginStep1Response(response: response!)
                                                            }else{
                                                                let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String ?? "Error occured"
                                                                  MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                            }
                                                        }else{
                                                            if  error != nil{
                                                                MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                            }
                                                        }
                                                        #if DEBUG
                                                        self.emailTextField.text = ""
                                                        #endif

                }
                
            } catch {
                print(error)
            }
//            MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
//                                                methodType: .post,
//                                                apiName: API.loginStep1,
//                                                parameters: ["mobile_session" : true ,"email": emailTextField.text!,"password":passwordTextField.text!],
//                                                headers: nil) { (response, error) in
//                                                    self.passwordTextField.text = ""
//                                                    MDHelper.shared.hideHudOnWindow()
//                                                    if response != nil && error == nil{
//                                                        if MDNetworkManager.shared.isResponseSucced(response: response!){
//                                                        self.handleLoginStep1Response(response: response!)
//                                                        }else{
//                                                            let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String ?? "Error occured"
//                                                              MDHelper.shared.showErrorAlert(message: message, viewController: self)
//                                                        }
//                                                    }else{
//                                                        if  error != nil{
//                                                            MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
//                                                        }
//                                                    }
//                                                    #if DEBUG
//                                                    self.emailTextField.text = ""
//                                                    #endif
//
//            }
        }
        
    }
    
//    func encryptionLogin(){
//
//            emailTextField.text = "inspeerodev@gmail.com"
//            passwordTextField.text = "Qwerty123"
//
//
//
//    }
/*
     // Currenty we are not using this Login screen
     // Step 2 Login has been shifted to Otp Verfication screen
     
     
    func loginStep2(otp:String){
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .post,
                                            apiName: API.loginStep2,
                                            parameters: ["grant_type":"password",
                                                         "username":tempAuthToken,
                                                         "password":otp],
                                            headers: nil) { (response, error) in
                                                            MDHelper.shared.hideHudOnWindow()
                                                            if response != nil && error == nil{
                                                                self.handleLoginStep2Response(response: response!)
                                                            }else{
                                                                if  error != nil{
                                                                    MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                                }
                                                            }

        }
    }
 */
    
    @IBAction func scrollContentTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        tapCountToOpenSettingScreen = 0
    }
    
    //MARK: - Button Actions
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        performSegue(withIdentifier: "MDForgotPasswordVC", sender: nil)
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: MDSignUpVC.storyBoardID)
        self.present(signUpViewController!, animated: true, completion: nil)
    }
    @IBAction func skipLoginAction(_ sender: Any) {
        if let tabBar = self.presentingViewController as? MDHomeTabBarControllerViewController{
            tabBar.selectedIndex = 0
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK:- Handle response handler
    
    /// This will parse the data comes from Sign in step 1
    ///
    /// - Parameter response: Response will be the dictionary , Which will have tempAuthToken , twoFAMehtod & grantType required for Sign in step 2
    func handleLoginStep1Response(response:NSDictionary){
        print(response)
        if let data = response.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
            if let tempToken = data.valueForCaseInsensativeKey(forKey: "tempAuthToken") as? String{
                tempAuthToken = tempToken
                appDelegate.tempAuthToken = tempAuthToken
                appDelegate.grant_Type = data.valueForCaseInsensativeKey(forKey: "twoFAMehtod") as! String
                UserDefaults.standard.setValue(data.valueForCaseInsensativeKey(forKey: "twoFAMehtod") as! String, forKey: "grantType")
                let isDeviceVerificationRequired : Bool
                if data.valueForCaseInsensativeKey(forKey: "deviceVerificationRequired") as? Bool ?? false{
                    isDeviceVerificationRequired = true
                }else{
                    isDeviceVerificationRequired = false
                }
                self.performSegue(withIdentifier: "loginStep2", sender: isDeviceVerificationRequired)
                // showOTPAlert(twoFAMehtod:data.valueForCaseInsensativeKey(forKey: "twoFAMehtod") as! String)  // Step 2 temp Login
            }
        }
    }
    
    /*
    func handleLoginStep2Response(response:NSDictionary){
     
        if let error = response.valueForCaseInsensativeKey(forKey: "error") as? String , error != ""{
            MDHelper.shared.showErrorAlert(message: response.valueForCaseInsensativeKey(forKey: "error_description") as! String, viewController: self)
        }else{
            if let accessToken =  response.valueForCaseInsensativeKey(forKey: "access_token") as? String,let expireIn = response.valueForCaseInsensativeKey(forKey: "expires_in") as? Int,let tokenType = response.valueForCaseInsensativeKey(forKey: "token_type") as? String{
                appDelegate.accessToken = accessToken
                appDelegate.expiresIn = expireIn
                appDelegate.tokenType = tokenType
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let viewc = storyboard.instantiateViewController(withIdentifier: "baseTabBarNavigationController")
                self.present(viewc, animated: true, completion: nil)
                // self.performSegue(withIdentifier: loginSegue, sender: self)
                UserDefaults.standard.setValue(accessToken, forKey: "AccessToken")
                MDNetworkManager.shared.authToken = "Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as? String ?? "")"
                appDelegate.fetchCoinsInfo()
        
            }
            
        }
    }
    */
    
    //MARK: - Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField{
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
                loginButtonAction(loginButton)
        }
        return true
    }
    
    //MARK: - Navigation
    /// This will pass user email on the otp verification screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MDOTPVerification {
            let otpScreen = segue.destination as! MDOTPVerification
            let isDeviceVerificationRec = sender as! Bool
            otpScreen.userEmail = self.emailTextField.text!
            otpScreen.isDeviceVerificationRequired = isDeviceVerificationRec
            otpScreen.tokenType = .token
            otpScreen.deviceID = self.deviceID
        }
    }
    
    
    //MARK: - Gestures actions
    @IBAction func logoDoubleTapped(_ sender: Any) {
        tapCountToOpenSettingScreen = 2
         print("Double tap on logo")
    }
    @IBAction func logoTapped(_ sender: Any) {
        
        #if DEBUG
           // print("If debug falg is triggered and dorectly opening the settings")
           // self.performSegue(withIdentifier: openSettingsSegueId, sender: self)
           // return
        #endif
        
        print("Single tap on logo")
        if tapCountToOpenSettingScreen == 5{
            self.performSegue(withIdentifier: openSettingsSegueId, sender: self)
        }else{
             tapCountToOpenSettingScreen = tapCountToOpenSettingScreen + 1
        }
        print("TappCount: \(tapCountToOpenSettingScreen)")
    }
    
    @IBAction func bottomLeftCornerTapped(_ sender: Any) {
        
        if tapCountToOpenSettingScreen == 2{
            tapCountToOpenSettingScreen += 1
        }else{
            tapCountToOpenSettingScreen = 0
        }
         print("TappCount: \(tapCountToOpenSettingScreen)")
    }
    @IBAction func topRightCornerTapped(_ sender: Any) {
        print("topRight Corner tapped")
        if tapCountToOpenSettingScreen == 4{
            tapCountToOpenSettingScreen += 1
        }else{
            tapCountToOpenSettingScreen = 0
        }
        print("TappCount: \(tapCountToOpenSettingScreen)")
    }
}


    


