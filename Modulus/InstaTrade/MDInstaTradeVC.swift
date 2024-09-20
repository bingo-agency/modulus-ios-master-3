//
//  MDInstaTradeVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/13/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import DropDown

class MDInstaTradeVC: UIViewController {

    @IBOutlet weak var lbl_1_coinEstimation: UILabel!
    @IBOutlet weak var lbl_1coinValue: UILabel!
    @IBOutlet weak var lbl_1coinCurrency: UILabel!
    
    @IBOutlet weak var lbl_valueyouhave: UILabel!
    @IBOutlet weak var lbl_valueyouhave_second: UILabel!
    
    @IBOutlet weak var spendBetweenLbl: UILabel!
    
    @IBOutlet weak var payment_amount_textfield: UITextField!
    @IBOutlet weak var receive_amount_textfield: UITextField!
    
    @IBOutlet weak var btn_buySell: UIButton!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var payment_currrency_lbl: UILabel!
    @IBOutlet weak var received_curreny_lbl: UILabel!
    @IBOutlet weak var payment_error_msg: UILabel!
    
    @IBOutlet weak var payment_currency_imgView: UIImageView!
    @IBOutlet weak var received_curreny_imageView: UIImageView!
    @IBOutlet weak var lbl_spend: UILabel!
    
    @IBOutlet weak var receiveAmtLabel: UILabel!
    @IBOutlet weak var paymentAnchorView: UIView!
    @IBOutlet weak var receiveAnchorView: UIView!
    @IBOutlet weak var thisAmountIsEstimatedLabel: UILabel!
    @IBOutlet weak var viewYouInstaTradeBtn: UIButton!
    @IBOutlet weak var youHaveLbl: UILabel!
    
    @IBOutlet weak var arrowImg1: UIImageView!
    @IBOutlet weak var arrowImg2: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var market = ""
    var trade = ""
    var minValue = 0.0
    var maxValue = 0.0
    var rate = 0.0
    var walletBalance = [NSDictionary]()
    
    var sourceIndex = 0{
        didSet{
            if self.fiatPairs.indices.contains(self.sourceIndex){
                self.updateUI()
            }
        }
    }
    
    var qouteIndex = 0{
        didSet{
            if self.fiatPairs.indices.contains(self.sourceIndex){
                if self.fiatPairs[sourceIndex].1.indices.contains(self.qouteIndex){
                    self.updateUI()
                }
            }
        }
    }
    
    var fiatPairs : [(String,[[String:Any]])] = []
    let notification_name:Notification.Name = Notification.Name(rawValue: "Login_BroadcastNotification")
    
    override func viewDidLoad() {
        self.getInstaPairs()
        self.fetchWalletBalance()
        super.viewDidLoad()
        self.setUpNavigation()
        self.addObservers()
        self.setUpColors()
        
    }
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = "Buy / Sell"
        self.navigationItem.titleView = label
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        self.lbl_1_coinEstimation.textColor = Theme.current.titleTextColor
        self.lbl_1coinValue.textColor = Theme.current.titleTextColor
        self.lbl_1coinCurrency.textColor = Theme.current.titleTextColor
        self.paymentAmountLabel.textColor = Theme.current.titleTextColor
        self.spendBetweenLbl.textColor = Theme.current.titleTextColor
        self.receiveAmtLabel.textColor = Theme.current.titleTextColor
        self.thisAmountIsEstimatedLabel.textColor = Theme.current.titleTextColor
        self.btn_buySell.backgroundColor = Theme.current.primaryColor
        
        self.payment_currrency_lbl.textColor = Theme.current.titleTextColor
        self.received_curreny_lbl.textColor = Theme.current.titleTextColor
        
        
        let attrFirstText = NSMutableAttributedString(string: "View you InstaTrade order history",
                                                      attributes: [NSAttributedString.Key.foregroundColor : Theme.current.titleTextColor,
                                                                   NSAttributedString.Key.font: UIFont(name: MDAppearance.Proxima_Nova.regular, size: 16)!])
        let hereAttrText = NSMutableAttributedString.init(string: " here", attributes: [NSAttributedString.Key.foregroundColor : Theme.current.redColor,
                                                                                       NSAttributedString.Key.font: UIFont(name: MDAppearance.Proxima_Nova.regular, size: 16)!])
        

