//
//  MDAccountVC.swift
//  Modulus
//
//  Created by Pathik  on 12/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit


class MDAccountVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    //MARK: - Segue Identifiers
    /// Segue identifiers to navigates from this screen to another screen
    struct segueIdentifiers {
        static let changePassword = "changePassword"
        static let securityVerification = "securityVerification"
        static let currency = "currencyScreen"
        static let language = "languageScreen"
        static let orderHistory = "orderHistory"
        static let phoneVerification = "phoneVerificationSegue"
    }
    
    //MARK: - StoryBoard outlets
    /// Tableview
    @IBOutlet weak var accountTableView: UITableView!
    /// Logged in user email
    @IBOutlet weak var emailLabel: UILabel!
    /// Logges in user name
    @IBOutlet weak var userNameLabel: UILabel!
    /// Logged in user initials
    @IBOutlet weak var nameInitialLabel: UILabel!
    /// Profile header view
    @IBOutlet weak var headerView: UIView!
    /// background View
    @IBOutlet weak var backgroundView: UIView!
    
    //MARK: - Constants
    /// Navigation title
    let navigationTitle = localised("Account")
    /// Number of options to be shown on Account screen
    var accountSettings : [settingOptions] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dropDownVC:MDDropDownVC? = nil
    let notification_name:Notification.Name = Notification.Name(rawValue: "Login_BroadcastNotification")
    //MARK: - View Controller life cycle
    /// Default viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewController()

    }
    
    @objc
    func setupViewController(){
        if (UIApplication.shared.delegate as! AppDelegate).enable_phone_verification{
            accountSettings.append(settingOptions(index: 0, name: localised("Phone Verification")))
            accountSettings.append(contentsOf: settingOptions.optionslist())
        }else{
            accountSettings = settingOptions.optionslist()
        }
        setNavigationbar()
        setUpUI()
        self.addObserver()
    }
    
    /// addObserver
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupData), name: Notification.Name(rawValue: "Login_BroadcastNotification"), object: nil)
        if MDHelper.shared.isUserLoggedIn() == true{
            NotificationCenter.default.addObserver(self, selector: #selector(self.islogingSuccessfully), name: notification_name, object: nil)
        }
    }
    @objc func islogingSuccessfully(){
        DispatchQueue.main.async { [weak self] in
            self?.viewWillAppear(false)
            //NotificationCenter.default.removeObserver(self, name:(self?.notification_name), object: nil)
        }
        
    }
    /// Default viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    @objc private
    func setupData(){
        setNavigationbar()
        setUpColors()
        setUpInitialData()
        setUpUI()
        self.accountTableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
       
    }
    
    
    
    //MARK:- navigation bar helprs
    /// Set up navigation bar titles and back button
    func setNavigationbar(){
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = MDAppearance.Fonts.largeNavigationTitleFont
        label.text = navigationTitle
        label.textColor = Theme.current.titleTextColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }
    
    //MARK:- setup appeareance
    /// Set up all the colors on this screen
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        backgroundView.backgroundColor  = Theme.current.backgroundColor
        headerView.backgroundColor = Theme.current.navigationBarColor
        nameInitialLabel.backgroundColor = Theme.current.profileInitialLabelBgColor
        nameInitialLabel.textColor = Theme.current.titleTextColor
        userNameLabel.textColor = Theme.current.titleTextColor
        emailLabel.textColor = Theme.current.subTitleColor
        
        self.accountTableView.backgroundColor = .clear
    }
    
    /// Initial Ui tweaks
    func setUpUI()  {
        nameInitialLabel.layer.cornerRadius = nameInitialLabel.frame.size.height / 2
        nameInitialLabel.clipsToBounds = true
        nameInitialLabel.layoutIfNeeded()
    }
    
    
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpUI()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpUI()
    }
    
    
    /// Intially load the data
    func setUpInitialData(){
        if let profile = UserDefaults.standard.value(forKey: "profile") as? NSDictionary{
            if let email = profile.valueForCaseInsensativeKey(forKey: "email") as? String{
                emailLabel.text = email
            }
            var name = profile.valueForCaseInsensativeKey(forKey: "name") as? String ?? ""
            var initaialLetters = ""
            if name == "" {
                if let firstname = profile.valueForCaseInsensativeKey(forKey: "firstName") as? String{
                    if !firstname.contains("null"){
                        name = firstname
                        initaialLetters = "\(name[name.startIndex])"
                    }
                }
                if let middleName = profile.valueForCaseInsensativeKey(forKey: "middleName") as? String{
                    if !middleName.contains("null"){
                        name = name + " \(middleName)"
                    }
                }
                if let lastName = profile.valueForCaseInsensativeKey(forKey: "lastName") as? String{
                    if !lastName.contains("null"){
                        name = name + " \(lastName)"
                        initaialLetters = initaialLetters + "\(lastName[lastName.startIndex])"
                    }
                }
            }
                userNameLabel.text = name
//                let seperatedCompoenents = name.components(separatedBy: " ")
//                if seperatedCompoenents.count > 1{
//                    self.nameInitialLabel.text = "\((seperatedCompoenents.first!.first)!)\((seperatedCompoenents.last!.first)!)".uppercased()
//                }else{
                    self.nameInitialLabel.text = initaialLetters.uppercased()
//                }
            
            
        }else{
            emailLabel.text = ""
            self.nameInitialLabel.text = "N/A"
            userNameLabel.text = localised("Unavailable")
        }
    }
    
    // MARK: - DataSource and delegate
    
    ///Default
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettings.count
    }
    
    ///Default
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    ///Default
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let accountCell = tableView.dequeueReusableCell(withIdentifier: MDAccountCell.resuableID) as! MDAccountCell
        let data = accountSettings[indexPath.row]
        accountCell.configureCell(name: data.name, isLogout: data.index == 10)
        
        return accountCell
    
    }
    
    ///Default
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let data = accountSettings[indexPath.row]
        
        switch data.index {
        case 0:
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: segueIdentifiers.phoneVerification, sender: nil)
            }
        case 1:  self.performSegue(withIdentifier: segueIdentifiers.securityVerification, sender: self);break
        case 2:  changePassword(shouldMovetoChangePassword: true) ;break
        case 3:   moveToFiatCurrencies() ; break
        case 4:  DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                SocketHelper.shared.delegate = nil
                self.performSegue(withIdentifier: segueIdentifiers.orderHistory, sender: false)
            } else {
                // Fallback on earlier versions
            }
            
        };break
        case 5:
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "MDIPListing", sender: self)
            }
        case 6: self.performSegue(withIdentifier: "white_list_device", sender: self);break
        case 7:self.performSegue(withIdentifier: "MDExchangeToken", sender: self); break
        case 8:   self.performSegue(withIdentifier: segueIdentifiers.language, sender: self);break
        case 9:  self.performSegue(withIdentifier: "showReferralVC", sender: self);break
        case 10:  MDAlertPopupView.showAlertPopupViewOnWidnow(title: localised("appName"), errorMessage: localised("Are you sure you want to logout of this account?"), alertDelegate: self); break
        case 11: self.performSegue(withIdentifier: "MDVolumeSegue", sender: self); break
        case 12: self.performSegue(withIdentifier: segueIdentifiers.orderHistory, sender: true)
            
        default:
            break
        }
        
