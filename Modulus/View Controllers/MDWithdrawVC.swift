//
//  MDWithdrawVC.swift
//  Modulus
//
//  Created by Pathik  on 15/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//  Base Currnecy Volm

import UIKit
import DropDown
import AVFoundation
import MaterialComponents.MaterialBottomSheet

class MDWithdrawVC: UIViewController {
    var bankList:[[String:Any]] = []
    @IBOutlet weak var textView_stackView: UIStackView!
    @IBAction func select_bank_Action(_ sender: Any) {
        if bankList.count == 0 {
            self.getBanksList()
        }else{
            self.setupDropDown_Banks(dataArray: self.bankList)
        }
    }
    @IBAction func btn_ip_addressaction(_ sender: Any?) {
        if self.addresses.count == 0 {
            self.getAddressBook()
        }else{
            self.setupDrop_Down_Address(dataArray: self.addresses as! [[String:Any]] )
        }
    }
    @IBOutlet weak var lbl_add_enabled_Cnst: NSLayoutConstraint!
    @IBOutlet weak var lbl_add_address_enabled: UILabel!
    @IBOutlet weak var select_add_width_Cnst: NSLayoutConstraint!
    //MARK: - StoryBoard outlets
    @IBOutlet weak var addbankView: UIView!
    @IBOutlet weak var select_bank_textfield: UITextField!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var inorderLabel: UILabel!
    @IBOutlet weak var minimumAmountLabel: UILabel!
    @IBOutlet weak var maximumAmountLabel: UILabel!
    @IBOutlet weak var allButton: UIButton!

    @IBOutlet weak var selectAddressBtn: UIButton!
    @IBOutlet weak var addBankBtn: UIButton!
    //@IBOutlet weak var selectBankBtn: UIButton!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var alreadyHaveLabel: UILabel!
    @IBOutlet weak var amountBackground: UIView!
    @IBOutlet weak var selectAddressBackground: UIView!
    @IBOutlet weak var scanAddBtn: UIButton!
    @IBOutlet weak var inorderBackground: UIView!
    @IBOutlet weak var alreadyHaveBackground: UIView!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currenyDownArrowImageView: UIImageView!
    @IBOutlet weak var changeCurrencyButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
 
    @IBOutlet weak var customSideBarBoxStackView: UIStackView!
    @IBOutlet weak var walletAddressUnderLine: UIView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var minimumAmountStackview: UIStackView!
    
    //PHASE 2
    @IBOutlet weak var addressSepratorBgView: UIView!
    @IBOutlet weak var addressTagBgView: UIView!
    @IBOutlet weak var bankNameBgView: UIView!
    @IBOutlet weak var beneficiaryNameBgView: UIView!
    @IBOutlet weak var accountNumberBgView: UIView!
    @IBOutlet weak var brcBgView: UIView!
    @IBOutlet weak var swiftCodeBgView: UIView!
    @IBOutlet weak var gAuthCodeBgView: UIView!
    @IBOutlet weak var inOrderStaticLabel: UILabel!
    @IBOutlet weak var alreadyHaveStaticLabel: UILabel!
    
    // TextFields
    
    
    // Phase 2 textFields
    @IBOutlet weak var walletAddressTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addressTagTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var beneficiaryNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var brcTextField: UITextField!
    @IBOutlet weak var swiftCodeTextField: UITextField!
    @IBOutlet weak var gauthCodeTextField: UITextField!
    @IBOutlet weak var addressSepratorTextField: UITextField!
    
    // UnderlineView
    @IBOutlet var textFieldUnderLines: [UIView]!
    
    //P2P Phase
    @IBOutlet weak var smsOTPView: UIView!
    @IBOutlet weak var smsOTPTextField: UITextField!
    @IBOutlet weak var balanceLbl: UILabel!
    
    //Email OTP
    @IBOutlet weak var emailOtpView: UIView!
    @IBOutlet weak var emailOTP: UITextField!
    @IBOutlet weak var emailGetOtpBtn: UIButton!
    @IBOutlet weak var smsGetOtpBtn: UIButton!
    
    var emailToken = ""
    var smsToken = ""
    var addresses = [NSDictionary]()
    var right_history_button : UIBarButtonItem!
    
    //MARK: - Variables
    var navigationTitle = localised("Deposit")
    var currencySettings : NSArray? = nil
    var currencies = ["BTC","ETH","XRP","LTC","LSK","NEC","BES"]
    var selectedCurrency = "BTC"
    var selectedCurrenyDetails:Currency?
    var listOfAddress : NSArray = []
    var withdrawalSuccessMessage = ""
    lazy var dropDowns: [DropDown] = {
        return [
            self.rightBarDropDown
        ]
    }()
    var bottomSheet : MDCBottomSheetController? = nil
    //MARK: - Constants
    let rightBarDropDown = DropDown()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var alreadyAvailableBalance : Double = 0

    //MARK: - Automation Identifiers
    func addAutomationIdentifiers(){
        //For Automation
        
        self.confirmButton.accessibilityValue = "confirmButton"
        self.confirmButton.accessibilityIdentifier = "confirmButton"
        self.confirmButton.accessibilityLabel = "confirmButton"
        
        self.walletAddressTextField.accessibilityValue = "walletAddressTextField"
        self.walletAddressTextField.accessibilityIdentifier = "walletAddressTextField"
        self.walletAddressTextField.accessibilityLabel = "walletAddressTextField"
        
        self.changeCurrencyButton.accessibilityLabel = "changeCurrencyButton"
        self.changeCurrencyButton.accessibilityValue = "changeCurrencyButton"
        self.changeCurrencyButton.accessibilityIdentifier = "changeCurrencyButton"
        
        
        self.amountTextField.isAccessibilityElement = true
        self.amountTextField.accessibilityLabel = "walletAmountTextField"
        self.amountTextField.accessibilityValue = "walletAmountTextField"
        self.amountTextField.accessibilityIdentifier = "walletAmountTextField"
        
        
        self.amountBackground.isAccessibilityElement = true
        self.amountBackground.accessibilityLabel = "walletAmountTextField"
        self.amountBackground.accessibilityValue = "walletAmountTextField"
        self.amountBackground.accessibilityIdentifier = "walletAmountTextField"
        
        
        
        
        
        self.allLabel.isAccessibilityElement = true
        self.allLabel.accessibilityLabel = "withdrawAllButton"
        self.allLabel.accessibilityValue = "withdrawAllButton"
        self.allLabel.accessibilityIdentifier = "withdrawAllButton"
    }
    
