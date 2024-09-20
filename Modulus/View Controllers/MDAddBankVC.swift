//
//  MDAddBankVC.swift
//  Modulus
//
//  Created by Pranay on 22/10/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift


class MDAddBankVC: UIViewController {
    
    let bankType = ["Savings","Checking"]
    
    @IBOutlet weak var topView: UIViewX!
    @IBOutlet weak var addBankView: UIScrollView!
    @IBOutlet weak var addBankContentView: UIView!
    @IBOutlet weak var banksTable: UITableView!
    @IBOutlet weak var saveYourBankAccStaticLbl: UILabel!
    @IBOutlet weak var addBanksBtn: UIButton!
    
    @IBOutlet weak var accCurrencyStaticLbl: UILabel!
    @IBOutlet weak var accCurrencyTF: UITextField!
    
    @IBOutlet weak var accTypeStaticLbl: UILabel!
    @IBOutlet weak var accTypeTF: UITextField!
    
    @IBOutlet weak var accNumberStaticLbl: UILabel!
    @IBOutlet weak var accNumTF: UITextField!
    
    @IBOutlet weak var bankNameStaticLbl: UILabel!
    @IBOutlet weak var bankNameTF: UITextField!
    
    @IBOutlet weak var banckRCStaticLbl: UILabel!
    @IBOutlet weak var bankCodeTF: UITextField!
    
    @IBOutlet weak var swiftCodeStaticLbl: UILabel!
    @IBOutlet weak var swiftCodeTF: UITextField!
    
    @IBOutlet weak var gAuthStaticLbl: UILabel!
    @IBOutlet weak var gAuthTF: UITextField!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var gAuthView: UIView!
    
    var selected_bank :Currency?
    var list_arry : [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        self.getBanksList()
        self.setupColors()
//        self.keyboardNotifications()
    }
    
    private
    func setupColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        
        self.saveYourBankAccStaticLbl.textColor = Theme.current.titleTextColor
        self.addBanksBtn.setTitleColor(Theme.current.btnTextColor,
                                       for: .normal)
        
        self.accCurrencyStaticLbl.textColor = self.saveYourBankAccStaticLbl.textColor
        self.accTypeStaticLbl.textColor = self.saveYourBankAccStaticLbl.textColor
        self.accNumberStaticLbl.textColor = self.saveYourBankAccStaticLbl.textColor
        self.bankNameStaticLbl.textColor = self.saveYourBankAccStaticLbl.textColor
        self.swiftCodeStaticLbl.textColor = self.saveYourBankAccStaticLbl.textColor
        self.gAuthStaticLbl.textColor = self.saveYourBankAccStaticLbl.textColor
        self.banckRCStaticLbl.textColor = self.saveYourBankAccStaticLbl.textColor
        self.btn_submit.setTitleColor(Theme.current.btnTextColor,
                                      for: .normal)
        
        self.btn_submit.backgroundColor = Theme.current.primaryColor
        
        self.topView.backgroundColor = Theme.current.mainTableCellsBgColor
        
        self.noDataLbl.textColor = Theme.current.titleTextColor
        
        self.addBankView.backgroundColor = Theme.current.navigationBarColor
        
        ///Text Fields
        self.accCurrencyTF.textColor = self.saveYourBankAccStaticLbl.textColor
        self.accTypeTF.textColor = self.saveYourBankAccStaticLbl.textColor
        self.accNumTF.textColor = self.saveYourBankAccStaticLbl.textColor
        self.bankNameTF.textColor = self.saveYourBankAccStaticLbl.textColor
        self.bankCodeTF.textColor = self.saveYourBankAccStaticLbl.textColor
        self.swiftCodeTF.textColor = self.saveYourBankAccStaticLbl.textColor
        self.gAuthTF.textColor = self.saveYourBankAccStaticLbl.textColor
        
        self.addBankContentView.backgroundColor = Theme.current.backgroundColor
        