//
//        if accountSettings.last! == name{
//
//
//        }
//
//        if name == localised("Change Password"){
//
//        }else if name == localised("Security Verification"){
//
//        }else if name == localised("Currency"){
//            self.performSegue(withIdentifier: segueIdentifiers.currency, sender: self)
//        }else if name == localised("Language"){
//
//        }else if name == localised("Order History"){
//
//        }else if name == localised("Fiat Currency"){
//
//        }else if name == "Referrals"{
//
//        }else if name == "Exchange Token" {
//
//        }else if name == "IP Whitelisting" {
//
//        }else  if name == "WhiteListed Device" {
//
//        }

    }
    
    func changePassword(shouldMovetoChangePassword:Bool = false){
        if (UserDefaults.standard.value(forKey: "profile") as? NSDictionary) != nil {
            var twoFA = false
            if let twoFactorEnabled = UserDefaults.standard.value(forKey: "is2FAEnabled") as? Bool {
                twoFA = twoFactorEnabled
            }
            if twoFA == true{
                if shouldMovetoChangePassword == true{
                     self.performSegue(withIdentifier: segueIdentifiers.changePassword, sender: self)
                }
            }else{
                requestOtpForChangePassword(shouldMovetoChangePassword: shouldMovetoChangePassword)
            }
        }
    }
    
    
    
    //MARK: -  Fiat estomation
    func moveToFiatCurrencies(){
        let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
        dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as? MDDropDownVC
        dropDownVC?.type = .none
        dropDownVC?.delegate = self
        let mutableData = NSMutableArray()
//        let selectedIndex = 0
//        var rateList = appDelegate.rateList
        var currentSelectedCurrency = ""
        if let selectedCurrencyDetails = UserDefaults.standard.value(forKey: "fiatSelectedCurrency") as? [String:Any],
            let currencyName = selectedCurrencyDetails["currency"] as? String{
            currentSelectedCurrency = currencyName
        }
        if let fiatCurrencies = UserDefaults.standard.value(forKey: "fiat_List") as? String{
            let list = fiatCurrencies.components(separatedBy: ",")
            for (_,currency) in list.enumerated() {
                
                let selectedData = ["title" : currency,
                                    "selected":currentSelectedCurrency == currency] as [String : Any]
                mutableData.add((selectedData as NSDictionary).mutableCopy() as! NSMutableDictionary)
            }
        }
        
        dropDownVC?.data = mutableData
//        dropDownVC?.initialSelectedIndex = selectedIndex
        dropDownVC?.navigationTitle = localised("Fiat Currency")
        //        dropDownVC.selectedCountry = countryTextField.text!
        dropDownVC?.searchBarPlaceHolder = localised("Search Currency")
//        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(dropDownVC!, animated: true)
        
    }
    
    //MARK: - Actions
    
    ///This will clear all the user related data from the app
    func logout()  {
        // logout Action
        UserDefaults.standard.removeObject(forKey: "AccessToken")
        UserDefaults.standard.removeObject(forKey: "profile")
        UserDefaults.standard.removeObject(forKey: "grantType")
        self.tabBarController?.selectedIndex = 0
//        //self.tabBarController?.dismiss(animated: true, completion: nil)
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let viewc = storyboard.instantiateInitialViewController()
//        let appDel = UIApplication.shared.delegate as! AppDelegate
////        MDSignalRManager.shared.connection?.stop()
//        appDel.window?.rootViewController = viewc
//        MDHelper.shared.showYouWantToLoginPopUp()
    }
    
    // MARK: - Navigation
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        vc.hidesBottomBarWhenPushed = true
        
        if segue.identifier == segueIdentifiers.language{
            (segue.destination as! MDCurrencyVC).isLanguage = true
        }else if segue.identifier == segueIdentifiers.orderHistory{
            if let ordersVC = segue.destination as? MarketListVC{
                ordersVC.isMarketScreen = false
                ordersVC.isOrderHistoryScreen = true
                ordersVC.isTradeHistoryScreen = sender as? Bool ?? false
                print("Is Trade History Screen \(sender as! Bool)")
                ordersVC.hidesBottomBarWhenPushed = true
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
extension MDAccountVC:alertPopupDelegate{
    ///Handle Alert popup click 
    func alertPopupResponse(isAgree: Bool) {
        if isAgree == true {
            logout()
        }
    }
}

//MARK: - API calls
extension MDAccountVC{
    
    // Request OTP for change password if only googleAutheticator is not enabled
    func requestOtpForChangePassword(shouldMovetoChangePassword:Bool = false){
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .post,
                                            apiName: API.requestChangePasswordOtp,
                                            parameters: nil,
                                            headers: headers as NSDictionary) { (response, error) in

                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if shouldMovetoChangePassword == true{
                                                            self.performSegue(withIdentifier: segueIdentifiers.changePassword, sender: self)
                                                        }else{
                                                            MDHelper.shared.showSucessAlert(message: "OTP has been successfully sent", viewController: self)
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
}
extension MDAccountVC:customDropDownDelegates{
    func dropDownSelected(title: String, data: NSDictionary) {
                print("selected Title : \(title)")
        self.dropDownVC?.navigationController?.popViewController(animated: true)
        if let selectedCurrencyDetails = appDelegate.rateList.filter({($0.currency)!.lowercased() == title.lowercased()}).first{
            UserDefaults.standard.setValue(["currency":selectedCurrencyDetails.currency,"rate":selectedCurrencyDetails.rate], forKey: "fiatSelectedCurrency")
        }else{
            UserDefaults.standard.setValue(["currency":title], forKey: "fiatSelectedCurrency")
        }
    
//        selectedText = data.valueForCaseInsensativeKey(forKey: "value") as? String ?? ""
//        dropDownButton.setTitle("   \(title.capitalized)       ", for: .normal)
//        if field?.fieldName == "KYCType"{
//            if let kycVc = self.viewController() as? MDKYCVC{
//                kycVc.toggleUIForTypeOfVerfication(selectedType: title)
//            }
//        }
    }
}
struct settingOptions{
    var index:Int
    var name:String
}
extension settingOptions {
    static func optionslist() -> [settingOptions]{
        return [//settingOptions(index: 0, name: localised("Phone Verification")),
                settingOptions(index: 1, name: localised("Security Verification")),
                settingOptions(index: 2, name: localised("Change Password")),
                settingOptions(index: 3, name: localised("Fiat Currency")),
                settingOptions(index: 4, name: localised("Order History")),
                settingOptions(index: 12, name: localised("trade_history")),
                settingOptions(index: 5, name: localised("IP Whitelisting")),
                settingOptions(index: 6, name: localised("WhiteListed Device")),
                settingOptions(index: 7, name: localised("Exchange Token")),
                settingOptions(index: 11, name: localised("Volume Discount")),
                //settingOptions(index: 8, name: localised("Language")),
                settingOptions(index: 9, name: localised("Referrals")),
                settingOptions(index: 10, name: localised("Log out"))]
    }
}
