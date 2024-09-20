//
//  MDMarketOverViewVC.swift
//  Modulus
//
//  Created by Pathik  on 18/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//   base_currency

import UIKit
import WebKit
import MaterialComponents.MaterialTabs
import DropDown
import Alamofire
struct ConstantSizes {
    static let navigationTitleWidth = CGFloat(175)
}
//1:0.68
class MDMarketOverViewVC: UIViewController , MDCTabBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,customDropDownDelegates {
    deinit {
        print("deint MDMarketOverViewVC")
        if #available(iOS 13.0, *) {
            SocketHelper.shared.unsubscribeToSpecificEvents()
            SocketHelper.shared.orderBookSell = []
            SocketHelper.shared.orderBookBuy = []
        }
    }
    
    //MARK: - StoryBoard Outlets
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var depthButton: UIButton!
    //    @IBOutlet weak var webViewContainerHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var closeFullScreenGraphButton: UIButton!
    @IBOutlet weak var webViewContainerView: UIView!
    @IBOutlet weak var buttonsMainView: UIView!
    @IBOutlet weak var noDepthChartDataLabel: UILabel!
    //    @IBOutlet weak var tableViewHight: NSLayoutConstraint!
    @IBOutlet weak var marketButton: UIButton!
    @IBOutlet weak var depthChartView: INDepthChartView!
    //    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainBuySellButtonBackground: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var rateInUSDLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var percentImageview: UIImageView!
    @IBOutlet weak var volumnLabel: UILabel!
    @IBOutlet weak var HighLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    @IBOutlet weak var highLabelAmount: UILabel!
    @IBOutlet weak var lowLabelAmount: UILabel!
    @IBOutlet weak var volumnLabelAmount: UILabel!
    
    @IBOutlet weak var orderandTradeBgView: UIView!
    @IBOutlet weak var orderBookButton: UIButton!
    @IBOutlet weak var tradeHistoryButton: UIButton!
    @IBOutlet weak var decimalAmoutTableView: UITableView!
    @IBOutlet weak var tabBakcgroundView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var landScapeWebView: WKWebView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var balanceFiguresStackView: UIStackView!
    @IBOutlet weak var chartsheaderViewBgView: UIView!
    @IBOutlet weak var ordersTradeColumnsHeaders: UIStackView!
    @IBOutlet weak var maximiseButton: UIButton!
    
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var amountButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var tradeTableViewLC: NSLayoutConstraint!
    //Landscape mode issues
    var detailLabel = UILabel()
    var titleButton = MDButtonWithImageOnRight()
    var titleView = UIView()
    // MARK: - transisting data
    /// Transisting data can be set by other Classes while transition to this Class
    var selectedCurrencyPairData:NSDictionary?
    var navigationTitle = ""
    var selectedCurrency = ""
    var marketType = ""
    var isTradeHistory = false
    var isDepthChartView = false
    var decimalTableInitialHeight = CGFloat(0)
    var isPageLoaded = false
    
    //MARK: - Constants
    let tabBar = MDCTabBar()
    let cellHeight = CGFloat(20)
    let cellID = "decimalAmoutCell"
    let navigationDropDown = DropDown()
    
    //MARK: - Variables
    var tabs  = ["8decimal","Amount","Valume"]
    var isLoadingIndicatorOnTableView = false
    var scrollViewInitialHeight:CGFloat = 0
    var bottomSheet : MDCBottomSheetController? = nil
    var tradeHistory : NSArray = []
    var orderBooks : NSArray = []
    var depthChartDataAvailable = false
    
    var orderBookBuyData = NSArray()
    var orderBookSellData = NSArray()
    /**Decimal Peecision*/
    var decimalPrecision : Int = 0
    var decimalPrecisionvolm : Int = 0
    
    
    //MARK: - Automation helpers
    func addAutomationIdentifiers(){
        
        //For Automation
        buyButton.accessibilityValue = "buyButton"
        buyButton.accessibilityIdentifier = "buyButton"
        buyButton.accessibilityLabel = "buyButton"
        
        sellButton.accessibilityValue = "sellButton"
        sellButton.accessibilityIdentifier = "sellButton"
        sellButton.accessibilityLabel = "sellButton"
        
        marketButton.accessibilityValue = "marketButton"
        marketButton.accessibilityIdentifier = "marketButton"
        marketButton.accessibilityLabel = "marketButton"
        
        depthButton.accessibilityValue = "depthButton"
        depthButton.accessibilityIdentifier = "depthButton"
        depthButton.accessibilityLabel = "depthButton"
        
        orderBookButton.accessibilityValue = "orderBookButton"
        orderBookButton.accessibilityIdentifier = "orderBookButton"
        orderBookButton.accessibilityLabel = "orderBookButton"
        
        tradeHistoryButton.accessibilityValue = "tradeHistoryButton"
        tradeHistoryButton.accessibilityIdentifier = "tradeHistoryButton"
        tradeHistoryButton.accessibilityLabel = "tradeHistoryButton"
    }
    
    //MARK: - Set all titles
    private func setAllTextOnScreenWithLocalisation(){
        marketButton.setTitle(localised("MARKET").localizedUppercase, for: .normal)
        depthButton.setTitle(localised("DEPTH").localizedUppercase, for: .normal)
        orderBookButton.setTitle(localised("ORDER BOOK").localizedUppercase, for: .normal)
        tradeHistoryButton.setTitle(localised("TRADES").localizedUppercase, for: .normal)
        
        buyButton.setTitle(localised("BUY").localizedUppercase, for: .normal)
        sellButton.setTitle(localised("SELL").localizedUppercase, for: .normal)
        
        self.setUpTableHeader()
        
        noDepthChartDataLabel.text = localised("No Depth chart data available")
        
    }
    
    private
    func setUpTableHeader(){
        let priceBtnTxt : String
        let amountBtnTxt : String
        let volumeBtnTxt : String
        if isTradeHistory {
            priceBtnTxt = localised("Price")
            amountBtnTxt = localised("Size")
            volumeBtnTxt = localised("Time")
        }else{
            priceBtnTxt = localised("Price") + "(\(self.marketType))"
            amountBtnTxt = localised("Size") + "(\(self.selectedCurrency))"
            volumeBtnTxt = localised("Total")
        }
        
        priceButton.setTitle(priceBtnTxt.localizedUppercase, for: .normal)
        amountButton.setTitle(amountBtnTxt.localizedUppercase, for: .normal)
        volumeButton.setTitle(volumeBtnTxt.localizedUppercase, for: .normal)
    }
        
        
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedCurrency = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base") as! String
        self.marketType = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "quote") as! String
        /**Get Dicimal Precision*/
        let decPrecisions = MDHelper.shared.getDecimalPrecision(base: self.selectedCurrency, quote: self.marketType)
        self.decimalPrecision = decPrecisions.0
        self.decimalPrecisionvolm = decPrecisions.1
        setpupColor()
        setUpIntialData()
        setUpTradingViewCharts()
        toggleTradeOpenOrder()
        toggleDepthChartMarketView()
        getLowHighChartData()
        getDepthChartData()
        self.setAllTextOnScreenWithLocalisation()
        /// Note the intial Heights for the scrrollview and the Bottom tableview
        self.decimalAmoutTableView.isUserInteractionEnabled = false
        decimalTableInitialHeight = decimalAmoutTableView.frame.size.height
        addAutomationIdentifiers()
        
        HighLabel.text = localised("High")
        lowLabel.text = localised("Low")
        self.volumnLabel.text = localised("Volume")

        self.addObserver()
        self.decimalAmoutTableView.isScrollEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.portrait)
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
            SocketHelper.shared.subscribeToSpecificEvents(coin: self.selectedCurrency + "_" + self.marketType)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SocketHelper.shared.subscribeToSpecificEvents(coin: self.selectedCurrency + "_" + self.marketType)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    SocketHelper.shared.subscribeToSpecificEvents(coin: self.selectedCurrency + "_" + self.marketType)
                }
            }
            
        }
        self.closeFullScreenGraphButton.isHidden = true
        setUpNavigationBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        webView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)

    }
    
    
    //MARK: - Orientation helpers
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UIDevice.current.orientation.isLandscape {
                self.titleButton.center = self.titleView.center
                self.detailLabel.frame = CGRect(x: self.titleButton.frame.origin.x + self.titleButton.frame.size.width -  10,
                                                y: self.titleButton.frame.origin.y,
                                                width: self.titleButton.frame.size.width,
                                                height: self.titleButton.frame.size.height)
            }else{
                self.titleView.frame = CGRect(x: 0, y: 0, width: ConstantSizes.navigationTitleWidth, height: (self.navigationController?.navigationBar.frame.size.height)!)
                self.titleButton.frame = CGRect(x: 0, y: 0, width: self.titleButton.frame.size.width, height: (self.navigationController?.navigationBar.frame.size.height)! - CGFloat(20))
                self.detailLabel.frame = CGRect.init(x: 0,
                                                     y:self.titleButton.frame.origin.y + self.titleButton.frame.size.height,
                                                     width: self.titleButton.frame.size.width,
                                                     height: 20)
            }
        }
        if self.bottomSheet != nil && (self.presentedViewController as? MDCBottomSheetController)?.presentingViewController != nil{
            let currency = (self.bottomSheet?.contentViewController as? MDDropDownVC)?.selectedCurrency
            self.bottomSheet?.dismiss(animated: false, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let filteredVC = self.navigationController?.viewControllers.filter({ (viewController) -> Bool in
                    viewController is MarketListVC
                })
                if let marketListVC = filteredVC?.first as? MarketListVC{
                    let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
                    let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
                    dropDownVC.marketSummary = marketListVC.marketSummary.mutableCopy() as! NSMutableArray
                    dropDownVC.delegate = self
                    dropDownVC.selectedPair = currency ?? self.selectedCurrency
                    dropDownVC.selectedCurrency = self.selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base") as! String
                    dropDownVC.marketType = currency ?? self.marketType
                    
                    self.bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
                    self.bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: self.view.frame.size.height -  (UIApplication.shared.statusBarFrame.height))
                    self.bottomSheet?.delegate = self
                    self.present(self.bottomSheet!, animated: true, completion: nil)
                }
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.updateContentSize()
            
        }
        DispatchQueue.main.async {
            self.depthChartView.configureDepthChartView()
        }
    }
    
    private
    func addObserver(){
        self.decimalAmoutTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newSize = change?[.newKey] as? CGSize{
                DispatchQueue.main.async {
                    if newSize.height == 0 {
                        self.tradeTableViewLC.constant = 300
                    }else{
                        self.tradeTableViewLC.constant = newSize.height
                    }
                }
              
            }
        }
    }
    
    //MARK: - Web view helpers
    /// We are showing Trading view charts in webView via Below mentioned Url
    /// URL :http://vps3.inspeero.com:9090/mobile_black.html
    func setUpTradingViewCharts(){
        var url : String = API.baseURL
        if API.baseURL.last == "/"{
            url.removeLast()
        }
        
        print("URLLL \(url)")
        //let url : String = "https://node1.modulusexchange.com"
        let urlRaw = Bundle.main.url(forResource: "index", withExtension: "html")
        // Show mobile view which is not fullscreen
        let absoluteStringMobile = "\(urlRaw!.absoluteString)?base=\(selectedCurrency)&to=\(marketType)&domain=\(url)&interval=5&timestamp=\(Date().millisecondsSince1970)"
        guard let mobileUrl = URL.init(string: absoluteStringMobile) else {
            print("No file at url")
            return
        }
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.loadFileURL(mobileUrl, allowingReadAccessTo: mobileUrl)
        webView.backgroundColor = .clear
        webView.navigationDelegate = self
        webView.uiDelegate = self
        MDHelper.shared.showHud(view: webView)
        // Full screen webview
        let absoluteStringFullscreen = "\(urlRaw!.absoluteString)?base=\(selectedCurrency)&to=\(marketType)&domain=\(url)&interval=5&timestamp=\(Date().millisecondsSince1970)&preset="
        guard let fullScreenUrl = URL.init(string: absoluteStringFullscreen) else {
            print("No file at url")
            return
        }
        print("\(urlRaw!.absoluteString)?base=\(selectedCurrency)&to=\(marketType)&domain=\(url)&interval=5&timestamp=\(Date().millisecondsSince1970)&preset=")
        
        landScapeWebView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        landScapeWebView.loadFileURL(fullScreenUrl, allowingReadAccessTo: fullScreenUrl)
        landScapeWebView.backgroundColor = .clear
        landScapeWebView.navigationDelegate = self
        landScapeWebView.uiDelegate = self
        landScapeWebView.isOpaque = false
        landScapeWebView.backgroundColor = .clear
        MDHelper.shared.showHud(view: landScapeWebView)
    }
    //MARK: - UI Helpers
    /// We have to update contentSize of main Scrollview of screen after reloading tables
    func updateContentSize(){
//        var topSafeArea: CGFloat
//        var bottomSafeArea: CGFloat
//        if #available(iOS 11.0, *) {
//            topSafeArea = view.safeAreaInsets.top
//            bottomSafeArea = view.safeAreaInsets.bottom
//        } else {
//            topSafeArea = topLayoutGuide.length
//            bottomSafeArea = bottomLayoutGuide.length
//        }
//        let navigationControllerObject = UINavigationController()
//        let defaultHeight = UIScreen.main.bounds.height - (orderandTradeBgView.frame.origin.y + orderandTradeBgView.frame.size.height + tabBakcgroundView.frame.size.height) - (navigationControllerObject.navigationBar.frame.height) - topSafeArea
//        // Default table height is set to 180 from storyboard
//        if decimalAmoutTableView.contentSize.height > defaultHeight {
//
//            let upparPartHeight = orderandTradeBgView.frame.size.height + tabBakcgroundView.frame.size.height
//            if (decimalAmoutTableView.contentSize.height + upparPartHeight) > self.view.frame.size.height{
//                var topSafeArea: CGFloat
//                var bottomSafeArea: CGFloat
//
//                if #available(iOS 11.0, *) {
//                    topSafeArea = view.safeAreaInsets.top
//                    bottomSafeArea = view.safeAreaInsets.bottom
//                } else {
//                    topSafeArea = topLayoutGuide.length
//                    bottomSafeArea = bottomLayoutGuide.length
//                }
//
//                // Dont consider safe area in landscape
//                let navigationControllerObject = UINavigationController()
//
//                if UIApplication.shared.statusBarOrientation.isLandscape {
//                    tableHeightConstraint.constant = self.view.frame.size.height - (navigationControllerObject.navigationBar.frame.height) - upparPartHeight - topSafeArea - (orderandTradeBgView.frame.size.height/2)
//                }else{
//                    tableHeightConstraint.constant = self.view.frame.size.height - (navigationControllerObject.navigationBar.frame.height) - upparPartHeight - topSafeArea
//                }
//
//                self.decimalAmoutTableView.isUserInteractionEnabled = false
//            }else{
//                tableHeightConstraint.constant = 180
//            }
//        }else{
//            tableHeightConstraint.constant = defaultHeight
//        }
        
        
    }
    
    /// This will set up navigation bar UI
    func setUpNavigationBar(){
        titleView =  UIView.init(frame: CGRect(x: 0, y: 0, width: ConstantSizes.navigationTitleWidth, height: (self.navigationController?.navigationBar.frame.size.height)!))
        titleButton = MDButtonWithImageOnRight(frame: CGRect(x: 0, y: 0, width: titleView.frame.size.width, height: titleView.frame.size.height-CGFloat(20)))
        if UIDevice.current.orientation.isLandscape {
            titleButton.center = titleView.center
        }
        titleButton.setImage(UIImage.init(named: "Rectangle"), for: .normal)
        titleButton.tintColor = Theme.current.subTitleColor
        titleButton.setTitle(navigationTitle, for: .normal)
        titleButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        titleButton.titleLabel?.font = MDAppearance.Fonts.smallNavigationTitleFont
        titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        titleButton.addTarget(self, action: #selector(showNavigationDropDown(sender:)), for: .touchUpInside)
        
        //For Automation
        titleButton.isAccessibilityElement = true
        titleButton.accessibilityIdentifier = "CurrencyDropDownButton"
        titleButton.accessibilityValue = "CurrencyDropDownButton"
        titleButton.accessibilityLabel = "CurrencyDropDownButton"
        titleView.addSubview(titleButton)
        detailLabel = UILabel(frame: CGRect.init(x: 0, y:titleButton.frame.origin.y + titleButton.frame.size.height, width: titleButton.frame.size.width, height: 20))
        detailLabel.textAlignment = .center
        detailLabel.textColor = Theme.current.redColor
        detailLabel.font =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 14)
        titleView.addSubview(detailLabel)
        var detailsLabelText = ""
        if let lastPriceVal = selectedCurrencyPairData!.valueForCaseInsensativeKey(forKey: "price") as? Double{
            detailsLabelText = MDHelper.shared.getFormattedNumber(amount: lastPriceVal, minimumFractionDigits: self.decimalPrecision) ?? ""
        }
        if let  percen = selectedCurrencyPairData!.valueForCaseInsensativeKey(forKey: "change_in_price") as? Double{
            detailsLabelText = detailsLabelText + "    \(String(format: "%.2f", percen))%"
            detailLabel.textColor = percen < 0 ? Theme.current.redColor : Theme.current.secondaryColor
        }
        detailLabel.text = detailsLabelText
        self.navigationItem.titleView = titleView
        if UIApplication.shared.statusBarOrientation.isLandscape{
            titleButton.center = self.navigationItem.titleView!.center
            detailLabel.frame = CGRect(x: titleButton.frame.origin.x + titleButton.frame.size.width -  10,
                                       y: titleButton.frame.origin.y,
                                       width: titleButton.frame.size.width,
                                       height: titleButton.frame.size.height)
        }else{
            titleButton.frame = CGRect(x: 0, y: 0, width: titleButton.frame.size.width, height: titleButton.frame.size.height)
            detailLabel.frame = CGRect.init(x: 0,
                                            y:titleButton.frame.origin.y + titleButton.frame.size.height,
                                            width: titleButton.frame.size.width,
                                            height: 20)
        }
    }
    
    func setpupColor()  {
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.scrollContentView.backgroundColor = Theme.current.backgroundColor
        tabBar.tintColor = Theme.current.primaryColor
        tabBar.selectedItemTintColor = Theme.current.primaryColor
        tabBar.unselectedItemTintColor = Theme.current.primaryColor
        
        lastPriceLabel.textColor = Theme.current.titleTextColor
        rateInUSDLabel.textColor = Theme.current.titleTextColor.withAlphaComponent(0.8)
   
        HighLabel.textColor = Theme.current.titleTextColor
        volumnLabel.textColor = Theme.current.titleTextColor
        lowLabel.textColor = Theme.current.titleTextColor
        
        highLabelAmount.textColor = Theme.current.titleTextColor
        volumnLabelAmount.textColor = Theme.current.titleTextColor
        lowLabelAmount.textColor = Theme.current.titleTextColor
        
        // Settings colors to balanceFiguresStackview
        for view in balanceFiguresStackView.arrangedSubviews{
            view.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
            for subview in view.subviews{
                if subview is UIStackView{
                    ((subview as! UIStackView).arrangedSubviews[0] as! UILabel).textColor = Theme.current.titleTextColor
                    ((subview as! UIStackView).arrangedSubviews[1] as! UILabel).textColor = Theme.current.primaryColor
                }else{
                    subview.backgroundColor = Theme.current.primaryColor
                }
            }
        }
        
        // Headers
        chartsheaderViewBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        orderandTradeBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        
        // COlumn headers
        for button in ordersTradeColumnsHeaders.arrangedSubviews{
            if button is UIButton{
                (button as! UIButton).setTitleColor(Theme.current.titleTextColor, for: .normal)
            }
        }
        
        //Bottom bar with buttons
        buttonsMainView.backgroundColor = Theme.current.backgroundColor
        sellButton.backgroundColor = Theme.current.redColor
        buyButton.backgroundColor = Theme.current.secondaryColor
        sellButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        buyButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
    }
    
    // MARK: - Intial Data helpers
    /// This will do the show all initial data on screen with some data manipulations
    func setUpIntialData(){
        let marketCurrency = selectedCurrencyPairData?.value(forKey: "quote") as! String
        let coinName = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base") as! String
        
        if let lastPriceVal = selectedCurrencyPairData!.valueForCaseInsensativeKey(forKey: "price") as? Double{
            lastPriceLabel.text = MDHelper.shared.getFormattedNumber(amount: lastPriceVal, minimumFractionDigits: self.decimalPrecision)
            rateInUSDLabel.text = MDHelper.shared.getFiatEstimatedPriceString(amount: lastPriceVal, baseCurrency: marketCurrency)
        }
        let decimalPrecision = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "min_order_value") as? Double ?? 0.0001
        let precision = MDHelper.shared.getNumberOFDecimals(double: decimalPrecision)
        
        
        if let vol = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base_volume") as? Double{
            volumnLabelAmount.text = MDHelper.shared.getFormattedNumber(amount: vol, minimumFractionDigits: precision)!
        }
        if let last24High = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "high_24hr") as? Double{
            highLabelAmount.text = MDHelper.shared.getFormattedNumber(amount: last24High, minimumFractionDigits: self.decimalPrecision)!
        }
        if let last24Low = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "low_24hr") as? Double{
            lowLabelAmount.text = MDHelper.shared.getFormattedNumber(amount: last24Low, minimumFractionDigits: self.decimalPrecision)!
        }
        
        if let percen = selectedCurrencyPairData!.valueForCaseInsensativeKey(forKey: "change_in_price") as? Double{
            percentageLabel.text = "\(String(format: "%.2f", percen))%".replacingOccurrences(of: "-", with: "")
            percentImageview.image = percen < 0 ?  UIImage(named: "redPriceDrop")?.imageWithColor(color1: Theme.current.redColor) : UIImage(named: "greenPriceUp")?.imageWithColor(color1: Theme.current.secondaryColor)
            percentageLabel.textColor = percen < 0 ? Theme.current.redColor : Theme.current.secondaryColor
        }
