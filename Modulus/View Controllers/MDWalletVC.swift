//
//  MDWalletVC.swift
//  Modulus
//
//  Created by Pathik  on 12/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDWalletVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    //MARK: - StoryBoard outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var hideShowButton: UIButton!
    @IBOutlet weak var hideShowImageView: UIImageView!
    @IBOutlet weak var hideShowLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var openOrderButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var depositButton: UIButton!
    @IBOutlet weak var inorderLabel: UILabel!
    @IBOutlet weak var availabalePriceLabel: UILabel!
    @IBOutlet weak var estimatedPriceLabel: UILabel!
    @IBOutlet weak var estimatedValueLabel: UILabel!//MARK: - Constants
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var holdingButton: UIButton!
    @IBOutlet weak var nameColumnSortStackView: sortIndicatorStackView!
    @IBOutlet weak var holdingSortStackview: sortIndicatorStackView!
    @IBOutlet weak var customBalanceViewsStackView: UIStackView!
    @IBOutlet weak var DepWithOpenOrdeBgView: UIView!
    @IBOutlet weak var tableColumnsView: UIView!
    @IBOutlet weak var shadowImageView: UIImageView!
    @IBOutlet weak var hideShowAssetsBgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var holdingLabel: UILabel!
    @IBOutlet weak var inorderlabel: UILabel!
    
    //MARK: - Constants
    let navigationTitle = localised("Wallet")
    let rowHeight = 80
    let headerHeight = 40
    let cellIdenitifier = "WalletTableCell"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let notification_name:Notification.Name = Notification.Name(rawValue: "Login_BroadcastNotification")
    
    //MARK: - Variables

    var walletData:NSArray = []
    var walletOriginalData:NSArray = []
    var walletOriginalDataWithoutSmallAmount:NSArray = []
    var rightTitle = UITextField()
    var isHideAssetsWithSmall = false
    var temp_data:NSArray = []
    private var estimatedCurrency : String = "USD" //CurrecyForWhichEstimationShouldShow
    
    //MARK: - Automation Identifiers
    func addAutomationIdentifiers(){
        //For Automation
        self.openOrderButton.accessibilityValue = "openOrderButton"
        self.openOrderButton.accessibilityIdentifier = "openOrderButton"
        self.openOrderButton.accessibilityLabel = "openOrderButton"
        
        self.depositButton.accessibilityValue = "depositButton"
        self.depositButton.accessibilityIdentifier = "depositButton"
        self.depositButton.accessibilityLabel = "depositButton"
        
        self.withdrawButton.accessibilityValue = "withdrawButton"
        self.withdrawButton.accessibilityIdentifier = "withdrawButton"
        self.withdrawButton.accessibilityLabel = "withdrawButton"
        
        self.tableView.isAccessibilityElement = true
        self.tableView.accessibilityValue = "walletTableView"
        self.tableView.accessibilityIdentifier = "walletTableView"
        self.tableView.accessibilityLabel = "walletTableView"
        
        self.nameButton.accessibilityValue = "nameButton"
        self.nameButton.accessibilityIdentifier = "nameButton"
        self.nameButton.accessibilityLabel = "nameButton"
        
        self.holdingButton.accessibilityValue = "holdingButton"
        self.holdingButton.accessibilityIdentifier = "holdingButton"
        self.holdingButton.accessibilityLabel = "holdingButton"
    }
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addAutomationIdentifiers()
        setNavigationbar()
        setUpColors()
        nameColumnSortStackView.configureStack()
        holdingSortStackview.configureStack()
        appDelegate.fetchCoinsInfo() // Fetch dropdown list of currency
        
        nameLabel.text  = localised("Name")
        holdingLabel.text = localised("Holding")
         
        depositButton.setTitle(localised("Deposit"), for: .normal)
        withdrawButton.setTitle(localised("Withdrawal"), for: .normal)
        openOrderButton.setTitle(localised("Open Orders"), for: .normal)
         
         
        availabalePriceLabel.text = localised("AVAILABLE").localizedUppercase
        estimatedValueLabel.text = localised("ESTIMATED VALUE").localizedUppercase
        inorderlabel.text = localised("IN ORDERS").localizedUppercase
        
        ///Adjust estimated text size so it will fixed on all devices
        self.estimatedPriceLabel.adjustsFontSizeToFitWidth = true
        self.estimatedPriceLabel.minimumScaleFactor = 0.2
        
        self.availableLabel.adjustsFontSizeToFitWidth = true
        self.availableLabel.minimumScaleFactor = 0.2
        
        self.inorderlabel.adjustsFontSizeToFitWidth = true
        self.inorderlabel.minimumScaleFactor = 0.2
        
        self.addObserver()
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        //self.tableView.bouncesZoom = false
       // self.tableView.alwaysBounceVertical = false
        
    }
    
    @objc func update() {
        // Something cool
        DispatchQueue.main.async {
            let AccessToken = UserDefaults.standard.value(forKey: "AccessToken") as? String ?? ""
            if AccessToken != ""{
                self.fetchWalletBalance()
            }else{
                print("User not logged in so do not refresh")
            }
            
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newSize = change?[.newKey] as? CGSize{
                DispatchQueue.main.async {
                    if newSize.height == 0 {
                        self.tableViewHeightLC.constant = 500
                    }else{
                        self.tableViewHeightLC.constant = newSize.height + 20
                    }
                }
              
            }
        }
    }
    
    @objc func refreshUI(){
        self.walletOriginalDataWithoutSmallAmount = self.getWithoutSmallAmout(dataArray: self.walletOriginalData)
        self.selAllBalanceAndTrade(dataArray: temp_data)
        if self.nameColumnSortStackView.tag == 0 || self.nameColumnSortStackView.tag == 1/*2 is both deselected*/{
            self.sortByNameWithIndicator()
        }
        if self.holdingSortStackview.tag == 0 || self.holdingSortStackview.tag == 1{
            self.sortByHoldingIndicator()
        }
        self.tableView.reloadData()
        self.toggleHideShowAssets()
    }
    override func viewWillAppear(_ animated: Bool) {
        if MDHelper.shared.isUserLoggedIn() == true{
            fetchWalletBalance()
        }else{
//            MDHelper.shared.showYouWantToLoginPopUp()
            availableLabel.text = String(format: "%.2f", 0)
            inorderLabel.text = String(format: "%.2f", 0)
            estimatedPriceLabel.text = String(format: "%.2f", 0)
            let myRange = NSRange(location: 2, length: 1)
            let attributedText = NSMutableAttributedString.init(string:  "≈ 0 BTC")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value:Theme.current.primaryColor, range: myRange)
            rightTitle.attributedText = attributedText
        }
        toggleHideShowAssets()
        ///set Estimated Currency Value From userDefaults
        if let selectedCurrencyDetails = UserDefaults.standard.value(forKey: "fiatSelectedCurrency") as? [String:Any],
           let currencyName = selectedCurrencyDetails["currency"] as? String{
            self.estimatedCurrency = currencyName
  
        }
    }
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: Notification.Name(rawValue: "userLoggedIn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUI), name: Notification.Name(rawValue: "coinsrefresh"), object: nil)
        if MDHelper.shared.isUserLoggedIn() == true{
            NotificationCenter.default.addObserver(self, selector: #selector(self.islogingSuccessfully), name: notification_name, object: nil)
        }
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    @objc func islogingSuccessfully(){
        self.viewWillAppear(false)
        NotificationCenter.default.removeObserver(self, name:notification_name, object: nil)
        NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "coinsrefresh"), object: nil)
    }
    //MARK: - Navigation bar helprs
    func setNavigationbar(){
        
        
        let leftTitle = UITextField(frame: CGRect(x: 0, y: 20, width: 100, height: (self.navigationController?.navigationBar.frame.size.height)!))
        leftTitle.contentVerticalAlignment = .bottom
        leftTitle.borderStyle = .none
        leftTitle.isUserInteractionEnabled = false
        leftTitle.textColor = Theme.current.titleTextColor
        leftTitle.font = MDAppearance.Fonts.largeNavigationTitleFont
        leftTitle.text = navigationTitle
        leftTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        leftTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftTitle)
        
        
        rightTitle = UITextField(frame: CGRect(x: 0, y: 20, width: 250, height: (self.navigationController?.navigationBar.frame.size.height)!))
        rightTitle.contentVerticalAlignment = .bottom
        rightTitle.borderStyle = .none
        rightTitle.isUserInteractionEnabled = false
        rightTitle.textColor = Theme.current.titleTextColor
        rightTitle.font = MDAppearance.Fonts.rightNavigationTitle
        let myRange = NSRange(location: 2, length: 1)
        let attributedText = NSMutableAttributedString.init(string:  "≈ 0 BTC")
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value:Theme.current.primaryColor, range: myRange)
        rightTitle.attributedText = attributedText
        rightTitle.textAlignment = .right
        rightTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightTitle)
    }
    
    //MARK:- setup appeareance
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        backgroundView.backgroundColor  = Theme.current.backgroundColor
        tableView.backgroundColor = UIColor.clear
        headerView.backgroundColor = Theme.current.navigationBarColor
        hideShowAssetsBgView.backgroundColor = Theme.current.backgroundColor
        
        // Custom views with side bar showing
        // EStimated value , available , inorders
        for customView in customBalanceViewsStackView.arrangedSubviews{
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
        
        DepWithOpenOrdeBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        let depositeWithOpenOrderStackView = DepWithOpenOrdeBgView.subviews.filter({$0 is UIStackView}).first as! UIStackView
        for v in depositeWithOpenOrderStackView.arrangedSubviews{
            if let button = v as? UIButton{
                button.setTitleColor(Theme.current.titleTextColor, for: .normal)
                button.tintColor = Theme.current.titleTextColor
            }
        }
        
        
        tableColumnsView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        for columnView in tableColumnsView.subviews.first!.subviews{
            for columnViewSubView in columnView.subviews{
                if let label = columnViewSubView as? UILabel{
                    label.textColor = Theme.current.titleTextColor
                }
            }
        }
        
        shadowImageView.tintColor = Theme.current.backgroundColor
        hideShowLabel.textColor = Theme.current.titleTextColor
        
    }

    
    
    ///This will Hide/Show small assets (Small asssets which will be <= 0.001)
    func toggleHideShowAssets()  {
        if isHideAssetsWithSmall == false {
            self.hideShowLabel.text = localised("Hide assets with small amounts")
            self.hideShowImageView.image = UIImage.init(named: "password-eye")!.imageWithColor(color1: Theme.current.subTitleColor)
            self.walletData = self.walletOriginalData
        }else {
            self.hideShowLabel.text = localised("Show assets with small amounts")
            self.hideShowImageView.image = UIImage.init(named: "password-eye-close")!.imageWithColor(color1: Theme.current.titleTextColor)
            
            self.walletData = self.walletOriginalDataWithoutSmallAmount
        }
        if self.nameColumnSortStackView.tag == 0 || self.nameColumnSortStackView.tag == 1/*2 is both deselected*/{
            self.sortByNameWithIndicator()
        }
        if self.holdingSortStackview.tag == 0 || self.holdingSortStackview.tag == 1{
            self.sortByHoldingIndicator()
        }
        self.tableView.reloadData()
    }
    
    /// This will filter wallet balance by neglecting Small amounts
    func getWithoutSmallAmout(dataArray:NSArray) ->NSArray {
        return dataArray.filter { (item) -> Bool in
            let dict1 = item as! NSDictionary
            
            if let balance1 = dict1.valueForCaseInsensativeKey(forKey: "balance") as? Double{
                return balance1>0.001
            }
            return true
            } as NSArray
    }
    
    // MARK: - Button Actions
    @IBAction func hideAssetsAction(_ sender: Any) {
        isHideAssetsWithSmall = !isHideAssetsWithSmall
        toggleHideShowAssets()
    }
    
    @IBAction func btn_banks_action(_ sender: Any) {
        //self.performSegue(withIdentifier: "MDAddBankVC", sender: self)
    }
    @IBAction func btn_cryptoaddressAction(_ sender: Any) {
        self.performSegue(withIdentifier: "MDAddressBook", sender: self)
    }
    @IBAction func openOrderButtonAction(_ sender: Any) {
        let ordersVC = self.storyboard?.instantiateViewController(withIdentifier: "ListScreen") as! MarketListVC
        ordersVC.isMarketScreen = false
        ordersVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ordersVC, animated: true)
    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
        if self.walletData.count == 0{
             MDHelper.shared.showErrorPopup(message:("Could not fetch wallet details"))
        }else{
         performSegue(withIdentifier: "MDWithdrawVC", sender: "Withdrawal")
        }
        
    }
    
    @IBAction func depositButtonAction(_ sender: Any) {
        if self.walletData.count == 0{
             MDHelper.shared.showErrorPopup(message:("Could not fetch wallet details"))
        }else{
            performSegue(withIdentifier: "MDDepositVC", sender: "Deposit")
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.destination is MDDepositVC {
        let viewC = segue.destination as! MDDepositVC
            viewC.navigationTitle = localised(sender as! String)
        viewC.hidesBottomBarWhenPushed = true
        }else if segue.destination is MDWithdrawVC {
            let viewC = segue.destination as! MDWithdrawVC
            viewC.navigationTitle = localised(sender as! String)
            viewC.hidesBottomBarWhenPushed = true
        }
    }
    
    //MARK:- tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  walletData.count == 0 && MDHelper.shared.getActivityIndicator(view: self.view) == nil{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
            noDataLabel.text          = localised("No data available")
            noDataLabel.textColor     = Theme.current.titleTextColor
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.backgroundView?.frame =  CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100)
            noDataLabel.font =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 15)
        }else{
            tableView.backgroundView  = nil
        }
        return walletData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:walletBalanceCurrencyCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdenitifier)! as! walletBalanceCurrencyCell
        
        let cellData = walletData[indexPath.row] as! NSDictionary
        cell.configure(data: cellData , estimatedCurrency: self.estimatedCurrency)
        
        
        return cell
    }
    
    //MARK:- sizes for tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    @IBAction func holdingButtonAction(_ sender: Any) {
       
        nameColumnSortStackView.tag = sortOptions.down.rawValue
        nameColumnSortStackView.sortIndicatorPressed()
        holdingSortStackview.sortIndicatorPressed()
        
        sortByHoldingIndicator()
        self.tableView.reloadData()
         if walletData.count > 0{
                tableView.scrollToRow(at: IndexPath.init(item: 0, section: 0), at: .top, animated: true)
         }
    }
    
    @IBAction func nameButtonAction(_ sender: Any) {
      
        // Deselecting other sort
        holdingSortStackview.tag = sortOptions.down.rawValue
        holdingSortStackview.sortIndicatorPressed()
        //performing new sort
        nameColumnSortStackView.sortIndicatorPressed()
     
            self.sortByNameWithIndicator()
            self.tableView.reloadData()

        if walletData.count > 0{
            tableView.scrollToRow(at: IndexPath.init(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    //MARK: - Sort indicators
    func sortByHoldingIndicator()  {
        if holdingSortStackview.tag == sortOptions.up.rawValue {
            self.walletData = walletData.sorted { (first, second) -> Bool in
                let cellData1 = first as! NSDictionary
                let cellData2 = second as! NSDictionary
                
                if let balance1 = cellData1.valueForCaseInsensativeKey(forKey: "balance") as? Double,let balance2 = cellData2.valueForCaseInsensativeKey(forKey: "balance") as? Double{
                    return balance1 < balance2
                }
                return true
                } as NSArray
            
        }else if holdingSortStackview.tag == sortOptions.down.rawValue{
            self.walletData = walletData.sorted { (first, second) -> Bool in
                let cellData1 = first as! NSDictionary
                let cellData2 = second as! NSDictionary
                
                if let balance1 = cellData1.valueForCaseInsensativeKey(forKey: "balance") as? Double,let balance2 = cellData2.valueForCaseInsensativeKey(forKey: "balance") as? Double{
                    return balance1 > balance2
                }
                return true
                } as NSArray
            
        }else{
            self.walletData =  isHideAssetsWithSmall ? self.walletOriginalDataWithoutSmallAmount : self.walletOriginalData
            
        }
    }
    
    func sortByNameWithIndicator()  {
        if nameColumnSortStackView.tag == sortOptions.up.rawValue {
            self.walletData = walletData.sorted { (first, second) -> Bool in
                let cellData1 = first as! NSDictionary
                let cellData2 = second as! NSDictionary
                
                if let firstName = cellData1.valueForCaseInsensativeKey(forKey: "currency") as? String,let secondName = cellData2.valueForCaseInsensativeKey(forKey: "currency") as? String{
                    return firstName.localizedCaseInsensitiveCompare(secondName) == .orderedAscending
                }
                return true
                } as NSArray
        }else if nameColumnSortStackView.tag == sortOptions.down.rawValue{
            self.walletData = walletData.sorted { (first, second) -> Bool in
                let cellData1 = first as! NSDictionary
                let cellData2 = second as! NSDictionary
                
                if let firstName = cellData1.valueForCaseInsensativeKey(forKey: "currency") as? String,let secondName = cellData2.valueForCaseInsensativeKey(forKey: "currency") as? String{
                    return firstName.localizedCaseInsensitiveCompare(secondName) == .orderedDescending
                }
                return true
                } as NSArray
            
        }else{
            self.walletData =   isHideAssetsWithSmall ? self.walletOriginalDataWithoutSmallAmount : self.walletOriginalData
            
        }
    }
    
    //MARK: - Network calls
    @objc func fetchWalletBalance(){
        let params = [
            "currency": "ALL",
            "timestamp":"\(MDNetworkManager.shared.getCurrentTimeStamp())",
            "recvWindow": "1000"
        ]  // String(Date().toMillis())
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
        
        
        if  self.walletData.count == 0 {
            MDHelper.shared.showHud(view: self.view)
            self.view.isUserInteractionEnabled = false
            self.tableView.reloadData()
        }
        
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .post,
                                            apiName: API.getWalletBalance,
                                            parameters: params as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
            self.view.isUserInteractionEnabled = true
            if response != nil && error == nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray{
                        
                        
                        let filtredEnabledCurrecies = data.filter({ (balanceInfo) -> Bool in
                            if let currencyName = (balanceInfo as! NSDictionary).valueForCaseInsensativeKey(forKey: "currency") as? String {
                                if let currencySetting = self.appDelegate.currencySettings.filter({$0.shortName == currencyName}).first{
                                    if currencySetting.currencyEnabled == true{
                                        return true
                                    }
                                }
                                
                            }
                            return false
                        }) as NSArray
                        
                        
                        
                        self.temp_data = data
                        self.walletData = filtredEnabledCurrecies
                        self.appDelegate.walletData = filtredEnabledCurrecies
                        self.walletOriginalData = filtredEnabledCurrecies
                        self.walletOriginalDataWithoutSmallAmount = self.getWithoutSmallAmout(dataArray: self.walletOriginalData)
                        self.selAllBalanceAndTrade(dataArray: data)
                        if self.nameColumnSortStackView.tag == 0 || self.nameColumnSortStackView.tag == 1/*2 is both deselected*/{
                            self.sortByNameWithIndicator()
                        }
                        if self.holdingSortStackview.tag == 0 || self.holdingSortStackview.tag == 1{
                            self.sortByHoldingIndicator()
                        }
                        self.tableView.reloadData()
                        self.toggleHideShowAssets()
                        MDHelper.shared.hideHud(view: self.view)
                    }
                }else{
                    if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                        if  self.walletData.count == 0 {
                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                            self.walletData = []
                            self.walletOriginalData = []
                            self.walletOriginalDataWithoutSmallAmount = []
                            self.tableView.reloadData()
                            self.toggleHideShowAssets()
                        }
                        MDHelper.shared.hideHud(view: self.view)
                    }
                }
            }else{
                if  error != nil{
                    print("error With fetching wallet balnce")
                    if  self.walletData.count == 0 {
                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                    }
                    MDHelper.shared.hideHud(view: self.view)
                }
                MDHelper.shared.hideHud(view: self.view)
            }
        }
    }
    
    //MARK: - Helper methods
    func balanceForCurrencyName(currency: String) -> NSDictionary? {
        for dataDict in (self.walletOriginalData as? [NSDictionary])! {
            if let name = dataDict.valueForCaseInsensativeKey(forKey: "currency") as? String,name == currency {
                return dataDict
            }
        }
        return nil
    }
    
    func selAllBalanceAndTrade(dataArray: NSArray){
        print("Debug!!!!")
        print(dataArray)
        var totalBalance = 0.0
        var totalTrade = 0.0
        var estimatedUSDValue = 0.0
        var btcBalanceInfo : NSDictionary? = nil
        let TempTotal : Double = 0.0
        //print("Name           ,Balance      , USD Val        ,Total Bal        ,Est        ,InTrade")
        for dataDict in (dataArray as? [NSDictionary])! {
            if let name = dataDict.valueForCaseInsensativeKey(forKey: "currency") as? String{
                var currencyBalance = 0.0
                if let balance = dataDict.valueForCaseInsensativeKey(forKey: "balance") as? Double{
                    totalBalance = balance + totalBalance
                    currencyBalance = balance
                }
                if let inTrade = dataDict.valueForCaseInsensativeKey(forKey: "balanceInTrade") as? Double {
                    if let usdVal : Double = MDHelper.shared.getCurrencyValueInUSD(currency: name){
                        estimatedUSDValue =  estimatedUSDValue + (currencyBalance)*usdVal
                        totalTrade = totalTrade + (usdVal * inTrade)
                        
                    }else{
                        if let usdVal = MDHelper.shared.getFiatCurrencyValueInUSD(currency: name),usdVal != 0 {
                            estimatedUSDValue =  estimatedUSDValue + (currencyBalance)/usdVal
                            totalTrade = totalTrade + (inTrade / usdVal)
                        }else{
                            print("Not a fiate and not crypto \(name)")
                        }
                    }
                }
                if name.uppercased() == "BTC"{
                    btcBalanceInfo = dataDict
                }
            }
        }
 
        estimatedUSDValue += totalTrade
        let selectedCurrency = self.estimatedCurrency
        if selectedCurrency != "USD"{
            let fiatEstValue = (estimatedUSDValue * (MDHelper.shared.getFiatCurrencyValueInUSD(currency: selectedCurrency) ?? 0))
            self.estimatedPriceLabel.text = (MDHelper.shared.getFormattedNumber(amount: fiatEstValue, minimumFractionDigits: 2 , maxFractionDigits: 2) ?? "0") + " \(selectedCurrency)"
        
            let fiatAvailableValue = ((estimatedUSDValue - totalTrade) * (MDHelper.shared.getFiatCurrencyValueInUSD(currency: selectedCurrency) ?? 0))
            self.availableLabel.text = (MDHelper.shared.getFormattedNumber(amount: fiatAvailableValue, minimumFractionDigits: 2) ?? "0") + " \(selectedCurrency)"
            
            let fiatInOrderValue = (totalTrade * (MDHelper.shared.getFiatCurrencyValueInUSD(currency: selectedCurrency) ?? 0))
            self.inorderLabel.text = (MDHelper.shared.getFormattedNumber(amount: fiatInOrderValue, minimumFractionDigits: 2) ?? "0") + " \(selectedCurrency)" /**In Order Data*/
            
            
        }else{
            self.estimatedPriceLabel.text = (MDHelper.shared.getFormattedNumber(amount: estimatedUSDValue, minimumFractionDigits: 2 , maxFractionDigits: 2) ?? "0") + " USD"
            self.availableLabel.text = (MDHelper.shared.getFormattedNumber(amount: estimatedUSDValue-totalTrade, minimumFractionDigits: 2) ?? "0") + " USD"
            self.inorderLabel.text = (MDHelper.shared.getFormattedNumber(amount: totalTrade, minimumFractionDigits: 2) ?? "0") + " USD" /**In Order Data*/
        }
        guard let btcValue = MDHelper.shared.getCurrencyValueInUSD(currency: "BTC") else {return}
        print("\nEstimated USD \(estimatedUSDValue) Currency in BTC \(btcValue) Total Trade \(totalTrade)")
        let BTCValue = (estimatedUSDValue / btcValue)
        print("BTC Val \(BTCValue)")
        //let roudedBTC = ceil(BTCValue * 100000000) / 100000000.0
        let decimalPrecForBTC = MDHelper.shared.getDecimalPrecisionFor(currnecy: "BTC")
        let roudedBTC : String = MDHelper.shared.getFormattedNumber(amount: BTCValue, minimumFractionDigits: 2 , maxFractionDigits: decimalPrecForBTC) ?? "N/A"
        let btcValueInString = roudedBTC
        let myRange = NSRange(location: 2, length: btcValueInString.count)
        let attributedText = NSMutableAttributedString.init(string:  "≈ \(btcValueInString) BTC")
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value:Theme.current.primaryColor, range: myRange)
        rightTitle.attributedText = attributedText
        rightTitle.adjustsFontSizeToFitWidth = true