        attrFirstText.append(hereAttrText)
        
        self.viewYouInstaTradeBtn.setAttributedTitle(attrFirstText, for: .normal)
        
        self.btn_buySell.setTitleColor(Theme.current.btnTextColor, for: .normal)
        self.lbl_valueyouhave.backgroundColor = Theme.current.mainTableCellsBgColor
        self.lbl_valueyouhave_second.backgroundColor = Theme.current.mainTableCellsBgColor
        
        self.lbl_valueyouhave.textColor = Theme.current.titleTextColor
        self.lbl_valueyouhave_second.textColor = Theme.current.titleTextColor
        
        self.youHaveLbl.textColor = Theme.current.titleTextColor
        self.payment_amount_textfield.textColor = Theme.current.titleTextColor
        self.receive_amount_textfield.textColor = Theme.current.titleTextColor
        
        self.payment_amount_textfield.placeHolderColorCustom = Theme.current.subTitleColor
        self.receive_amount_textfield.placeHolderColorCustom = Theme.current.subTitleColor
        
        self.arrowImg1.tintColor = Theme.current.titleTextColor
        self.arrowImg2.tintColor = self.arrowImg1.tintColor
    }
    
    func addObservers(){
        self.payment_amount_textfield.addTarget(self, action: #selector(searchTextChange), for: UIControl.Event.editingChanged)
        self.receive_amount_textfield.addTarget(self, action: #selector(searchTextChange), for: UIControl.Event.editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.islogingSuccessfully), name: notification_name, object: nil)
    }
    
    func showDropDown(anchorView : UIView,source : [String],isBase : Bool){
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.direction = .bottom
        dropDown.dataSource = source
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if isBase{
                self.payment_currrency_lbl.text = item
                self.sourceIndex = index
            }else{
                self.qouteIndex = index
                self.received_curreny_lbl.text = item
            }
        }
        dropDown.width = 100
        dropDown.show()

    }
    
    func updateUI(){
        var quoteCurrency = ""
        if !self.fiatPairs.indices.contains(sourceIndex){
            return
        }
        
        let baseCurrency = self.fiatPairs[sourceIndex].0
        if self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "quoteCurrency") as? String ?? ""}).indices.contains(self.qouteIndex){
            quoteCurrency = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "quoteCurrency") as? String ?? ""})[self.qouteIndex]
            self.minValue = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "minLimit") as? Double ?? 0.0})[self.qouteIndex]
            self.maxValue = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "maxLimit") as? Double ?? 0.0})[self.qouteIndex]
            self.rate = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "rate") as? Double ?? 0.0})[self.qouteIndex]
        }else{
            quoteCurrency = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "quoteCurrency") as? String ?? ""}).first ?? ""
            self.minValue = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "minLimit") as? Double ?? 0.0}).first ?? 0.0
            self.maxValue = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "maxLimit") as? Double ?? 0.0}).first ?? 0.0
            self.rate = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "rate") as? Double ?? 0.0}).first ?? 0.0
        }
        
        self.market = baseCurrency
        self.trade = quoteCurrency
        
        let baseCurrencyDict = self.walletBalance.first { (dictData) -> Bool in
            (dictData.value(forKey: "currency") as? String ?? "") == baseCurrency
        }
        
        let qouteCurrencyDict = self.walletBalance.first { (dictData) -> Bool in
            (dictData.value(forKey: "currency") as? String ?? "") == quoteCurrency
        }
        
        self.lbl_valueyouhave.text = "\(baseCurrencyDict?.value(forKey: "balance") as? Double ?? 0.0)" + " \(baseCurrency)"
        self.lbl_valueyouhave_second.text = "\(qouteCurrencyDict?.value(forKey: "balance") as? Double ?? 0.0)" + " \(quoteCurrency)"
        
        self.spendBetweenLbl.text = "Spend between \(self.minValue) and \(self.maxValue) \(baseCurrency)"
        self.lbl_1_coinEstimation.text = localised("1 \(quoteCurrency) roughly equals") 
        self.lbl_1coinValue.text = MDHelper.shared.getFormattedNumber(amount: 1/self.rate, minimumFractionDigits: 8) ?? ""
        self.lbl_1coinCurrency.text = baseCurrency
        self.received_curreny_lbl.text = quoteCurrency
        if MDHelper.shared.isUserLoggedIn(){
            self.btn_buySell.setTitle("Buy \(quoteCurrency)", for: [])
        }else{
            self.btn_buySell.setTitle("Login or Register", for: [])
            
        }
        
        
        
        
        self.payment_currency_imgView.image = MDHelper.shared.getImageByCurrencyCode(code: baseCurrency)
        self.received_curreny_imageView.image = MDHelper.shared.getImageByCurrencyCode(code: quoteCurrency)
    }
    
    private
    func getConvertedValue(quoteCurrency:String , baseCurrency:String)->String{
        let usdValue1 = MDHelper.shared.getCurrencyValueInUSD(currency: baseCurrency) ?? 1
        let usdValue2 = MDHelper.shared.getCurrencyValueInUSD(currency: quoteCurrency) ?? 1

        return MDHelper.shared.getFormattedNumber(amount: usdValue1/usdValue2, minimumFractionDigits: 8) ?? ""
        
    }
    
    @objc func islogingSuccessfully(){
        DispatchQueue.main.async { [weak self] in
            self?.viewDidLoad()
        }
        
    }
    
    //MARK:------ IBActions --------
    
    @IBAction func paymentAmtDropDown(_ sender: Any) {
        self.showDropDown(anchorView: self.paymentAnchorView,
                          source : self.fiatPairs.map({ $0.0 }),
                          isBase: true)
    }
    
    @IBAction func receiveAmntDropDown(_ sender: Any) {
        let source = self.fiatPairs[sourceIndex].1.map({ ($0 as NSDictionary).value(forKey: "quoteCurrency") as? String ?? ""})
        self.showDropDown(anchorView: self.receiveAnchorView,
                          source : source,
                          isBase: false)
    }
    
    @IBAction func buySellAction(_ sender: Any) {
        
        if !MDHelper.shared.isUserLoggedIn(){
            //Show login
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewc = storyboard.instantiateInitialViewController() as! UINavigationController
            if let navBar = UIApplication.shared.topMostViewController() as? UINavigationController{
                navBar.pushViewController(viewc, animated: true)
            }else if let tabBar =  UIApplication.shared.topMostViewController() as? UITabBarController{
                viewc.modalPresentationStyle = .fullScreen
                tabBar.present(viewc, animated: true, completion: nil)
//                (tabBar.selectedViewController as? UINavigationController)?.pushViewController(viewc.viewControllers.first!, animated: true)
            }
            return
        }
        
        if self.payment_amount_textfield.text!.isEmpty {
            //Show errors here
            self.payment_error_msg.text = "Must be greater than or equal to \(self.minValue)"
            self.payment_error_msg.isHidden = false
            return
        }
        if Double(self.payment_amount_textfield.text ?? "0") ?? 0 < self.minValue{
            //Show errors here
            self.payment_error_msg.text = "Must be greater than or equal to \(self.minValue)"
            self.payment_error_msg.isHidden = false
            return
        }
        if Double(self.payment_amount_textfield.text ?? "0") ?? 0 > self.maxValue{
            //Show errors here
            self.payment_error_msg.text = "Must be less than or equal to \(self.maxValue)"
            self.payment_error_msg.isHidden = false
            return
        }
        
        
        
        
        let doubtValue = Double(self.payment_amount_textfield.text ?? "0") ?? 0
        
        self.makeBuySellCall(market: self.market,
                             trade: self.trade,
                             amount: doubtValue)
    }
    
    @IBAction func seeTradeHistory(_ sender: Any) {
        if let _ = UserDefaults.standard.value(forKey: "AccessToken") as? String{
            self.performSegue(withIdentifier: "getInstaTrades", sender: self)
        }else{
            MDHelper.shared.showErrorAlert(message: "Please login to see history", viewController: self)
        }
        
    }
}