//        DispatchQueue.global(qos: .background).async {
//            if MDHelper.shared.isUserLoggedIn() == true{
//                if let balanceInfo = MDWalletHelper.shared.getWalletBalanceForCurrency(currency: marketCurrency){
//                    // print(balanceInfo)
//                    let inorders = balanceInfo.valueForCaseInsensativeKey(forKey: "balanceInTrade") as? Double ?? 0.0
//                    let balance = balanceInfo.valueForCaseInsensativeKey(forKey: "balance") as? Double ?? 0.0
//                    let lastPriceVal = self.selectedCurrencyPairData!.valueForCaseInsensativeKey(forKey: "price") as? Double ?? 1
//                    DispatchQueue.main.async {
//                        let decimalsForBal = MDHelper.shared.getNumberOFDecimals(double: balance)
//                        let minFractionDigitsBal = balance == 0 ? 2 : 0
//                        let minFractionDigitsIn = inorders == 0 ? 2 : 0
//                        self.availableUSDLabel.text = MDHelper.shared.getFormattedNumber(amount: balance, minimumFractionDigits: minFractionDigitsBal ,  maxFractionDigits: decimalsForBal)
//                        self.inOrderLabel.text = MDHelper.shared.getFormattedNumber(amount: inorders , minimumFractionDigits: minFractionDigitsIn , maxFractionDigits: decimalsForBal)
//                        let name = marketCurrency
//                        if let usdVal : Double = MDHelper.shared.getCurrencyValueInUSD(currency: name){
//
//                            let usdConversion = balance * usdVal
//                            if let btcValue = MDHelper.shared.getCurrencyValueInUSD(currency: "BTC"){
//                                let btcConversion = usdConversion / btcValue
//                                print(btcConversion)
//                                self.convertBTCLabel.text =  MDHelper.shared.getFormattedNumber(amount: btcConversion, minimumFractionDigits: 8)
//                            }
//                        }else{
//                            if let usdVal = MDHelper.shared.getFiatCurrencyValueInUSD(currency: name),usdVal != 0 {
//                                let usdConversion = balance * usdVal
//                                if let btcValue = MDHelper.shared.getCurrencyValueInUSD(currency: "BTC"){
//                                    let btcConversion = usdConversion / btcValue
//                                    print(btcConversion)
//                                    self.convertBTCLabel.text =  MDHelper.shared.getFormattedNumber(amount: btcConversion, minimumFractionDigits: 2 , maxFractionDigits: 8)
//                                }
//                            }else{
//                                print("Not a fiate and not crypto \(name)")
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
    //MARK: - Data fetching methods
    /// This will fetch the Trade history data for given currency
    ///
    /// - Parameter forCurrency: You need to pass the currency of which you have to fetch trade history
    func fetchTradeHistory(forCurrency:String)  {
        tradeHistory = []
        self.decimalAmoutTableView.reloadData()
        self.updateContentSize()
        if #available(iOS 13.0, *) {
            if let tradeHistoryData =  SocketHelper.shared.tradeHistory {
                tradeHistory = tradeHistoryData
                updateContentSize()
                self.decimalAmoutTableView.reloadData()
                self.updateContentSize()
                
            }else{
                if tradeHistory.count == 0 {
                    MDHelper.shared.showHud(view: decimalAmoutTableView)
                    isLoadingIndicatorOnTableView = true
                    self.decimalAmoutTableView.backgroundView = nil
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            MDHelper.shared.hideHud(view: self.decimalAmoutTableView)
            self.isLoadingIndicatorOnTableView = false
            self.decimalAmoutTableView.reloadData()
            self.updateContentSize()
        }
    }
    
    
    //MARK: - Response Handlers
    /// This will parse response for trade history
    /// - Parameter response: response came from SignalR stream
    func handleTradeHistoryResponse(response:NSDictionary){
        if let data = response.valueForCaseInsensativeKey(forKey:"data") as? NSArray{
            //  if let orders = data.valueForCaseInsensativeKey(forKey: "Orders") as? NSArray{
            tradeHistory = data
            
            updateContentSize()
            self.decimalAmoutTableView.reloadData()
            self.updateContentSize()
            // }
        }
    }
    
    
    //MARK: - DepthChart Data
    /// Currently depth chart data is fetching from the Rest API : BaseUrl + user-api/depth
    func getDepthChartData()  {
        MDHelper.shared.showHud(view: self.depthChartView)
        self.depthChartView.depthChart.isHidden = true
        self.landScapeWebView.isHidden = true
        //   self.depthChartView.clearDepthChartData()
        let coinName = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base") as! String
        let marketName = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "quote") as! String
        MDNetworkManager.shared.getDepthChartData(currencyPair: "\(marketName)_\(coinName)", limit: "50") { [unowned self](response, error) in
            MDHelper.shared.hideHud(view: self.depthChartView)
            if response != nil && error == nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
                        if let ask = data.valueForCaseInsensativeKey(forKey: "asks") as? NSArray ,
                           let bid = data.valueForCaseInsensativeKey(forKey: "bids") as? NSArray ,
                           (ask.count > 0 ||
                                bid.count > 0){
                            self.depthChartView.depthChart.isHidden = false
                            self.depthChartDataAvailable = true
                            if self.isDepthChartView == true {
                                self.depthChartView.isHidden = false
                                self.noDepthChartDataLabel.isHidden = true
                                
                            }
                            self.depthChartView.configureDepthChart(response:response!)
                        }else{
                            self.depthChartDataAvailable = false
                            if self.isDepthChartView == true{
                                self.depthChartView.isHidden = true
                                self.noDepthChartDataLabel.isHidden = false
                                
                            }
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
    func getLowHighChartData() {
//        HighLabel.text = localised("High")+":     N/A"
//        lowLabel.text = localised("Low")+":     N/A"
//        if let last24High = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "high_24hr") as? Double{
//            HighLabel.text = localised("High")+":     " + MDHelper.shared.getFormattedNumber(amount: last24High, minimumFractionDigits: self.decimalPrecision)!
//        }
//        if let last24Low = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "low_24hr") as? Double{
//            lowLabel.text = localised("Low")+":     " + MDHelper.shared.getFormattedNumber(amount: last24Low, minimumFractionDigits: self.decimalPrecision)!
//        }
    }
    
    
    //MARK: - tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  isTradeHistory ? tradeHistory.count : orderBooks.count
        if count == 0  && isLoadingIndicatorOnTableView == false{
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
        return isTradeHistory ? tradeHistory.count : orderBooks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MDOrderTradeCell
        let cellData =  isTradeHistory ? tradeHistory[indexPath.row] as! NSDictionary : orderBooks[indexPath.row] as! NSDictionary
        cell.configureCell(data: cellData,isTrade: isTradeHistory, decimalPrecision: self.decimalPrecision)
        let celltype = cellData.valueForCaseInsensativeKey(forKey: "execution_side") as? String
        if celltype?.lowercased() == "buy"{
            cell.tradeLabel.textColor = Theme.current.secondaryColor
            cell.amountLabel.textColor = Theme.current.secondaryColor
            cell.volumeLabel.textColor = Theme.current.secondaryColor
        }else if celltype?.lowercased() == "sell"{
            cell.tradeLabel.textColor = Theme.current.redColor
            cell.amountLabel.textColor = Theme.current.redColor
            cell.volumeLabel.textColor = Theme.current.redColor
        }
        return cell
    }
    
    //MARK: - sizes for tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    //MARK: - Tab bar delegates
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //        print("prepare for segue")
        let viewC = segue.destination as! MDBuySellVC
        // viewC.navigationTitle = sender as! String
        viewC.selectedCurrencyPairData = selectedCurrencyPairData!
        viewC.navigationTitle = navigationTitle
        viewC.isBuyTypeScreen = sender as! Bool
        viewC.selectedCurrency = selectedCurrency
        viewC.marketType = self.marketType
        viewC.decimalPricisonPrice = self.decimalPrecision
        viewC.decimalPricisionVolume = self.decimalPrecisionvolm
        viewC.hidesBottomBarWhenPushed = true
    }
    
    func toggleTradeOpenOrder()  {
        if isTradeHistory {
            orderBookButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            tradeHistoryButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            fetchTradeHistory(forCurrency: selectedCurrency)
        }else {
            tradeHistoryButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            orderBookButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            self.fetchOrdersForAll(forCurrency: selectedCurrency)
        }
        self.setUpTableHeader()
    }
    func toggleDepthChartMarketView()  {
        
        if isDepthChartView {
            marketButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            depthButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            if depthChartDataAvailable == false{
                maximiseButton.isHidden = true
                depthChartView.isHidden = true
                noDepthChartDataLabel.isHidden = false
            }else{
                maximiseButton.isHidden = true
                depthChartView.isHidden = false
                noDepthChartDataLabel.isHidden = true
            }
            
            webView.isHidden = true
        }else {
            maximiseButton.isHidden = false
            depthButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            marketButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            depthChartView.isHidden = true
            webView.isHidden = false
            noDepthChartDataLabel.isHidden = true
        }
        
    }
    func fetchOrdersForAll(forCurrency:String)  {
        if orderBooks.count == 0 {
            MDHelper.shared.showHud(view: decimalAmoutTableView)
            isLoadingIndicatorOnTableView = true
            //tradeHistory = []
            orderBooks = []
            self.decimalAmoutTableView.reloadData()
            self.updateContentSize()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+10) {
            MDHelper.shared.hideHud(view: self.decimalAmoutTableView)
            self.isLoadingIndicatorOnTableView = false
            self.decimalAmoutTableView.reloadData()
            self.updateContentSize()
        }
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
        }
    }
    func handleOpenOrderResponse(response:NSDictionary){
        if let data = response.valueForCaseInsensativeKey(forKey:"data") as? NSDictionary{
            let type = data.valueForCaseInsensativeKey(forKey: "Type") as! String
            if let orders = data.valueForCaseInsensativeKey(forKey: "Orders") as? NSArray{
                let oldArray  = NSMutableArray(array: orderBooks)
                orderBooks = oldArray.addingObjects(from:orderArrayFormated(fromArray: orders, type: type) as! [Any]) as NSArray
                self.decimalAmoutTableView.reloadData()
                self.updateContentSize()
            }
        }
    }
    
    func handleOrderBookData(response:NSArray,type:String){
        let oldArray  = NSMutableArray(array: orderBooks)
        let oldSequnce = oldArray.compactMap { str in str as? NSDictionary }
        let newSequence = orderArrayFormated(fromArray: response, type: type).compactMap { str in str as? NSDictionary }
        let oldSet = Set(oldSequnce)
        let newSet = Set(newSequence)
        let combinedSet = newSet.union(oldSet)
        orderBooks = NSArray.init(array: Array(combinedSet))
        self.decimalAmoutTableView.reloadData()
        self.updateContentSize()
    }
    
    func refreshData(){
        orderBooks = (orderBookBuyData.reversed() as! [[String:Any]]) + (orderBookSellData as! [[String:Any]]) as NSArray
        self.decimalAmoutTableView.reloadData()
        self.updateContentSize()
    }
    
    func orderArrayFormated(fromArray: NSArray,type:String) -> NSArray {
        var newArray : [NSDictionary] = []
        for item in fromArray {
            let editItem = NSMutableDictionary.init(dictionary: item as! NSDictionary)
            editItem.setValue(type, forKey: "ExecutionType")
            newArray.append(editItem)
        }
        return newArray as NSArray
    }
    
    //MARK: - button Actions
    @IBAction func sellButtonAction(_ sender: Any) {
        if MDHelper.shared.isUserLoggedIn() == true{
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    SocketHelper.shared.delegate = nil
                    self.performSegue(withIdentifier: "buySellScreen", sender: false)
                }
            }
        }else{
            MDHelper.shared.showYouWantToLoginPopUp()
        }
    }
    @IBAction func buyButtonAction(_ sender: Any) {
        if MDHelper.shared.isUserLoggedIn() == true{
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    SocketHelper.shared.delegate = nil
                    self.performSegue(withIdentifier: "buySellScreen", sender: true)
                }
            }
            
        }else{
            MDHelper.shared.showYouWantToLoginPopUp()
        }
    }
    
    @IBAction func orderBookAction(_ sender: Any) {
        if isTradeHistory == true {
            isTradeHistory = false
            toggleTradeOpenOrder()
            if #available(iOS 13.0, *) {
                self.orderBookBuyDataReceived(response: SocketHelper.shared.orderBookBuy ?? [])
            }
        }
    }
    @IBAction func tradeHistoryACtion(_ sender: UIButton) {
        if isTradeHistory == false{
            isTradeHistory = true
            toggleTradeOpenOrder()
            if #available(iOS 13.0, *) {
                self.orderBookBuyDataReceived(response: SocketHelper.shared.orderBookBuy ?? [])
            }
        }
        
        
    }
    
    @IBAction func tapGestureOnGraph(_ sender: Any) {
        print("doubrl tapped on the webcontainer")
        
        if isDepthChartView == false{
            self.landScapeWebView.isHidden = false
            self.closeFullScreenGraphButton.isHidden = false
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.landScapeWebView.backgroundColor = Theme.current.backgroundColor
            self.closeFullScreenGraphButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            self.closeFullScreenGraphButton.backgroundColor = Theme.current.navigationBarColor.withAlphaComponent(0.5)
        }
        
    }
    @IBAction func closeFullScrennGraphAction(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.landScapeWebView.isHidden = true
        self.closeFullScreenGraphButton.isHidden = true
    }
    
    
    //    //MARK: - WKNavigation delegates
    //    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    //
    //            isPageLoaded = true
    //            MDHelper.shared.hideHud(view: self.webView)
    //            MDHelper.shared.hideHud(view: landScapeWebView)
    //    }
    
    //MARK: - navigation dropdown
    @objc func showNavigationDropDown(sender:Any){
        
        
        
        self.view.endEditing(true)
        
        let filteredVC = self.navigationController?.viewControllers.filter({ (viewController) -> Bool in
            viewController is MarketListVC
        })
        
        if let marketListVC = filteredVC?.first as? MarketListVC{
            let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
            let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
            dropDownVC.marketSummary = marketListVC.marketSummary.mutableCopy() as! NSMutableArray
            dropDownVC.delegate = self
            dropDownVC.selectedPair = selectedCurrency
            dropDownVC.selectedCurrency = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base") as! String
            dropDownVC.marketType = marketType
            
            bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
            
            
            bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: self.view.frame.size.height -  (UIApplication.shared.statusBarFrame.height))
            
            
            
            bottomSheet?.delegate = self
            present(bottomSheet!, animated: true, completion: nil)
        }
    }
    
    //MARK: - Refresh data
    /// This will refresh screen with data for selected trade currency from drop down
    func refreshDataWithChoosenCurrency(selectedCurrencyData:NSDictionary){
        
        //        let filteredVC = self.navigationController?.viewControllers.filter({ (viewController) -> Bool in
        //            viewController is MarketListVC
        //        })
        
        //        if let marketListVC = filteredVC?.first as? MarketListVC{
        if #available(iOS 13.0, *) {
            SocketHelper.shared.unsubscribeToSpecificEvents()
        }
        
        self.selectedCurrencyPairData = selectedCurrencyData
        self.selectedCurrency = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base") as! String
        self.marketType = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "quote") as! String
        self.navigationTitle = "\(selectedCurrency)/\(self.marketType)"
        MDSignalRManager.shared.joinGroups(marketType: marketType, currency: selectedCurrency)
        
        
        setUpNavigationBar()
        setpupColor()
        setUpIntialData()
        toggleTradeOpenOrder()
        getDepthChartData()
        setUpTradingViewCharts()
        getLowHighChartData()
        self.bottomSheet = nil
        
        if #available(iOS 13.0, *) {
            SocketHelper.shared.subscribeToSpecificEvents(coin: self.selectedCurrency + "_" + self.marketType)
        } else {
            // Fallback on earlier versions
        }
        
        //        }
    }
    
    
    //MARK: -  Charts view switching
    
    /// This will show depth charts on screen
    @IBAction func depthButtonAction(_ sender: Any) {
        isDepthChartView = true
        toggleDepthChartMarketView()
    }
    /// This will show Trading view market chart on screen
    @IBAction func marketButtonAction(_ sender: Any) {
        isDepthChartView = false
        toggleDepthChartMarketView()
    }
    
    
    
    //MARK: - Scrollview Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView{
            
            if scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.height){
                self.decimalAmoutTableView.isUserInteractionEnabled = false
            }else{
                self.decimalAmoutTableView.isUserInteractionEnabled = true
            }
        }
    }
    
    //MARK: - Dropdown Delegates
    /// This will be give selected dropdown element data and Title
    func dropDownSelected(title: String, data: NSDictionary) {
        tradeHistory = []
        orderBooks = []
        refreshDataWithChoosenCurrency(selectedCurrencyData: data)
    }
}