//        print("\n-------------------------Cripto Rate List----------------------")
//        for each in appDelegate.cryptoRateList{
//            print("\(each.currency!) => \(each.rate!)")
//        }
//        print("-----------------------------------------------")
//        print("\n-------------------------Fiat Rate List----------------------")
//        for each in appDelegate.rateList{
//            print("\(each.currency!) => \(each.rate!)")
//        }
//        print("-----------------------------------------------")
    }
}


class walletBalanceCurrencyCell:UITableViewCell{
    
    //MARK: - StoryBoard outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var balanceAmount: UILabel!
    @IBOutlet weak var usdValue: UILabel!
    @IBOutlet weak var symbolImageview: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    //MARK: - Constants
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - Variables
    var cellData:NSDictionary = NSDictionary()
    
    override func draw(_ rect: CGRect) {
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.title.textColor = Theme.current.titleTextColor
        self.subTitle.textColor = Theme.current.subTitleColor
        self.balanceAmount.textColor = Theme.current.titleTextColor
        self.usdValue.textColor = Theme.current.subTitleColor
    }
    /// This will Configure the data on cell Ui
    ///
    /// - Parameter data: Data to show on the cell
    func configure(data:NSDictionary , estimatedCurrency : String){
     cellData = data
        if let titleString = cellData.valueForCaseInsensativeKey(forKey: "currency") as? String{
            title.text = titleString.uppercased()
            symbolImageview.image = MDHelper.shared.getImageByCurrencyCode(code: titleString)
            let coinsInfo = appDelegate.coinsInfo
            let filter = coinsInfo.filter { (coin) -> Bool in
                if coin is NSDictionary{
                    if let coinTicker = ((coin as! NSDictionary).valueForCaseInsensativeKey(forKey: "Coin_Ticker") as? String){
                        return coinTicker.lowercased() == titleString.lowercased()
                    }
                }
                return false
               
            }
            if filter.count > 0{
                if let coinName = (filter.first as! NSDictionary).valueForCaseInsensativeKey(forKey: "Coin_Name") as? String{
                    subTitle.text = coinName
                }else{
                    subTitle.text = ""
                }
            }else{
                subTitle.text = ""
            }
            if let balance = cellData.valueForCaseInsensativeKey(forKey: "balance") as? Double{
                let decimalPrec = MDHelper.shared.getNumberOFDecimals(double: balance)
                balanceAmount.text = MDHelper.shared.getFormattedNumber(amount: balance, minimumFractionDigits: decimalPrec)! + " " + title.text!
                self.balanceAmount.adjustsFontSizeToFitWidth = true
                let amount : Double
                
                if let usdVal : Double = MDHelper.shared.getCurrencyValueInUSD(currency: titleString){
                    amount = balance * usdVal
                
                }else{
                    if let usdVal : Double = MDHelper.shared.getFiatCurrencyValueInUSD(currency: titleString) , usdVal != 0{
                        amount = balance / usdVal
                    }else{
                        amount = 0
                    }
                }
                
                if amount == 0{
                    usdValue.text  = "\(estimatedCurrency) 0.0"
                }else{
                    
                    
                }
                let amountToBeDisplay : String
                if estimatedCurrency == "USD"{
                    amountToBeDisplay = (MDHelper.shared.getFormattedNumber(amount: amount, minimumFractionDigits: 2) ?? "")
                }else{
                    let fiatEst = (amount * (MDHelper.shared.getFiatCurrencyValueInUSD(currency: estimatedCurrency) ?? 0))
                    amountToBeDisplay = (MDHelper.shared.getFormattedNumber(amount: fiatEst , minimumFractionDigits: 2) ?? "")
                }
               
                usdValue.text = estimatedCurrency + " " + amountToBeDisplay
            }
            
        }
    }
    
}
/*
 
 Name=> AAPL, Balance=> 0.0
 Name=> BTC, Balance=> 1.18442068
 Name=> DOGE, Balance=> 0.0
 Name=> EOS, Balance=> 0.0
 Name=> ETH, Balance=> 970.94967787
 Name=> EUR, Balance=> 1.07
 Name=> GBP, Balance=> 0.0
 Name=> GC, Balance=> 0.0
 Name=> GLD, Balance=> 0.0
 Name=> LTC, Balance=> 1001.09167555
 Name=> MOD, Balance=> 1.16084
 Name=> SGR, Balance=> 0.0
 Name=> SXRE, Balance=> 0.0
 Name=> USDT, Balance=> 759340.17163387
 Name=> XLM, Balance=> 16.9125
 Name=> XRP, Balance=> 100000.0
 
 */
