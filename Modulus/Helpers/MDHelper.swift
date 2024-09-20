//
//  MDHelper.swift
//  Modulus
//
//  Created by Pathik  on 12/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

func localised(_ string:String)->String{
    return LocalizationSystem.sharedInstance.localizedStringForKey(key: string, comment: "")
}


class MDHelper: NSObject {
    
    static let shared = MDHelper()
    
    private var settingDict : NSDictionary?
    
    private override init() {}
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var md_market_data : [MDMarketTabModel] = []
    
    var notDisplayQuoteCurrencyPairs : [String] = []
    /***Trade Settings*/
    var tradeSettings : [MDTradeSettings] = []
    
    /// Theme Helpers
    
    func setUpTheme(response:NSDictionary)
    {
        let themeDefault  = MDDarkTheme()
        
        
        /// Background color
        if let backgroundColor = response.valueForCaseInsensativeKey(forKey: "backgroundColor") as? NSDictionary , let hex = backgroundColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.backgroundColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(backgroundColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// dropDownBgColor
        if let dropDownBgColor = response.valueForCaseInsensativeKey(forKey: "dropDownBgColor") as? NSDictionary , let hex = dropDownBgColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.dropDownBgColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(dropDownBgColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// navigationBarColor
        if let navigationBarColor = response.valueForCaseInsensativeKey(forKey: "navigationBarColor") as? NSDictionary , let hex = navigationBarColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.navigationBarColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(navigationBarColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// primaryColor
        if let primaryColor = response.valueForCaseInsensativeKey(forKey: "primaryColor") as? NSDictionary ,
            let hex = primaryColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.primaryColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(primaryColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        /// secondaryColor
        if let secondaryColor = response.valueForCaseInsensativeKey(forKey: "secondaryColor") as? NSDictionary , let hex = secondaryColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.secondaryColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(secondaryColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        ///titleTextColor
        if let titleTextColor = response.valueForCaseInsensativeKey(forKey: "titleTextColor") as? NSDictionary , let hex = titleTextColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.titleTextColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(titleTextColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        /// subTitleColor
        if let subTitleColor = response.valueForCaseInsensativeKey(forKey: "subTitleColor") as? NSDictionary , let hex = subTitleColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.subTitleColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(subTitleColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        /// textFieldIconsTintColorActive
        if let textFieldIconsTintColorActive = response.valueForCaseInsensativeKey(forKey: "textFieldIconsTintColorActive") as? NSDictionary , let hex = textFieldIconsTintColorActive.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.textFieldIconsTintColorActive = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(textFieldIconsTintColorActive.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// textFieldIconsTintColorInActive
        if let textFieldIconsTintColorInActive = response.valueForCaseInsensativeKey(forKey: "textFieldIconsTintColorInActive") as? NSDictionary , let hex = textFieldIconsTintColorInActive.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.textFieldIconsTintColorInActive = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(textFieldIconsTintColorInActive.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// customValuesBoxWithSidebarColor
        if let customValuesBoxWithSidebarColor = response.valueForCaseInsensativeKey(forKey: "customValuesBoxWithSidebarColor") as? NSDictionary , let hex = customValuesBoxWithSidebarColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.customValuesBoxWithSidebarColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(customValuesBoxWithSidebarColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// BuySellScreentextFiledLabelBgColor
        if let BuySellScreentextFiledLabelBgColor = response.valueForCaseInsensativeKey(forKey: "BuySellScreentextFiledLabelBgColor") as? NSDictionary , let hex = BuySellScreentextFiledLabelBgColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.BuySellScreentextFiledLabelBgColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(BuySellScreentextFiledLabelBgColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// BuySellScreentextFiledBgColor
        if let BuySellScreentextFiledBgColor = response.valueForCaseInsensativeKey(forKey: "BuySellScreentextFiledBgColor") as? NSDictionary , let hex = BuySellScreentextFiledBgColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.BuySellScreentextFiledBgColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(BuySellScreentextFiledBgColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// mainTableCellsBgColor
        if let mainTableCellsBgColor = response.valueForCaseInsensativeKey(forKey: "mainTableCellsBgColor") as? NSDictionary , let hex = mainTableCellsBgColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.mainTableCellsBgColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(mainTableCellsBgColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// selectedCellBgColor
        if let selectedCellBgColor = response.valueForCaseInsensativeKey(forKey: "selectedCellBgColor") as? NSDictionary , let hex = selectedCellBgColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.selectedCellBgColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(selectedCellBgColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// profileInitialLabelBgColor
        if let profileInitialLabelBgColor = response.valueForCaseInsensativeKey(forKey: "profileInitialLabelBgColor") as? NSDictionary , let hex = profileInitialLabelBgColor.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.profileInitialLabelBgColor = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(profileInitialLabelBgColor.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        /// accountCellSeparator
        if let accountCellSeparator = response.valueForCaseInsensativeKey(forKey: "accountCellSeparator") as? NSDictionary , let hex = accountCellSeparator.valueForCaseInsensativeKey(forKey: "hex") as? String{
            
            themeDefault.accountCellSeparator = (UIColor(hexString:"#\(hex)FF")?.withAlphaComponent(accountCellSeparator.valueForCaseInsensativeKey(forKey: "opacity") as? CGFloat ?? 1))!
        }
        
        
        
//        Theme.current  = themeDefault
        Theme.current = MDDarkTheme()
        self.appDelegate.setTabBarAndNavigationColors()
        
        if let navigation =  UIApplication.shared.topMostViewController() as? UINavigationController{
//            if let settingVC = navigation.visibleViewController as? MDSettingURLVC{
//                settingVC.setUpColors()
//                settingVC.setNavigationBar()
//            }
            navigation.popViewController(animated: true)
        }
    }
    
    
    
    
    
    
    
    func logOut(){
        // logout Action
        UserDefaults.standard.removeObject(forKey: "AccessToken")
        UserDefaults.standard.removeObject(forKey: "profile")
        UserDefaults.standard.removeObject(forKey: "grantType")
        UserDefaults.standard.removeAllFav()
//        //self.tabBarController?.dismiss(animated: true, completion: nil)
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let viewc = storyboard.instantiateInitialViewController()
//        let appDel = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 13.0, *) {
            SocketHelper.shared.stopConnection()
        } else {
            // Fallback on earlier versions
        }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewc = storyboard.instantiateInitialViewController() as! UINavigationController
        if let navBar = UIApplication.shared.topMostViewController() as? UINavigationController{
            navBar.pushViewController(viewc, animated: true)
        }else if let tabBar =  UIApplication.shared.topMostViewController() as? UITabBarController{
            tabBar.present(viewc, animated: true, completion: nil)
            //                (tabBar.selectedViewController as? UINavigationController)?.pushViewController(viewc.viewControllers.first!, animated: true)
        }
//        appDel.window?.rootViewController = viewc
    }
    
    //MARk:- validation helpers
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //MARK:- Alert helpers
    func showErrorAlert(message:String, viewController:UIViewController){
//        let alert = UIAlertController(title: "Error", message:message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//        viewController.present(alert, animated: true, completion: nil)
        MDSnackBarHelper.shared.showErroMessage(message: message)
    }
    func showErrorPopup(message:String)  {
        _ = MDPopupView.showErrorPopupViewOnWidnow(title: "server error", errorMessage:message, messageImage: nil)
    }
    func showSucessAlert(message:String, viewController:UIViewController){
          MDSnackBarHelper.shared.showSuccessMessage(message: message)
//        let alert = UIAlertController(title: "Success", message:message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showHudOnWindow(){
        if (appDelegate.window?.viewWithTag(MDAppearance.tags.windowHud)) != nil
        {
            
        }else{
            let view = UIView(frame: (appDelegate.window?.frame)!)
            view.backgroundColor = Theme.current.backgroundColor
                .withAlphaComponent(0.4)
            
            
            
            view.tag = MDAppearance.tags.windowHud
            let progress = GradientCircularProgress()
            let progressView = progress.show(frame: CGRect(
                x: view.frame.origin.x + 15,
                y: (view.frame.size.height - view.frame.size.width) / 2,
                width: view.frame.size.width - 30,
                height: view.frame.size.width - 30), message: "", style: MyStyle())
         //   progressView?.layer.cornerRadius = 20
            
            view.addSubview(progressView!)
            
            progressView?.translatesAutoresizingMaskIntoConstraints = false
            
            progressView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            progressView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            progressView?.widthAnchor.constraint(equalToConstant: view.frame.size.width - 30).isActive = true
            progressView?.heightAnchor.constraint(equalToConstant: view.frame.size.width - 30).isActive = true
            
            
            //            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            view.bringSubviewToFront(progressView!)
            view.accessibilityIdentifier = "HUD";
            appDelegate.window?.addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false

            view.centerXAnchor.constraint(equalTo: appDelegate.window!.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: appDelegate.window!.centerYAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: appDelegate.window!.widthAnchor, multiplier: 1).isActive = true
            view.heightAnchor.constraint(equalTo: appDelegate.window!.heightAnchor, multiplier: 1).isActive = true
            
            
        }
    }
//    func getRect() -> CGRect {
//        return CGRect(
//            x: view.frame.origin.x + 15,
//            y: (view.frame.size.height - view.frame.size.width) / 2,
//            width: view.frame.size.width - 30,
//            height: view.frame.size.width - 30)
//    }
    
    func hideHudOnWindow(){
        if let activityIndicatorView = appDelegate.window?.viewWithTag(MDAppearance.tags.windowHud)
        {
            activityIndicatorView.removeFromSuperview()
        }
    }
    
    func showHud(view:UIView){
        
        
   
      
        //   progressView?.layer.cornerRadius = 20
        
     //   view.addSubview(progressView!)
        if let activityIndicator = getActivityIndicator(view: view){
            activityIndicator.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
            //activityIndicator.startAnimating()
        }else{
            let progress = GradientCircularProgress()
            let progressView = progress.show(frame: CGRect(x: 0, y: 0, width: 100, height: 100), message: "", style: MyStyle())!
          //  let indicatorView = NVActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                     //        type: NVActivityIndicatorType.ballPulse, color:UIColor.white,
                                                        //     padding: 0)
           // indicatorView.startAnimating()
            progressView.tag = MDAppearance.tags.hudTag
          //  progressView.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
            view.addSubview(progressView)
            view.accessibilityIdentifier = "HUD";
            view.bringSubviewToFront(progressView)
            
            
            progressView.translatesAutoresizingMaskIntoConstraints = false
            
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            progressView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            
            
            
            
            
            
            
            
            //        let deadlineTime = DispatchTime.now() + .seconds(30)
            //        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
            //            MDHelper.shared.hideHud(view: self!.decimalAmoutTableView)
            //            self!.isLoadingIndicatorOnTableView = false
            //            self!.decimalAmoutTableView.reloadData()
            //        }
            
        }
    }
    
    func hideHud(view:UIView){
        if let indicator = getActivityIndicator(view: view){
         indicator.removeFromSuperview()
            // indicator.stopAnimating()
        }
    }
    
    func getActivityIndicator(view:UIView)->UIView?{
        if let activityIndicator = view.viewWithTag(MDAppearance.tags.hudTag)
        {
            return activityIndicator
        }
        return nil
    }
    
    
    
    
    
    //MARK:- Data helpers
    
    //MARK: - Currency conversion
    func getCurrencyValueInUSD(currency:String)->Double?{
        if let currencyDetails = appDelegate.cryptoRateList.filter({($0.currency)!.lowercased() == currency.lowercased()}).first{
            return currencyDetails.rate
        }
        return nil
    }
    
    
    func getFiatEstimatedPrice(amount:Double , baseCurrency:String , shouldUsedForOnlyFiatEstimateViewing:Bool = false)->Double{
        if let selectedCurrencyDetails = UserDefaults.standard.value(forKey: "fiatSelectedCurrency") as? [String:Any],
            let currencyName = selectedCurrencyDetails["currency"] as? String{
            
            if baseCurrency == "USD"{
                return 0.0
            }else{
                if shouldUsedForOnlyFiatEstimateViewing == true {
                    if (getCurrencyValueInUSD(currency: baseCurrency) ?? 0) == 0 {
                        return amount * (getFiatCurrencyValueInUSD(currency: baseCurrency) ?? 0)
                    }else {
                        return amount * (getCurrencyValueInUSD(currency: baseCurrency) ?? 1) * (getFiatCurrencyValueInUSD(currency: currencyName) ?? 1)
                    }
                }else{
                    return amount * (getCurrencyValueInUSD(currency: baseCurrency) ?? 1) * (getFiatCurrencyValueInUSD(currency: currencyName) ?? 1)
                }
                
            }
            
        }
        
        return 0.0
    }
    func getFiatEstimatedPriceString(amount:Double , baseCurrency:String, shouldUsedForOnlyFiatEstimateViewing:Bool = false)->String{
        if let selectedCurrencyDetails = UserDefaults.standard.value(forKey: "fiatSelectedCurrency") as? [String:Any],
            let currencyName = selectedCurrencyDetails["currency"] as? String{
            let amount = getFiatEstimatedPrice(amount: amount, baseCurrency: baseCurrency,shouldUsedForOnlyFiatEstimateViewing: shouldUsedForOnlyFiatEstimateViewing)
            let numberFormatter = NumberFormatter()
             numberFormatter.numberStyle = NumberFormatter.Style.decimal
             let formattedNumber = numberFormatter.string(from: NSNumber(value:amount))
            if amount > 0{
                return String(format: "\(currencyName) \(formattedNumber ?? "")")
            }else{
                return  String(format: "\(currencyName) 0.0")
                
            }
        }
        return ""
    }
    
    func getCurrencyPageRates(amount:Double)->(String,String){
        if let selectedCurrencyDetails = UserDefaults.standard.value(forKey: "fiatSelectedCurrency") as? [String:Any],
           let currencyName = selectedCurrencyDetails["currency"] as? String{
            return ("\((appDelegate.rateList.filter { (rate) -> Bool in rate.currency == currencyName }.first?.rate ?? 0) * amount)",currencyName)
        }
        return ("","")
    }
    
    func getFiatCurrencyValueInUSD(currency:String)->Double?{
        if let currencyDetails = appDelegate.rateList.filter({($0.currency)!.lowercased() == currency.lowercased()}).first{
            return currencyDetails.rate
        }
        return nil
    }
    
    
//////////// GET USD VALUE CURRENCY ////////////////////////
    func getFiatValue(market:String,trade:String)->String{
        
        let usdMarketVal = getCurrencyValueInUSD(currency: market) ?? 0
        let usdTradeVal = getFiatCurrencyValueInUSD(currency: trade) ?? 0
        
        return "\((1/usdMarketVal) * (1/usdTradeVal))"
        
//        if let selectedCurrencyDetails = UserDefaults.standard.value(forKey: "fiatSelectedCurrency") as? [String:Any],
//            let currencyName = selectedCurrencyDetails["currency"] as? String{
//            let amount = getFiatEstimatedPrice(amount: amount, baseCurrency: baseCurrency,shouldUsedForOnlyFiatEstimateViewing: true)
//            if amount > 0{
//                return String(format: "%.2f \(currencyName)", amount)
//            }else{
//                return ""
//
//            }
//        }
//        return ""
    }
    
    func getImageByCurrencyCode(code: String) ->UIImage {
        var image = UIImage.init(named: "generic")!
        
        if let img = UIImage.init(named: code.lowercased()) {
            image = img
        }

    return image
  }
    
    
    
    //MARK: -  WithoutLogin new functionality
    func isUserLoggedIn()->Bool{
        if let _ = UserDefaults.standard.value(forKey: "AccessToken") as? String{
            return true
        }
        return false
    }
    
    func showYouWantToLoginPopUp(){
        _ = MDAlertPopupView.showAlertPopupViewOnWidnow(title: localised("appTitle"), errorMessage: "Do you want to Login to use this feature ?", alertDelegate: self,shoudlDimissOutSide: false)
        
    }
}

extension MDHelper:alertPopupDelegate{
    ///Handle Alert popup click
    func alertPopupResponse(isAgree: Bool) {
        if isAgree == true {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewc = storyboard.instantiateInitialViewController() as! UINavigationController
            if let navBar = UIApplication.shared.topMostViewController() as? UINavigationController{
                navBar.pushViewController(viewc, animated: true)
            }else if let tabBar =  UIApplication.shared.topMostViewController() as? UITabBarController{
                viewc.modalPresentationStyle = .fullScreen
                tabBar.present(viewc, animated: true, completion: nil)
//                (tabBar.selectedViewController as? UINavigationController)?.pushViewController(viewc.viewControllers.first!, animated: true)
            }
        }else{
            if let tabBar =  UIApplication.shared.topMostViewController() as? UITabBarController{
//                tabBar.present(viewc, animated: true, completion: nil)
                tabBar.selectedIndex = 0

            }
        }
    }
}

extension MDHelper{
    
    func getDecimalPrecision(base : String , quote : String)->(Int , Int){
        /**Get Dicimal Precision*/
        let trade = MDHelper.shared.tradeSettings.first { (trade) -> Bool in
            return (trade.coinName == base && trade.marketName == quote)
        }
        return (trade?.decisionPrecisionPrice ?? 3 , trade?.decimalPrecisionVoulme ?? 3)
    }
    
    func getFormattedNumber(amount:Double , minimumFractionDigits:Int)->String?{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        numberFormatter.maximumFractionDigits = minimumFractionDigits
        //numberFormatter.roundingMode = .down
        let formattedNumber = numberFormatter.string(from: NSNumber(value:amount))
        return formattedNumber
    }
    
    func getFormattedNumber(amount:Double , minimumFractionDigits:Int , maxFractionDigits : Int)->String?{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        numberFormatter.maximumFractionDigits = maxFractionDigits
       // numberFormatter.roundingMode = .down
        let formattedNumber = numberFormatter.string(from: NSNumber(value:amount))
        return formattedNumber
    }
    
    func getFormattedNumberWithTrailingZero(amount:Double)->String?{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 16
        let formattedNumber = numberFormatter.string(from: NSNumber(value:amount))
        return formattedNumber
    }
    
    func getNumberOFDecimals(double : Double)->Int{
        let decimalNumber = NSDecimalNumber(string: "\(double)")
        if decimalNumber.description.contains("."){
            return decimalNumber.description.split(separator: ".").last?.count ?? 0
        }else{
            return 0
        }
    }
    
    func saveAppSetting(dict: NSDictionary?){
        self.settingDict = dict
    }
    
    func getAppSetting()->NSDictionary?{
        return self.settingDict
    }
    
    func setMarketetData(marketData : [MDMarketTabModel]){
        self.md_market_data = marketData
    }

    func getMarketetData() -> [MDMarketTabModel]{
        return self.md_market_data
    }
    
    
    func getDecimalPrecisionFor(currnecy : String)->Int{
        let currencyInfo = appDelegate.currencySettings.first { $0.shortName == currnecy }
        return min(8 , currencyInfo?.decimalPrecision ?? 2)
    }

}
