//
//  MDWithdraDepositVC.swift
//  Modulus
//
//  Created by Pathik  on 15/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import DropDown
import MaterialComponents.MaterialBottomSheet
import WebKit
class BankDetailsView:UIView{
    @IBOutlet weak var bgView: UIView!
//    @IBOutlet weak var bankNameLabel: UILabel!
//    @IBOutlet weak var beneficiaryNameLabel: UILabel!
//    @IBOutlet weak var brcLabel: UILabel!
//    @IBOutlet weak var accountNumberLabel: UILabel!
//    @IBOutlet weak var swiftCodeLabel: UILabel!
//    @IBOutlet weak var locationLabrl: UILabel!
    @IBOutlet weak var bankDetailsTextView: UITextView!
    
    ///initialisation
    fileprivate
    func setUpBankDetailsView(){
        self.bankDetailsTextView.delegate = self
        self.setInitialBankDetails()
    }
    
    fileprivate func setInitialBankDetails(){
        //self.bankDetailsTextView.textColor = Theme.current.titleTextColor
        self.bankDetailsTextView.backgroundColor = .clear
        self.setBankDetailsTextView(bankName: "N/A", benName: "N/A", bankRoutingCode: nil, AcNo: "N/A", SwiftCode: "N/A", location: nil)
    }
    
    fileprivate
    func setBankDetailsTextView(bankName:String? , benName : String? , bankRoutingCode:String? , AcNo : String? , SwiftCode : String? , location : String?){
        
        let attributedText : NSMutableAttributedString = .init(string: "")
        // Set bank Name
        if bankName != nil {
            attributedText.append(getAttributedString(baseString: localised("Bank Name")+" : ", appendedString: bankName! + "\n"))
        }
        // Set Beneficiary Name
        if benName != nil {
            attributedText.append(getAttributedString(baseString: localised("Beneficiary Name")+" : ", appendedString: benName! + "\n"))
        }
        // Set bank Rounting code
        if bankRoutingCode != nil {
            attributedText.append(getAttributedString(baseString: localised("Bank Routing Code")+" : ", appendedString: bankRoutingCode! + "\n"))
        }
        //Account number
        if AcNo != nil {
            attributedText.append(getAttributedString(baseString: localised("Account Number")+" : ", appendedString: AcNo! + "\n"))
        }
        //Swift Code
        if SwiftCode != nil {
            attributedText.append(getAttributedString(baseString: localised("Swift Code")+" : ", appendedString: SwiftCode! + "\n"))
        }
        //Location Label
        if location != nil {
            attributedText.append(getAttributedString(baseString: localised("Location")+" : ", appendedString: location!))
        }
        
        self.bankDetailsTextView.attributedText = attributedText
    }
    
    private func getAttributedString(baseString:String,appendedString:String)->NSMutableAttributedString{
        let boldFont = UIFont.init(name: MDAppearance.Proxima_Nova.bold, size: 17)
        let normalFont = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 16)
        let boldTextAttribute = [NSAttributedString.Key.font:boldFont , .foregroundColor:Theme.current.titleTextColor]
        let actualText = baseString + appendedString
        let actualAttributedString = NSMutableAttributedString(string: actualText)
        actualAttributedString
            .addAttributes(boldTextAttribute as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: baseString.count))
        actualAttributedString
            .addAttributes([NSAttributedString.Key.font:normalFont! ,
                                              .foregroundColor : Theme.current.titleTextColor],
                                             range: NSRange(location: baseString.count, length: appendedString.count))
        return actualAttributedString
    }

}

extension BankDetailsView : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
}

class MDDepositVC: UIViewController {
    
    @IBAction func btn_inner_historyview(_ sender: Any) {
        self.showHistoryScreen()
    }
    @IBOutlet weak var inner_history_button: UIButton!
    @IBOutlet weak var allCurrencyView: UIView!
    //MARK: - StoryBoard outlets
    @IBOutlet weak var inorderLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var copyDestinationTagButton: UIButton!
    @IBOutlet weak var addressBackground: UIView!
    @IBOutlet weak var inOrderBackgroud: UIView!
    @IBOutlet weak var alreadyHabeBackground: UIView!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var alreadyHaveBalanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var currencyNameAddressLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currenyDownArrowImageView: UIImageView!
    @IBOutlet weak var changeCurrencyButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var customSideBarBoxesStackView: UIStackView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var sectionsSeprator: UIView!
    
    //MARK: -  PHASE 2
    
    //Destiantion tag
    @IBOutlet weak var destinationTagStackView: UIStackView!
    @IBOutlet weak var destinationTagTextField: UILabel!
    @IBOutlet weak var destinationTagLabel: UILabel!
    
    @IBOutlet weak var selectPaymentMethodBgView: UIView!
    @IBOutlet weak var selectPaaymentMethodButton: UIButton!
    
    @IBOutlet weak var bankDetailsSubmitView: UIView!
    @IBOutlet weak var bankDetailsView: BankDetailsView!
    @IBOutlet weak var bankNameButton: UIButton!
    
