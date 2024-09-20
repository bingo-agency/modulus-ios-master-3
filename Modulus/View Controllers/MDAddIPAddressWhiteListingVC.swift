//
//  MDAddIPAddressWhiteListingVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/20/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import DropDown

class MDAddIPAddressWhiteListingVC: UIViewController {

    @IBOutlet weak var textfield_Currency: UITextField!
    @IBOutlet weak var textfield_Address: UITextField!
    @IBOutlet weak var textfield_Tag: UITextField!
    @IBOutlet weak var textfield_GoogleCode: UITextField!
    @IBOutlet weak var textfield_Label: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var currnecyStaticLbl: UILabel!
    @IBOutlet weak var arrow1: UIImageView!
    
    @IBOutlet weak var labelStaticLabel: UILabel!
    @IBOutlet weak var addressStaticLbl: UILabel!
    @IBOutlet weak var googleAuthView: UIView!
    @IBOutlet weak var googleAuthStaticLbl: UILabel!
    
    private var isGoogle2faEnabled: Bool = false
    
    var strSource : [CoinsData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegate()
        self.getcurrencySetting()
        self.shouldConfrimButtonEnable()
        self.setupColors()
        self.setLocalisedLabel()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    
    private func
    setLocalisedLabel(){
        self.currnecyStaticLbl.text = localised("Currency")
        
        self.labelStaticLabel.text = localised("Label")
        
        self.addressStaticLbl.text = localised("Address")
        
        self.googleAuthStaticLbl.text = localised("Google Authenticator Code")
    }
    
    private
    func setupColors(){
        self.bgView.backgroundColor = Theme.current.navigationBarColor
        self.currnecyStaticLbl.textColor = Theme.current.titleTextColor
        self.labelStaticLabel.textColor = self.currnecyStaticLbl.textColor
        self.addressStaticLbl.textColor = self.currnecyStaticLbl.textColor
        self.googleAuthStaticLbl.textColor = self.currnecyStaticLbl.textColor
        
        self.arrow1.tintColor = self.currnecyStaticLbl.textColor
        
        self.textfield_Currency.textColor = self.currnecyStaticLbl.textColor
        
        self.textfield_Currency.placeholder = localised("Select")
        
        self.textfield_Currency.placeHolderColorCustom = Theme.current.subTitleColor
        
        self.textfield_Label.textColor = self.currnecyStaticLbl.textColor
        self.textfield_Label.placeholder = ""
        
        
        self.textfield_Address.textColor = self.currnecyStaticLbl.textColor
        self.textfield_Address.placeholder = ""
        
        self.textfield_GoogleCode.textColor = self.currnecyStaticLbl.textColor
        self.textfield_GoogleCode.placeholder = ""
        
        self.btn_submit.setTitleColor(Theme.current.btnTextColor, for: .normal)
        
        self.btn_submit.backgroundColor = Theme.current.primaryColor
        
    }
    
    private
    func setUpUI(){
        if let twoFactorEnabled = UserDefaults.standard.value(forKey: "is2FAEnabled") as? Bool {
            self.googleAuthView.isHidden = !twoFactorEnabled
            self.isGoogle2faEnabled = !twoFactorEnabled
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setDelegate(){
        self.textfield_Currency.delegate = self
        self.textfield_Address.delegate = self
        self.textfield_Tag.delegate = self
        self.textfield_GoogleCode.delegate = self
        self.textfield_Label.delegate = self
    }
    func shouldConfrimButtonEnable(){

    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btn_submitAction(_ sender: Any) {
        self.submitIPadd()
        
    }
    
    func validateTextFields() -> Bool{
        if self.textfield_Currency.text?.replacingOccurrences(of: " ", with: "") == ""{
            let  message = localised("Please enter currency")
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
            return false
        }
        if self.textfield_Label.text?.replacingOccurrences(of: " ", with: "") == ""{
            let  message = localised("Please enter label name")
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
            return false
        }
        if self.textfield_Address.text?.replacingOccurrences(of: " ", with: "") == ""{
            let  message = localised("Please enter address")
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
            return false
        }
        if self.isGoogle2faEnabled {
            if self.textfield_GoogleCode.text?.replacingOccurrences(of: " ", with: "") == ""{
                let  message = localised("Please enter Google Auth code")
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
        }
        return true
    }
    
    private func submitIPadd(){
        
        if !self.validateTextFields(){
            return
        }
        
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
                    ]
        
        let data = self.strSource.first { (data) -> Bool in
            return textfield_Currency.text == data.str
        }?.data ?? [:]
        
        let currency = String(self.textfield_Currency.text?.split(separator: "(").last ?? "").split(separator: ")").first ?? ""
        
        let parameters = [
            "Currency":currency,
            "Label":self.textfield_Label.text ?? "",
            "Address":self.textfield_Address.text ?? "",
            "gauth_code":self.textfield_GoogleCode.text ?? "" , "DT_Memo":""
        ] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName:API.Add_AddressBook, parameters: parameters as NSDictionary, headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if response != nil && error == nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String ?? ""
                    MDHelper.shared.showSucessAlert(message: message, viewController: self)
                    self.dismiss(animated: true, completion: nil)
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
    @IBAction func btn_dropDownAction(_ sender: Any) {
        self.showDropDown(anchorView: self.textfield_Currency, source: [""])
    }
    func showDropDown(anchorView : UIView,source : [String]){
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.direction = .bottom
        dropDown.dataSource = self.strSource.map({$0.str})
        dropDown.width = self.textfield_Label.frame.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.textfield_Currency.text = item
        }
        dropDown.show()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK: API Call
extension MDAddIPAddressWhiteListingVC {
    func getcurrencySetting(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        self.strSource = appdelegate.coinsInfo.map({ (dict) -> CoinsData in
            let data = dict as? [String:Any] ?? [:]
           return CoinsData(str: "\(data["fullName"] as? String ?? "") (\(data["shortName"] as? String ?? ""))", data: data)
        })
    }
}
//MARK: UITexfield Delegate
extension MDAddIPAddressWhiteListingVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textfield_Currency {
            self.btn_dropDownAction(self)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.shouldConfrimButtonEnable()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textfield_Currency {
            return false
        }
        self.shouldConfrimButtonEnable()
        return true
    }
}
struct CoinsData{
    var str : String
    var data :[String:Any]
}
