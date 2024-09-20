//
//  MDForgotPasswordVC.swift
//  Modulus
//
//  Created by Pathik  on 24/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

open class MDForgotPasswordVC: UIViewController , UITextFieldDelegate {

    //MARK: - Outlets
    /// Outlet for forgot password button
    @IBOutlet weak var sendButton: UIButton!
    
    /// Outlet for Email textField
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var screenMainTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    /// StoryBoard Identifer for this view controller
    static let storyBoardID = "MDForgotPasswordVC"
    
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //MARK: - AUtomation identifer helpers
    func addAutomatioIdentifiers(){
        /// Automation Accesibility id
        emailTextField.accessibilityLabel = "emailTextField"
        emailTextField.accessibilityValue = "emailTextField"
        emailTextField.accessibilityIdentifier = "emailTextField"
        
        sendButton.accessibilityIdentifier = "sendButton"
        sendButton.accessibilityLabel = "sendButton"
        sendButton.accessibilityValue = "sendButton"
    }
    
    //MARK: - View Life cycles
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setUpColors()
        reDesignTextFields()
        addAutomatioIdentifiers()
        setAllTextOnScreenWithLocalisation()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        TSMessage.dismissActiveNotification()
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        emailTextField.delegate = self
    }
   
    //MARK: - Set all titles
    func setAllTextOnScreenWithLocalisation(){
        emailTextField.placeholder = localised("Please enter your email")
        sendButton.setTitle(localised("SEND VERIFICATION EMAIL"), for: .normal)
        screenMainTitle.text = localised("Forgot Password")
        emailTextField.selectedTitle = localised("Please enter your email")
        emailTextField.title = localised("Please enter your email")
    }
    
    //MARK: - Ui Helpers
    func setUpColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        bgView.backgroundColor = Theme.current.backgroundColor
        screenMainTitle.textColor = Theme.current.titleTextColor
        sendButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        sendButton.backgroundColor = Theme.current.primaryColor
        
        emailTextField.placeholderColor = Theme.current.subTitleColor
        emailTextField.titleColor = Theme.current.titleTextColor
        emailTextField.lineColor = Theme.current.subTitleColor
        emailTextField.selectedLineColor  = Theme.current.subTitleColor
        emailTextField.selectedTitleColor = Theme.current.subTitleColor
        emailTextField.textColor = Theme.current.titleTextColor
        
    }
    
    /// This will Help to redesign Textfield Ui from default to cusstom
    func reDesignTextFields() {
        emailTextField.addPaddingView(mode: .left,paddingWidthPercent:0.5 , image: UIImage.init(named: "email")!.imageWithColor(color1: Theme.current.textFieldIconsTintColorInActive).withRenderingMode(.alwaysOriginal)){ (button) in
            self.emailTextField.becomeFirstResponder()
        }
    }
    
    //MARK: - Network response Handlers
    
    /**
     This will handle response of forgot password api call
     - parameter response: Api response for parsing
     - returns:
     */
    func handleForgotPasswordResponse(response:NSDictionary)  {
        if MDNetworkManager.shared.isResponseSucced(response: response) {
           MDAlertMessageView.showMessagePopupViewOnWidnow(message: localised("please check your inbox for password reset link"), alertDelegate: self)
        }else{
            let message = response.valueForCaseInsensativeKey(forKey:"Message" ) as? String ?? "null"//{
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
        }
    }
    
    //MARK: - Validation helpers
    /**
     This will check if entered input is valid or not (Checking enetered email is valid or not)
     - parameter :
     - returns: If Entered input values are in required format this will return a boolean Value to indicate
     */
    func validateTextFields() -> Bool {
        if MDHelper.shared.isValidEmail(testStr: emailTextField.text!){
                return true
        }else{
//            MDHelper.shared.showErrorAlert(message: "Invalid URL", viewController: self)
            MDHelper.shared.showErrorAlert(message:localised("Please enter valid email"), viewController:self)
            return false
        }
    }
    

    //MARK: - Scrollview Helper
    @IBAction func scrollContentTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    //MARK: - Textfield Delegates
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    //MARK: - Forgot password button action
    /// Forgot password Api request will send after required validations
    @IBAction func sendButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.validateTextFields() {
            MDHelper.shared.showHudOnWindow()
            let params = ["email":emailTextField.text!]
            MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                                methodType: .post,
                                                apiName: API.forgotPassword,
                                                parameters: params as NSDictionary,
                                                headers: nil) { (response, error) in
                                                    
                                                    MDHelper.shared.hideHudOnWindow()
                                                    if response != nil && error == nil{
                                                        self.handleForgotPasswordResponse(response: response!)
                                                    }else{
                                                        if  error != nil{
                                                            MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                        }
                                                    }
            }
        }
    }
}


extension MDForgotPasswordVC:alertPopupMessageDelegate{
    func alertPopupMessage(presedOk: Bool) {
        if presedOk == true {
            self.emailTextField.text = ""
            self.navigationController?.popViewController(animated: true)
        }
    }
}