    //MARK: - View Controller life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if withdrawalSuccessMessage != ""{
            MDHelper.shared.showSucessAlert(message: withdrawalSuccessMessage, viewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        appDelegate.currencySettings
        // Selected currency
        self.select_bank_textfield.isUserInteractionEnabled = false
        var withdrawalFilteredCurrency :[[String:Any]] = []
        appDelegate.currencySettings.filter({$0.withdrawalEnabled == true}).forEach { (currency) in
            if let walletBalanceCurrency = appDelegate.walletData.filter({(($0 as! NSDictionary).valueForCaseInsensativeKey(forKey: "currency") as! String) == currency.shortName}).first as? [String:Any]{
                withdrawalFilteredCurrency.append(walletBalanceCurrency)
            }else{
                withdrawalFilteredCurrency.append(["balance":0,"balanceInTrade":0,"currency":currency.shortName ?? ""])
            }
        }
        withdrawalFilteredCurrency.insert(["balance":0,"balanceInTrade":0,"currency":"ALL"], at: 0)
        // Selected currency
        if let selectedCurrencyDetails = withdrawalFilteredCurrency[1] as NSDictionary?{
            if let currencyName = selectedCurrencyDetails.valueForCaseInsensativeKey(forKey: "currency") as? String{
                selectedCurrency = currencyName
                self.currencyNameLabel.text = selectedCurrency
            }
        }
//        let currencyList = appDelegate.walletData.compactMap({($0 as! NSDictionary).valueForCaseInsensativeKey(forKey: "currency") as! String})
//        currencies = currencyList
        setNavigationbar()
        setUpColors()
        setUpUI()
       // getListOfAllAddress()
        getbalaceInfo()
        getCurrencySetting()
        self.getwithdrawl_whitelisting_status()
        // Do any additional setup after loading the view.
        self.currencyImageView.image = MDHelper.shared.getImageByCurrencyCode(code: selectedCurrency)
       
        addAutomationIdentifiers()
        setMinimumWithdrawAndFee()
        
        amountTextField.delegate = self
        walletAddressTextField.delegate = self
        addressTagTextField.delegate = self
        bankNameTextField.delegate = self
        beneficiaryNameTextField.delegate = self
        accountNumberTextField.delegate = self
        brcTextField.delegate = self
        swiftCodeTextField.delegate = self
        gauthCodeTextField.delegate = self
        amountTextField.placeholder = localised("Amount")
        walletAddressTextField.placeholder  = localised("Select Wallet Address")
        confirmButton.setTitle(localised("CONFIRM"), for: .normal)
        allLabel.text = localised("ALL")
               
        allLabel.textAlignment = .center
           
        infoTextView.text = localised("- The transfer of digital assets between the accounts of this platform is not supported, please ensure that your transfer address is not our account address.\n- We will process your withdrawal in 30 minutes, it depends on the blockchain when the assets would finally transferred to your wallet.\n- To enhance the security of your assets, if your withdrawal amount is larger than 50.0 BTC, we have to manually proccess your request, please double check your withdraw address.")
        inOrderStaticLabel.text = localised("IN ORDERS")
        alreadyHaveStaticLabel.text = localised("ALREADY HAVE")
        self.fetchUserProfile()
        self.addObservers()
    
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        if  self.bottomSheet != nil && (self.presentedViewController as? MDCBottomSheetController)?.presentingViewController != nil{
            
            self.bottomSheet?.dismiss(animated: false, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.changeCurrencyButtonAction(UIButton())
            }
        }
        
    }
    
    
    private
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.fiateBankAdded(_:)), name: NSNotification.Name.init("fiat_bank_added"), object: nil)
    }
 
    func fetchUserProfile(){
        if let is2FAEnabled = UserDefaults.standard.value(forKey: "is2FAEnabled") as? Bool{
            if is2FAEnabled{
                //Show Google authenticator
                self.gAuthCodeBgView.isHidden = false
            }else{
                //Hide Google authenticator
                self.gAuthCodeBgView.isHidden = true
            }
        }
        self.smsOTPView.isHidden = !(UIApplication.shared.delegate as! AppDelegate).isMobileVerified
    }
    
    //MARK: - Navigation bar helpers
    func setNavigationbar(){

        self.navigationItem.backBarButtonItem?.title = ""
        
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = navigationTitle
        self.navigationItem.titleView = label
        
        let rightLabel = UIButton()
        rightLabel.setTitleColor(Theme.current.titleTextColor, for: .normal)
      
        rightLabel.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightLabel.setTitle(localised("History"), for: .normal)
        rightLabel.isUserInteractionEnabled = true
        rightLabel.addTargetClosure { (button) in
            self.showHistoryScreen()
        }
        
        //For Automation
        
        rightLabel.isAccessibilityElement = true
        rightLabel.accessibilityLabel = "HistoryButton"
        rightLabel.accessibilityValue = "HistoryButton"
        rightLabel.accessibilityIdentifier = "HistoryButton"
        right_history_button = UIBarButtonItem.init(customView: rightLabel)
        self.navigationItem.rightBarButtonItem = right_history_button
    }
    
    func showHistoryScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MDWalletHistoryVC") as! MDWalletHistoryVC
        vc.screenType = .Withdraw
        vc.selectedCurrency = self.selectedCurrency
        vc.navigationTitle = localised("Withdrawal History")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- setup appeareance
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        backgroundView.backgroundColor  = Theme.current.backgroundColor
        inorderBackground.backgroundColor = MDAppearance.Colors.highlightBackgroundColor
        alreadyHaveBackground.backgroundColor = MDAppearance.Colors.highlightBackgroundColor
        selectAddressBackground.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        amountBackground.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        currencyNameLabel.textColor = Theme.current.titleTextColor
        currenyDownArrowImageView.tintColor = Theme.current.subTitleColor
        walletAddressTextField.textColor = Theme.current.titleTextColor
        walletAddressTextField.placeHolderColorCustom = Theme.current.subTitleColor
        amountTextField.placeHolderColorCustom = Theme.current.subTitleColor
        walletAddressUnderLine.backgroundColor = Theme.current.titleTextColor
        amountTextField.textColor = Theme.current.titleTextColor
        addressSepratorTextField.textColor = Theme.current.titleTextColor
        allButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        self.allLabel.textColor = Theme.current.titleTextColor
        
        // background view colors of textField
        addressTagBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        bankNameBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        beneficiaryNameBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        accountNumberBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        brcBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        swiftCodeBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        gAuthCodeBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        smsOTPView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        self.emailOtpView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        addressSepratorBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        
        // Textfield all color properties
        addressTagTextField.textColor = Theme.current.titleTextColor
        addressTagTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        smsOTPTextField.textColor = Theme.current.titleTextColor
        smsOTPTextField.placeHolderColorCustom = Theme.current.subTitleColor
        self.smsOTPTextField.placeholder = localised("SMS Verification Code")
        self.smsOTPTextField.keyboardType = .default
        if #available(iOS 12.0, *) {
            self.smsOTPTextField.textContentType = .oneTimeCode
        }

        self.emailOTP.textColor = Theme.current.titleTextColor
        self.emailOTP.placeHolderColorCustom = Theme.current.subTitleColor
        self.emailOTP.placeholder = localised("Email Verification Code")
        self.emailOTP.keyboardType = .default
        
        bankNameTextField.textColor = Theme.current.titleTextColor
        bankNameTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        beneficiaryNameTextField.textColor = Theme.current.titleTextColor
        beneficiaryNameTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        accountNumberTextField.textColor = Theme.current.titleTextColor
        accountNumberTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        brcTextField.textColor = Theme.current.titleTextColor
        brcTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        swiftCodeTextField.textColor = Theme.current.titleTextColor
        swiftCodeTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        gauthCodeTextField.textColor = Theme.current.titleTextColor
        gauthCodeTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        addressSepratorTextField.textColor = Theme.current.titleTextColor
        addressSepratorTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        self.selectAddressBtn.backgroundColor = Theme.current.primaryColor
        self.selectAddressBtn.setTitleColor(Theme.current.btnTextColor, for: .normal)
    
        self.scanAddBtn.backgroundColor = self.selectAddressBtn.backgroundColor
        self.scanAddBtn.setTitleColor(self.selectAddressBtn.currentTitleColor, for: .normal)
        
        self.smsGetOtpBtn.backgroundColor = self.selectAddressBtn.backgroundColor
        self.smsGetOtpBtn.setTitleColor(self.selectAddressBtn.currentTitleColor, for: .normal)
        
        self.emailGetOtpBtn.backgroundColor = self.selectAddressBtn.backgroundColor
        self.emailGetOtpBtn.setTitleColor(self.selectAddressBtn.currentTitleColor, for: .normal)
        
        self.addBankBtn.backgroundColor = self.selectAddressBtn.backgroundColor
        self.addBankBtn.setTitleColor(self.selectAddressBtn.currentTitleColor, for: .normal)
        
        self.infoTextView.textColor = Theme.current.titleTextColor
        self.confirmButton.backgroundColor = self.selectAddressBtn.backgroundColor
        self.confirmButton.setTitleColor(self.selectAddressBtn.currentTitleColor, for: .normal)
        
        
        
        bankNameTextField.placeholder = localised("Bank Name")
        beneficiaryNameTextField.placeholder = localised("Beneficiary Name")
        accountNumberTextField.placeholder = localised("IBAN")
        brcTextField.placeholder = localised("Bank Routing Code")
        swiftCodeTextField.placeholder = localised("Swift Code")
        gauthCodeTextField.placeholder = localised("Google Autheticator Code")
        // Set color to all TextFields underline
        textFieldUnderLines.forEach { (underLine) in
            underLine.backgroundColor = Theme.current.titleTextColor
        }
        
    
        for customView in customSideBarBoxStackView.arrangedSubviews{
            customView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
            for subView in customView.subviews{
                if subView is UIStackView{
                    let label = (subView as! UIStackView).arrangedSubviews.first as! UILabel
                    let value = (subView as! UIStackView).arrangedSubviews.last as! UILabel
                    label.textColor = Theme.current.titleTextColor
                    value.textColor = Theme.current.primaryColor
                }else{
                    subView.backgroundColor = Theme.current.primaryColor
                }
            }
        }
        
        for label in minimumAmountStackview.arrangedSubviews{
            (label as! UILabel).textColor = Theme.current.titleTextColor
        }
    }
    
    //MARK: - set Ui components visibilites
    func setUpUI(){
        self.amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        gauthCodeTextField.keyboardType = .numberPad
        if let selectedCurrencyDetails = appDelegate.currencySettings.filter({$0.shortName?.lowercased() == self.selectedCurrency.lowercased()}).first{
            self.selectedCurrenyDetails = selectedCurrencyDetails
            // Wallet type is fiat type then we have to show all bank related stuff
            if selectedCurrencyDetails.walletType == walletTypes.fiatPG.rawValue ||
                selectedCurrencyDetails.walletType == walletTypes.fiatManual.rawValue{
                bankNameBgView.isHidden = false
                beneficiaryNameBgView.isHidden = false
                accountNumberBgView.isHidden = false
                brcBgView.isHidden = false
                swiftCodeBgView.isHidden = false
                selectAddressBackground.isHidden = true
                ///Disable user interaction for fiate currency withdrawal user can not modify it
                ///it should be selected from drop down
                self.bankNameBgView.isUserInteractionEnabled = false
                self.accountNumberBgView.isUserInteractionEnabled = false
                self.brcBgView.isUserInteractionEnabled = false
                self.swiftCodeBgView.isUserInteractionEnabled = false
                
                if selectedCurrencyDetails.walletType == walletTypes.fiatPG.rawValue {
                    addressTagBgView.isHidden = false
                    addressSepratorBgView.isHidden = false
                }else{
                    addressSepratorBgView.isHidden = true
                    addressTagBgView.isHidden = true
                }
                addbankView.isHidden = false
            }else{
                addbankView.isHidden = true
                selectAddressBackground.isHidden = false
                addressSepratorBgView.isHidden = true
                bankNameBgView.isHidden = true
                beneficiaryNameBgView.isHidden = true
                accountNumberBgView.isHidden = true
                brcBgView.isHidden = true
                swiftCodeBgView.isHidden = true
            }
            
            if let addressSeprator = selectedCurrencyDetails.addressSeparator , addressSeprator != ""{
                selectAddressBackground.isHidden = true
                addressTagBgView.isHidden = false
                addressSepratorBgView.isHidden = false
                addressTagTextField.placeholder = "\(selectedCurrencyDetails.shortName?.uppercased() ?? "") "+localised("Address Tag")
                addressSepratorTextField.placeholder = "\(selectedCurrencyDetails.shortName?.uppercased() ?? "") "+localised("Address") //addressSeprator.stripped.uppercased()
            }else{
                addressSepratorBgView.isHidden = true
                addressTagBgView.isHidden = true
            }
        }
        resetTextfields()
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
                self.bankList = dataArray as! [[String : Any]]
                self.setupDropDown_Banks(dataArray: self.bankList)
            }
        }
    }
    
    @objc func fiateBankAdded(_ notification : Notification){
        if let dataArray : [[String:Any]] = notification.object as? [[String:Any]]{
            self.bankList = dataArray
        }
    }
    
    func setupDropDown_Banks(dataArray:[[String:Any]]){
        let source = dataArray.compactMap { (dict) -> String? in
            return "\(dict["bankName"] as! String)-\(dict["accountNumber"] as! String)"
            
        }
        self.addDropDownToSelectBank(toAnchorView: self.select_bank_textfield, DataSource: source) { (str) in
            if let selected_data = dataArray.first(where: { (dict) -> Bool in
                let checkStr = "\(dict["bankName"] as! String)-\(dict["accountNumber"] as! String)"
                return checkStr == str
            }){
                //setup
                self.select_bank_textfield.text = str
                self.setupBanks(selected_dict: selected_data )
            }
        }
    }
    func setupDrop_Down_Address(dataArray:[[String:Any]]){
        let source = dataArray.compactMap { (dict) -> String? in
            return "\(dict["Address"] as! String)-\(dict["Currency"] as! String)"
            
        }
        self.addDropDownToSelectBank(toAnchorView: self.walletAddressTextField, DataSource: source) { (str) in
            if let selected_data = dataArray.first(where: { (dict) -> Bool in
                let checkStr = "\(dict["Address"] as! String)-\(dict["Currency"] as! String)"
                return checkStr == str
            }){
                self.walletAddressTextField.text = str
                self.walletAddressTextField.resignFirstResponder()

            }
        }
    }
    func addDropDownToSelectBank(toAnchorView:UIView,DataSource:[String],completion:@escaping(String)->()){
        var data_source = DataSource
        let dropDown = DropDown()
        dropDown.anchorView = toAnchorView
        dropDown.width = toAnchorView.frame.width
        if data_source.count == 0 {
            data_source.append("No Data")
        }
        dropDown.dataSource = data_source
        dropDown.direction = .bottom
        dropDown.selectionAction = { (index: Int, item: String) in
            if item == "No Data"{
                return
            }
           completion(item)
        }
        dropDown.show()
    }
    func setupBanks(selected_dict:[String:Any]){
        self.bankNameTextField.text =  selected_dict["bankName"] as? String ?? ""
        self.swiftCodeTextField.text = selected_dict["swiftCode"] as? String ?? ""
        self.accountNumberTextField.text = selected_dict["accountNumber"]  as? String ?? ""
        self.brcTextField.text = selected_dict["bankRoutingCode"] as? String ?? ""
    }
    
    func resetTextfields(){
        walletAddressTextField.text = ""
        amountTextField.text = ""
        addressTagTextField.text = ""
        bankNameTextField.text = ""
        beneficiaryNameTextField.text = ""
        accountNumberTextField.text = ""
        brcTextField.text = ""
        swiftCodeTextField.text = ""
        gauthCodeTextField.text = ""
        addressSepratorTextField.text = ""
        self.smsOTPTextField.text = ""
        self.emailOTP.text = ""
        
    }
    
    //MARK: - Data Helpers
    func getbalaceInfo()  {
        MDHelper.shared.showHudOnWindow()
        DispatchQueue.global(qos: .background).async {
            
            if let balanceInfo = MDWalletHelper.shared.getWalletBalanceForCurrency(currency: self.selectedCurrency){
                DispatchQueue.main.async {
                    MDHelper.shared.hideHudOnWindow()
                    // print(balanceInfo)
                    let numberOfDec =  MDHelper.shared.getDecimalPrecisionFor(currnecy: self.selectedCurrency)
                    if let inorders = balanceInfo.valueForCaseInsensativeKey(forKey: "balance") as? Double {
                        self.alreadyAvailableBalance = inorders
                        self.alreadyHaveLabel.text =  MDHelper.shared.getFormattedNumber(amount: self.alreadyAvailableBalance, minimumFractionDigits: 0 , maxFractionDigits: numberOfDec)
                    }
                    if let alreadyhave = balanceInfo.valueForCaseInsensativeKey(forKey: "balanceInTrade") as? Double {
                        
                        self.inorderLabel.text =  MDHelper.shared.getFormattedNumber(amount: alreadyhave, minimumFractionDigits: 0 , maxFractionDigits: numberOfDec)
                    }
                    self.setMinimumWithdrawAndFee()
                }
            }else {
                DispatchQueue.main.async {
                    MDHelper.shared.hideHudOnWindow()
                }
            }
        }
    }
    /// This will set Withdrawal fee as per the selected screen
    func setMinimumWithdrawAndFee()  {
        self.feeLabel.text = ""
        self.minimumAmountLabel.text = ""
        self.maximumAmountLabel.text = ""
        if let array = self.currencySettings {
            if let dict = self.getNeedCurrency(array: array) {
                if dict.valueForCaseInsensativeKey(forKey: "withdrawalServiceCharge") is Double {
                    if let withdrawalServiceChargeType = dict.valueForCaseInsensativeKey(forKey: "withdrawalServiceChargeType") as? String{
                        switch withdrawalServiceChargeType.lowercased(){
                        case "fixed":
                            let withdrawalServiceChargeFixed = dict.value(forKey: "withdrawalServiceChargeFixed") as? Double ?? 0
                            
                            self.feeLabel.text = localised("Fee")+" \("\(String(withdrawalServiceChargeFixed))".prefix(6)) "+"\(self.selectedCurrency)"
                        case "fixed + percentage":
                            let withdrawalServiceChargeFixed = dict.value(forKey: "withdrawalServiceChargeFixed") as? Double ?? 0
                            let withdrawalServiceChargePercentage = dict.value(forKey: "withdrawalServiceChargePercentage") as? Double ?? 0
                            
                            self.feeLabel.text = localised("Fee")+" \("\(String(withdrawalServiceChargeFixed))".prefix(6)) " + self.selectedCurrency + " + " + "\(withdrawalServiceChargePercentage) %"
                        case "percentage" :
                            let withdrawalServiceChargePercentage = dict.value(forKey: "withdrawalServiceChargePercentage") as? Double ?? 0
                            self.feeLabel.text = localised("Fee")+" \("\(String(withdrawalServiceChargePercentage))".prefix(6))"+"%"
                            
                        default:
                            break
                        }
                        
                        
                    }
                    
                }
                self.minimumAmountLabel.text = "Service Charge: 0 \(self.selectedCurrency)"
                self.maximumAmountLabel.text = "You will Receive: 0 \(self.selectedCurrency)"
                if self.alreadyAvailableBalance != 0{
                    let numberOfDec = MDHelper.shared.getDecimalPrecisionFor(currnecy: self.selectedCurrency)
                    let balance : String = MDHelper.shared.getFormattedNumber(amount: self.alreadyAvailableBalance, minimumFractionDigits: numberOfDec) ?? ""
                    self.balanceLbl.text = "Balance after Withdrawal: \(balance) \(self.selectedCurrency)"
                    
                }else{
                    self.balanceLbl.text = "Balance after Withdrawal: 0 \(self.selectedCurrency)"
                }
            }
            }else {
                    self.getCurrencySetting()
            }
    }
    
    func getNeedCurrency(array: NSArray) -> NSDictionary? {
        for item in array {
            let dict = item as! NSDictionary
            let shortName = dict.valueForCaseInsensativeKey(forKey: "shortName") as! String
            if self.selectedCurrency.lowercased() == shortName.lowercased() {
                return dict
            }
        }
        return nil
    }
    
    //MARK: -  NetworkData Validations
    func shouldCreateWithdrawalRequest()->Bool{
        if let addressSeprator = selectedCurrenyDetails?.addressSeparator , addressSeprator != ""{
            if addressTagTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
                let  message = localised("Please enter")+" \(addressTagTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
            if addressSepratorTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
                let  message = localised("Please enter")+" \(addressSepratorTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
        }else{
            if selectedCurrenyDetails?.walletType == walletTypes.fiatManual.rawValue ||
                selectedCurrenyDetails?.walletType == walletTypes.fiatPG.rawValue{
                
            }else{
                if walletAddressTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
                    let  message = localised("Please enter")+" \(walletAddressTextField.placeholder!)"
                    MDHelper.shared.showErrorAlert(message: message, viewController: self)
                    return false
                }
            }
        }
        
        if amountTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
            let  message = localised("Please enter")+" \(amountTextField.placeholder!)"
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
            return false
        }
        
        if (self.emailOTP.text?.replacingOccurrences(of: " ", with: "") ?? "") == ""{
            let  message = localised("Please enter")+" \(emailOTP.placeholder!)"
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
            return false
        }
        
        if (self.emailOTP.text?.replacingOccurrences(of: " ", with: "") ?? "").count != 6{
            let  message = localised("Please enter valid")+" \(emailOTP.placeholder!)"
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
            return false
        }
        
        if (UIApplication.shared.delegate as! AppDelegate).isMobileVerified{
            if (self.smsOTPTextField.text?.replacingOccurrences(of: " ", with: "") ?? "") == ""{
                let  message = localised("Please enter")+" \(smsOTPTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
            
            if (self.smsOTPTextField.text?.replacingOccurrences(of: " ", with: "") ?? "").count != 6{
                let  message = localised("Please enter valid")+" \(smsOTPTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
        }
        

        
        
        if selectedCurrenyDetails?.walletType == walletTypes.fiatManual.rawValue {
            if bankNameTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
                let  message = localised("Please enter")+" \(bankNameTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
            if beneficiaryNameTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
                let  message = localised("Please enter")+" \(beneficiaryNameTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
            if accountNumberTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
                let  message = localised("Please enter")+" \(accountNumberTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
            if brcTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
                let  message = localised("Please enter")+" \(brcTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
            if swiftCodeTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" {
                let  message = localised("Please enter")+" \(swiftCodeTextField.placeholder!)"
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                return false
            }
        }
        
        if gauthCodeTextField.text?.replacingOccurrences(of: " ", with: "") ?? "" == "" , !self.gAuthCodeBgView.isHidden {
            let  message = localised("Please enter")+" \(gauthCodeTextField.placeholder!)"
            MDHelper.shared.showErrorAlert(message: message, viewController: self)
            return false
        }
        return true
    }
    
    //MARK: - Network Calls
    func getAddressBook(){
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
                    ]
        
        let param = ["Currency":self.selectedCurrenyDetails?.shortName ?? ""] as NSDictionary
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: API.Get_AddressBook, parameters: param, headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? [NSDictionary] {
                self.addresses = dataArray
                self.setupDrop_Down_Address(dataArray: self.addresses as! [[String:Any]])
            }else{
                self.addresses = []
                self.setupDrop_Down_Address(dataArray: [])
            }
        }
    }
    func getwithdrawl_whitelisting_status(){
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
                    ]
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.Get_Withdrawal_Address_Whitelisting_Status, parameters: nil, headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? Bool {
                DispatchQueue.main.async {
                    self.setup_addressEnaled(isaddress_enabled: dataArray)
                }
                
            }
        }
    }
    func setup_addressEnaled(isaddress_enabled:Bool){
        self.lbl_add_enabled_Cnst.constant = isaddress_enabled ? 60 : 0
        self.lbl_add_address_enabled.isHidden = isaddress_enabled ? false : true
        self.scanAddBtn.alpha = isaddress_enabled ? 0.6:1
        self.scanAddBtn.isUserInteractionEnabled = !isaddress_enabled
        self.view.layoutSubviews()
    }
    func getOTP(type:String){
        let headers = ["Content-Type": "application/json",
                       "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"] as [String : Any]
        var requestedAmount = self.amountTextField.text ?? ""
        if let amount = Double(self.amountTextField.text ?? ""){
            if let withdrawalServiceCharge = selectedCurrenyDetails?.withdrawalServiceCharge{
                let amountUserWillReceive = (100 * amount)/(100 + withdrawalServiceCharge)
                let roundUp = (amountUserWillReceive*100000000).rounded()/100000000
                requestedAmount = String(format: "%.2f", roundUp)
            }
        }else{
             MDHelper.shared.showErrorAlert(message: localised("Please enter valid amount"), viewController: self)
            return
        }
        var addressToPass = self.walletAddressTextField.text ?? ""
        addressToPass = addressTagTextField.text ?? self.walletAddressTextField.text ?? ""

        if walletAddressTextField.text == "" {
            
            addressToPass = addressTagTextField.text ?? ""
        }else{
            addressToPass = walletAddressTextField.text ?? ""
            
        }
        
        let params = [
                        "amount": requestedAmount,
                        "currency": selectedCurrency,
                        "address": addressToPass,
                        "otp_type": type
                    ]
        
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .post,
                                            apiName: API.requestWithdraw_EmailOTP,
                                            parameters: params as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
                                                //Handle Response Here
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String ?? ""
                                                        MDHelper.shared.showSucessAlert(message: message, viewController: self)
                                                        if let data = response?.value(forKey: "data") as? NSDictionary{
                                                            let token = data.value(forKey: "token") as? String ?? ""
                                                            switch type{
                                                            case "email": self.emailToken = token
                                                            case "sms": self.smsToken = token
                                                            default:break
                                                            }
                                                        }
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
    
    
    func getCurrencySetting(){
        MDHelper.shared.showHudOnWindow()
        let header = ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"]
        
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.getCurrencySetting, parameters: nil, headers: header as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray {
                
                self.currencySettings = dataArray
                self.appDelegate.currencySettings =  dataArray.compactMap({Currency(data: $0 as! NSDictionary)})
                
//                self.currencySettings = dataArray
                self.setMinimumWithdrawAndFee()
                
            }
            
        }
    }
    
    func createWithdrawRequest(){
        if let amount = Double(self.amountTextField.text ?? ""){
            var addressToPass = self.walletAddressTextField.text ?? ""
            var addresstag = "null"
            //        if let addressSeprator = selectedCurrenyDetails?.addressSeparator , addressSeprator != ""{
            addressToPass = addressTagTextField.text ?? self.walletAddressTextField.text ?? ""
            addresstag = addressSepratorTextField.text ?? ""
            //        }
            var params:[String:Any] = [:]
            if walletAddressTextField.text == "" {
                params["addressTag"] = addresstag
                addressToPass = addressTagTextField.text ?? ""
            }else{
                addressToPass = walletAddressTextField.text ?? ""
            }
            params["currency"] = selectedCurrency
            params["amount"] = String(amount)
            params["address"] = addressToPass
            params["gauth_code"] = gauthCodeTextField.text!
            params["email_token"] = self.emailToken
            params["email_otp"] = self.emailOTP.text ?? ""
            params["sms_token"] = self.smsToken
            params["sms_otp"] = self.smsOTPTextField.text ?? ""
            
            let headers = ["Authorization":MDNetworkManager.shared.authToken,
                           "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
            
            MDHelper.shared.showHudOnWindow()
            MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                                methodType: .post,
                                                apiName: "api/withdraw-crypto?fee=v2",
                                                parameters: params as NSDictionary,
                                                headers: headers as NSDictionary) { (response, error) in
                MDHelper.shared.hideHudOnWindow()
                if response != nil && error == nil{
                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                        self.handleWithdrawalResponse(response: response!)
                    }else{
                        if let message = response?.valueForCaseInsensativeKey(forKey: "message") as? String{
                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                            //self.resetTextfields()
                        }
                    }
                }else{
                    if  error != nil{
                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                        self.resetTextfields()
                    }
                }
            }
        }else{
            MDHelper.shared.showErrorAlert(message: localised("Please enter valid amount"), viewController: self)
        }
        
    }
    
    func createWithdrawalRequestForFiat_Manual(){
        // Calulate the amount to be passed:
        var requestedAmount = self.amountTextField.text ?? ""
        if let amount = Double(self.amountTextField.text ?? ""){
            if let withdrawalServiceCharge = selectedCurrenyDetails?.withdrawalServiceCharge{
                let amountUserWillReceive = (100 * amount)/(100 + withdrawalServiceCharge)
                let roundUp = (amountUserWillReceive*100000000).rounded()/100000000
                requestedAmount = String(format: "%.2f", roundUp)
            }

        }
            let params = [
                "RequestAmount":requestedAmount
                ,"BankName":bankNameTextField.text ?? ""
                ,"BeneficiaryName":beneficiaryNameTextField.text ?? ""
                ,"AccountNumber":accountNumberTextField.text ?? ""
                ,"BankRoutingCode":brcTextField.text ?? ""
                ,"SwiftCode":swiftCodeTextField.text ?? ""
                ,"CurrencyName": selectedCurrency
                ,"gauth_code":gauthCodeTextField.text ?? ""
            ]
            
            let headers = ["Authorization":MDNetworkManager.shared.authToken,
                           "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary),
                           "Content-Type":"application/json"] as [String : Any]
            
            
            MDHelper.shared.showHudOnWindow()
        
        MDNetworkManager.shared.sendJSONRequest(methodType: .post,
                                                apiName: API.addFiatManualWithdrwalRequest,
                                                parameters: params as NSDictionary,
                                                headers: headers as NSDictionary) { (response, error) in
                                                    MDHelper.shared.hideHudOnWindow()
                                                    if response != nil && error == nil{
                                                        if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                            self.handleWithdrawalResponse(response: response!)
                                                        }else{
                                                            if let message = response?.valueForCaseInsensativeKey(forKey: "data") as? String{
                                                                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                                self.resetTextfields()
                                                            }else if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                                                                MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                                self.resetTextfields()
                                                            }
                                                        }
                                                    }else{
                                                        if  error != nil{
                                                            MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                            self.resetTextfields()
                                                        }
                                                    }
        }
    }
    
    
    func getListOfAllAddress(){
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .post,
                                            apiName: API.getListOfAllAddress,
                                            parameters: nil,
                                            headers: headers as NSDictionary) { (response, error) in
                                                
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        
                                                        if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
                                                            //                                                            if let address = data.valueForCaseInsensativeKey(forKey: self.selectedCurrency.lowercased()) as? String {
                                                            //                                                                self.listOfAddress = [address]
                                                            //                                                            }
                                                        }
                                                    }else{
                                                        if let message = response?.valueForCaseInsensativeKey(forKey: "message") as? String{
                                                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                        }
                                                    }
                                                }else{
                                                    if  error != nil{
                                                        //                                                        MDHelper.shared.showErrorAlert(message: (error?.localizedDescription)!, viewController: self)
                                                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                    }
                                                }
                                                //                                                print("Get wallet details")
        }
        
    }
    
    func showDropDown(anchorView : UIView){
        var source = self.addresses.map({ $0.value(forKey: "Address") as? String ?? "" })
        if source.count == 0 {
            source.append("No Data")
        }
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.direction = .bottom
        dropDown.dataSource = source
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "No Data"{
                return
            }
            self.walletAddressTextField.text = item
        }
        dropDown.width = self.walletAddressTextField.frame.width
        dropDown.show()

    }
    
    //MARK: - Button Actions
    @IBAction func showAdressDD(_ sender: Any) {
        self.showDropDown(anchorView: self.walletAddressTextField)
    }
    @IBAction func allButtonAction(_ sender: UIButton) {
        
        self.amountTextField.text = self.getAllCurrency()?.replacingOccurrences(of: ",", with: "")
        
        self.textFieldDidChange(self.amountTextField)
        self.balanceLbl.text = "Balance after Withdrawal: 0.00  \(self.selectedCurrency)"
        
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        if sender.tag == 121 {
            self.showHistoryScreen()
            return
        }
        self.view.endEditing(true)
        if self.shouldCreateWithdrawalRequest() == true{
            MDAlertPopupView.showAlertPopupViewOnWidnow(title: localised("appTitle"), errorMessage: localised("Are you sure you want to place this withdrawal request?"), alertDelegate: self)
        }
    }
    
    @IBAction func getOTP(_ sender: Any) {
        self.getOTP(type: "sms")
    }
    
    @IBAction func getEmailOTP(_ sender: UIButton) {
        self.getOTP(type: "email")
    }
    
    @IBAction func scanTapped(_ sender: UIButton) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .notDetermined:
            //Ask Permission
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    self.navigateToScannerVC()
                }
            }
        case .restricted:
            DispatchQueue.main.async {
                MDHelper.shared.showErrorAlert(message: "Camera Access Restricted", viewController: self)
            }
        case .denied:
            DispatchQueue.main.async {
                MDHelper.shared.showErrorAlert(message: "Camera Access Restricted", viewController: self)
            }
        case .authorized:
            DispatchQueue.main.async {
                self.navigateToScannerVC()
            }
        }
    }
    
    private
    func navigateToScannerVC(){
        DispatchQueue.main.async {
            let scannerVC = MDScannerVC()
            scannerVC.delegate = self
            self.navigationController?.pushViewController(scannerVC, animated: true)
        }
    }
    
    ///Apply reverce logic
    private func getAllCurrency()->String?{
        let maxDecimals = MDHelper.shared.getDecimalPrecisionFor(currnecy: self.selectedCurrency)
        if let array = self.currencySettings {
            if let dict = self.getNeedCurrency(array: array) {
                if let fees = dict.valueForCaseInsensativeKey(forKey: "withdrawalServiceCharge") as? Double {
                    if let withdrawalServiceChargeType = dict.valueForCaseInsensativeKey(forKey: "withdrawalServiceChargeType") as? String{
                        var deductor = 0.0
                        let enteredAmount : Double = Double(self.amountTextField.text ?? "0") ?? 0
                    
                        switch withdrawalServiceChargeType.lowercased() {
                        case "fixed":
                            deductor = fees
                        case "fixed + percentage":
                            if let withdrawalServiceChargePercentage = dict.value(forKey: "withdrawalServiceChargePercentage") as? Double{
                                let percentageFees : Double = (withdrawalServiceChargePercentage/100.00)
                                deductor = (self.alreadyAvailableBalance * percentageFees) + fees
                                
                                let divider = 1 + percentageFees
                                
                                let amount = (self.alreadyAvailableBalance - fees)/divider
                                
                                let roundOfHund : Double = pow(10.0,Double(maxDecimals))
                                
                                let roundedNumber = floor(amount * roundOfHund) / roundOfHund
                                
                                return MDHelper.shared.getFormattedNumber(amount: roundedNumber,
                                                                          minimumFractionDigits: 2 , maxFractionDigits: maxDecimals) ?? "0"
                                
                                
                            }
                        case "percentage":
                            if let withdrawalServiceChargePercentage = dict.value(forKey: "withdrawalServiceChargePercentage") as? Double{
                                let percentageFees : Double = (withdrawalServiceChargePercentage/100.00)
                                deductor = (self.alreadyAvailableBalance * percentageFees)
                                
                                let divider = 1 + percentageFees
                                
                                let amount = (self.alreadyAvailableBalance)/divider
                                
                                let roundOfHund : Double = pow(10.0,Double(maxDecimals))
                                
                                let roundedNumber = floor(amount * roundOfHund) / roundOfHund
                                
                                return MDHelper.shared.getFormattedNumber(amount: roundedNumber,
                                                                          minimumFractionDigits: 2 , maxFractionDigits: maxDecimals) ?? "0"
                                
                                
                            }
                        default:
                            fatalError("withdrawal service type not found")
                        }
                      
                        return MDHelper.shared.getFormattedNumber(amount: self.alreadyAvailableBalance - deductor,
                                                                  minimumFractionDigits: 2 , maxFractionDigits: maxDecimals) ?? "0"
                        
                    }
                }
            }
        }
        
        
        return nil
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let array = self.currencySettings {
            if let dict = self.getNeedCurrency(array: array) {
                if let fees = dict.valueForCaseInsensativeKey(forKey: "withdrawalServiceCharge") as? Double {
                    if let withdrawalServiceChargeType = dict.valueForCaseInsensativeKey(forKey: "withdrawalServiceChargeType") as? String{
                        var deductor = 0.0
                        let enteredAmount : Double = Double(self.amountTextField.text ?? "0") ?? 0
                        if withdrawalServiceChargeType.lowercased() == "fixed"{
                            deductor = fees
                        }else{
                            if withdrawalServiceChargeType == "Fixed + Percentage"{
                                if let withdrawalServiceChargePercentage = dict.value(forKey: "withdrawalServiceChargePercentage") as? Double{
                                    deductor = (enteredAmount * (withdrawalServiceChargePercentage/100)) + fees
                                }
                            }else{
                                deductor = (enteredAmount * (fees/100))
                            }
                        }
                        
                        let maxDecimals = MDHelper.shared.getDecimalPrecisionFor(currnecy: self.selectedCurrency)
                        

                        let minimumAmountLabelText : String = MDHelper.shared.getFormattedNumber(amount: deductor, minimumFractionDigits: 2 , maxFractionDigits: maxDecimals) ?? "0"

                        let balnceAfterWithrawText : String = MDHelper.shared.getFormattedNumber(amount: self.alreadyAvailableBalance - enteredAmount - deductor,
                                                                                                 minimumFractionDigits: 2 , maxFractionDigits: maxDecimals) ?? "0"
                        
                        let enteredAmountText : String =  MDHelper.shared.getFormattedNumber(amount: enteredAmount,
                                                                                             minimumFractionDigits: 2 , maxFractionDigits: maxDecimals) ?? "0"
                        

                        self.minimumAmountLabel.text = "Service Charge: \(minimumAmountLabelText) \(self.selectedCurrency)"
                        self.maximumAmountLabel.text = "You will Receive: \(enteredAmountText) \(self.selectedCurrency)"
                        
                        self.balanceLbl.text = "Balance after Withdrawal: \(balnceAfterWithrawText) \(self.selectedCurrency)"
                    }
                }
            }
        }
    }
    
    //MARK: - Response Handlers
    func handleWithdrawalResponse(response: NSDictionary)  {
        if (response.valueForCaseInsensativeKey(forKey: "message") as? String) != nil{
            MDAlertMessageView.showMessagePopupViewOnWidnow(message: localised("Withdrawal request received."),alertDelegate : self)
            self.getbalaceInfo()
        }
    }
    
    
    @IBAction func changeCurrencyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // Filter the currencies should be shown in deposite as per currencySetting
        // if Withdrawal is enabled in currency setting then only it should show in dropdown
        var withdrawalFilteredCurrency :[[String:Any]] = []
        appDelegate.currencySettings.filter({$0.withdrawalEnabled == true}).forEach { (currency) in
            if let walletBalanceCurrency = appDelegate.walletData.filter({(($0 as! NSDictionary).valueForCaseInsensativeKey(forKey: "currency") as! String) == currency.shortName}).first as? [String:Any]{
                withdrawalFilteredCurrency.append(walletBalanceCurrency)
            }else{
                withdrawalFilteredCurrency.append(["balance":0,"balanceInTrade":0,"currency":currency.shortName ?? ""])
            }
        }
        withdrawalFilteredCurrency.insert(["balance":0,"balanceInTrade":0,"currency":"ALL"], at: 0)
        let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
        let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
        dropDownVC.delegate = self
        dropDownVC.data = (withdrawalFilteredCurrency as NSArray).mutableCopy() as! NSMutableArray
        dropDownVC.type = .currencyList
        dropDownVC.selectedPair = selectedCurrency
        bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
        bottomSheet?.delegate = self
        bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2,
                                                  height:self.view.frame.size.height - (changeCurrencyButton.frame.origin.y + self.changeCurrencyButton.frame.size.height + self.backgroundView.frame.origin.y + (UIApplication.shared.statusBarFrame.height)))
        present(bottomSheet!, animated: true, completion: nil)
    }
}