        self.addBanksBtn.backgroundColor = Theme.current.primaryColor
    }


    func setUpUi(){
        IQKeyboardManager.shared.enable = true
        self.setUpNavigation()
        self.addBankView.isHidden = true
        if let twoFactorEnabled = UserDefaults.standard.value(forKey: "is2FAEnabled") as? Bool {
            self.gAuthView.isHidden = !twoFactorEnabled
        }
        
        ///Set up placeholder
        self.accCurrencyTF.placeholder = "Select"
        self.accCurrencyTF.placeHolderColorCustom = Theme.current.subTitleColor
        
        self.accTypeTF.placeholder = "Select"
        self.accTypeTF.placeHolderColorCustom = Theme.current.subTitleColor
        
        self.accNumTF.placeholder = ""
        
        self.bankNameTF.placeholder = ""
        self.bankCodeTF.placeholder = ""
        
        self.swiftCodeTF.placeholder = ""
        
        self.gAuthTF.placeholder = ""
 
    }
  
    @IBOutlet weak var btn_submit: UIButton!
    
    func addDropDown(anchorView:UIView,width:CGFloat,dataSource:[String],completionHandler:@escaping(String)->()){
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.direction = .bottom
        dropDown.dataSource = dataSource
        dropDown.width = width
        dropDown.selectionAction = {(index: Int, item: String) in
            completionHandler(item)
        }
        dropDown.show()
    }
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = "Banks"
        self.navigationItem.titleView = label
    }
    @IBAction func hideBankView(_ sender: Any) {
        self.addBankView.isHidden = true
    }
    
    @IBAction func addBankAction(_ sender: Any) {
        self.addBankView.isHidden = false
    }
    
    @IBAction func submitAction(_ sender: Any) {
      //  guard
        
        self.saveBank()
    }
    @IBAction func btn_exchange_drop_down(_ sender: Any) {
        self.getAccountCurrency()
    }
    @IBAction func btn_bank_type_action(_ sender: Any) {
        self.addDropDown(anchorView: self.accTypeTF, width: self.accTypeTF.frame.width, dataSource: self.bankType) { (selected_Str) in
            self.accTypeTF.text = selected_Str
        }
    }
}
//MARK: API Calls
extension MDAddBankVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func reloadTableView(){
        DispatchQueue.main.async {
            self.banksTable.reloadData()
        }
    }
    func getAccountCurrency(){
        if let appdelegate = (UIApplication.shared.delegate as? AppDelegate)?.currencySettings,appdelegate.count > 0 {
            let bankList = appdelegate.filter({($0.walletType?.lowercased().contains("fiat") ?? false)})
            let dataSource = bankList.map({return "\($0.fullName ?? "") (\($0.shortName ?? ""))"})
            self.addDropDown(anchorView: self.accCurrencyTF, width: self.accCurrencyTF.frame.width, dataSource:dataSource) { (clicked_str) in
                self.accCurrencyTF.text = clicked_str
                self.selected_bank = bankList.first(where: { return "\($0.fullName ?? "") (\($0.shortName ?? ""))" == clicked_str})
            }
        }else{
            //call api
        }
    }
    func getBanksList(){
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
        ]
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.Get_Fiat_CustomerAccounts, parameters: nil, headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray {
                self.list_arry = dataArray as! [[String : Any]]
                DispatchQueue.main.async {
                    self.noDataLbl.isHidden = self.list_arry.count > 0
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "fiat_bank_added"),
                                                    object: self.list_arry)
                }
                self.reloadTableView()
            }
        }
    }
    func saveBank(){
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
        ]
        let param = self.createParameter()
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: API.Add_Fiat_CustomerAccount, parameters: param as NSDictionary, headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let e = error{
                MDHelper.shared.showErrorAlert(message: e.localizedDescription , viewController: self)
                return
            }
            guard response != nil else {return}
            
            if MDNetworkManager.shared.isResponseSucced(response: response!) {
                if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray {
                    self.list_arry = dataArray as! [[String : Any]]
                    self.hideBankView(self)
                    self.reloadTableView()
                }else{
                    print("Get Bank List")
                    self.getBanksList()
                    self.hideBankView(self)
                }
            }else{
                let msg = response?.value(forKey: "message") as? String ?? ""
                MDHelper.shared.showErrorAlert(message: msg, viewController: self)
            }
        }
    }
    
    func createParameter() -> [String:Any]{
        let accTypeTF_ = accTypeTF.text ?? ""
        let accNumTF_ = accNumTF.text ?? ""
        let bankNameTF_ = bankNameTF.text ?? ""
        let bankCodeTF_ = bankCodeTF.text ?? ""
        let swiftCodeTF_ = swiftCodeTF.text ?? ""
        let gAuthTF_ = gAuthTF.text ?? ""
          
        return [
            "BankName":bankNameTF_,
            "AccountCurrency": self.selected_bank?.shortName ?? "",
            "AccountType": accTypeTF_,
            "AccountNumber": accNumTF_,
            "BankRoutingCode": bankCodeTF_,
            "SwiftCode": swiftCodeTF_,
            "gauth_code": gAuthTF_,
            "otp": "542124",
            "token": "d539072b-f940-44a6-becc-7fac34fcbfab"
        ]
    }
}
extension MDAddBankVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDBankCells", for: indexPath) as! MDBankCells
        let data = self.list_arry[indexPath.item]
        cell.accountCurreny.text = data["accountCurrency"] as? String ?? ""
        cell.acountNum.text = data["accountNumber"] as? String ?? ""
        cell.acountType.text = data["accountType"] as? String ?? ""
        cell.bankName.text = data["bankName"] as? String ?? ""
        cell.bankCode.text = data["bankRoutingCode"] as? String ?? ""
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list_arry.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}


class MDBankCells : UITableViewCell{
    
    @IBOutlet weak var bgView: UIViewX!
    @IBOutlet weak var acountType: UILabel!
    @IBOutlet weak var accountCurreny: UILabel!
    @IBOutlet weak var acountNum: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var bankCode: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialiseCell()
        
    }
    
    private
    func initialiseCell(){
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        for each in [self.acountType , self.accountCurreny , self.acountNum, self.bankName, self.bankCode]{
            each?.textColor = Theme.current.titleTextColor
        }
        
    }
    
    
}
//  return [
//            "BankName": "SBI",
//            "AccountCurrency": "EUR",
//            "AccountType": "Savings",
//            "AccountNumber": "233232323",
//            "BankRoutingCode": "454545",
//            "SwiftCode": "28787",
//            "gauth_code": "999888",
//            "otp": "542124",
//            "token": "d539072b-f940-44a6-becc-7fac34fcbfab"
//        ]


extension MDAddBankVC {
    func validateInputField()->(Bool , String){
        if self.accCurrencyTF.text == ""{
            return (false , localised("Currnecy field can't be empty"))

        }
        if self.accTypeTF.text == "" {
            return (false , localised("Account type field can't be empty"))
        }
        if self.accNumTF.text == "" {
            return (false , localised("Account number field can't be empty"))
        }

        if self.bankNameTF.text == "" {
            return (false , localised("Bank number field can't be empty"))
        }
        
        if self.bankCodeTF.text == "" {
            return (false , localised("Bank Routing code field can't be empty"))
        }
        
        if self.swiftCodeTF.text == "" {
            return (false , localised("Swift code field can't be empty"))
        }
        
        if self.gAuthTF.text == "" {
            return (false , localised("Google Auth code field can't be empty"))
        }
        
        return (true , "")
    }
}
