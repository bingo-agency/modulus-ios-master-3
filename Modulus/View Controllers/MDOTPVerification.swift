//
//  MDOTPVerification.swift
//  Modulus
//
//  Created by Pathik  on 27/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
enum OTPScreenType {
    case loginOTP
    case forgotPasswordOTP
    case withdrawOTP
}

enum DeviceType{
    case token
    case tokenWithOTP
}

class MDOTPVerification: UIViewController {
    
    //MARK: - StoryBoard Outlets
    @IBOutlet weak var textFieldsStackView: UIStackView!
    @IBOutlet weak var otpTextLabel: UILabel!
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var mobileIcon: UIImageView!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var fourth: UITextField!
    @IBOutlet weak var resendOTPText: UILabel!
    @IBOutlet weak var resendOTPButton: UIButton!
    @IBOutlet weak var clickHereToGetOneBtn: UIButton!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sendAgainOTPAttributedText: UILabel!
    var isDeviceVerificationRequired : Bool = false
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var googleCodeTextfield: customPlaceHolderTextField!
    @IBOutlet weak var otpTextField: customPlaceHolderTextField!
    @IBOutlet weak var deviceOTPView: UIView!
    
    //MARK: - Constants
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let notification_name:Notification.Name = Notification.Name(rawValue: "Login_BroadcastNotification")
    
    //MARK: - Variables
    var tempAuthToken = ""
    var userEmail = ""
    var optScreenType = OTPScreenType.loginOTP
    var activeTextField : UITextField? = nil
    var tokenType : DeviceType = .token
    var deviceID = ""
    
    //MARK: - Navigation bar helpers
    func setNavigationBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = UIFont.init(name: MDAppearance.Proxima_Nova.semiBold
            , size: 25)
        label.text = localised("Security Verification")
        self.navigationItem.titleView = label
    }
    
    //MARK: - Automation Identifiers
    func addAutomationIdentifiers(){
        submitButton.accessibilityIdentifier = "submitOtp"
        self.view.accessibilityIdentifier = "otpVerificationScreen"
    }
    
    //MARK: - Keyboard Helpers
    func addCustomiseKeyboard(){
        let textFieldArray:NSMutableArray = NSMutableArray()
        
        for view in textFieldsStackView.arrangedSubviews{
            let textField  = view.subviews.filter { (nView) -> Bool in
                nView is UITextField
                }.first as! UITextField
            
            textField.accessibilityLabel         = "otp"
            textField.accessibilityValue         = "otp"
            textField.accessibilityIdentifier    = "otp"
            textFieldArray.add(textField)
            
        }
        for text in textFieldArray  {
            let textField = text as! UITextField
            textField.disableSuggestionsAndAutoCorrect()
            textField.textColor = Theme.current.titleTextColor
//            textField.inputAccessoryView = customizeKeyboardView()
        }
    }
    
    //MARK: - Intial Data & UI Helpers
    /// This will decide whether we have to show Resend otp option or not
    /// If user has Google authenticator enabled , We have to hide resendOTP option
    func setUpUI(){
        self.deviceOTPView.isHidden = self.isDeviceVerificationRequired == false ? true : false
        self.resendOTPButton.isHidden = true
        self.resendOTPText.isHidden = true
        if optScreenType == OTPScreenType.loginOTP{
            self.otpTextLabel.text = localised("Get a verification code from 'Google Authenticator' app")
            if let grandType = UserDefaults.standard.value(forKey: "grantType") as? String{
                if grandType.lowercased().contains("email"){
                    self.resendOTPButton.isHidden = false
                    self.resendOTPText.isHidden = false
                    self.otpTextLabel.text = localised("Please enter the One Time Password (OTP) which was sent to")+" \(userEmail)"
                }
            }
        }else if optScreenType == OTPScreenType.withdrawOTP{
            var userEmail = "xxx@yyy.zz"
            if let profile = UserDefaults.standard.value(forKey: "profile") as? NSDictionary {
                if let email = profile.valueForCaseInsensativeKey(forKey: "email") as? String {
                    userEmail = email
                }
            }
            self.otpTextLabel.text = localised("Please enter the One Time Password (OTP) which was sent to") + "\(userEmail)"
        }
         submitButton.setTitle(localised("SUBMIT"), for: .normal)
    }
    
    func setupColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        mobileIcon.tintColor = Theme.current.titleTextColor
        self.otpTextLabel.textColor = Theme.current.titleTextColor
        underLine.backgroundColor = Theme.current.subTitleColor
        bgView.backgroundColor = Theme.current.backgroundColor
        submitButton.backgroundColor = Theme.current.primaryColor
        submitButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        self.clickHereToGetOneBtn.setTitleColor(Theme.current.primaryColor, for: .normal)
        
        
         let fontAttribute = [ NSAttributedString.Key.font:UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 14)]
            let receiveOtp = localised("Didn't Receive OTP ?")
            let sendAgainText = localised(" Send again")
            let attributedString = receiveOtp+sendAgainText
            var myMutableString = NSMutableAttributedString(string: attributedString)
                
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.current.titleTextColor, range: NSRange(location:0,length:receiveOtp.count))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.current.primaryColor, range: NSRange(location:receiveOtp.count,length:sendAgainText.count))
        //        resenOTPLabel.attributedText = myMutableString
            sendAgainOTPAttributedText.attributedText = myMutableString
    }
    
    //MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
        addAutomationIdentifiers()
        addCustomiseKeyboard()
        setUpUI()
        
        if #available(iOS 13.0, *) {
           // SocketHelper.shared.stopConnection()
            //SocketHelper.shared.marketSummery = nil
            //SocketHelper.shared.connection = nil
        } else {
            // Fallback on earlier versions
        }
        