extension MDWithdrawVC:customDropDownDelegates{
    func dropDownSelected(title: String, data: NSDictionary) {
        self.selectedCurrency = title
        self.currencyNameLabel.text = title
        self.currencyImageView.image = MDHelper.shared.getImageByCurrencyCode(code: title)
        self.getbalaceInfo()
        self.setMinimumWithdrawAndFee()
        self.bottomSheet = nil
        if title.lowercased() == "all"{
            self.textView_stackView.subviews.forEach { (view) in
                view.isHidden = true
            }
            self.confirmButton.setTitle(localised("View History"), for: .normal)
            self.confirmButton.tag = 121
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.textView_stackView.subviews.forEach { (view) in
                view.isHidden = false
            }
            self.fetchUserProfile()
            self.confirmButton.tag = 0
            self.confirmButton.setTitle(localised("Confirm"), for: .normal)
            setUpUI()
            if self.navigationItem.rightBarButtonItem == nil {
                self.setNavigationbar()
            }
        }
    }
}


extension MDWithdrawVC:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == walletAddressTextField && self.lbl_add_address_enabled.isHidden == false {
            textField.resignFirstResponder()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let sepratedString = textField.text?.components(separatedBy: ".")
        if (sepratedString?.count)! == 2 {
            var firstText = sepratedString?.first
            var secoundText = sepratedString?.last
            if firstText == ""{
                firstText = "0"
            }
            if secoundText == ""{
                secoundText = "0"
            }
            textField.text = "\(firstText!).\(secoundText!)"
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let userEnteredString = textField.text
        
        var newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString

//        if (newString.length) > 19{
//            return false
//        }
        return true
    }
}
extension MDWithdrawVC:alertPopupDelegate{
    func alertPopupResponse(isAgree: Bool) {
        if isAgree == true {
            if selectedCurrenyDetails?.walletType == walletTypes.fiatManual.rawValue || selectedCurrenyDetails?.walletType == walletTypes.fiatPG.rawValue{
                createWithdrawalRequestForFiat_Manual()
            }else{
                createWithdrawRequest()
            }
        }
    }
}
extension MDWithdrawVC:alertPopupMessageDelegate{
    func alertPopupMessage(presedOk:Bool){
        if presedOk == true {
            
            self.resetTextfields()
            
           self.walletAddressTextField.text = ""
            self.amountTextField.text = ""
        }
    }
}


extension MDWithdrawVC:UITextPasteConfigurationSupporting{
    var pasteDelegate: UITextPasteDelegate? {
        get {
            print(UIPasteboard.general.string)
            return pasteDelegate
        }
        set(pasteDelegate) {
            print(UIPasteboard.general.string)
        }
    }
    
    
    
    
}
//MARK: - Bottom Sheet Delegates

extension MDWithdrawVC : MDCBottomSheetControllerDelegate {
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        print(controller)
        self.bottomSheet = nil
        
    }
    
}

extension MDWithdrawVC :MDScannerDelegate {
    func didFoundCode(code: String) {
        self.walletAddressTextField.text = code
    }
}