    @IBOutlet weak var requestAmountTextField: UITextField!
    @IBOutlet weak var transactionIdTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextField!
    
    
    @IBOutlet weak var bankNameStaticLabel: UILabel!
    @IBOutlet weak var bankSelectionView: UIView!
    
    
    @IBOutlet weak var redirectionLabel: UILabel!
    @IBOutlet weak var transactionFeeLabel: UILabel!
    @IBOutlet weak var redirectionTransactionView: UIView!
    
    @IBOutlet weak var transactionFeeNGN: UILabel!
    @IBOutlet weak var charegesAmountNGN: UILabel!
    @IBOutlet weak var transactionChargesView: UIView!
    
    @IBOutlet weak var qrBlurView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    //@IBOutlet weak var copyButtonForAccountNumber:UIButton!
    @IBOutlet weak var bankDetailsLabel: UILabel!
    @IBOutlet weak var submitDepositeLabel: UILabel!
    @IBOutlet weak var alreadyHaveStaticlabel: UILabel!
    @IBOutlet weak var inOrderStaticLabel: UILabel!
    @IBOutlet weak var destinationTagStaticLabel: UILabel!
    
    var isOnlinePayment = false
    //MARK: -  Phase 2 Data variables
    var bankDetails:[[String:Any]] = []
    var selectedBankdetailsIndex = 0
    
    
    
    //MARK: - Variables
    var navigationTitle = localised("Deposit")
    var currencies = ["BTC","ETH","XRP","LTC","LSK","NEC","BES"]
    var selectedCurrency = "AE"
    
