//
//  MDSettingURLVC.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 18/12/18.
//  Copyright © 2018 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class MDSettingURLVC: UIViewController {

    @IBOutlet weak var urlTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var modulusLogo: UIImageView!
    @IBOutlet weak var refreshTheme: UIButton!
    @IBOutlet weak var webSocketURLTF: SkyFloatingLabelTextField!
    
    var tempSavedUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.text = String(API.baseURL)
        webSocketURLTF.text = String(API.webSocket_url)
        saveButtonState(enable: false)
        setNavigationBar()
        setUpColors()
        saveButton.setTitle(localised("SAVE").localizedUppercase, for: UIControl.State())
        refreshTheme.setTitle(localised("REFRESH THEME").localizedUppercase, for: UIControl.State())
        
        urlTextField.autocorrectionType = .no
        webSocketURLTF.autocorrectionType = .no
        
        
        urlTextField.keyboardType = .default
        webSocketURLTF.keyboardType = .default

    }
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            SocketHelper.shared.stopConnection()
            SocketHelper.shared.marketSummery = nil
            //SocketHelper.shared.connection = nil
        } else {
            // Fallback on earlier versions
        }
        
//        MDSignalRManager.shared.hub = nil
    }
    override func viewWillDisappear(_ animated: Bool) {
//         MDSignalRManager.shared.startDataConnectionWithoutLogin()
        
        if #available(iOS 13.0, *) {
            SocketHelper.shared.stopConnection()
            SocketHelper.shared.marketSummery = nil
        } else {
            // Fallback on earlier versions
        }
        //SocketHelper.shared.connection = nil
    }
    
    @objc func backButtonPressed(_ sender:Any){
        self.view.endEditing(true)
        if self.saveButton.isEnabled == false{
            self.navigationController?.popViewController(animated: true)
        }else{
             _ = MDAlertPopupView.showAlertPopupViewOnWidnow(title: localised("appTitle"), errorMessage: localised("Your changes will be discarded. Do you want to continue?"), alertDelegate: self)
        }
        
    }
    override func viewDidLayoutSubviews() {
        modulusLogo.tintColor = Theme.current.primaryColor
    }
    
    func setUpColors(){
        
        self.view.backgroundColor = Theme.current.backgroundColor
        
        
        modulusLogo.tintColor = Theme.current.primaryColor
        
        urlTextField.placeholderColor = Theme.current.subTitleColor
        urlTextField.titleColor = Theme.current.titleTextColor
        urlTextField.lineColor = Theme.current.subTitleColor
        urlTextField.selectedLineColor  = Theme.current.subTitleColor
        urlTextField.selectedTitleColor = Theme.current.subTitleColor
        urlTextField.textColor = Theme.current.titleTextColor
        
        saveButton.backgroundColor = Theme.current.primaryColor
        saveButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        
        refreshTheme.backgroundColor = Theme.current.primaryColor
        refreshTheme.setTitleColor(Theme.current.btnTextColor, for: .normal)
        
        webSocketURLTF.placeholderColor = Theme.current.subTitleColor
        webSocketURLTF.titleColor = Theme.current.titleTextColor
        webSocketURLTF.lineColor = Theme.current.subTitleColor
        webSocketURLTF.selectedLineColor  = Theme.current.subTitleColor
        webSocketURLTF.selectedTitleColor = Theme.current.subTitleColor
        webSocketURLTF.textColor = Theme.current.titleTextColor
        webSocketURLTF.tintColor = .red
        urlTextField.tintColor = .red
    }
    
    func setNavigationBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = UIFont.init(name: MDAppearance.Proxima_Nova.semiBold
            , size: 25)
        label.text = localised("Settings")
        self.navigationItem.titleView = label
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "Back"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(backButtonPressed(_:)))
        navigationItem.leftBarButtonItem = backBTN
        
//        self.navigationController?.navigationBar.layoutIfNeeded()
        
//        navigationController?.navigationBar.tintColor = Theme.current.titleTextColor
//        navigationController?.navigationBar.backgroundColor = Theme.current.navigationBarColor

//        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    @IBAction func refreshThemeAction(_ sender: Any) {
        MDHelper.shared.showHudOnWindow()
        UserDefaults.standard.removeObject(forKey: "themeFromServer")
//        MDNetworkManager.shared.fetchStyleSheetFromServer()
    }
    
    func shouldShowMessage()->Bool{
        if let navBar = UIApplication.shared.topMostViewController() as? UINavigationController{
            if let settingsVC = navBar.visibleViewController as? MDSettingURLVC{
                return true
            }
        }else if let _ = UIApplication.shared.topMostViewController() as? MDSettingURLVC{
            return true
        }
        return false
    }
    
    //MARK: - Button Actions
    @IBAction func saveButtonAction(_ sender: Any) {
        if (urlTextField.text?.count)! > 0{
            tempSavedUrl = urlTextField.text!
            if !tempSavedUrl.contains("https://"){
                tempSavedUrl = "https://\(urlTextField.text!)"
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.isConnectedToInternet() == true{
                saveButtonState(enable: false)
                MDHelper.shared.showHudOnWindow()
                if verifyUrl(urlString: tempSavedUrl) == true{
                    if #available(iOS 13.0, *) {
                        SocketHelper.shared.marketSummery = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            SocketHelper.shared.connectSocket()
                            MDHelper.shared.hideHudOnWindow()
                            UserDefaults.standard.setValue(self.tempSavedUrl, forKey: "baseURL")
                            
                            let webSocket = self.webSocketURLTF.text
                            UserDefaults.standard.setValue(webSocket, forKey: "ws_baseURL")
                            
                            API.baseURL = self.tempSavedUrl
                            MDHelper.shared.showSucessAlert(message: "\(self.tempSavedUrl)", viewController: self)
                        }
                    } else {
                        // Fallback on earlier versions
                        MDHelper.shared.hideHudOnWindow()
                    }
                    
                }else{
                    MDHelper.shared.hideHudOnWindow()
                    MDHelper.shared.showErrorAlert(message: localised("Invalid URL"), viewController: self)
                }
            }else{
                MDHelper.shared.hideHudOnWindow()
                MDHelper.shared.showErrorAlert(message: localised("The internet appears to be offline"), viewController: self)
                
            }
        }else{
            
        }
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }

    //MARK: -  Helper actions
    func saveButtonState(enable:Bool){
        if enable == true{
            saveButton.isEnabled = true;
            saveButton.alpha = 1.0;
        }else{
            saveButton.isEnabled = false;
            saveButton.alpha = 0.5;
        }
    }
    
}

extension MDSettingURLVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let changedString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if changedString.count == 0 ||
        changedString == API.baseURL ||
        changedString == tempSavedUrl ||
        changedString == String(API.baseURL.dropLast()) ||
        changedString == String(API.baseURL.dropFirst(8)) ||
        changedString == String(String(API.baseURL.dropFirst(8)).dropLast()){
            saveButtonState(enable: false)
        }else{
            saveButtonState(enable: true)
        }
        return true
    }
}


extension MDSettingURLVC:UINavigationBarDelegate,UINavigationControllerDelegate{
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return true
    }
}

extension MDSettingURLVC:alertPopupDelegate{
    func alertPopupResponse(isAgree: Bool) {
        if isAgree == true{
            self.saveButtonState(enable: false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
