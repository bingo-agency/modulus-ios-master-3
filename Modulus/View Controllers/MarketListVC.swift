//
//  MarketListVC.swift
//  Modulus
//
//  Created by Pathik  on 09/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTabs
import MaterialComponents.MaterialBottomSheet
//import MaterialComponents.MaterialTabs_ColorThemer


class MarketListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MDCTabBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarView: UIView!
    
    //MARK: - Outlets
    @IBOutlet weak var extraSpaceView: UIView!
    @IBOutlet weak var canceOrderlButton: UIButton!
    @IBOutlet weak var cancelButtonBGView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headersBGView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowImageview: UIImageView!
    @IBOutlet weak var marketListheader: MarketListHeaders!
    @IBOutlet weak var ordersListHeader: OrderListHeaders!
    //For Automation
    @IBOutlet weak var VolumeButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var openOrdersPriceButton: UIButton!
    @IBOutlet weak var openOrdersAmountFilledButton: UIButton!
    @IBOutlet weak var openOrdersTotalButton: UIButton!
    
    //MARK: - Constraints Outlets
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonBGHieghtConstant: NSLayoutConstraint!
    @IBOutlet weak var pairLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountFilledLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tradingPairLabel: UILabel!
    private var selectedTap : MDMarketTabModel?
    var optionsView: MDMarketOptionsView?
    //MARK: - Constants
    //    let newtaboptions:[NewTabOptions] = NewTabOptions.getoption()
    /// height constants
    let ordersRowHeight = 57 // 80
    let marketRowHeight = 90
    let headerHeight = 40
    
    /// Identifiers
    let marketCellReuseIdentifier = "MarketListCell"
    let ordersCellReuseIdentifier = "OrdersCell"
    let ordersHistoryCellReuseIdentifier = "OrdersHistoryCell"
    
    var tabs  = ["BTC","ETH","ETC","BCH","LTC","ZEC","DASH","XMR","XRP","BTG"]
    var tabBar = MDCTabBar()
    var navigationTitle = localised("Market")
    var dataArray:NSArray = []
    var marketSummary:NSArray = []
    var orderList:NSArray = []
    var orderListSorted:NSArray = []
    
    var orderHistoryList:NSArray = []
    var orderHistorySorted:NSArray = []
    
    var selectedItem : NSDictionary? = nil
    var selectIndexPath:IndexPath = IndexPath.init(row: 0, section: 0)
    var isLoadingIndicatorOnTableView = false
    var isMarketScreen = true;
    var isTableScrolling = false
    var isOrderHistoryScreen = false
    var isTradeHistoryScreen : Bool = false
    @objc let appDel = UIApplication.shared.delegate as! AppDelegate
    var orderHistoryCurrentPage : Int = 1
    var orderHistoryCurrentPageRowCount : Int = 20
    var orderHistoryLastPage : Int = 1
    var bottomSheet : MDCBottomSheetController? = nil
    var isCurrencyPairActiveDropDown : Bool = false
    var currencyPair : String = localised("ALL")
    var orderHistoryHeaderView : MDOrderHistoryHeaderView?
    static var selected_option : String = Market_Tabbar.shared_instance.list.first?.market_name ?? ""
    //MARK: - Sort Indictor UI Helper
    func configureSortIndicators(){
        marketListheader.firstColumnSortStackView.configureStack()
        marketListheader.thirdColumnSortStackView.configureStack()
        ordersListHeader.secoundColumnSortStackView.configureStack()
        ordersListHeader.thirdColumnSortStackView.configureStack()
        ordersListHeader.fourthColumnSortStackView.configureStack()
        ordersListHeader.secoundColumnSortStackView.configureStack()
    }
    
    
    //TradedHistory_Grouped
    //MARK: - View Controller life cycles
    /// This will setup the initial values , Automation idetifiers , Navigation bar Ui
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
            
            SocketHelper.shared.subscribeToBaseEvents()
            
            
        } else {
            // Fallback on earlier versions
        }
        configureSortIndicators()
        //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        addObserver(self, forKeyPath: #keyPath(appDel.listOfMarket), options: [.old, .new,.initial], context: nil)
        setNavigationbar()
        setupTabs()
        setUpColors()
        addAutomationIdentifiers()
        setupSearchBar()
        self.getFavoriteList()
        self.refreshTabbar()
        if appDel.listOfMarket.count == 0 {
            //            MDHelper.shared.showHudOnWindow()
            appDel.getListOfMarket()
        }else{
            fetchMarketList()
        }
        if isMarketScreen {
            cancelButtonBGHieghtConstant.constant = 0
        }else {
            if isOrderHistoryScreen{
                cancelButtonBGHieghtConstant.constant = 0
            }else{
                cancelButtonBGHieghtConstant.constant = 80
            }
        }
        canceOrderlButton.setTitle(localised("CANCEL"), for: .normal)
        pairLabel.text = localised("Pair")
        changeLabel.text = localised("Change")
        lastPriceLabel.text = localised("Last Price")
        amountFilledLabel.text = localised("Amount Filled")
        priceLabel.text = localised("Price")
        totalAmountLabel.text = localised("Total Amount")
        tradingPairLabel.text = localised("Trading Pair")
        NotificationCenter.default.addObserver(self, selector:#selector(self.refreshTabbar_fromNotification), name: NSNotification.Name.init("refreshTabbar"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.refreshFav), name: NSNotification.Name.init("fav_change_from_drop_down"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.useLoggedIn),
                                               name: NSNotification.Name.init("userLoggedIn"), object: nil)
        