    var selectedCurrenyDetails:Currency?
    var history_button:UIBarButtonItem!
    //MARK: - Constants
    let rightBarDropDown = DropDown()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.rightBarDropDown
        ]
    }()
    
    var bottomSheet : MDCBottomSheetController? = nil
    var responseURL = ""
    let transparentButton = UIButton()
    var depositeFilteredCurrency :[[String:Any]] = []

    //MARK: - Automation Identifiers
    func addAutomationIdentifiers(){
        changeCurrencyButton.accessibilityLabel = "changeCurrencyButton"
        changeCurrencyButton.accessibilityValue = "changeCurrencyButton"
        changeCurrencyButton.accessibilityIdentifier = "changeCurrencyButton"
        
        copyButton.accessibilityLabel = "copyButton"
        copyButton.accessibilityValue = "copyButton"
        copyButton.accessibilityIdentifier = "copyButton"
    }
    
    //MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbar()
        setUpColors()
        allCurrencyView.backgroundColor = addressBackground.backgroundColor
        allCurrencyView.isHidden = true
        inner_history_button.layer.cornerRadius = 8.0
        inner_history_button.layer.masksToBounds = true
        self.view.layoutSubviews()
        
        //For Automation
        print(appDelegate.currencySettings)
        appDelegate.currencySettings.filter({$0.depositEnabled == true}).forEach { (currency) in
            if let walletBalanceCurrency = appDelegate.walletData.filter({(($0 as! NSDictionary).valueForCaseInsensativeKey(forKey: "currency") as! String) == currency.shortName}).first as? [String:Any]{
                depositeFilteredCurrency.append(walletBalanceCurrency)
            }else{
                depositeFilteredCurrency.append(["balance":0,"balanceInTrade":0,"currency":currency.shortName ?? ""])
            }
        }
        depositeFilteredCurrency.insert(["balance":0,"balanceInTrade":0,"currency":"ALL"], at: 0)
        
        // Selected currency
        if let selectedCurrencyDetails = depositeFilteredCurrency[1] as NSDictionary?{
            if let currencyName = selectedCurrencyDetails.valueForCaseInsensativeKey(forKey: "currency") as? String{
                selectedCurrency = currencyName
                currencyNameAddressLabel.text = currencyName
            }
        }
        getBankDetails(currency: selectedCurrency)
        self.currencyImageView.image = MDHelper.shared.getImageByCurrencyCode(code: selectedCurrency)
        self.currencyNameLabel.text = selectedCurrency
        getNewAddressForCurrency(currency:selectedCurrency)
        self.setUpUI()
        getbalaceInfo()
        webView.navigationDelegate = self
        
        addressTitleLabel.text = localised("Address") + ":"
        copyButton.setTitle(localised("COPY"), for: .normal)
        //copyButtonForAccountNumber.setTitle(localised("COPY"), for: .normal)
        copyDestinationTagButton.setTitle(localised("COPY"), for: .normal)
        infoTextView.text = localised("- Do not use this address to deposit any other asset than the selected one. Any loss due to maloperation can not be retrieved.\n - This is your one and only address for depositing purpose. You are allowed to proceed multiple deposits simultaneously.\n - Depositing wil be done automatically. Selecting asset to transfer requires confirmation from the whole Bitcoin network. The asset you selected will be deposited into your account when reaches 6 confirmations.")
        bankDetailsLabel.text = localised("Bank Details")
        submitDepositeLabel.text = localised("Submit Deposit")
        submitButton.setTitle(localised("SUBMIT"), for: .normal)
        bankNameStaticLabel.text = localised("Bank Name")
        alreadyHaveStaticlabel.text = localised("Amount")
        inOrderStaticLabel.text = localised("IN ORDERS")
        requestAmountTextField.placeholder = localised("Request Amount")
        commentsTextField.placeholder = localised("Comments")
        requestAmountTextField.placeHolderColorCustom = Theme.current.subTitleColor
        commentsTextField.placeHolderColorCustom = Theme.current.subTitleColor
        destinationTagStaticLabel.text = localised("Destination Tag:")
        self.selectPaaymentMethodButton.setTitle("       "+localised("Select a Payment Method"), for: .normal)
        
        self.bankDetailsView.setUpBankDetailsView()
    }
    
    @objc func backAction(sender:UIButton) {
        // Some sction
//        print("fhhfghfhgfhgfhgfhgf")
        if webView.isHidden == false{
            MDAlertPopupView.showAlertPopupViewOnWidnow(title: localised("appTitle"), errorMessage: localised("Are you sure you want to cancel Deposit request?"), alertDelegate: self)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTransactionId()
       
        transparentButton.frame = CGRect(x: 0, y: 0, width: 50, height: 40  )
        transparentButton.backgroundColor = UIColor.clear
        transparentButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(transparentButton)
    }
    override func viewWillDisappear(_ animated: Bool) {
        transparentButton.removeFromSuperview()
    }
 
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
       if  self.bottomSheet != nil && (self.presentedViewController as? MDCBottomSheetController)?.presentingViewController != nil{
            
            self.bottomSheet?.dismiss(animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.changeCurrencyButtonAction(self)
            }
        
        }
        
    }
    
    
    // Set transaction ID
    func setTransactionId(){
        if let profile = UserDefaults.standard.value(forKey: "profile") as? NSDictionary{
            if let custId = profile.valueForCaseInsensativeKey(forKey: "customerid") as? String{
                transactionIdTextField.text = custId
                transactionIdTextField.isUserInteractionEnabled = false
            }
        }
    }
    //MARK: - Ui visibility helper
    func setUpUI(){
        if let selectedCurrencyDetails = appDelegate.currencySettings.filter({$0.shortName?.lowercased() == self.selectedCurrency.lowercased()}).first{
            self.selectedCurrenyDetails = selectedCurrencyDetails
            
            addressBackground.isHidden = true
            selectPaymentMethodBgView.isHidden = true
            bankDetailsView.isHidden = true
            bankDetailsSubmitView.isHidden = true
            
            // Wallet type is fiat type then we have to show all bank related stuff
            if selectedCurrencyDetails.walletType == walletTypes.fiatPG.rawValue ||
                selectedCurrencyDetails.walletType == walletTypes.fiatManual.rawValue{

                if selectedCurrencyDetails.walletType == walletTypes.fiatPG.rawValue{
                    selectPaymentMethodBgView.isHidden = false
                }else{
                    bankDetailsSubmitView.isHidden = false
                    bankDetailsView.isHidden = false
                    bankSelectionView.isHidden = false
                    bankNameStaticLabel.isHidden = false
                    sectionsSeprator.isHidden = false
                }
            }else{
                addressBackground.isHidden = false
            }
            
            if let addressSeprator = selectedCurrencyDetails.addressSeparator , addressSeprator != ""{
                destinationTagStackView.isHidden = false
            }else{
                destinationTagStackView.isHidden = true
            }
        }
        
        setUiTargets()
        
        redirectionTransactionView.isHidden = true
        transactionChargesView.isHidden = true
        
        if addressLabel.text! != ""{
            qrCodeImage.isHidden = false
            qrImageView.image = generateQRimage(fromQRString: addressLabel.text!)
        }else{
            qrCodeImage.isHidden = true
        }
        
    }
    
    func setUiTargets(){
        
        let tapToShowQRCode = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        qrCodeImage.isUserInteractionEnabled = true
        qrCodeImage.addGestureRecognizer(tapToShowQRCode)
        
        let tapToHideQRCode = UITapGestureRecognizer(target: self, action: #selector(qrBlurViewTapped(tapGestureRecognizer:)))
        qrBlurView.isUserInteractionEnabled = true
        qrBlurView.addGestureRecognizer(tapToHideQRCode)
        
        requestAmountTextField.addTarget(self, action: #selector(reqAmountDidChange(_:)), for: .editingChanged)
        
    }
    
    
    //MARK: - SHOW / HIDE BAR CODE
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        qrBlurView.isHidden = false
    }
    
    @objc func qrBlurViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        qrBlurView.isHidden = true
    }
    
    //MARK: - CALCULATING TRANSACTION CHARGES
    @objc func reqAmountDidChange(_ textField: UITextField) {
     
        if isOnlinePayment == true{
            
            print("typing req amount")
            
            if requestAmountTextField.text! != "" {
//                if Double(requestAmountTextField.text!)! >= 0 && Double(requestAmountTextField.text!)! <= 9 {
                    let calculatedFee = Double(requestAmountTextField.text!)! * (selectedCurrenyDetails!.withdrawalServiceCharge!/100)
                    let calculatedCharge = Double(requestAmountTextField.text!)! + calculatedFee
                    
                    transactionFeeNGN.text = String(format: localised("Transaction Fee") + " %.2f \(selectedCurrency)", calculatedFee)//"Transaction Fee \(calculatedFee) NGN"
                    charegesAmountNGN.text = String(format: localised("Charge Amount") + " %.2f \(selectedCurrency)", calculatedCharge)//"Charge Amount \(calculatedCharge) NGN"
            }else{
                    transactionFeeNGN.text = localised("Transaction Fee")+" 0.00 \(selectedCurrency)"
                    charegesAmountNGN.text = localised("Charge Amount")+" 0.00 \(selectedCurrency)"
                
            }
        }
    }
    
    //MARK: - UI Value Helpers
    func setBankDetails(){
        if selectedBankdetailsIndex < bankDetails.count {
            if let bankDetail = bankDetails[selectedBankdetailsIndex] as? [String:Any]{
                
                // Set bank Name
                self.bankDetailsView.setBankDetailsTextView(bankName: bankDetail["bankName"] as? String,
                                                            benName: bankDetail["beneficiaryName"] as? String,
                                                            bankRoutingCode: bankDetail["bankRoutingCode"] as? String,
                                                            AcNo: bankDetail["accountNumber"] as? String,
                                                            SwiftCode: bankDetail["swiftCode"] as? String,
                                                            location: bankDetail["branchName"] as? String)
                
                bankNameButton.setTitle("       \(bankDetail["bankName"] as! String)", for: .normal)
                
            }
        }
    }
    
    func getAttributedString(baseString:String,appendedString:String)->NSMutableAttributedString{
        let boldFont = UIFont.init(name: MDAppearance.Proxima_Nova.bold, size: 17)
        let normalFont = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 16)
        let boldTextAttribute = [NSAttributedString.Key.font:boldFont]
        let actualText = baseString + appendedString
        let actualAttributedString = NSMutableAttributedString(string: actualText)
        actualAttributedString.addAttributes(boldTextAttribute as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: baseString.count))
        actualAttributedString.addAttributes([NSAttributedString.Key.font:normalFont!], range: NSRange(location: baseString.count, length: appendedString.count))
        return actualAttributedString
    }
    
    func generateQRimage(fromQRString : String) -> UIImage{
        
        // Get data from the string
        let data = fromQRString.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        // Input the data
        qrFilter!.setValue(data, forKey: "inputMessage")
        // Get the output image
        let qrImage = qrFilter?.outputImage
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage!.transformed(by: transform)
        // Do some processing to get the UIImage
        let context = CIContext()
        let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent)
        let processedImage = UIImage(cgImage: cgImage!)
        
        return processedImage
        
    }
    
    
    
    //"0x30a310f5dbcdaa819b1b6d5369553e187d12119b"
    
    
    //MARK: - Navigation Bar helpers
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
        history_button =  UIBarButtonItem.init(customView: rightLabel)
        self.navigationItem.rightBarButtonItem = history_button
        
    }
    func showHistoryScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MDWalletHistoryVC") as! MDWalletHistoryVC
        vc.screenType = .Deposit
        vc.selectedCurrency = self.selectedCurrency
        vc.navigationTitle = localised("Deposit History")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - Setup appeareance
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        backgroundView.backgroundColor  = Theme.current.backgroundColor
        inOrderBackgroud.backgroundColor = MDAppearance.Colors.highlightBackgroundColor
        alreadyHabeBackground.backgroundColor = MDAppearance.Colors.highlightBackgroundColor
        addressBackground.backgroundColor = Theme.current.navigationBarColor
        addressTitleLabel.textColor = Theme.current.titleTextColor
        currencyNameLabel.textColor = Theme.current.titleTextColor
        currenyDownArrowImageView.tintColor = Theme.current.subTitleColor
        for customView in customSideBarBoxesStackView.arrangedSubviews{
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
        
        currencyNameAddressLabel.textColor = Theme.current.primaryColor
        addressLabel.textColor = Theme.current.titleTextColor
        copyButton.backgroundColor = Theme.current.primaryColor
        copyButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        addressLabel.textColor = Theme.current.titleTextColor
        infoTextView.textColor = Theme.current.titleTextColor
        
        // Phase 2 elements coloring
        destinationTagLabel.textColor = Theme.current.titleTextColor
        copyDestinationTagButton.backgroundColor = Theme.current.primaryColor
        copyDestinationTagButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        
        requestAmountTextField.textColor = Theme.current.titleTextColor
        requestAmountTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        transactionIdTextField.textColor = Theme.current.titleTextColor
        transactionIdTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        commentsTextField.textColor = Theme.current.titleTextColor
        commentsTextField.placeHolderColorCustom = Theme.current.subTitleColor
        
        redirectionLabel.textColor = UIColor.white
        transactionFeeLabel.textColor = UIColor.white
        transactionFeeNGN.textColor = UIColor.white
        charegesAmountNGN.textColor = UIColor.white
        
        redirectionLabel.text = localised("You will be redirected to an external website to complete your deposit.")
        transactionFeeLabel.text = localised("Trasnsaction Fee")+" 10.0%"
//        transactionFeeNGN.text = "Trasnsaction Fee 0.00 NGN"
//        charegesAmountNGN.text = "Charge Amount 0.00 NGN"
        reqAmountDidChange(self.requestAmountTextField)
        submitButton.backgroundColor = Theme.current.primaryColor
        
    }
    
    
    //MARK: - Data Fetchers
    /// This will Help to fetch wallet balance of logged in user
    func getbalaceInfo()  {
        DispatchQueue.global(qos: .background).async {
            
            if let balanceInfo = MDWalletHelper.shared.getWalletBalanceForCurrency(currency: self.selectedCurrency){
                // print(balanceInfo)
                if let inorders = balanceInfo.valueForCaseInsensativeKey(forKey: "balance") as? Double {
                    DispatchQueue.main.async {
                        self.alreadyHaveBalanceLabel.text = String(format: "%.7f", inorders)
                    }
                }
                if let alreadyhave = balanceInfo.valueForCaseInsensativeKey(forKey: "balanceInTrade") as? Double {
                    DispatchQueue.main.async {
                        self.inorderLabel.text = String(format: "%.7f", alreadyhave)
                    }
                }
                
            }
        }
    }
    
    //MARK: - Button Actions
    /// This will Copy the address of currency that you have selected
    @IBAction func copyButtonAction(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        if sender == copyButton{
            pasteboard.string = addressLabel.text
        }else if sender == copyDestinationTagButton{
             pasteboard.string = destinationTagTextField.text
        }
        MDSnackBarHelper.shared.showSuccessMessage(message: localised("Address copied"),duration: 1)
    }
    
    ///This will open the dropdown with All the currencies available
    @IBAction func changeCurrencyButtonAction(_ sender: Any) {
        
        // Filter the currencies should be shown in deposite as per currencySetting
        // if deposite is enabled in currency setting then only it should show in dropdown

        
            self.view.endEditing(true)
            let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
            let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
            dropDownVC.delegate = self
            dropDownVC.data = (depositeFilteredCurrency as NSArray).mutableCopy() as! NSMutableArray
            dropDownVC.type = .currencyList
            dropDownVC.selectedPair = selectedCurrency
            bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
            bottomSheet?.delegate = self
            bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2,
                                                      height:self.view.frame.size.height - (changeCurrencyButton.frame.origin.y + self.changeCurrencyButton.frame.size.height + self.backgroundView.frame.origin.y + (UIApplication.shared.statusBarFrame.height)))
        present(bottomSheet!, animated: true, completion: nil)
    }
    
    //MARK: - Phase 2 Button actions
    
    @IBAction func changeSelectedbankDetailsAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
        let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
        dropDownVC.type = .none
        dropDownVC.delegate = self
        
        //Convert options in to the nsmutableArray
        let mutableData = NSMutableArray()