//MARK: - Textfield Delegates
extension MDInstaTradeVC : UITextFieldDelegate {
    
    @objc func searchTextChange(_ textField:UITextField) {
        self.payment_error_msg.isHidden = true
        
        if textField == self.payment_amount_textfield{
            let amount = self.payment_amount_textfield.text ?? "0"
            self.receive_amount_textfield.text = "\(self.rate * (Double(amount) ?? 0))"
        }else{
            let amount = self.receive_amount_textfield.text ?? "0"
            self.payment_amount_textfield.text = "\((Double(amount) ?? 0) / self.rate)" // here 1 will be replaced by conversion value between 2 currencies
        }
    }
    
}

//MARK: - API Calls
extension MDInstaTradeVC {
    
    func fetchWalletBalance(){
        let params = [
            "currency": "ALL",
            "timestamp":"\(MDNetworkManager.shared.getCurrentTimeStamp())",
            "recvWindow": "1000"
        ]  // String(Date().toMillis())
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
        
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .post,
                                            apiName: API.getWalletBalance,
                                            parameters: params as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
                                            MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? [NSDictionary]{
                                                            self.walletBalance = data
                                                            DispatchQueue.main.async { [weak self] in
                                                                self?.updateUI()
                                                            }
                                                        }
                                                    }
                                                }else{
                                                    if  error != nil{
                                                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                         MDHelper.shared.hideHud(view: self.view)
                                                    }
                                                     MDHelper.shared.hideHud(view: self.view)
                                                }
        }
        
    }
    
    func getInstaPairs(){
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .get,
                                            apiName: API.get_insta_pairs,
                                            parameters: nil,
                                            headers: nil) { (response, error) in
                                                //Handle Response Here
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if let data = response?.value(forKey: "data") as? [NSDictionary]{
                                                            self.handlePairsResponse(data: data)
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
    
    func handlePairsResponse(data : [NSDictionary]){
        //var baseCurrencies = [String]()
        data.forEach { (eachData) in
            let tuppleValues = ["quoteCurrency":eachData.value(forKey: "quoteCurrency") as? String ?? "",
                                "minLimit":eachData.value(forKey: "minLimit") as? Double ?? 0.0,
                                "maxLimit":eachData.value(forKey: "maxLimit") as? Double ?? 0.0,
                                "rate":eachData.value(forKey: "rate") as? Double ?? 0.0] as [String : Any]
            
            let baseCurrency = eachData.value(forKey: "baseCurrency") as? String ?? ""
            if self.fiatPairs.map({ $0.0 }).contains(baseCurrency){
                let firstIndex = self.fiatPairs.firstIndex(where: { $0.0 == baseCurrency}) ?? 0
                self.fiatPairs[firstIndex].1.append(tuppleValues)
            }else{
                self.fiatPairs.append((baseCurrency,
                                       [tuppleValues]))
            }
        }
        self.sourceIndex = 0
    }
    
    func makeBuySellCall(market : String,
                         trade : String,
                         amount : Double){
        
        let headers = ["Content-Type": "application/json",
                       "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"] as [String : Any]
        
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .post,
                                            apiName: API.request_insta_trade,
                                            parameters: ["baseCurrency": market,
                                                         "quoteCurrency":trade,
                                                         "baseAmount":amount],
                                            headers: headers as NSDictionary) { (response, error) in
                                                //Handle Response Here
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String ?? ""
                                                        MDHelper.shared.showSucessAlert(message: message, viewController: self)
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
    
    
    
}