//MARK: - SignalR deleagates
extension MDMarketOverViewVC:signalRDataDelegates{
    
    /// Order book for buy has been received from SignalR
    ///
    /// - Parameter response: Array of order book for buy
    func orderBookBuyDataReceived(response: NSArray) {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                if let marketSummery  = SocketHelper.shared.marketSummery{
                    var mutableArray = NSMutableArray()
                    mutableArray = NSMutableArray(array: marketSummery)
                    for data in mutableArray{
                        if let dictData = data as? NSDictionary{
                         
                            let base = dictData.valueForCaseInsensativeKey(forKey: "base") as? String ?? ""
                            let qoute = dictData.valueForCaseInsensativeKey(forKey: "quote") as? String ?? ""
                            if base == self.selectedCurrency && qoute == self.marketType{
                                self.selectedCurrencyPairData = dictData
                                break
                            }
                        }
                    }
                    self.selectedCurrency = self.selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base") as! String
                    self.marketType = self.selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "quote") as! String
                    self.setUpNavigationBar()
                    self.setUpIntialData()
                    
                }
            } else {
                // Fallback on earlier versions
            }
            
            if !self.isTradeHistory{
                if #available(iOS 13.0, *) {
                    let mutableArray = NSMutableArray()
                    let prevOrderBook = NSMutableArray(array: self.orderBooks)
                    if let orderbookBuyData = SocketHelper.shared.orderBookSell{
                        for eachData in orderbookBuyData{
                            
                            if let innerArray = eachData as? NSArray{
                                let price = innerArray[0]
                                let volume = innerArray[1]
                                let type = innerArray[2]
                                for i in prevOrderBook{
                                    if let eachData = i as? NSDictionary{
                                        if (eachData.value(forKey: "rate") as? Double ?? 0.0) == (price as? Double ?? 0.0){
                                            if (eachData.value(forKey: "volume") as? Double ?? 0.0) == (volume as? Double ?? 0.0){
                                                break
                                            }
                                        }
                                    }
                                    
                                }
                                mutableArray.add(["rate":price,"volume":volume,"execution_side":type])
                            }
                        }
                        //self.orderBookBuyDataReceived(response: orderbookBuyData)
                    }
                    
                    
                    mutableArray.sort { (ele1, ele2) -> ComparisonResult in
                        if let dict1 = ele1 as? NSDictionary , let dict2 = ele2 as? NSDictionary{
                            if let rate1 = dict1.value(forKey: "rate") as? Double, let rate2 = dict2.value(forKey: "rate") as? Double{
                                if rate1 < rate2{
                                    return ComparisonResult.orderedDescending
                                }
                            }
                            return ComparisonResult.orderedAscending
                        }else{
                            return ComparisonResult.orderedAscending
                        }
                        
                    }
                    
                    let mutableArraySell = NSMutableArray()
                    if let orderbookSellData = SocketHelper.shared.orderBookBuy{
                        for eachData in orderbookSellData{
                            if let innerArray = eachData as? NSArray{
                                let price = innerArray[0]
                                let volume = innerArray[1]
                                let type = innerArray[2]
                                for i in prevOrderBook{
                                    if let eachData = i as? NSDictionary{
                                        if (eachData.value(forKey: "rate") as? Double ?? 0.0) == (price as? Double ?? 0.0){
                                            if (eachData.value(forKey: "volume") as? Double ?? 0.0) == (volume as? Double ?? 0.0){
                                                break
                                            }
                                        }
                                    }
                                    
                                }
                                mutableArraySell.add(["rate":price,"volume":volume,"execution_side":type])
                            }
                        }
                        //self.orderBookSellyDataReceived(response: orderbookSellData)
                    }
                    
                    mutableArraySell.sort { (ele1, ele2) -> ComparisonResult in
                        if let dict1 = ele1 as? NSDictionary , let dict2 = ele2 as? NSDictionary{
                            if let rate1 = dict1.value(forKey: "rate") as? Double, let rate2 = dict2.value(forKey: "rate") as? Double{
                                if rate1 < rate2{
                                    return ComparisonResult.orderedDescending
                                }
                            }
                            return ComparisonResult.orderedAscending
                        }else{
                            return ComparisonResult.orderedAscending
                        }
                        
                    }
                    
                    for each in mutableArraySell{
//                        print((each as! NSDictionary).value(forKey: "rate"))
                        
                    }
                    mutableArray.addObjects(from: mutableArraySell as! [Any])
                    self.orderBooks = mutableArray as NSArray
                    self.decimalAmoutTableView.reloadData()
                    MDHelper.shared.hideHud(view: self.decimalAmoutTableView)
                    self.updateContentSize()
                }
            }
        }
    }
    
    /// Order book for Sell has been received from SignalR
    ///
    /// - Parameter response: Array of order book for Sell
    func orderBookSellyDataReceived(response: NSArray) {
        if !isTradeHistory{
            if let currencyType = (response.firstObject as? NSDictionary)?.value(forKey: "CurrencyType") as? String ,
               let marketType =  (response.firstObject as? NSDictionary)?.value(forKey: "MarketType") as? String,
               currencyType == navigationTitle.components(separatedBy: "/").first,
               marketType == navigationTitle.components(separatedBy: "/").last{
                self.isLoadingIndicatorOnTableView = false
                MDHelper.shared.hideHud(view: self.decimalAmoutTableView)
                orderBookSellData = (Array(orderArrayFormated(fromArray: response, type: "Sell").prefix(10))) as NSArray
                refreshData()
                //            handleOrderBookData(response:(Array(response.prefix(10))).reversed() as NSArray, type: "Sell")
            }
        }
    }
    
    func marketSummeryDataReceived(response: NSArray) {
        
    }
    
    
    func orderBookBuyDataUpdatesReceived(response: NSArray) {
        if !isTradeHistory{
//            print("orderBookBuyDataUpdatesReceived\n \(response)")
            if let currencyType = (response.firstObject as? NSDictionary)?.value(forKey: "CurrencyType") as? String ,
               let marketType =  (response.firstObject as? NSDictionary)?.value(forKey: "MarketType") as? String,
               currencyType == navigationTitle.components(separatedBy: "/").first,
               marketType == navigationTitle.components(separatedBy: "/").last{
                self.isLoadingIndicatorOnTableView = false
                MDHelper.shared.hideHud(view: self.decimalAmoutTableView)
                handleOrderBookData(response:(Array(response.prefix(10))).reversed() as NSArray, type: "Buy")
            }
        }
    }
    
    func orderBookSellDataUpdatesReceived(response: NSArray) {
        if !isTradeHistory{
            if let currencyType = (response.firstObject as? NSDictionary)?.value(forKey: "CurrencyType") as? String ,
               let marketType =  (response.firstObject as? NSDictionary)?.value(forKey: "MarketType") as? String,
               currencyType == navigationTitle.components(separatedBy: "/").first,
               marketType == navigationTitle.components(separatedBy: "/").last{
                self.isLoadingIndicatorOnTableView = false
                MDHelper.shared.hideHud(view: self.decimalAmoutTableView)
                handleOrderBookData(response:(Array(response.prefix(10))).reversed() as NSArray, type: "Sell")
            }
        }
    }
    
    /// Trade history received from SignalR
    ///
    /// - Parameter response: Array of trade history
    func tradeHistoryDataReceived(response: NSArray) {
        DispatchQueue.main.async {
            if self.isTradeHistory{
                self.isLoadingIndicatorOnTableView = false
                MDHelper.shared.hideHud(view: self.decimalAmoutTableView)
                self.tradeHistory = response
                
                self.decimalAmoutTableView.reloadData()
                self.updateContentSize()
            }
        }
        
    }
    
    func pendingOrdersReceived(response:NSArray){
        
    }
    /// Trading view chart data received from SignalR
    /// This will be use to show high and low value for selected trade currency
    ///
    /// - Parameter response: Array of chart data points
    func chartDataReceived(response: NSArray) {
        if let dataDict = (response as NSArray).firstObject as? NSDictionary {
            if let high = dataDict.valueForCaseInsensativeKey(forKey: "high") as? Double{
                //self.HighLabel.text = localised("High")+":     " + String(format: "%.8f", high)
            }
            if let low = dataDict.valueForCaseInsensativeKey(forKey: "low") as? Double{
                //self.lowLabel.text = localised("Low")+":     " + String(format: "%.8f", low)
            }
        }
        //        }
    }
}




//MARK: - Bottom Sheet Delegates

extension MDMarketOverViewVC : MDCBottomSheetControllerDelegate {
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        self.bottomSheet = nil
    }
}

extension MDMarketOverViewVC:WKNavigationDelegate,WKUIDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MDHelper.shared.hideHud(view: webView)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView error : \(error)")
    }
}