//        let selectedIndex = 0
        for detail in bankDetails {
            let title = detail["bankName"] as? String ?? ""
            var selectedData = ["title" : title,
                                "key":title,
                                "value":detail,
                                "type":"Bank",
                                "selected":false] as [String : Any]
            
            if title.replacingOccurrences(of: " ", with: "").lowercased() == bankNameButton.titleLabel?.text!.replacingOccurrences(of: " ", with: "").lowercased(){
                //                selectedIndex = index + 1
                selectedData["selected"] = true
            }
            mutableData.add((selectedData as NSDictionary).mutableCopy() as! NSMutableDictionary)
        }
        
        dropDownVC.data = mutableData
//        dropDownVC.initialSelectedIndex = selectedIndex
        //        dropDownVC.selectedCountry = countryTextField.text!
        dropDownVC.searchBarPlaceHolder = localised("Search Bank Name")
        bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
        bottomSheet?.delegate = self
        bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2,
                                                   height: self.view.frame.size.height)
        self.present(bottomSheet!, animated: true, completion: nil)

    }

    @IBAction func changeSelectedPaymentMethodsAction(_ sender: Any) {
        
        func isSelected(text:String)->Bool{
            if let paymentMethodTitle = selectPaaymentMethodButton.titleLabel?.text {
                if paymentMethodTitle.replacingOccurrences(of: " ", with: "").lowercased() == text.replacingOccurrences(of: " ", with: "").lowercased(){
                    return true
                }
            }
            return false
        }
        
        let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
        let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
        dropDownVC.type = .none
        dropDownVC.delegate = self
        
        //Convert options in to the nsmutableArray
        let mutableData = NSMutableArray()
        mutableData.add(["title" : localised("Bank Transfer"),
                         "type":localised("Payment Method"),
                         "selected":isSelected(text: "Bank Transfer")] as [String : Any])
        mutableData.add(["title" : localised("Online Payment"),
                            "type":localised("Payment Method"),
                            "selected":isSelected(text: "Online Payment")] as [String : Any])

        dropDownVC.data = mutableData
        dropDownVC.searchBarPlaceHolder = localised("Search Bank Name")
        bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
        bottomSheet?.delegate = self
        bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2,
                                                   height: self.view.frame.size.height)
        self.present(bottomSheet!, animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        

        if isOnlinePayment == false{
            print("Submit through Bank transfer")
            if (requestAmountTextField.text!.count > 0 && transactionIdTextField.text!.count > 0) {
                print("do network req")
                
                if self.selectedCurrenyDetails?.walletType == walletTypes.fiatManual.rawValue{
                    addFiatManualDepositeRequest()
                }else if self.selectedCurrenyDetails?.walletType == walletTypes.fiatPG.rawValue{
                    if let paymentType = selectPaaymentMethodButton.titleLabel?.text{
                        if paymentType == localised("Bank Transfer"){
                            addFiatPGDepositeRequest()
                        }else{
                            addFiatManualDepositeRequest()
                        }
                    }
                }
                
            }else if requestAmountTextField.text?.count == 0 {
                MDSnackBarHelper.shared.showErroMessage(message: localised("Request amount cannot be empty"))
                
            }else if transactionIdTextField.text?.count == 0 {
                MDSnackBarHelper.shared.showErroMessage(message: localised("Transaction ID cannot be empty"))
                
            }/*else if commentsTextField.text?.count == 0 {
                MDSnackBarHelper.shared.showErroMessage(message: "Comments cannot be empty")
                
            }*/
        }else{
            print("Submit through Online transfer")
            if (requestAmountTextField.text!.count > 0) {
                print("do network req")
                if self.selectedCurrenyDetails?.walletType == walletTypes.fiatManual.rawValue{
                    addFiatManualDepositeRequest()
                }else if self.selectedCurrenyDetails?.walletType == walletTypes.fiatPG.rawValue{
                    if let paymentType = selectPaaymentMethodButton.titleLabel?.text{
                        if paymentType == localised("Online Payment"){
                            addFiatPGDepositeRequest()
                        }else{
                            addFiatManualDepositeRequest()
                        }
                    }
                }
                
            }else if requestAmountTextField.text?.count == 0 {
                MDSnackBarHelper.shared.showErroMessage(message: localised("Request amount cannot be empty"))
                
            }/*else if commentsTextField.text?.count == 0 {
                MDSnackBarHelper.shared.showErroMessage(message: "Comments cannot be empty")
                
            }*/
    }
    
}
    
    //MARK:- Network calls
    
    /// This wll fetch the address from server for the selected currency
    /// API Name: GenerateAddress
    /// - Parameter currency: String of currency selected from dropdown
    func getNewAddressForCurrency(currency:String) {
       addressLabel.text = ""
        MDHelper.shared.showHudOnWindow()
        
        let params = [
            "currency": selectedCurrency
            ,"timestamp": "\(MDNetworkManager.shared.getCurrentTimeStamp())"
            ,"recvWindow": "10"
        ]
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,methodType: .post,
                                            apiName: API.getWithdrawAddress,
            parameters: params  as NSDictionary,
            headers: headers  as NSDictionary) { (response, error) in
                
                MDHelper.shared.hideHudOnWindow()
                if response != nil && error == nil{
                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                        self.handleGetAddressResponse(response: response!)
                    }else{
                        let message = response?.valueForCaseInsensativeKey(forKey: "data") as? String ?? "Error occured"
                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                    }
                }
        }
    }
    
    
    /// This will feth the wallet balance for selected currency and its address
    ///
    /// - Parameters:
    ///   - currency: Selected currency name
    ///   - address: Currency address fetched for selected currency
    func getAddressBalance(currency:String,address:String) {
        // MDHelper.shared.showHudOnWindow()
        let apiName = "\(API.getAddressBalance)/\(API.merchantAPIKey)/\(currency)/\(address)"
        MDNetworkManager.shared.sendRequest(baseUrl:API.chartsDataURL,methodType: .get,
                                            apiName: apiName,
                                            parameters: nil,
                                            headers: nil) { (response, error) in
                                                
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        self.handleAddressBalanceResponse(response: response!)
                                                    }
                                                }
        }
    }
    
    //Phase 2
    /// This wll fetch the bank details from server for the selected currency
    /// API Name: GenerateAddress
    /// - Parameter currency: String of currency selected from dropdown
    func getBankDetails(currency:String) {
//        addressLabel.text = ""
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,methodType: .get,
                                            apiName: "\(API.getBankList)/\(currency)",
                                            parameters:nil,
                                            headers:nil) { (response, error) in
                                                
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        self.handleGetBankDetailsResponse(response: response!)
                                                    }
                                                }else{
                                                    print("Error")
                                                }
        }
    }
    
    
    
    //MARK: - Submit request network calls
    func addFiatManualDepositeRequest(){
        
        // Collect all reqired params
        
        let requestAmount = requestAmountTextField.text ?? ""
        let transactionID = transactionIdTextField.text ?? ""
        let comments = commentsTextField.text ?? ""
        
        let bankID = "\(bankDetails[selectedBankdetailsIndex]["id"] as! Int)"
        
        MDHelper.shared.showHudOnWindow()
        let params = ["RequestAmount": requestAmount,
                      "TransactionID": transactionID,
                      "Comments": comments,
                      "BankID": bankID]
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
        
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,methodType: .post,
                                            apiName: API.addFiatManualDepositRequest,
                                            parameters: params  as NSDictionary,
                                            headers: headers  as NSDictionary) { (response, error) in
                                                
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if let message = response?.valueForCaseInsensativeKey(forKey: "message") as? String{
                                                            
                                                            self.requestAmountTextField.text = ""
                                                            self.commentsTextField.text = ""
                                                            self.reqAmountDidChange(self.requestAmountTextField)
//                                                            self.transactionIdTextField.text = ""
                                                            self.setTransactionId()
                                                            MDSnackBarHelper.shared.showSuccessMessage(message: message)
                                                        }
                                                    }else{
                                                        if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? String {
                                                            MDSnackBarHelper.shared.showErroMessage(message: data)
                                                        }
                                                    }
                                                }
        }
        
    }
    
    
    func addFiatPGDepositeRequest(){
        // Collect all reqired params
        
        let requestAmount = requestAmountTextField.text ?? ""
        let transactionID = transactionIdTextField.text ?? ""
        let comments = commentsTextField.text ?? ""
        
        MDHelper.shared.showHudOnWindow()
        let params = ["amount": requestAmount,
                      "currency": selectedCurrency,
                      "comment": comments,
                      "timestamp": "\(MDNetworkManager.shared.getCurrentTimeStamp())",
                      "recvWindow": "1000"]
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
        
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,methodType: .post,
                                            apiName: API.addFiatPGDepositRequest,
                                            parameters: params  as NSDictionary,
                                            headers: headers  as NSDictionary) { (response, error) in
                                                
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if let message = response?.valueForCaseInsensativeKey(forKey: "message") as? String{
                                                            self.requestAmountTextField.text = ""
                                                            self.commentsTextField.text = ""
//                                                            self.transactionIdTextField.text = ""
                                                            self.setTransactionId()
                                                            self.reqAmountDidChange(self.requestAmountTextField)
//                                                            MDSnackBarHelper.shared.showSuccessMessage(message: message)
                                                            if let responseurl = response?.value(forKeyPath: "data.redirectURL") as? String{
                                                                if let url = URL(string: responseurl){
//                                                                    UIApplication.shared.openURL(url)
                                                                    self.responseURL = response?.value(forKeyPath: "data.responseURL") as? String ?? ""
                                                                    let urlRequest = URLRequest(url: url)
                                                                    self.webView.isHidden = false
                                                                    self.webView.load(urlRequest)
                                                                    self.navigationItem.rightBarButtonItem = nil
                                                                }
                                                            }
                                                        }
                                                    }else{
                                                        if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? String {
                                                            MDSnackBarHelper.shared.showErroMessage(message: data)
                                                        }
                                                    }
                                                }
        }
    }
    
    
    //MARK: - Response Handlers

    
    func handleGetBankDetailsResponse(response:NSDictionary){
        if let data = response.valueForCaseInsensativeKey(forKey: "data") as? [[String:Any]]{
            bankDetails = data
            selectedBankdetailsIndex = 0
            setBankDetails()
        }
    }
    
    func handleGetAddressResponse(response:NSDictionary){
        if let data = response.valueForCaseInsensativeKey(forKey:"data") as? NSDictionary{
            if let address = data.valueForCaseInsensativeKey(forKey: "address") as? String{
             
                addressLabel.text = address
                
                // Set destination tag also if available
                let separatedStrings = address.lowercased().components(separatedBy: (selectedCurrenyDetails?.addressSeparator ?? "").lowercased())
                if separatedStrings.count > 1{
                    addressLabel.text = separatedStrings.first
                    
                    self.destinationTagTextField.text = separatedStrings[1]
                }else{
                    self.destinationTagTextField.text = "N/A"
                }
                
                if addressLabel.text! != ""{
                    qrCodeImage.isHidden = false
                    qrImageView.image = generateQRimage(fromQRString: addressLabel.text!)
                }else{
                    qrCodeImage.isHidden = true
                }
               // getAddressBalance(currency: selectedCurrency, address: address)
            }
        }
        
    }
    
    func handleAddressBalanceResponse(response:NSDictionary){
        if let data = response.valueForCaseInsensativeKey(forKey:"data") as? NSDictionary{
            if let balance = data.valueForCaseInsensativeKey(forKey: "Balance") as? Double{
                alreadyHaveBalanceLabel.text = String(format: "%.4f", balance)
                //addressLabel.text = address
            }
        }
    }
    
}