//        setupColors()

    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        addActionToTextFields()
        setupColors()
    }
    
    //MARK: - Textfield Helpers
    
    /// This will add action add delegates & actions for every textFields
    func addActionToTextFields(){
        for view in textFieldsStackView.arrangedSubviews{
            let textField  = view.subviews.filter { (nView) -> Bool in
                nView is UITextField
                }.first as! UITextField
            setPlaceHolder(textField: textField)
            textField.textColor = Theme.current.titleTextColor
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        }
    }
    
    /// This will show placeHolders on textField
    func setPlaceHolder(textField:UITextField){
        var placeHolder = NSMutableAttributedString()
        let Name  = ""
        placeHolder = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: MDAppearance.Proxima_Nova.regular, size: 24.0)!])
        // Set the color
        placeHolder.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range:NSRange(location:0,length:Name.count))
        // Add attribute
        textField.attributedPlaceholder = placeHolder
    }
    
    //MARK: - Button Actions
    /// This will perform api call of resent OTP & parse the response
    @IBAction func resendOTPButtonAction(_ sender: Any) {
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: (API.resendOTP + "/\(appDelegate.tempAuthToken)"), parameters: nil, headers: nil) { (response, error) in
            if response != nil && error == nil{
                MDHelper.shared.hideHudOnWindow()
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    MDHelper.shared.showSucessAlert(message: localised("OTP has been successfully sent"), viewController: self)
                }else{
                    if let message = response?.valueForCaseInsensativeKey(forKey: "message") as? String{
                        MDHelper.shared.showErrorAlert(message: message, viewController: self)
                    }
                }
            }else{
                if error != nil{
                    MDHelper.shared.showErrorAlert(message: error?.localizedDescription ?? "Error", viewController: self)
                }
            }
        }
    }
    
    @IBAction func getDeviceOTP(_ sender: Any) {
        
        self.getDeviceOTP()
        
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        
        if appDelegate.byPassLogin == true{
            /*
             * By pass login due to server is not stable
             */
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewc = storyboard.instantiateViewController(withIdentifier: "baseTabBarNavigationController")
            self.present(viewc, animated: true, completion: nil)
            UserDefaults.standard.setValue("", forKey: "AccessToken")
            MDNetworkManager.shared.authToken = "Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as? String ?? "")"
            return
        }
        
        
        var otp = self.googleCodeTextfield.text ?? ""
//        for view in textFieldsStackView.arrangedSubviews{
//            let textField  = view.subviews.filter { (nView) -> Bool in
//                nView is UITextField
//                }.first as! UITextField
//
//            #if DEBUG
//            if textField.text == "" {
//                textField.text = "999888"
//            }
//            #endif
//
//            otp = otp + textField.text!
//
//        }
        if self.isDeviceVerificationRequired{
            if otp == "" || (self.otpTextField.text ?? "") == ""{
                MDHelper.shared.showErrorAlert(message: localised("Please Enter OTP"), viewController: self)
            }else {
                loginStep2(otp: otp)
            }
            
        }else{
            
            if otp == "" {
                MDHelper.shared.showErrorAlert(message: localised("Please Enter OTP"), viewController: self)
            }else {
                loginStep2(otp: otp)
            }
        }
        
    }
    //MARK: - Input validations
    func validateInputs(){
            var otp = ""
            for view in textFieldsStackView.arrangedSubviews{
                let textField  = view.subviews.filter { (nView) -> Bool in
                    nView is UITextField
                    }.first as! UITextField
                otp = otp + textField.text!
                
            }
            loginStep2(otp: otp)
        
    }
    
    //MARK: - API Calls
    func getDeviceOTP(){
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .post,
                                            apiName: API.Request_Device_Verification_OTP,
                                            parameters: ["email": self.userEmail,
                                                         "dvc_id":self.deviceID], headers: [:]) { (response, error) in
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        MDHelper.shared.showSucessAlert(message: localised("Success! Check your email for the one time password"), viewController: self)
                                                    }else{
                                                        let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String ?? "Error occured"
                                                          MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                    }
                                                }else{
                                                    if  error != nil{
                                                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                    }
                                                }

        }
        
    }
    
    
    /// This will perform api call for submit OTP
    func loginStep2(otp:String){
        MDHelper.shared.showHudOnWindow()
        var apiName = ""
        var params = ["":""]
        let baseURL = API.baseURL
//        var headers : NSDictionary? = nil
        var headers = [
            "Accept" : "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
            
                    ] as NSDictionary
        
        if optScreenType == OTPScreenType.loginOTP {
            apiName = API.loginStep2 + "/v2"
            if self.isDeviceVerificationRequired{
                params = ["grant_type":"password",
                          "username":appDelegate.tempAuthToken,
                          "password":otp,
                          "dvc_otp":self.otpTextField.text ?? "",
                          "dvc_id":self.deviceID]
            }else{
                params = ["grant_type":"password",
                          "username":appDelegate.tempAuthToken,
                          "password":otp,
                          "dvc_id":self.deviceID]
            }
            
        }else if optScreenType == OTPScreenType.withdrawOTP {
            apiName = API.requestWithdrawConfirmation
            params = ["EmailToken":otp
                ,"timestamp": "\(MDNetworkManager.shared.getCurrentTimeStamp())"
                ,"recvWindow": "10"]
            headers = NSDictionary.init(dictionary: ["Authorization":MDNetworkManager.shared.authToken,
                                                     "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any])
        }
        
        MDNetworkManager.shared.sendRequest(baseUrl:baseURL,
                                            methodType: .post,
                                            apiName:apiName ,
                                            parameters: params as NSDictionary,
                                            headers: headers,encoding: MDNetworkManager.urlEncoding) { (response, error) in
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
    
    
    //MARK: - Response Handlers
    
    /// This will parse OTP verification API call response
    /// If OTP validation is successfull it will redirect use to Market Summery
    func handleLoginStep2Response(response:NSDictionary){
        
        
        
        if let errorDisc = response.valueForCaseInsensativeKey(forKey: "error_description") as? String{
            for view in textFieldsStackView.arrangedSubviews{
                let textField  = view.subviews.filter { (nView) -> Bool in
                    nView is UITextField
                    }.first as! UITextField
                textField.text = ""
            }
             MDHelper.shared.showErrorAlert(message: errorDisc, viewController: self)
        }else if let error = response.valueForCaseInsensativeKey(forKey: "error") as? String , error != ""{
            for view in textFieldsStackView.arrangedSubviews{
                let textField  = view.subviews.filter { (nView) -> Bool in
                    nView is UITextField
                    }.first as! UITextField
                textField.text = ""
            }
            MDHelper.shared.showErrorAlert(message: response.valueForCaseInsensativeKey(forKey: "error") as! String, viewController: self)
        }else{
            if optScreenType == OTPScreenType.loginOTP {
                loginOtpHandling(response: response)
            }else if optScreenType == OTPScreenType.withdrawOTP{
                
            }
        }
    }
    
    func withdrawalOtpHandling(response: NSDictionary)  {
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
            appDelegate.fetchProfile()
            if #available(iOS 13.0, *) {
                //SocketHelper.shared.stopConnection()
                //SocketHelper.shared.connectSocket()
            } else {
                // Fallback on earlier versions
            }
            //MDSignalRManager.shared.startDataConnectionWithoutLogin()
             appDelegate.getListOfMarket()
        }
    }
    
    //MARK: ---------- Handle Login Otp After Subitting Auth Code / OTP
    func loginOtpHandling(response: NSDictionary)  {
        if let accessToken =  response.valueForCaseInsensativeKey(forKey: "access_token") as? String,let expireIn = response.valueForCaseInsensativeKey(forKey: "expires_in") as? Int,let tokenType = response.valueForCaseInsensativeKey(forKey: "token_type") as? String{
            appDelegate.accessToken = accessToken
            appDelegate.expiresIn = expireIn
            appDelegate.tokenType = tokenType
            appDelegate.fetchCurrencySettings()
            
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            let viewc = storyboard.instantiateViewController(withIdentifier: "baseTabBarNavigationController")
//
//
//            self.present(viewc, animated: true, completion: nil)
            UserDefaults.standard.setValue(accessToken, forKey: "AccessToken")
            
            MDNetworkManager.shared.authToken = "Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as? String ?? "")"
            //appDelegate.fetchCoinsInfo()
            appDelegate.fetchProfile(isFromWithoutLogin: true)
            print("########### Login Success ###########")
            NotificationCenter.default.post(Notification.init(name:Notification.Name(rawValue: "userLoggedIn") ))
            UserDefaults.standard.removeAllFav()
            
        }
    }
    
    
    //MARK: - TextField action
    @objc func textFieldDidChange(textField: UITextField){
        
//        let text = textField.text
//
//        let textFieldArray:NSMutableArray = NSMutableArray()
//
//        for view in textFieldsStackView.arrangedSubviews{
//            let textField  = view.subviews.filter { (nView) -> Bool in
//                nView is UITextField
//                }.first as! UITextField
//            textFieldArray.add(textField)
//
//        }
//        if (text?.utf16.count)! >= 1{
//            let index = textFieldArray.index(of: textField)
//            if index < (textFieldArray.count - 1){
//                (textFieldArray.object(at: index + 1) as! UITextField).becomeFirstResponder()
//            }else{
//                textField.resignFirstResponder()
//            }
//        }else{
//
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Customised Keyboard
    func customizeKeyboardView() -> UIView{
        let buttonTitles = ["0", "1", "2", "3", "4", "5","6", "7", "8", "9"]
        let buttons = createButtons(buttonTitles)
        let topRow = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 40))///CGRectMake(0, 0, 320, 40))
        
        for button in buttons {
            topRow.addSubview(button)
        }
        
        
        
        addConstraints(buttons, containingView: topRow)
        return topRow
    }
    
    func createButtons(_ titles: [String]) -> [UIButton] {
        
        var buttons = [UIButton]()
        
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 15)
            button.addTargetClosure { (button) in
                print("")
                if let  title = button.currentTitle{
                    if let active = self.activeTextField {
//                        if (active.text?.count)! > 5 {
//
//                        }else {
                            active.text =   active.text! + title
//                        }
                      
//                        let textFieldArray:NSMutableArray = NSMutableArray()
//
//                        for view in self.textFieldsStackView.arrangedSubviews{
//                            let textField  = view.subviews.filter { (nView) -> Bool in
//                                nView is UITextField
//                                }.first as! UITextField
//                            textFieldArray.add(textField)
//
//                        }
//                         let index = textFieldArray.index(of: active)
//                        if index < (textFieldArray.count - 1){
//                            (textFieldArray.object(at: index + 1) as! UITextField).becomeFirstResponder()
//                        }else{
//                            active.resignFirstResponder()
//                        }
                    }
                  
                }
            }
            buttons.append(button)
        }
        
        return buttons
    }
    
    func addConstraints(_ buttons: [UIButton], containingView: UIView){
        
        for (index, button) in buttons.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: containingView, attribute: .top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: containingView, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            let leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1.0, constant: 0)
                
            }else{
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: buttons[index-1], attribute: .right, multiplier: 1.0, constant: 0)
                
                let widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                
                containingView.addConstraint(widthConstraint)
            }
            
            let rightConstraint : NSLayoutConstraint!
            if index == buttons.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: containingView, attribute: .right, multiplier: 1.0, constant:0)
                
            }else{
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: buttons[index+1], attribute: .left, multiplier: 1.0, constant: 0)
            }
            
            containingView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
}

