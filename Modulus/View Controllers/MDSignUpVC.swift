//
//  MDSignUpVC.swift
//  Modulus
//
//  Created by Pathik  on 22/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MaterialComponents.MaterialTabs
import IQKeyboardManagerSwift

class MDSignUpVC: UIViewController,UITextFieldDelegate {

    //MARK: - StoryBoard outlets
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
       @IBOutlet weak var middleNameTextField: SkyFloatingLabelTextField!
       @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var modulusLogo: UIImageView!
    @IBOutlet weak var passWordGuideLinesLabel: UILabel!
    @IBOutlet weak var countryCodeField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var requestMobileOtpView: UIView!  ///Hide it if "signup_mobile_verfication" is false
    @IBOutlet weak var requestOtpBtn: UIButton!
    @IBOutlet weak var otpTextField: SkyFloatingLabelTextField! ///Hide it if "signup_mobile_verfication" is false
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    @IBOutlet weak var referralCode: SkyFloatingLabelTextField!
    
    ///Layout Constraints
    @IBOutlet weak var countryCodeFieldWidthLC: NSLayoutConstraint!
    
    
    //MARK: - Variables
    var countryCode:NSNumber?
    var exampleNumber:NBPhoneNumber?
    var selectedCountry:NSDictionary?
     var bottomSheet : MDCBottomSheetController? = nil
    var countryId:String = ""
    
    //MARK: - Constants
    static let storyBoardID = "MDSignUpVC"
    let phoneUtil = NBPhoneNumberUtil()
    private let signup_mobile_verfication = ((UIApplication.shared.delegate) as! AppDelegate).signup_mobile_verfication
    
    //MARK: - Automation Identifiers
    func addAutomationIdentifiers(){
        emailTextField.accessibilityLabel       = "emailTextField"
        emailTextField.accessibilityValue       = "emailTextField"
        emailTextField.accessibilityIdentifier  = "emailTextField"
        
        nameTextField.accessibilityLabel        = "nameTextField"
        nameTextField.accessibilityValue        = "nameTextField"
        nameTextField.accessibilityIdentifier  = "nameTextField"
        
        countryTextField.accessibilityLabel         = "countryTextField"
        countryTextField.accessibilityValue         = "countryTextField"
        countryTextField.accessibilityIdentifier    = "countryTextField"
        
        mobileTextField.accessibilityLabel          = "mobileTextField"
        mobileTextField.accessibilityValue          = "mobileTextField"
        mobileTextField.accessibilityIdentifier     = "mobileTextField"
        
        otpTextField.accessibilityLabel = "otpTextField"
        otpTextField.accessibilityValue = "otpTextField"
        otpTextField.accessibilityIdentifier = "otpTextField"
        
        passwordTextField.accessibilityLabel        = "passwordTextField"
        passwordTextField.accessibilityValue        = "passwordTextField"
        passwordTextField.accessibilityIdentifier   = "passwordTextField"
        
        confirmPasswordTextField.accessibilityLabel         = "confirmPasswordTextField"
        confirmPasswordTextField.accessibilityValue         = "confirmPasswordTextField"
        confirmPasswordTextField.accessibilityIdentifier    = "confirmPasswordTextField"
        
        signUpButton.accessibilityLabel         = "signUpButton"
        signUpButton.accessibilityValue         = "signUpButton"
        signUpButton.accessibilityIdentifier    = "signUpButton"
        
        self.view.accessibilityIdentifier = "MDSignUVC"
    }