//MARK: - Dropdown delegates
extension MDDepositVC:customDropDownDelegates{
    func dropDownSelected(title: String, data: NSDictionary) {
        allCurrencyView.isHidden = true
        if self.navigationItem.rightBarButtonItem == nil{
            self.setNavigationbar()
        }
        requestAmountTextField.text = ""
        //        transactionIdTextField.text = ""
        commentsTextField.text = ""
        
        if let type = data.valueForCaseInsensativeKey(forKey: "type") as? String{
            if type == "Bank"{
                selectedBankdetailsIndex = self.bankDetails.firstIndex(where: {$0["bankName"] as! String == title}) ?? 0
                setBankDetails()
            }else if type == localised("Payment Method"){
                
                
                bankDetailsSubmitView.isHidden = false
                
                self.selectPaaymentMethodButton.setTitle("       \(title)", for: .normal)
                if title == localised("Bank Transfer"){
                    isOnlinePayment = false
                    
                    bankDetailsView.isHidden = false
                    sectionsSeprator.isHidden = false
                    transactionIdTextField.superview!.isHidden = false
                    
                    redirectionTransactionView.isHidden = true
                    transactionChargesView.isHidden = true
                    
                    bankNameStaticLabel.isHidden = false
                    bankSelectionView.isHidden = false
                }else{
                    
                    isOnlinePayment = true
                    sectionsSeprator.isHidden = true
                    bankDetailsView.isHidden = true
                    
                    transactionIdTextField.superview!.isHidden = true
                    
                    redirectionTransactionView.isHidden = false
                    transactionChargesView.isHidden = false
                    
                    bankNameStaticLabel.isHidden = true
                    bankSelectionView.isHidden = true
                    self.reqAmountDidChange(self.requestAmountTextField)
                    
                }
            }
        }else{
            
            self.selectedCurrency = title
            self.currencyNameLabel.text = title
            self.currencyImageView.image = MDHelper.shared.getImageByCurrencyCode(code: title)

            self.currencyNameAddressLabel.text = title
            self.bottomSheet = nil
            setUpUI()
            setTransactionId()
            self.selectPaaymentMethodButton.setTitle("       "+localised("Select a Payment Method"), for: .normal)
            if self.navigationItem.rightBarButtonItem == nil{
                self.setNavigationbar()
            }
            if title.lowercased() == "all"{
                addressBackground.isHidden = true
                selectPaymentMethodBgView.isHidden = true
                bankDetailsView.isHidden = true
                bankDetailsSubmitView.isHidden = true
                allCurrencyView.isHidden = false
                self.navigationItem.rightBarButtonItem = nil
            }else{
                
                //Avoid Get new Address API for Fiat
                
                // Wallet type is fiat type then we have to show all bank related stuff
                if let selectedCurrencyDetails = self.selectedCurrenyDetails{
                    if selectedCurrencyDetails.walletType == walletTypes.fiatPG.rawValue ||
                        selectedCurrencyDetails.walletType == walletTypes.fiatManual.rawValue{
                        self.getBankDetails(currency: selectedCurrency)
                    }else{
                        self.addressBackground.isHidden = false
                        self.getNewAddressForCurrency(currency: title)
                    }
                }
                
                
          
                self.getbalaceInfo()

            }
            
        }
        
        if addressLabel.text! != ""{
            qrCodeImage.isHidden = false
            qrImageView.image = generateQRimage(fromQRString: addressLabel.text!)
        }else{
            qrCodeImage.isHidden = true
        }
        
        transactionFeeLabel.text = localised("Transaction Fee")+" \(selectedCurrenyDetails!.withdrawalServiceCharge!)%"
        
    }
}

//MARK: - Bottom Sheet Delegates

extension MDDepositVC : MDCBottomSheetControllerDelegate {
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        print(controller)
        self.bottomSheet = nil
    }
    
}


extension MDDepositVC:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start provision")
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("redirect proviion ")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("provision fail")
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("process terminate")
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("process did commit")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish")
//        print("URL: \(webView.url)")
//        print("URL response:\(responseURL)")
        if (webView.url?.absoluteString.contains(responseURL))!{
            webView.isHidden = true
            MDSnackBarHelper.shared.showSuccessMessage(message: "Sucess")
            setNavigationbar()
            if let clearURL = URL(string: "about:blank") {
                webView.load(URLRequest(url: clearURL))
            }
        }
    }

    
}
extension MDDepositVC:alertPopupDelegate{
    ///Handle Alert popup click
    func alertPopupResponse(isAgree: Bool) {
        if isAgree == true {
            self.webView.isHidden = true
            setNavigationbar()
            if let clearURL = URL(string: "about:blank") {
                webView.load(URLRequest(url: clearURL))
            }
        }
    }
}