extension MDOTPVerification: UITextFieldDelegate{
   

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        setPlaceHolder(textField: textField)
        activeTextField = textField
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if (textField.text?.count)! > 5 && string != ""{
//            return false
//        }
        
//        if string == ""{
//            let text = textField.text
//
//            let textFieldArray:NSMutableArray = NSMutableArray()
//
//            for view in textFieldsStackView.arrangedSubviews{
//                let textField  = view.subviews.filter { (nView) -> Bool in
//                    nView is UITextField
//                    }.first as! UITextField
//                textFieldArray.add(textField)
//
//            }
//            if (text?.utf16.count)! <= 0{
//                let index = textFieldArray.index(of: textField) - 1
//
//                if index >= 0{
//                    (textFieldArray.object(at:index) as! UITextField).becomeFirstResponder()
//                }else{
//                    textField.resignFirstResponder()
//                }
//            }else{
//
//            }
//        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
}

class customPlaceHolderTextField:UITextField{
//    override func layoutSubviews() {
//        var placeHolder = NSMutableAttributedString()
//        let Name  = "●"
//        //            textField.placeholder = "●"
//        // Set the Font
//        placeHolder = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: MDAppearance.Proxima_Nova.regular, size: 24.0)!])
//        
//        // Set the color
//        placeHolder.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range:NSRange(location:0,length:Name.characters.count))
//        
//        // Add attribute
//        self.attributedPlaceholder = placeHolder
//    }
//    override func deleteBackward() {
//        super.deleteBackward()
//
//       // _ = delegate?.textField?(self, shouldChangeCharactersIn: NSMakeRange(0, 0), replacementString: "")
//    }
}