//        self.navigationController?.navigationBar.isHidden = true
//        print("navigation_item",self.navigationController?.isNavigationBarHidden)
        // This is the default value of edgesForExtendedLayout
        self.edgesForExtendedLayout = .all;

        // The default for this is false
        self.extendedLayoutIncludesOpaqueBars = true;
        self.navigationController?.tabBarController?.selectedIndex = 1
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
                self.navigationController?.tabBarController?.selectedIndex = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.navigationController?.tabBarController?.selectedIndex = 0
                self.viewWillApperNew()
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.viewWillApperNew()
                }
            }
            
            
        }
    }
    func viewWillApperNew() {
        
        
        setNavigationbar()
        
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
            SocketHelper.shared.subscribeToBaseEvents()
            
            
        } else {
            // Fallback on earlier versions
        }
        
        if isMarketScreen == true{
            // fetchMarketList()
        }else{
            if self.isOrderHistoryScreen{
                self.fetchOrderHistoryList()
                marketListheader.firstColumnSortStackView.isHidden = true
                marketListheader.firstColumnSortStackView.isHidden = true
                marketListheader.thirdColumnSortStackView.isHidden = true
                ordersListHeader.secoundColumnSortStackView.isHidden = true
                ordersListHeader.thirdColumnSortStackView.isHidden = true
                ordersListHeader.fourthColumnSortStackView.isHidden = true
                
            }else{
                self.fetchOrderList()
            }
        }
        
        canceOrderlButton.isUserInteractionEnabled = false
        canceOrderlButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        marketListheader.isHidden = !isMarketScreen
        ordersListHeader.isHidden = isMarketScreen
        
        if appDel.listOfMarket.count == 0{
            appDel.getListOfMarket()
            
        }
        //        if MDSignalRManager.shared.connection == nil{
        //            MDSignalRManager.shared.startDataConnectionWithoutLogin()
        //        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        setNavigationbar()
        
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
            SocketHelper.shared.subscribeToBaseEvents()
            
            
        } else {
            // Fallback on earlier versions
        }
        
        if isMarketScreen == true{
            // fetchMarketList()
        }else{
            if self.isOrderHistoryScreen{
                self.fetchOrderHistoryList()
                marketListheader.firstColumnSortStackView.isHidden = true
                marketListheader.firstColumnSortStackView.isHidden = true
                marketListheader.thirdColumnSortStackView.isHidden = true
                ordersListHeader.secoundColumnSortStackView.isHidden = true
                ordersListHeader.thirdColumnSortStackView.isHidden = true
                ordersListHeader.fourthColumnSortStackView.isHidden = true
                
            }else{
                self.fetchOrderList()
            }
        }
        
        canceOrderlButton.isUserInteractionEnabled = false
        canceOrderlButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        marketListheader.isHidden = !isMarketScreen
        ordersListHeader.isHidden = isMarketScreen
        
        if appDel.listOfMarket.count == 0{
            appDel.getListOfMarket()
            
        }
        //        if MDSignalRManager.shared.connection == nil{
        //            MDSignalRManager.shared.startDataConnectionWithoutLogin()
        //        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK: - Setup searchbar
    func setupSearchBar(){
        if self.isOrderHistoryScreen{
            self.searchBarHeight.constant = 0
            self.searchBarView.isHidden = true
        }
        self.searchBar.delegate = self
        self.searchBar.layer.cornerRadius = 12
        self.searchBar.layer.masksToBounds = false
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = Theme.current.titleTextColor
        textFieldInsideSearchBar?.font = UIFont.systemFont(ofSize: 15)
    }
    
    //MARK: - Key value observer
    /// We have stored list of markets in appdelegates,
    /// Observing that if the markets has been changed
    /// If List of markets has been changed then We have to update that On Ui
    /// This observer will be responsible for list of markets
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(appDel.listOfMarket) {
            tabs = appDel.listOfMarket as! [String]
            //                refreshTabbar()
        }
    }
    
    //MARK: - Automation identifiers wou
    func addAutomationIdentifiers(){
        //Bottom Tab Bar
        if let tabBarController = self.tabBarController{
            let items = (tabBarController.tabBar.items)!
            
            items[0].isAccessibilityElement = true
            items[1].isAccessibilityElement = true
            items[2].isAccessibilityElement = true
            
            items[0].accessibilityLabel = "MarketIdentifier"
            items[0].accessibilityIdentifier = "MarketIdentifier"
            
            items[1].accessibilityLabel = "WalletIdentifier"
            items[1].accessibilityIdentifier = "WalletIdentifier"
            
            items[2].accessibilityLabel = "AccountIdentifier"
            items[2].accessibilityIdentifier = "AccountIdentifier"
            
        }
        
        
        /// Accesibility identifiers
        VolumeButton.accessibilityIdentifier = "VolumeButton"
        VolumeButton.accessibilityLabel = "VolumeButton"
        
        changeButton.accessibilityIdentifier = "changeButton"
        changeButton.accessibilityLabel = "changeButton"
        
        openOrdersPriceButton.accessibilityIdentifier = "openOrdersPriceButton"
        openOrdersPriceButton.accessibilityLabel = "openOrdersPriceButton"
        
        openOrdersTotalButton.accessibilityIdentifier = "openOrdersTotalButton"
        openOrdersTotalButton.accessibilityLabel = "openOrdersTotalButton"
        
        openOrdersAmountFilledButton.accessibilityIdentifier = "openOrdersAmountFilledButton"
        openOrdersAmountFilledButton.accessibilityLabel = "openOrdersAmountFilledButton"
        
        canceOrderlButton.accessibilityHint = "btn_cancel"
        canceOrderlButton.accessibilityLabel = "btn_cancel"
        canceOrderlButton.accessibilityIdentifier = "btn_cancel"
        
        
        
    }
    
    @objc func orientationDidChange(notification: NSNotification) {
        optionsView!.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height:  tabBar.frame.height)
        
        self.view.layoutSubviews()
    }
    @objc func refreshTabbar_fromNotification(){
//        self.tabBar.removeFromSuperview()
        DispatchQueue.main.async { [weak self] in
//            MarketListVC.selected_option = MDMarketOptionsView.option_arry[1]
            self?.optionsView!.selectedIndex = MarketListVC.selected_option
            self?.optionsView?.collectionView.reloadData()
        }
    }
    
    @objc func useLoggedIn(){
        DispatchQueue.main.async { [weak self] in
            self?.getFavoriteList()
        }
    }
    
    
    @objc func refreshFav(){
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) { [weak self] in
            print("self?.selectedTap!.title \(self?.selectedTap!.title)")
            if localised("Favorites") == self?.selectedTap?.title{
                self?.marketSummeryDataReceived(response: self?.marketSummary ?? [])
            }else{
                self?.tableView.reloadData()
            }
        }
    }
    
    
    
    //MARK: - Tab bar helper methods
    /// This will reload tabBar
    func refreshTabbar() {
        NotificationCenter.default.addObserver(self, selector:#selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        let tabBarTemp = MDCTabBar()
        tabBarTemp.frame =  backgroundView.bounds
        tabBarTemp.backgroundColor = Theme.current.navigationBarColor
        tabBarTemp.tintColor = Theme.current.primaryColor
        tabBarTemp.selectedItemTintColor = Theme.current.primaryColor
        tabBarTemp.unselectedItemTintColor = Theme.current.titleTextColor
        let tabItems:[UITabBarItem] = []
        //        for (index,name) in tabs.enumerated(){
        //            tabItems.append(UITabBarItem(title:name, image: nil, tag: index))
        //        }
        
        tabBarTemp.items = tabItems
        tabBarTemp.unselectedItemTitleFont = MDAppearance.Fonts.tabsTitle!
        tabBarTemp.selectedItemTitleFont = MDAppearance.Fonts.tabsTitle!
        tabBarTemp.itemAppearance = .titles
        tabBarTemp.delegate = self
        tabBarTemp.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBarTemp.sizeToFit()
        tabBar.removeFromSuperview()
        backgroundView.addSubview(tabBarTemp)
        tabBar = tabBarTemp
        optionsView = MDMarketOptionsView(frame:CGRect(x: 15, y: 0, width: tabBarTemp.frame.width, height:  tabBarTemp.frame.height))
        optionsView!.delegate = self
        optionsView!.backgroundColor = .clear
        optionsView!.selectedIndex = MarketListVC.selected_option
        DispatchQueue.main.async { [weak self] in
            self?.optionsView?.collectionView.reloadData()
        }
        
        //        let bundle = Bundle(for: type(of: self))
        //        let nib = UINib(nibName: MDMarketOptionsView.nibName, bundle: bundle)
        //        let view = nib.instantiate(withOwner: self, options: nil)[0] as! MDMarketOptionsView
        
        if self.isOrderHistoryScreen{
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: MDOrderHistoryHeaderView.identifier, bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! MDOrderHistoryHeaderView
            view.frame = tabBarTemp.bounds
            //view.backgroundColor = .green
            tabBarTemp.addSubview(view)
            view.delegate = self
            view.currencyPairLabel.text = self.currencyPair
            view.numberOfRowsLabel.text = String(self.orderHistoryCurrentPageRowCount)
            tabBarTemp.backgroundColor = .red
            tabBarTemp.bringSubviewToFront(view)
            self.orderHistoryHeaderView = view
        }else if isMarketScreen{
            tabBarTemp.addSubview(optionsView!)
        }
        fetchMarketList()
        
        
    }
    
    
    //MARK: - Navigation bar helprs
    func setNavigationbar(){
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
        self.navigationItem.backBarButtonItem?.title = ""
        
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        
        label.text = navigationTitle
        if isMarketScreen == true{
            label.font = MDAppearance.Fonts.largeNavigationTitleFont
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        }else{
            label.font = MDAppearance.Fonts.smallNavigationTitleFont
            if isOrderHistoryScreen{
                if self.isTradeHistoryScreen{
                    label.text = localised("trade_history")
                }else{
                    label.text = localised("Order History")
                }
            }else{
                label.text = localised("Orders")
            }
            self.navigationItem.titleView = label
            
        }
        
    }
    
    //MARK: - UI Helpers
    // This will set up all the colors on this screen
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        tabBar.backgroundColor = Theme.current.navigationBarColor
        tabBar.tintColor = Theme.current.primaryColor
        tabBar.selectedItemTintColor = Theme.current.primaryColor
        tabBar.unselectedItemTintColor = Theme.current.titleTextColor
        tableView.backgroundColor = UIColor.clear
        
        backgroundView.backgroundColor  = Theme.current.backgroundColor
        shadowImageview.tintColor = Theme.current.backgroundColor
        
        extraSpaceView.backgroundColor = Theme.current.navigationBarColor
        marketListheader.backgroundColor = Theme.current.navigationBarColor
        ordersListHeader.backgroundColor = Theme.current.navigationBarColor
        headersBGView.backgroundColor = Theme.current.navigationBarColor
        
        
        
        for item in self.tabBarController!.tabBar.items! {
            if let image = item.image {
                item.image = image.imageWithColor(color1: Theme.current.titleTextColor).withRenderingMode(.alwaysOriginal)
            }
        }
        
        cancelButtonBGView.backgroundColor = Theme.current.navigationBarColor
        canceOrderlButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        canceOrderlButton.backgroundColor = Theme.current.mainTableCellsBgColor
        
        //        self.tabBarController?.tabBar.tintColor = UIColor.green
        //        self.navigationController?.tabBarController?.tabBar.unselectedItemTintColor = UIColor.red
        
    }
    
    //MARK: - UI helpers
    func setupTabs(){
        tabBar.frame =  backgroundView.bounds
        var tabItems:[UITabBarItem] = []
        for (index,name) in tabs.enumerated(){
            tabItems.append(UITabBarItem(title:name, image: nil, tag: index))
        }
        
        tabBar.items = tabItems
        tabBar.unselectedItemTitleFont = MDAppearance.Fonts.tabsTitle!
        tabBar.selectedItemTitleFont = MDAppearance.Fonts.tabsTitle!
        tabBar.itemAppearance = .titles
        tabBar.delegate = self
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        backgroundView.addSubview(tabBar)
        
        headerViewTopConstraint.constant = tabBar.frame.height
        if tabBar.items.count>=2{
            //For Automation
            tabBar.items[1].isAccessibilityElement = true
            tabBar.items[1].accessibilityIdentifier = "2ndTabBarElement"
            tabBar.items[1].accessibilityLabel = "2ndTabBarElement"
            tabBar.items[1].accessibilityValue = "2ndTabBarElement"
            tabBar.items[1].accessibilityTraits = UIAccessibilityTraits.button
        }
    }
    
    //MARK: -  Data fetching from ther server
    
    /// Fetch market list data from the server
    func fetchMarketList(){
        if appDel.isConnectedToInternet() == true {
            isLoadingIndicatorOnTableView = true
            tableView.reloadData()
            MDHelper.shared.showHudOnWindow()
            
            
            
            /*                  //*********** REST API ***************************//
             MDNetworkManager.shared.sendRequest(methodType: .get,
             apiName: API.marketSummary,
             parameters: nil,
             headers: nil) { (response, error) in
             self.isLoadingIndicatorOnTableView = false
             MDHelper.shared.hideHudOnWindow()
             if response != nil && error == nil{
             if MDNetworkManager.shared.isResponseSucced(response: response!){
             self.handleMarketSummaryRespnse(response: response!)
             }
             }
             }*/
            
            
            // ============ SIGNALR IMPLEMENTATION =========================
            
            // Fetch all data intially then after see for the updates only
            
            
            
            if #available(iOS 13.0, *) {
                SocketHelper.shared.delegate = self
                if let marketSummeryData =  SocketHelper.shared.marketSummery,marketSummeryData.count > 0 {
                    
                    self.marketSummary = marketSummeryData
                    isLoadingIndicatorOnTableView = false
                    MDHelper.shared.hideHudOnWindow()
                    dataArray = self.getFilteredDataforSelectedTab()
                    if marketListheader.firstColumnSortStackView.tag == 0 || marketListheader.firstColumnSortStackView.tag == 1/*2 is both deselected*/{
                        marketListheader.refreshDataWithVolumeSort()
                    }
                    if marketListheader.thirdColumnSortStackView.tag == 0 || marketListheader.thirdColumnSortStackView.tag == 1{
                        marketListheader.refreshDataWithChangeSort()
                    }
                    tableView.reloadData()
                    
                }else{
                    isLoadingIndicatorOnTableView = true
                    MDHelper.shared.showHudOnWindow()
                    let deadlineTime = DispatchTime.now() + .seconds(9)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
                        MDHelper.shared.hideHudOnWindow()
                        if self != nil{
                            self!.isLoadingIndicatorOnTableView = false
                            self!.tableView.reloadData()
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func fetchOrderHistoryList(){
        isLoadingIndicatorOnTableView = true
        MDHelper.shared.showHudOnWindow()
        var urlString = API.baseURL + "\(API.tradeHistoryGrouped)?"
        
        if self.isTradeHistoryScreen{
            urlString = API.baseURL + "\(API.trade_history)?"
        }
        
        var currencyPair = ""
        if self.currencyPair == localised("ALL"){
            currencyPair = "ALL"
        }else{
            currencyPair = self.currencyPair
        }
        
        let params   = ["side":"ALL",
                        "pair":currencyPair,
                        "page": String(self.orderHistoryCurrentPage),
                        "count":String(self.orderHistoryCurrentPageRowCount),
                        "timestamp": "\(MDNetworkManager.shared.getCurrentTimeStamp())",
                        "recvWindow": "10000"]
        for (index,key) in params.keys.enumerated(){
            if index == 0 {
                urlString = urlString + "\(key)=\(params[key]!)"
            }else{
                urlString = urlString + "&\(key)=\(params[key]!)"
            }
            
        }
        self.sendRequest(urlString: urlString, parameters: params as NSDictionary)
    }
    
    
    /// Fetch Order list from the server
    func fetchOrderList(){
        isLoadingIndicatorOnTableView = true
        MDHelper.shared.showHudOnWindow()
        let params = ["side": "ALL",
                      "pair":"ALL",
                      "timestamp": "\(MDNetworkManager.shared.getCurrentTimeStamp())",
                      "recvWindow": "10000"]
        
        var urlString = API.baseURL + "\(API.pendingOrders)?"
        
        for (index,key) in params.keys.enumerated(){
            if index == 0 {
                urlString = urlString + "\(key)=\(params[key]!)"
            }else{
                urlString = urlString + "&\(key)=\(params[key]!)"
            }
            
        }
        self.sendRequest(urlString: urlString, parameters: params as NSDictionary)
    }
    
    
    func sendRequest(urlString : String , parameters : NSDictionary){
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: parameters as NSDictionary)] as [String : Any]
        MDNetworkManager.shared.sendRequest(baseUrl:urlString,
                                            methodType: .post,
                                            apiName: "",
                                            parameters: parameters as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if response != nil && error == nil{
                self.isLoadingIndicatorOnTableView = false
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    self.handleOrderListRespnse(response: response!)
                }else{
                    if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                        MDHelper.shared.showErrorAlert(message: message, viewController: self)
                    }
                }
            }else{
                if  error != nil{
                    //                                                        MDHelper.shared.showErrorAlert(message: (error?.localizedDescription)!, viewController: self)
                    MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                }
            }
        }
    }
    
    
    //MARK: - Button Action
    
    /// Cancel order button action
    @IBAction func cancelOrderButtonAction(_ sender: UIButton) {
        MDAlertPopupView.showAlertPopupViewOnWidnow(title: "appTitle", errorMessage: localised("Are you sure you want to cancel this order?"), alertDelegate: self)
        
    }
    
    //MARK: - Rest api calls
    
    /// Cancel order
    func cancelOrder(){
        
        if let item = self.selectedItem {
            
            let cellData = item//(orderListSorted[indexP.row] as! NSDictionary)
            let side = cellData.valueForCaseInsensativeKey(forKey: "side") as! String
            let orderId = cellData.valueForCaseInsensativeKey(forKey: "orderId") as! Int
            
            let params = [ "side":side.uppercased(),
                           "orderId": "\(orderId)",
                           "clientOrderId": "",
                           "timestamp": "\(MDNetworkManager.shared.getCurrentTimeStamp())",
                           "recvWindow": "1000"
            ]
            
            
            let headers = ["Authorization":MDNetworkManager.shared.authToken,
                           "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
            
            MDHelper.shared.showHudOnWindow()
            MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                                methodType: .post,
                                                apiName: API.cancelOrder,
                                                parameters: params as NSDictionary,
                                                headers: headers as NSDictionary) { (response, error) in
                //                                                    MDHelper.shared.hideHudOnWindow()
                if response != nil && error == nil{
                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                        
                        //                                                            if let message = response?.valueForCaseInsensativeKey(forKey: "status") as? String, message.lowercased() == "success"{
                        
                        MDHelper.shared.showSucessAlert(message: localised("Order has been cancelled"), viewController: self)
                        self.selectedItem = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            MDHelper.shared.hideHudOnWindow()
                            self.fetchOrderList()
                        })
                        
                        self.canceOrderlButton.isUserInteractionEnabled = false
                        self.canceOrderlButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                        
                        //                                                            }
                    }else{
                        MDHelper.shared.hideHudOnWindow()
                        if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                        }
                    }
                }else{
                    MDHelper.shared.hideHudOnWindow()
                    if  error != nil{
                        // MDHelper.shared.showErrorAlert(message: (error?.localizedDescription)!, viewController: self)
                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                    }
                }
            }
        }
    }
    
    
    //MARK:- Scroll delegates
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTableScrolling = true
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isTableScrolling = true
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isTableScrolling = false
    }
    
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //
    //    }
    //MARK: - tableview Datasource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((isMarketScreen == false && orderListSorted.count == 0 ) || ( isMarketScreen == true && dataArray.count == 0) || ( isOrderHistoryScreen == true && orderHistorySorted.count == 0)) && isLoadingIndicatorOnTableView == false{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
            noDataLabel.text          = localised("No data available")
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            noDataLabel.textColor = Theme.current.titleTextColor
            tableView.backgroundView  = noDataLabel
            tableView.backgroundView?.frame =  CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100)
            noDataLabel.font =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 15)
        }else{
            tableView.backgroundView  = nil
        }
        return isMarketScreen == true ?  dataArray.count : isOrderHistoryScreen == true ? orderHistorySorted.count : orderListSorted.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        
        if isMarketScreen == true{
            let cellData = (dataArray[indexPath.row] as! NSDictionary)
            let marketCell = self.tableView.dequeueReusableCell(withIdentifier: marketCellReuseIdentifier)! as! MDMarketListCell
            
            var titleCell = cellData.valueForCaseInsensativeKey(forKey: "base") as! String
            if let tabTitle = tabBar.selectedItem?.title{
                titleCell = "\(titleCell)/\(tabTitle)"
            }
            marketCell.title = titleCell//cellData.valueForCaseInsensativeKey(forKey: "CoinName") as! String
            marketCell.reloadData = { (_) in
                DispatchQueue.main.async {
                    self.marketSummeryDataReceived(response: self.marketSummary)
                }
            }
            marketCell.configureCellForMarket(data: cellData, isSecurityGroup: selectedTap?.isSecurityGroup ?? false)
            cell = marketCell
            
            //for Automation
            
        }else{
            
            if isOrderHistoryScreen{
                
                let orderCell = self.tableView.dequeueReusableCell(withIdentifier: ordersHistoryCellReuseIdentifier)! as! MDOrderHistoryCell
                if let cellData = (orderHistorySorted[indexPath.row] as? NSDictionary){
                    var selected = false
                    if cellData == self.selectedItem {
                        //if cellData == indexPath.row {
                        selected = true
                        // }
                    }
                    orderCell.configure(data: cellData,selected: selected)
                }
                cell = orderCell
                
            }else{
                
                let orderCell = self.tableView.dequeueReusableCell(withIdentifier: ordersCellReuseIdentifier)! as! MDOrdersListCell
                let cellData = (orderListSorted[indexPath.row] as! NSDictionary)
                var selected = false
                if cellData == self.selectedItem {
                    //if cellData == indexPath.row {
                    selected = true
                    // }
                }
                orderCell.configure(data: cellData,selected: selected)
                cell = orderCell
            }
            
            
        }
        
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = "CellElement\(indexPath.row)"
        cell.accessibilityValue = "CellElement\(indexPath.row)"
        cell.accessibilityLabel = "CellElement\(indexPath.row)"
        
        return cell
    }
    
    //MARK: - sizes for tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat( isMarketScreen == true ? marketRowHeight : ordersRowHeight )
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    //MARK: - Tableview delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMarketScreen == true{
            tableView.deselectRow(at: indexPath, animated: true)
            selectIndexPath = indexPath
            performSegue(withIdentifier: "market_overview", sender: self)
        }else {
            let cellData = (orderListSorted[indexPath.row] as! NSDictionary)
            canceOrderlButton.isUserInteractionEnabled = true
            canceOrderlButton.backgroundColor = Theme.current.primaryColor
            self.selectedItem = cellData
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isOrderHistoryScreen{
            if self.orderHistoryCurrentPage < self.orderHistoryLastPage && indexPath.row == self.orderHistoryList.count-1{
                self.orderHistoryCurrentPage = orderHistoryCurrentPage  + 1
                self.fetchOrderHistoryList()
            }else{
                if self.orderHistoryCurrentPage == self.orderHistoryLastPage && indexPath.row + 1 == self.orderHistoryList.count{
                    MDHelper.shared.showSucessAlert(message: localised("End Reached"), viewController: self)
                }
            }
        }
    }
    
    
    //MARK: - Tab Bar delegates
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        //        UIView.transition(with: tableView,
        //            duration: 1.0,
        //            options: .transitionCrossDissolve,
        //            animations: { self.tableView.reloadData() })
        
        dataArray = []
        if isMarketScreen == true {
            marketListheader.resetHeaders()
            dataArray = getFilteredDataforSelectedTab()
        }else{
            if isOrderHistoryScreen{
                marketListheader.resetHeaders()
                orderHistorySorted = getFilteredDataforSelectedTabOrderHistoryList()
            }else{
                orderListSorted = getFilteredDataforSelectedTabOrderList()
            }
            
            
            //            fetchOrderList(forCurrency: (tabBar.selectedItem?.title)!)
        }
        canceOrderlButton.isUserInteractionEnabled = false
        canceOrderlButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.selectedItem = nil
        tableView.reloadData()
        if dataArray.count > 0{
            tableView.scrollToRow(at: IndexPath.init(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func getFavoriteList(){
        MDHelper.shared.showHudOnWindow()
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.Customer_Favourite_Coins, parameters:nil, headers: headers as NSDictionary) { (dict, err) in
            MDHelper.shared.hideHudOnWindow()
            if let data = dict as? [String:Any] , let data_ = data["status"] as? String , data_.lowercased() == "success",let Arry = data["data"] as? [String]{
                UserDefaults.standard.handleArr_Fav(arr:Arry)
            }
        }
        
    }
    //MARK: - API response handlers
    
    /// This will handle response for market list summery fetched from ther server
    func handleMarketSummaryRespnse(response:NSDictionary){
        if (response.valueForCaseInsensativeKey(forKey:"data") as? NSDictionary) != nil{
            //            marketSummary = data
            
        }
        self.tableView.reloadData()
    }
    
    /// This will handle response for Order list fetched from ther server
    func handleOrderListRespnse(response:NSDictionary){
        if isOrderHistoryScreen{
            if let data = response.valueForCaseInsensativeKey(forKey:"data") as? NSDictionary{
                if let rows = data.valueForCaseInsensativeKey(forKey: "rows") as? NSArray{
                    let array : NSMutableArray = NSMutableArray.init(array: self.orderHistoryList)
                    array.addObjects(from: rows as! [Any])
                    orderHistoryList = array
                    orderListSorted = array
                    orderHistorySorted = array
                    DispatchQueue.main.async {
                        self.configureSortIndicators()
                        self.tableView.reloadData()
                    }
                }
                if let pageInfo = data.value(forKey: "pageInfo") as? NSDictionary{
                    if let pageSize = pageInfo.value(forKey: "pageSize") as? Int,
                       let currentPage = pageInfo.value(forKey: "currentPage") as? Int,
                       let totalRows = pageInfo.value(forKey: "totalRows") as? Int{
                        self.orderHistoryCurrentPage = currentPage
                        self.orderHistoryLastPage = Int(ceil(Double(totalRows) / Double(pageSize)))
                    }
                }
            }
            return
        }else{
            if let data = response.valueForCaseInsensativeKey(forKey:"data") as? NSArray{
                orderList = data.reversed() as NSArray
                print(data)
                orderListSorted = getFilteredDataForOrderHistory()
                self.tableView.reloadData()
                return
            }
        }
        /***Order History*/
        if let data = response.valueForCaseInsensativeKey(forKey:"data") as? NSArray{
            orderList = data
            orderListSorted = getFilteredDataforSelectedTabOrderList()
            self.tableView.reloadData()
        }
        
    }
    
    func showDropDown(){
        let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
        let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
        dropDownVC.delegate = self
        let mutableData = NSMutableArray()
        var selectedIndex : Int = 0
        if isCurrencyPairActiveDropDown{
            var pairNames = [localised("ALL")]
            var currencyPairNames = [String]()
            for each in self.marketSummary{
                if let data = each as? NSDictionary{
                    let coinName = data.value(forKey: "base") as? String ?? ""
                    let marketName = data.value(forKey: "quote") as? String ?? ""
                    let title = "\(coinName)/\(marketName)"
                    currencyPairNames.append(title)
                }
            }
            
            let sortedPairNames = currencyPairNames.sorted()
            pairNames.append(contentsOf: sortedPairNames)
            var currencyPairString = ""
            let currencyPairArray = self.currencyPair.split(separator: "-")
            if currencyPairArray.count > 1{
                currencyPairString = "\(currencyPairArray[0])/\(currencyPairArray[1])"
            }else{
                currencyPairString = localised("ALL")
            }
            
            for (index,each) in pairNames.enumerated(){
                let isSelected : Bool
                if each == currencyPairString{
                    selectedIndex = index
                    isSelected = true
                }else{
                    isSelected = false
                }
                mutableData.add(["title" : each ,
                                 "selected":isSelected] as [String : Any])
            }
            
            bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: (self.view.frame.size.height))
        }else{
            mutableData.add(["title" : "10" ,
                             "selected":false] as [String : Any])
            mutableData.add(["title" : "20",
                             "selected":false] as [String : Any])
            mutableData.add(["title" : "50",
                             "selected":false] as [String : Any])
            mutableData.add(["title" : "100",
                             "selected":false] as [String : Any])
            
            for (index,key) in mutableData.enumerated(){
                let data1 = key as! NSDictionary
                let data = data1.mutableCopy() as! NSMutableDictionary
                if data.value(forKey: "title") as! String == String(self.orderHistoryCurrentPageRowCount){
                    selectedIndex = index
                    data.setValue(true, forKey: "selected")
                }
                mutableData.replaceObject(at: index, with: data)
            }
            bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: (self.view.frame.size.height/2)+50)
        }
        dropDownVC.alreadySelectedIndex = selectedIndex
        dropDownVC.data = mutableData
        dropDownVC.type = .orderHistoryOptionList
        bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
        bottomSheet?.delegate = self
        if isCurrencyPairActiveDropDown{
            bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: (self.view.frame.size.height))
        }else{
            bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: (self.view.frame.size.height/2)+50)
        }
        present(bottomSheet!, animated: true, completion: nil)
    }
    
    //MARK: -  Data filter Helper methods
    
    /// Filter Order list received from server as per the selected market
    /// Order List summary data from server provides data for all markets
    func getFilteredDataforSelectedTabOrderList()->NSArray{
        
        orderListSorted = orderList
        let selectedTab = tabBar.selectedItem?.title
        return orderListSorted.filter { (dict) -> Bool in
            
            ((dict as! NSDictionary).valueForCaseInsensativeKey(forKey: "market") as! String) == selectedTab
            //            "\((str as! String).prefix((selectedTab?.count)!))" == selectedTab
        } as NSArray
    }
    

    /// Filter Order list received from server as per the selected market
    /// Order List summary data from server provides data for all markets
    func getFilteredDataForOrderHistory()->NSArray{
        if let queryText =  self.searchBar.text , queryText.count > 0 {
            let orderHistory = self.orderList.filter({ (dict) -> Bool in
                let market = (dict as? [String :Any] ?? [:])["market"] as? String ?? ""
                let trade = (dict as? [String :Any] ?? [:])["trade"] as? String ?? ""
                return (market.contains(queryText) ||  trade.contains(queryText))
            }) as NSArray
        
            return sortPerSelectedColumn(listToBeSorted: orderHistory)
        }else{
            return sortPerSelectedColumn(listToBeSorted: orderList)
        }
    }
    
    private
    func sortPerSelectedColumn(listToBeSorted:NSArray)->NSArray{
        if ordersListHeader.secoundColumnSortStackView.tag != 3{
            return self.ordersListHeader.sortForSecondColumn(listToBeSorted: listToBeSorted)
        }
        
        if ordersListHeader.thirdColumnSortStackView.tag != 3{
            return self.ordersListHeader.sortForThirdColumn(listToBeSorted: listToBeSorted)
        }
        
        if ordersListHeader.fourthColumnSortStackView.tag != 3{
            return self.ordersListHeader.sortForFourthColumn(listToBeSorted: listToBeSorted)
        }
        return listToBeSorted
    }
    
    /// Filter Order History list received from server as per the selected market
    /// Order History List summary data from server provides data for all markets
    func getFilteredDataforSelectedTabOrderHistoryList()->NSArray{
        orderHistorySorted = orderHistoryList
        let selectedTab = tabBar.selectedItem?.title
        return orderHistorySorted.filter { (dict) -> Bool in
            if let dataDict = dict as? NSDictionary{
                if let currencyPair = dataDict.valueForCaseInsensativeKey(forKey: "currencypair") as? String{
                    let seprateCurrncies = currencyPair.components(separatedBy: "-")
                    if let marketName = seprateCurrncies.last{
                        if selectedTab == marketName{
                            return true
                        }
                    }
                }
            }
            return false
        } as NSArray
    }
    
    
    /// Filter market data received from server as per the selected market
    /// Market List summary data from server provides data for all markets
    func getFilteredDataforSelectedTab()->NSArray{
        dataArray = marketSummary
        if MarketListVC.selected_option.lowercased().contains(Market.fav_option.market_name.lowercased()) {
            self.selectedTap = MDHelper.shared.getMarketetData().first
            if let queryText =  self.searchBar.text , queryText.count > 0 {
                return self.searchDataFromFav(queryText: queryText)
            }else{
                return self.filterDataFromFav()
            }
        }
        if let queryText =  self.searchBar.text , queryText.count > 0 {
            return self.searchTextFrom_Data(queryText: queryText)
        }else{
            return self.filterDataFroBase_Quote()
        }
    }
    //MARK: // Filter
    func filterDataFroBase_Quote()-> NSArray{
        /***get seleted gropup object*/
        guard let selectedGroup = (MDHelper.shared.getMarketetData().first{ $0.title == MarketListVC.selected_option }) else {return []}
        self.selectedTap = selectedGroup
        let filteredArray = self.dataArray.filter { (dictionary) -> Bool in
            if let eachMarket = dictionary as? [String:Any],
               let baseCurrency = eachMarket["base"] as? String ,
               let quote_currency = eachMarket["quote"] as? String{
                let pair = "\(baseCurrency)/\(quote_currency)"
                if selectedGroup.isSecurityGroup{
                    for name in selectedGroup.markest{
                        if (name == baseCurrency){
                            return true
                        }
                    }
                }else{
                    for name in selectedGroup.markest{
                        if !MDHelper.shared.notDisplayQuoteCurrencyPairs.contains(pair){
                            if selectedGroup.isNonGroup{
                                if name == quote_currency{
                                    return true
                                }
                            }else{
                                if (name == quote_currency){
                                    return true
                                }
                            }
                            
                        }
                    }
                }
                return false
            }
            return false
        }
        return filteredArray as NSArray
    }
    //MARK: // Filter
    func filterDataFromFav()-> NSArray{
        dataArray = marketSummary
        return dataArray.filter({ (dict) -> Bool in
            return UserDefaults.standard.checkIsDataPresent(data: (dict as! [String:Any])) != nil
        }) as NSArray
    }
    //MARK: // Filter
    func searchDataFromFav(queryText:String)-> NSArray{
        dataArray = self.filterDataFromFav()
        return self.dataArray.filter({ (dict) -> Bool in
            let search_key = (dict as? [String :Any] ?? [:])["base"] as? String ?? ""
            return search_key.prefix(queryText.count).lowercased().contains(queryText.lowercased())
        }) as NSArray
    }
    //MARK: // Search From TableView
    func searchTextFrom_Data(queryText:String) -> NSArray{
        dataArray = self.filterDataFroBase_Quote()
        return self.dataArray.filter({ (dict) -> Bool in
            let search_key = (dict as? [String :Any] ?? [:])["base"] as? String ?? ""
            return search_key.prefix(queryText.count).lowercased().contains(queryText.lowercased())
        }) as NSArray
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /// In a storyboard-based application, you will often want to pass data from one viewController to other
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MDMarketOverViewVC {
            if isMarketScreen == true {
                let cellData = dataArray[selectIndexPath.row] as! NSDictionary
                guard let selectedCurrency = cellData.valueForCaseInsensativeKey(forKey: "base") as? String,
                      let marketType = cellData.value(forKey: "quote") as? String else {return}
                let viewC = segue.destination as! MDMarketOverViewVC
                viewC.selectedCurrencyPairData = cellData
                viewC.navigationTitle = "\(selectedCurrency)/\(marketType)"
                viewC.selectedCurrency = "\(marketType)_\(selectedCurrency)"
                viewC.marketType = marketType
                viewC.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    
    
    
    
    //MARK:- Mock response
    
    
    
}

//MARK: - SignalR data socket delegates
extension MarketListVC:signalRDataDelegates{
    /// Market List summary is received from the SignalR
    func marketSummeryDataReceived(response: NSArray) {
        DispatchQueue.main.async {
            self.marketSummary = response
            self.dataArray = self.getFilteredDataforSelectedTab()
            if self.marketListheader.firstColumnSortStackView.tag == 0 || self.marketListheader.firstColumnSortStackView.tag == 1/*2 is both deselected*/{
                self.marketListheader.refreshDataWithVolumeSort(shoudMoveToTop : false)
            }
            if self.marketListheader.thirdColumnSortStackView.tag == 0 || self.marketListheader.thirdColumnSortStackView.tag == 1{
                self.marketListheader.refreshDataWithChangeSort(shoudMoveToTop : false)
            }
            if let navBar = UIApplication.shared.topMostViewController() as? UINavigationController{
                if (navBar.visibleViewController as? MarketListVC) != nil{
                    MDHelper.shared.hideHudOnWindow()
                }
            }
            
            if self.isTableScrolling == false  {
                if self.isMarketScreen == true{
                    self.tableView.reloadData()
                    self.isLoadingIndicatorOnTableView = false
                }
            }
        }
        
    }
    func orderBookBuyDataReceived(response:NSArray){
        
    }
    func orderBookBuyDataUpdatesReceived(response:NSArray){
        
    }
    func orderBookSellyDataReceived(response:NSArray){
        
    }
    func orderBookSellDataUpdatesReceived(response:NSArray){
        
    }
    func tradeHistoryDataReceived(response:NSArray){
        
    }
    func chartDataReceived(response:NSArray){
        
    }
    func pendingOrdersReceived(response:NSArray){
        
    }
}

//MAEK: - Alert pop up Delegates
extension MarketListVC:alertPopupDelegate{
    /// This will inform if User has agreed the alert
    func alertPopupResponse(isAgree: Bool) {
        if isAgree == true {
            cancelOrder()
        }
    }
}

//MARK:-Drop Down Delegate
extension MarketListVC : MDCBottomSheetControllerDelegate ,  customDropDownDelegates , MDOrderHistoryHeaderViewProtocol{
    func didPressCurrencyPairButton() {
        self.isCurrencyPairActiveDropDown = true
        self.showDropDown()
        
    }
    
    func didPressNumberOfRowsButton() {
        self.isCurrencyPairActiveDropDown = false
        self.showDropDown()
    }
    
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        
    }
    
    func dropDownSelected(title: String, data: NSDictionary) {
        if self.isCurrencyPairActiveDropDown{
            self.orderHistoryHeaderView?.currencyPairLabel.text = title
            let currencyPair = title.split(separator: "/")
            if currencyPair.count > 1{
                self.currencyPair = "\(currencyPair[0])-\(currencyPair[1])"
            }else{
                self.currencyPair = title
            }
        }else{
            self.orderHistoryHeaderView?.numberOfRowsLabel.text = title
            self.orderHistoryCurrentPageRowCount = Int(title) ?? 10
        }
        orderHistoryList = []
        orderListSorted = []
        orderHistorySorted = []
        self.orderHistoryCurrentPage = 1
        self.fetchOrderHistoryList()
    }
}

//MARK:------------- MDMarketOptionsViewDelegate -------------
extension MarketListVC : MDMarketOptionsViewDelegate {
    func selectedIndexID(_ id: String) {
        MarketListVC.selected_option = id
        self.dataArray = self.getFilteredDataforSelectedTab()
        self.tableView.reloadData()
    }
}
//MARK:---------- UISearchBarDelegate --------------
extension MarketListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.isMarketScreen || self.isOrderHistoryScreen{
            self.dataArray =  self.getFilteredDataforSelectedTab()
        }else{
            self.orderListSorted = self.getFilteredDataForOrderHistory()
        }
        self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

@IBDesignable
class PaddingLabel: UILabel {
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    @IBInspectable
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
}