    private
    func initialSetUpSignUPVC(){
        self.requestMobileOtpView.isHidden = !self.signup_mobile_verfication
        self.otpTextField.isHidden = true
    }
    //MARK: - Set all titles
    private func setAllTextOnScreenWithLocalisation(){
        
        nameTextField.placeholder = localised("Name")
        nameTextField.selectedTitle = localised("Name")
        nameTextField.title = localised("Name")
        
        confirmPasswordTextField.placeholder = localised("Confirm Password")
        confirmPasswordTextField.selectedTitle = localised("Confirm Password")
        confirmPasswordTextField.title = localised("Confirm Password")
        
        emailTextField.placeholder = localised("Email")
        emailTextField.selectedTitle = localised("Email")
        emailTextField.title = localised("Email")
        
        mobileTextField.placeholder = localised("Mobile")
        mobileTextField.selectedTitle = localised("")
        mobileTextField.title = localised("")
        
        otpTextField.placeholder = localised("OTP")
        otpTextField.selectedTitle = localised("OTP")
        otpTextField.title = localised("OTP")
        
        
        passwordTextField.placeholder = localised("Password")
        passwordTextField.selectedTitle = localised("Password")
        passwordTextField.title = localised("Password")
        
        countryTextField.placeholder = localised("Country")
        countryTextField.selectedTitle = localised("Country")
        countryTextField.title = localised("Country")
        
        passWordGuideLinesLabel.text = localised("Password must be no less than 7 characters including  uppercase and lowercase letters")
        signUpButton.setTitle(localised("SIGN UP"), for: .normal)
        alreadyHaveAccountButton.setTitle(localised("Have an account already?  Log in"), for: .normal)
        
        middleNameTextField.placeholder = localised("Middle Name")
        middleNameTextField.selectedTitle = localised("Middle Name")
         middleNameTextField.title = localised("Middle Name")
        
        lastNameTextField.placeholder = localised("Last Name")
        lastNameTextField.selectedTitle = localised("Last Name")
         lastNameTextField.title = localised("Last Name")
        
        referralCode.placeholder = localised("Referral Code")
        referralCode.selectedTitle = localised("Referral Code")
        referralCode.title = localised("Referral Code")
        
        
        
    }
    //MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAutomationIdentifiers()
        self.setUpColors()
        self.setNavigationbar()
        self.reDesignTextFields()
        self.setAllTextOnScreenWithLocalisation()
        self.initialSetUpSignUPVC()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override func viewWillDisappear(_ animated: Bool) {
        TSMessage.dismissActiveNotification()
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.view.endEditing(true)
        if self.bottomSheet != nil && (self.presentedViewController as? MDCBottomSheetController)?.presentingViewController != nil{
            
            self.bottomSheet?.dismiss(animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showCurrencyDropDown()
            }
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    //MARK: - Screen Touch Delegates
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - UI Color Helpers
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.scrollContentView.backgroundColor = Theme.current.backgroundColor
        
        emailTextField.placeholderColor = Theme.current.subTitleColor
        emailTextField.titleColor = Theme.current.titleTextColor
        emailTextField.lineColor = Theme.current.subTitleColor
        emailTextField.selectedLineColor  = Theme.current.subTitleColor
        emailTextField.selectedTitleColor = Theme.current.subTitleColor
        emailTextField.textColor = Theme.current.titleTextColor

        
        nameTextField.placeholderColor = Theme.current.subTitleColor
        nameTextField.titleColor = Theme.current.titleTextColor
        nameTextField.lineColor = Theme.current.subTitleColor
        nameTextField.selectedLineColor  = Theme.current.subTitleColor
        nameTextField.selectedTitleColor = Theme.current.subTitleColor
        nameTextField.textColor = Theme.current.titleTextColor

        middleNameTextField.placeholderColor = Theme.current.subTitleColor
        middleNameTextField.titleColor = Theme.current.titleTextColor
        middleNameTextField.lineColor = Theme.current.subTitleColor
        middleNameTextField.selectedLineColor  = Theme.current.subTitleColor
        middleNameTextField.selectedTitleColor = Theme.current.subTitleColor
        middleNameTextField.textColor = Theme.current.titleTextColor

        lastNameTextField.placeholderColor = Theme.current.subTitleColor
        lastNameTextField.titleColor = Theme.current.titleTextColor
        lastNameTextField.lineColor = Theme.current.subTitleColor
        lastNameTextField.selectedLineColor  = Theme.current.subTitleColor
        lastNameTextField.selectedTitleColor = Theme.current.subTitleColor
        lastNameTextField.textColor = Theme.current.titleTextColor

        
        countryTextField.placeholderColor = Theme.current.subTitleColor
        countryTextField.titleColor = Theme.current.titleTextColor
        countryTextField.lineColor = Theme.current.subTitleColor
        countryTextField.selectedLineColor  = Theme.current.subTitleColor
        countryTextField.selectedTitleColor = Theme.current.subTitleColor
        countryTextField.textColor = Theme.current.titleTextColor

        
        mobileTextField.placeholderColor = Theme.current.subTitleColor
        mobileTextField.titleColor = Theme.current.titleTextColor
        mobileTextField.lineColor = Theme.current.subTitleColor
        mobileTextField.selectedLineColor  = Theme.current.subTitleColor
        mobileTextField.selectedTitleColor = Theme.current.subTitleColor
        mobileTextField.textColor = Theme.current.titleTextColor
        
        
        self.countryCodeField.titleColor = Theme.current.subTitleColor
        self.countryCodeField.titleColor = Theme.current.titleTextColor
        self.countryCodeField.lineColor = Theme.current.subTitleColor
        self.countryCodeField.selectedLineColor = Theme.current.subTitleColor
        self.countryCodeField.selectedTitleColor = Theme.current.subTitleColor
        self.countryCodeField.textColor = Theme.current.titleTextColor
        
        self.otpTextField.placeholderColor = Theme.current.subTitleColor
        self.otpTextField.titleColor = Theme.current.titleTextColor
        self.otpTextField.lineColor = Theme.current.subTitleColor
        self.otpTextField.selectedLineColor  = Theme.current.subTitleColor
        self.otpTextField.selectedTitleColor = Theme.current.subTitleColor
        self.otpTextField.textColor = Theme.current.titleTextColor
        
        self.requestOtpBtn.setTitle(localised("Request OTP"), for: .normal)
        self.requestOtpBtn.backgroundColor = Theme.current.primaryColor
        self.requestOtpBtn.setTitleColor(Theme.current.titleTextColor, for: .normal)
        self.requestOtpBtn.layer.cornerRadius = 5
        
        passwordTextField.placeholderColor = Theme.current.subTitleColor
        passwordTextField.titleColor = Theme.current.titleTextColor
        passwordTextField.lineColor = Theme.current.subTitleColor
        passwordTextField.selectedLineColor  = Theme.current.subTitleColor
        passwordTextField.selectedTitleColor = Theme.current.subTitleColor
        passwordTextField.textColor = Theme.current.titleTextColor

        
        confirmPasswordTextField.placeholderColor = Theme.current.subTitleColor
        confirmPasswordTextField.titleColor = Theme.current.titleTextColor
        confirmPasswordTextField.lineColor = Theme.current.subTitleColor
        confirmPasswordTextField.selectedLineColor  = Theme.current.subTitleColor
        confirmPasswordTextField.selectedTitleColor = Theme.current.subTitleColor
        confirmPasswordTextField.textColor = Theme.current.titleTextColor
        
        passWordGuideLinesLabel.textColor = Theme.current.titleTextColor
        modulusLogo.tintColor = Theme.current.primaryColor
        signUpButton.backgroundColor = Theme.current.primaryColor
        signUpButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        alreadyHaveAccountButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        
        referralCode.placeholderColor = Theme.current.subTitleColor
        referralCode.titleColor = Theme.current.titleTextColor
        referralCode.lineColor = Theme.current.subTitleColor
        referralCode.selectedLineColor  = Theme.current.subTitleColor
        referralCode.selectedTitleColor = Theme.current.subTitleColor
        referralCode.textColor = Theme.current.titleTextColor
    

    }

    //MARK: - Navigation bar Helpers
    func setNavigationbar(){
        self.navigationItem.backBarButtonItem?.title = ""
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = localised("Sign Up")
        self.navigationItem.titleView = label
    }
    
    //MARK: - Textfield  UI Helpers
    func reDesignTextFields() {

        emailTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "email")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.emailTextField.becomeFirstResponder()
        }
        passwordTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "padlock")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.passwordTextField.becomeFirstResponder()
        }
        confirmPasswordTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "padlock")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.passwordTextField.becomeFirstResponder()
        }
        
        countryCodeField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "telephone")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        
        
        
        countryCodeField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "telephone")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        countryTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "pin")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        
        countryTextField.addPaddingView(mode: .right,paddingWidthPercent:0.4, image: UIImage.init(named: "down-arrow")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)) { (button) in
            // print("eye clicked")
              self.countryTextField.becomeFirstResponder()
        }
        nameTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "avatar")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        middleNameTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "avatar")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        lastNameTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "avatar")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        referralCode.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "avatar")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)){ (button) in
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        passwordTextField.addPaddingView(mode: .right,paddingWidthPercent:0.4, image: UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)) { (button) in
            // print("eye clicked")
            
            if let rightView = self.passwordTextField.rightView as? UIButton {
                if !self.passwordTextField.isSecureTextEntry {
                    rightView.setImage(UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal), for: .normal)
                }else{
                    rightView.setImage( UIImage.init(named: "password-eye")!.imageWithColor(color1: Theme.current.titleTextColor).withRenderingMode(.alwaysOriginal), for: .normal)
                    
                }
            }
            self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        }
        confirmPasswordTextField.addPaddingView(mode: .right,paddingWidthPercent:0.4, image: UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal)) { (button) in
            // print("eye clicked")
            
            if let rightView = self.confirmPasswordTextField.rightView as? UIButton {
                if !self.confirmPasswordTextField.isSecureTextEntry {
                    rightView.setImage(UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.subTitleColor).withRenderingMode(.alwaysOriginal), for: .normal)
                }else{
                    rightView.setImage( UIImage.init(named: "password-eye")!.imageWithColor(color1: Theme.current.titleTextColor).withRenderingMode(.alwaysOriginal), for: .normal)
                    
                }
            }
            self.confirmPasswordTextField.isSecureTextEntry = !self.confirmPasswordTextField.isSecureTextEntry
        }
        
    }

    //MARK: - Button Actions
    @IBAction func signUpButtonAction(_ sender: UIButton) {
          self.view.endEditing(true)
        if self.validateTextFields() {
            MDHelper.shared.showHudOnWindow()
            
            var params = ["firstname": nameTextField.text!,
                          "middlename": middleNameTextField.text ?? "",
                          "lastname": lastNameTextField.text!,
                          "email":emailTextField.text!,
                          "country":(selectedCountry!["countryCode"] as? String ?? ""),
                          "mobile":mobileTextField.text!,
                          "password":passwordTextField.text!,
                          "referralId": referralCode.text ?? ""]
            
            if self.signup_mobile_verfication {
                params["mobileOTP"] = self.otpTextField.text!
            }
            
            MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                                methodType: .post,
                                                apiName: API.signUp,
                                                parameters: params as NSDictionary,
                                                headers: nil) { (response, error) in
                                                    //self.passwordTextField.text = ""
                                                    MDHelper.shared.hideHudOnWindow()
                                                    if response != nil && error == nil{
                                                        self.handleSignUpResponse(response: response!)
                                                    }else{
                                                        if  error != nil{
                                                            MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                        }
                                                    }
            }
        }
        
    }
    
    //MARK: - Response Handlers
    func handleSignUpResponse(response:NSDictionary)  {
        if MDNetworkManager.shared.isResponseSucced(response: response) {
            MDAlertMessageView.showMessagePopupViewOnWidnow(message: localised("Please complete the sign-up process by clicking on the link in your email inbox"), alertDelegate: self)
        }else{
            let message = response.value(forKey:"message" ) as? String ?? "null"
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
        }
        print(response)
    }
    
    //MARK: - Validations
    func validateTextFields() -> Bool {
        var result = false
        var message = ""
        if nameTextField.text != ""{
            if lastNameTextField.text != ""{
                if MDHelper.shared.isValidEmail(testStr: emailTextField.text!){
                    if countryTextField.text != ""{
                       
//                        if mobileTextField.text != ""{
                        
                            if isValidPhoneNumber(value: mobileTextField.text!) == true {
                                if passwordTextField.text != ""{
                                    if passwordTextField.text!.count >= 7 {
                                    if passwordTextField.text!.isValidPassword() {
                                        if confirmPasswordTextField.text != "" {
                                        if passwordTextField.text == confirmPasswordTextField.text {
                                            return true
                                        }else{
                                            result = false
                                            message = localised("Password and confirm password do not match")
                                        }
                                        }else{
                                            result = false
                                            message = localised("Please enter confirm password")
                                        }
                                    }else{
                                        result = false
                                        message = localised("Please enter valid password")
                                    }
                                    }else{
                                        result = false
                                        message = localised("Password must be no less than 7 characters")
                                    }
                                }else{
                                    result = false
                                    message = localised("Please enter password")
                                }
                            }else {
                                result = false
                                message = localised("Please enter valid mobile number")
                            }
//                        }else{
//                                result = false
//                                message = "Please enter mobile number"
//                        }
                        
                        }else{
                           result = false
                           message = localised("Please enter country")
                        }
                }else{
                    result = false
                    message = localised("Please enter valid email")
                }
            }else{
                result = false
                message = localised("Please enter last name")
            }
        }else{
            result = false
            message = localised("Please enter first name")
        }
        if message != "" {
            MDHelper.shared.showErrorAlert(message:message, viewController:self)
        }
        return result
    }
    
    //MARK: -  ScrollView Helpers
    @IBAction func scrollContentTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    //MARK:- Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case nameTextField:
            textField.resignFirstResponder()
            middleNameTextField.becomeFirstResponder()
        case middleNameTextField:
            textField.resignFirstResponder()
            self.lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            textField.resignFirstResponder()
            self.emailTextField.becomeFirstResponder()
        case emailTextField:
            textField.resignFirstResponder()
            self.showCurrencyDropDown()
        case passwordTextField:
            textField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            textField.resignFirstResponder()
            self.referralCode.becomeFirstResponder()
        case countryTextField:
            textField.resignFirstResponder()
            mobileTextField.becomeFirstResponder()
        case mobileTextField:
            textField.resignFirstResponder()
        default :
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField || textField == countryTextField{
            let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        if textField == mobileTextField{
            if string != "" {
                var numberText = textField.text!.replacingOccurrences(of: "+\((self.countryCode ?? 0)) ", with: "")
                    numberText = numberText + string
                    if let number = exampleNumber {
//                        if numberText.count > "\(number.nationalNumber!)".count {
//                            return false
//                    }
                }
            }
            if let text = textField.text,
                let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                if selectedCountry != nil{
                    if updatedText.contains("+\((countryCode ?? 0)) "){
                        
                    }else{
//                        return false
                    }
                }
            }
        }
        return true
    }
    
    fileprivate func showCurrencyDropDown() {
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
        let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
        dropDownVC.type = .countryCode
        dropDownVC.delegate = self
        dropDownVC.selectedCountry = countryTextField.text!
        dropDownVC.searchBarPlaceHolder = localised("Search Country")
        bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
        bottomSheet?.delegate = self
        bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: self.view.frame.size.height)
        present(bottomSheet!, animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
        if textField == confirmPasswordTextField {
            IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        }
        if textField == countryTextField{
            showCurrencyDropDown()
            return false
        }
        if textField == mobileTextField{
            if textField.text == ""{
                if selectedCountry != nil{
//                    mobileTextField.text = "+\((phoneUtil.getCountryCode(forRegion: selectedCountry?.value(forKey: "countryCode") as? String)!)) "
                }else{
                    MDHelper.shared.showErrorAlert(message: localised("Please select country"), viewController: self)
                    
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField ==  self.mobileTextField {
            self.countryCodeField.lineColor = Theme.current.subTitleColor
            self.countryCodeField.lineHeight = self.countryCodeField.selectedLineHeight
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField ==  self.mobileTextField {
            self.countryCodeField.lineColor = Theme.current.subTitleColor
            self.countryCodeField.lineHeight = self.mobileTextField.lineHeight
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
    
    //MARK: ---- Button Actions ----
    @IBAction func laredyHaveLoginAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestOTPAction(_ sender: UIButton) {
        guard let mobile = self.mobileTextField.text else{return}
        guard mobile != "" else {
            MDSnackBarHelper.shared.showSuccessMessage(message: "Mobile number field can't be empty" , duration: 2)
            return
        }
        guard mobile.count >= 10 else {
            MDSnackBarHelper.shared.showSuccessMessage(message: "Mobile Number Format Error" , duration: 2)
            return
        }
        
        let params : NSDictionary = NSDictionary(dictionary: ["country" : self.countryId , "mobile" : self.mobileTextField.text ?? ""])
        print("Parameters")
        print(params)
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .post,
                                            apiName: API.requestOTP,
                                            parameters: params as NSDictionary,
                                            headers: nil) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let response = response{
                if MDNetworkManager.shared.isResponseSucced(response: response) {
                    MDSnackBarHelper.shared.showSuccessMessage(message: "The OTP has been sent to your mobile number" , duration: 2)
                    self.otpTextField.isHidden = false
                }else{
                    let message = response.value(forKey:"message") as? String ?? "null"
                    MDHelper.shared.showErrorAlert(message: message, viewController: self)
                }
            }
        }
    }
    
}
extension String {
    public func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{7,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}


extension MDSignUpVC:customDropDownDelegates{
    
    func dropDownSelected(title: String, data: NSDictionary) {
        countryTextField.text = title
        selectedCountry = data
        self.countryId =  data.value(forKey: "countryCode") as? String ?? ""
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse("0000000000", defaultRegion: data.value(forKey: "countryCode") as? String)
            if phoneNumber.countryCode != nil {
                self.countryCodeFieldWidthLC.constant = 55
                let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .INTERNATIONAL)
                mobileTextField.text = ""
                
                if let subString = formattedString.split(separator: " ").first{
                    self.countryCodeField.text = String(subString)
                }
                let number = try phoneUtil.getExampleNumber(data.value(forKey: "countryCode") as? String)
                print(number)
                exampleNumber = number
                countryCode = (phoneUtil.getCountryCode(forRegion: selectedCountry?.value(forKey: "countryCode") as? String)!)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.bottomSheet = nil
    }
    func isValidPhoneNumber(value: String) -> Bool {
        guard self.signup_mobile_verfication else {return true}
        if let number = exampleNumber {
            let numberText = value.replacingOccurrences(of: "+\((countryCode ?? 0)) ", with: "")
            if numberText.replacingOccurrences(of: " ", with: "") == ""{
                return true
            }else{
                if numberText.count == "\(number.nationalNumber!)".count {
                    return true
                }
            }
        }
        return false
//        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
//        let result =  phoneTest.evaluate(with: value)
//        return result
    }
}

extension MDSignUpVC:alertPopupMessageDelegate{
    func alertPopupMessage(presedOk: Bool) {
        if presedOk == true{
         
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension MDSignUpVC : MDCBottomSheetControllerDelegate {
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        print(controller)
        self.bottomSheet = nil
    }
    
}
