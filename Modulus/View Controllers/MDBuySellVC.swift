 //
//  MDBuySellVC.swift
//  Modulus
//
//  Created by Pathik  on 16/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import WebKit
import MaterialComponents.MaterialTabs
import DropDown
import Alamofire
 enum BuySellOrderType{
    case limit
    case market
    case stop
    case stopLimit
    case stopMarket
    case trailingStopMarket
 }
 
struct ScreenTypeTextFieldTags {
    static let currency = 331
    static let title = 330
}

class MDBuySellVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,customDropDownDelegates{

    //MARK: - StoryBoard outlets
    @IBOutlet weak var sortViewStack: sortIndicatorStackView!
   // @IBOutlet weak var scrollContentHieghtConstant: NSLayoutConstraint!
    @IBOutlet weak var allOrderMyOrderBgView: UIView!
    @IBOutlet weak var totalViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var timeInForceHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var volumeViewHieghtConstant: NSLayoutConstraint!
    @IBOutlet weak var priceViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var shadowImageView: UIImageView!
    @IBOutlet weak var stopViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var allOrdersButton: UIButton!
    @IBOutlet weak var myOrdersButton: UIButton!
    @IBOutlet weak var percentageBarView: UIView!
    @IBOutlet weak var sellOrBuyButton: UIButton!
    @IBOutlet weak var sellOrBuyOrdersLabels: UILabel!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var timeInforceView: UIView!
    @IBOutlet weak var buySellTableView: UITableView!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceTitle: UILabel!
    @IBOutlet weak var lastPriceBackground: UIView!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var buySellButtonBackground: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    //For Automation
    @IBOutlet weak var timeInForceTextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var priceOrLimitTextField: UITextField!
    @IBOutlet weak var stopPriceTextField: UITextField!
    @IBOutlet weak var tableColumnsView: UIView!

    @IBOutlet weak var buySellTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var volumelabel: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    var decimalPricisonPrice : Int = 0
    var decimalPricisionVolume : Int = 0
    
    //MARK: - Variables
    var scrollViewInitialHeight:CGFloat = 0
    var triangleView = TriangleView()
    let navigationDropDown = DropDown()
    var selectedCurrencyPairData:NSDictionary?
    var selectedCurrency = ""
    var navigationTitle = ""
    var marketValue : Double = 0.0
    var screenOrderType : BuySellOrderType = .limit
    var screens = [localised("Market"),localised("Limit") ,localised("Stop"), localised("Stop Market"),localised("Trailing Stop Market")]
    var timeInforceOptions = [localised("Good till cancelled"),localised("Immediate or cancel"),localised("Fill or Kill"),localised("Day only")]
    var timeInForceOptionsEng = ["Good till cancelled","Immediate or cancel","Fill or Kill","Day only"]
    var trailValue = [localised("Absolute Trailing Value"),localised("Trailing Value Percentage")]
    var priceOptions = [localised("Last Price"),localised("Ask Price"),localised("Bid Price")]
    var selectedPrice = ""
    var cellType = "All"
    let cellTypes = ["Sell","Buy","All"]
    var typeFromResponse = "All"
    var isBuyTypeScreen = false
    var openOrders : NSArray = []
    var openOrdersBuy : NSArray = []
    var openOrdersSell : NSArray = []
    var tableViewDefaultHeight = CGFloat(0)
    var navigationBarRightButton = UIButton()
    var isAllOrders = true
    let changeScreenDropDown = DropDown()
    let timeInForceDropdown = DropDown()
    let priceDropdown = DropDown()
    var selectedDropDownValue = localised("Limit")
    var selectedTimeInForce = localised("Good till cancelled")
    var timeInForceForServer = "GTC"
    var imageViewOnRightButton = UIImageView()
    
    var titleView = UIView()
    //For Automation
    var timeInForceIdentifiers = ["goodIdentifier","cancelIdentifers","fillKillIdentifier","dayIdentifier"]
    var priceIdentifers        = ["lastPriceIdentifiers","askPriceIdentifiers","bidPriceIdentifiers"]
    var orderButtonIdentifiers = ["marketOrderIdentifier","limitOrderIdentifier","stopOrderIdentifiers","stopMarketIdentifier","tralingStopMarketIdentifier"]
    
    var isDropDownShown = false
    var availableBalance : Double = 50.0
    var bottomSheet : MDCBottomSheetController? = nil
    
    var maxDecimalsAllowed = 1
    var minOrderValue : Double?
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.changeScreenDropDown
        ]
    }()
    
    var isTextFieldJustBegin : Bool = false
    
    var titleButton = MDButtonWithImageOnRight()
    var detailLabel = UILabel()
    
    //MARK: - Constants
    let cellID = "MDBuySellOrderCell"
    let cellHeight = CGFloat(33)

    var marketType = ""

    //MARK: - View Controller life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollViewInitialHeight = scrollContentHieghtConstant.constant
        self.addObsrver()
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
        } else {
            // Fallback on earlier versions
        }
        self.addPercentageSeekBar()
        self.calculateMaxDecimals()
        setNavigationbar()
        setHighLowData()
        setUpColors()
        setupDrowDown()
        self.setAllTextOnScreenWithLocalisation()
        toggleBuySell()
        toggleAllMyOrders()
        screenDidChanged(name : selectedDropDownValue)
        balanceTitle.text = localised("Balance")
        let defaultHeight = self.view.frame.height - (allOrderMyOrderBgView.frame.origin.y + allOrderMyOrderBgView.frame.size.height + tableColumnsView.frame.size.height) - (self.navigationController?.navigationBar.bounds.size.height)!
        self.buySellTableViewHeightConstraint.constant = defaultHeight
        if let textField = self.getTextFieldOf(unitView: timeInforceView){
            setupDrowDownForTimeInForce(baseView : textField)
        }
        sortViewStack.configureStack()
        if let button = self.getTitleButtonForView(unitView: priceView){
            setupDrowDownForPrice(baseView: button)
        }
        DispatchQueue.main.async{
            self.getTextFieldOf(unitView: self.volumeView)!.addTarget(self, action: #selector(self.volumeDidChangedManually(_:)), for: .editingChanged)
        }
        
        self.marketValue = self.selectedCurrencyPairData?.value(forKey: "price") as? Double ?? 0.0
        updateContentSize()
        //For Automation
        timeInForceTextField.accessibilityIdentifier = "timeInForceTextField"
        timeInForceTextField.accessibilityValue = "timeInForceTextField"
        timeInForceTextField.accessibilityLabel = "timeInForceTextField"
        
        totalTextField.accessibilityIdentifier = "totalTextField"
        totalTextField.accessibilityValue = "totalTextField"
        totalTextField.accessibilityLabel = "totalTextField"
        
        volumeTextField.accessibilityIdentifier = "volumeTextField"
        volumeTextField.accessibilityValue = "volumeTextField"
        volumeTextField.accessibilityLabel = "volumeTextField"
        
        priceOrLimitTextField.accessibilityIdentifier = "priceOrLimitTextField"
        priceOrLimitTextField.accessibilityValue = "priceOrLimitTextField"
        priceOrLimitTextField.accessibilityLabel = "priceOrLimitTextField"
        
        stopPriceTextField.accessibilityIdentifier = "stopPriceTextField"
        stopPriceTextField.accessibilityValue = "stopPriceTextField"
        stopPriceTextField.accessibilityLabel = "stopPriceTextField"
        
        allOrdersButton.accessibilityIdentifier = "allOrdersButton"
        allOrdersButton.accessibilityValue = "allOrdersButton"
        allOrdersButton.accessibilityLabel = "allOrdersButton"
        
        myOrdersButton.accessibilityIdentifier = "myOrdersButton"
        myOrdersButton.accessibilityValue = "myOrdersButton"
        myOrdersButton.accessibilityLabel = "myOrdersButton"
        
        buyButton.accessibilityIdentifier = "buyButton"
        buyButton.accessibilityValue = "buyButton"
        buyButton.accessibilityLabel = "buyButton"
        
        sellButton.accessibilityIdentifier = "sellButton"
        sellButton.accessibilityValue = "sellButton"
        sellButton.accessibilityLabel = "sellButton"
        
        
        sellOrBuyButton.accessibilityValue = "sellOrBuyButton"
        sellOrBuyButton.accessibilityLabel = "sellOrBuyButton"
        sellOrBuyButton.accessibilityIdentifier = "sellOrBuyButton"
        DispatchQueue.main.async {
            if self.isAllOrders {
                self.myOrdersButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
                self.allOrdersButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            }else {
                self.allOrdersButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
                self.myOrdersButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            }
        }
        
//        self.screenDidChanged(name: screens[3])
        self.navigationBarRightButton.setTitle(selectedDropDownValue, for: .normal)
        
        self.totalTextField.isUserInteractionEnabled = true
    }
    
    @objc func volumeDidChangedManually(_ sender : UITextField){
        print(sender.text!)
        let volume = Double(sender.text!) ?? 0.0
        let percentage : Double
        
        if volume > 0 && self.availableBalance > 0{
            percentage = (volume/self.availableBalance) * 100
        }else{
            percentage = 0.0
        }
    }
    //MARK: - Set all titles
    private func setAllTextOnScreenWithLocalisation(){
        buyButton.setTitle(localised("BUY").localizedUppercase, for: .normal)
        sellButton.setTitle(localised("SELL").localizedUppercase, for: .normal)
        
        volumelabel.text = localised("Volume")
        pricelabel.text = localised("Price")
   
    }
    
    private
    func addObsrver(){
        self.buySellTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" ,let newSize = change?[.newKey] as? CGSize{
            if newSize.height > 10{
                self.buySellTableViewHeightConstraint.constant = newSize.height + 60
            }else{
                self.buySellTableViewHeightConstraint.constant = 100
            }
            
        }
    }
    
    private func addPercentageSeekBar(){
        self.percentageBarView.backgroundColor = .clear
        let view = Bundle.main.loadNibNamed(MDPercentageSeekBarView.identifier ,
                                                owner: nil,
                                                options: nil)![0] as! MDPercentageSeekBarView
        view.frame = CGRect.init(x: 10, y: self.percentageBarView.frame.height / 2 - 15, width: self.percentageBarView.frame.width - 20, height: 20)
        view.isBuyTypeScreen = self.isBuyTypeScreen
        view.delegate = self
        self.percentageBarView.addSubview(view)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self           
        }
        self.calculateMaxDecimals()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            SocketHelper.shared.unsubscribeToSpecificEvents()
        } else {
            // Fallback on earlier versions
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
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
        
        
        DispatchQueue.main.async {
            if self.isAllOrders {
                self.myOrdersButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
                self.allOrdersButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            }else {
                self.allOrdersButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
                self.myOrdersButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            }
            
            let view = self.percentageBarView.subviews.first! as! MDPercentageSeekBarView
            view.ViewWillTransit()
        }
        if ((UIApplication.shared.keyWindow)?.subviews.first(where: {$0.isKind(of: DropDown.self)})) == timeInForceDropdown{
            timeInForceDropdown.hide()
           
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self.timeInForceDropdown.show()
            }
            
            
        }
         if self.bottomSheet != nil && (self.presentedViewController as? MDCBottomSheetController)?.presentingViewController != nil {
            
            self.bottomSheet?.dismiss(animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showNavigationDropDown(sender: self)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateContentSize()
        }
    }
    
    //MARK:- Calculate max decimals

    func calculateMaxDecimals(){
        if let min_trade_amount = self.selectedCurrencyPairData?.value(forKey: "min_trade_amount") as? Double{
            let decimalValues = Float(min_trade_amount).avoidNotation.split(separator: ".")
            if decimalValues.count > 1{
                if let valueAfterDecimal = Float(min_trade_amount).avoidNotation.split(separator: ".")[1] as? NSString{
                       let decimalArray = Array("\(valueAfterDecimal)")
                       self.maxDecimalsAllowed = (decimalArray.firstIndex(of: "1") ?? 8) + 1
                   }
            }
        }
        if let min_order_value = self.selectedCurrencyPairData?.value(forKey: "min_order_value") as? Double{
            self.minOrderValue = min_order_value
        }
    }
    
    
    
    //MARK:- navigation bar helprs
    func setNavigationbar(){
         titleView =  UIView.init(frame: CGRect(x: 0, y: 0, width: ConstantSizes.navigationTitleWidth, height: (self.navigationController?.navigationBar.frame.size.height)!))
         titleButton = MDButtonWithImageOnRight(frame: CGRect(x: 0, y: 0, width: titleView.frame.size.width, height: titleView.frame.size.height-CGFloat(20)))
        if UIDevice.current.orientation.isLandscape {
            titleButton.center = titleView.center
        }
        titleButton.setImage(UIImage.init(named: "Rectangle"), for: .normal)
        titleButton.setTitle(navigationTitle, for: .normal)
        titleButton.tag = 109
        titleButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        titleButton.titleLabel?.font = MDAppearance.Fonts.smallNavigationTitleFont
        titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        titleButton.addTarget(self, action: #selector(showNavigationDropDown(sender:)), for: .touchUpInside)
        
        titleView.addSubview(titleButton)
        detailLabel = UILabel(frame: CGRect.init(x: 0, y:titleButton.frame.origin.y + titleButton.frame.size.height, width: titleButton.frame.size.width, height: 20))
//        detailLabel.text = "0.03654 -1.48%"
        detailLabel.textAlignment = .center
        detailLabel.textColor = Theme.current.primaryColor
         detailLabel.font =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 14)
        titleView.addSubview(detailLabel)
        //For Automation
        titleView.isAccessibilityElement = true
        titleView.accessibilityIdentifier = "CurrencyDropDownButton"
        titleView.accessibilityValue = "CurrencyDropDownButton"
        titleView.accessibilityLabel = "CurrencyDropDownButton"
        var detailsLabelText = ""
        if let lastPriceVal = selectedCurrencyPairData!.value(forKey: "price") as? Double{
            detailsLabelText = MDHelper.shared.getFormattedNumber(amount: lastPriceVal, minimumFractionDigits: self.decimalPricisonPrice) ?? ""
        }
        if let  percen = selectedCurrencyPairData!.value(forKey: "change_in_price") as? Double{
            detailsLabelText = detailsLabelText + "    \(String(format: "%.2f", percen))%"
            detailLabel.textColor = percen < 0 ? Theme.current.primaryColor : Theme.current.secondaryColor
        }
        detailLabel.text = detailsLabelText
        
        self.navigationItem.titleView = titleView
        
        let rightBarButtonView = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: (self.navigationController?.navigationBar.frame.size.height)!))
       
        
        navigationBarRightButton = UIButton.init(frame: CGRect(x: -10, y: 0, width: 80, height: (self.navigationController?.navigationBar.frame.size.height)!))
        //navigationBarRightButton.setImage(UIImage.init(named: "Rectangle"), for: .normal)
        navigationBarRightButton.setTitle(localised("Limit"), for: .normal)
        navigationBarRightButton.titleLabel?.font =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 14)
        navigationBarRightButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        navigationBarRightButton.addTarget(self, action: #selector(screenChangeAction(_:)), for: .touchUpInside)
        navigationBarRightButton.contentHorizontalAlignment = .right
        //For Automation
        navigationBarRightButton.isAccessibilityElement = true
        navigationBarRightButton.accessibilityValue = "marketStopLimit"
        navigationBarRightButton.accessibilityIdentifier = "marketStopLimit"
        navigationBarRightButton.accessibilityValue = "marketStopLimit"
        rightBarButtonView.addSubview(navigationBarRightButton)
        imageViewOnRightButton = UIImageView.init(frame: CGRect.init(x: navigationBarRightButton.frame.origin.x + navigationBarRightButton.frame.size.width + 8, y: (self.navigationController?.navigationBar.frame.size.height)!/2 - 5, width: 10, height: 10))
        imageViewOnRightButton.contentMode = .scaleAspectFit
        imageViewOnRightButton.image = UIImage.init(named: "Rectangle")
        rightBarButtonView.addSubview(imageViewOnRightButton)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(customView: rightBarButtonView)
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
    
    //MARK:- setup appeareance
    func setUpColors(){
       self.view.backgroundColor = Theme.current.backgroundColor
        buySellButtonBackground.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        lastPriceBackground.backgroundColor = Theme.current.backgroundColor
        sellOrBuyOrdersLabels.backgroundColor = Theme.current.backgroundColor
        scrollContentView.backgroundColor  = Theme.current.navigationBarColor
        balanceLabel.textColor = Theme.current.titleTextColor
        balanceTitle.textColor = Theme.current.titleTextColor
         // All textfilds and buttons
        let textFieldBgView = [stopView,priceView,volumeView,totalView,timeInforceView]
        for bgView in textFieldBgView{
            bgView!.backgroundColor = UIColor.clear
            for subViewOfbgView in (bgView?.subviews)!{
                subViewOfbgView.backgroundColor = Theme.current.BuySellScreentextFiledBgColor
                for subView in subViewOfbgView.subviews{
                    if subView is UIButton{
                        let button = (subView as! UIButton)
                    button.setBackgroundImage(UIImage.from(color:Theme.current.BuySellScreentextFiledLabelBgColor), for: .normal)
                        button.setTitleColor(Theme.current.titleTextColor, for: .normal)
                        button.tintColor = Theme.current.subTitleColor
                    }else if subView is UITextField{
                        let textField = (subView as! UITextField)
                        textField.textColor = Theme.current.titleTextColor
                        textField.placeHolderColorCustom = Theme.current.subTitleColor
                    }
                }
            }
        }
        // Header
        sellOrBuyOrdersLabels.textColor = Theme.current.titleTextColor
        sellOrBuyOrdersLabels.backgroundColor = Theme.current.backgroundColor

        allOrdersButton.setTitleColor(Theme.current.primaryColor, for: .normal)
        myOrdersButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        
        allOrderMyOrderBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        allOrdersButton.setTitleColor(Theme.current.primaryColor, for: .normal)
        
        tableColumnsView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        buySellTableView.backgroundColor = Theme.current.navigationBarColor
        
        if let tableColumnsStackView = (tableColumnsView.subviews.first as? UIView)?.subviews.first as? UIStackView{
            for arrangeSubview in tableColumnsStackView.arrangedSubviews{
                if arrangeSubview is UILabel{
                    (arrangeSubview as! UILabel).textColor = Theme.current.titleTextColor
                }
            }
        }
        shadowImageView.tintColor = Theme.current.navigationBarColor
    }
    
    //MARK: - Dropdown UI helpers
    func setupDrowDown()  {
        let dropDownsdata = screens
        let appearance = DropDown.appearance()
        appearance.cellHeight = 35
        appearance.backgroundColor = Theme.current.dropDownBgColor
        appearance.cornerRadius = 2
        appearance.animationduration = 0.25
        appearance.selectionBackgroundColor = UIColor.clear
        changeScreenDropDown.direction = .any
            /*** FOR CUSTOM CELLS ***/
        changeScreenDropDown.cellNib = UINib(nibName: "MDChangeScreenCell", bundle: nil)
        changeScreenDropDown.dataSource = dropDownsdata
        changeScreenDropDown.anchorView = navigationBarRightButton
        changeScreenDropDown.shadowColor = UIColor.clear
        changeScreenDropDown.shadowColor = .clear
        changeScreenDropDown.shadowOpacity = 0
        changeScreenDropDown.shadowRadius = 0
        changeScreenDropDown.selectRow(1)
        self.selectedDropDownValue = dropDownsdata[1]
        changeScreenDropDown.width = navigationBarRightButton.frame.size.width + 100
            changeScreenDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MDChangeScreenCell else { return }
             
                if self.selectedDropDownValue == item{
                    cell.suffixLabel.backgroundColor = Theme.current.selectedCellBgColor
                }else{
                    cell.suffixLabel.backgroundColor = Theme.current.mainTableCellsBgColor //MDAppearance.Colors.highlightBackgroundColor
                }
                // Setup your custom UI components
                cell.suffixLabel.text = self.screens[index]
                cell.suffixLabel.textColor = Theme.current.titleTextColor
                //For Automation
                cell.suffixLabel.isAccessibilityElement = true
                cell.suffixLabel.accessibilityValue = self.orderButtonIdentifiers[index]
                cell.suffixLabel.accessibilityIdentifier = self.orderButtonIdentifiers[index]
                cell.suffixLabel.accessibilityLabel = self.orderButtonIdentifiers[index]
                cell.suffixLabel.accessibilityHint = self.orderButtonIdentifiers[index]
            }
        changeScreenDropDown.cancelAction = {
            if let tv = self.navigationBarRightButton.viewWithTag(1080){
                tv.removeFromSuperview()
            }
            UIView.animate(withDuration: 0.3) {
                  self.imageViewOnRightButton.transform = CGAffineTransform.identity
            }
        }
        changeScreenDropDown.selectionAction =  { [weak self] (index, item) in
            switch item{
            case localised("Stop"):
                self?.navigationBarRightButton.setTitle(localised("Stop Limit"), for: .normal)
            case localised("Trailing Stop Market"):
                self?.navigationBarRightButton.setTitle(localised("Trail Market"), for: .normal)
            default:
                self?.navigationBarRightButton.setTitle(self?.screens[index], for: .normal)
            }
            
            if let tv = self?.navigationBarRightButton.viewWithTag(1080){
                tv.removeFromSuperview()
            }
            self?.screenDidChanged(name: (self?.screens[index])!)
            self!.selectedDropDownValue = item
            UIView.animate(withDuration: 0.3) {
                self?.imageViewOnRightButton.transform = CGAffineTransform.identity
            }
        }
    }

    func setupDrowDownForPrice (baseView : UIView)  {
        
        let dropDownsdata = priceOptions
        
        
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 35
        appearance.backgroundColor = Theme.current.dropDownBgColor//MDAppearance.Colors.highlightBackgroundColor
        appearance.cornerRadius = 2
        appearance.shadowColor = UIColor.clear
        appearance.shadowColor = .clear
        appearance.shadowOpacity = 0
        appearance.shadowRadius = 0
        appearance.animationduration = 0.25
        appearance.selectionBackgroundColor = UIColor.clear
        priceDropdown.direction = .any
        //        dropDowns.forEach {
        /*** FOR CUSTOM CELLS ***/
        priceDropdown.cellNib = UINib(nibName: "MDChangeScreenCell", bundle: nil)
        priceDropdown.dataSource = dropDownsdata
        priceDropdown.anchorView = baseView
        priceDropdown.width = navigationBarRightButton.frame.size.width + 60
        priceDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MDChangeScreenCell else { return }
            
            if self.selectedPrice == item{
                cell.suffixLabel.backgroundColor = Theme.current.selectedCellBgColor//MDAppearance.Colors.dropdownSelectedBgColor
            }else{
                cell.suffixLabel.backgroundColor = Theme.current.mainTableCellsBgColor//UIColor.init(red: 63/255, green: 60/255, blue: 76/255, alpha: 1.0) //MDAppearance.Colors.highlightBackgroundColor
            }
            // Setup your custom UI components
            cell.suffixLabel.text = self.priceOptions[index]
            cell.suffixLabel.textColor = Theme.current.titleTextColor
            
            
            //For Automation
            cell.suffixLabel.isAccessibilityElement = true
            cell.suffixLabel.accessibilityValue = self.priceIdentifers[index]
            cell.suffixLabel.accessibilityIdentifier = self.priceIdentifers[index]
            cell.suffixLabel.accessibilityLabel = self.priceIdentifers[index]
            cell.suffixLabel.accessibilityHint = self.priceIdentifers[index]
        }
        self.priceDropdown.isAccessibilityElement = true
        self.priceDropdown.accessibilityValue = "priceDropdown"
        self.priceDropdown.accessibilityIdentifier = "priceDropdown"
        self.priceDropdown.accessibilityLabel = "priceDropdown"
        
        priceDropdown.selectionAction =  { [weak self] (index, item) in
            if item != self?.selectedPrice {
                self?.selectedPrice = item
                self?.priceChanged(name:item)
            }
        }
    }
    
    func setupDrowDownForTimeInForce (baseView : UIView,ShouldShowTrailOptions:Bool = false)  {
        
        let dropDownsdata = ShouldShowTrailOptions == true ? trailValue : timeInforceOptions
        
        
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 35
        appearance.backgroundColor = Theme.current.dropDownBgColor
        //        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 2
        //        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        //        appearance.shadowOpacity = 0.9
        //        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.selectionBackgroundColor = UIColor.clear
        //        appearance.textColor = .darkGray
        //        appearance.textFont = UIFont(name: "Georgia", size: 14)
        timeInForceDropdown.direction = .any
        //        dropDowns.forEach {
        /*** FOR CUSTOM CELLS ***/
        timeInForceDropdown.cellNib = UINib(nibName: "MDChangeScreenCell", bundle: nil)
        timeInForceDropdown.dataSource = dropDownsdata
        timeInForceDropdown.anchorView = baseView
        timeInForceDropdown.selectRow(0)
        self.selectedTimeInForce = dropDownsdata[0]
        timeInForceDropdown.width = baseView.frame.size.width+25
        timeInForceDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MDChangeScreenCell else { return }
            
            if self.selectedTimeInForce == item{
                cell.suffixLabel.backgroundColor = Theme.current.selectedCellBgColor
                
                
            }else{
                cell.suffixLabel.backgroundColor = Theme.current.mainTableCellsBgColor //MDAppearance.Colors.highlightBackgroundColor
            }
            // Setup your custom UI components
            cell.suffixLabel.text = self.timeInForceDropdown.dataSource[index]
            cell.suffixLabel.textColor = Theme.current.titleTextColor
            //For Automation
            cell.suffixLabel.isAccessibilityElement = true
            cell.suffixLabel.accessibilityValue = self.timeInForceIdentifiers[index]
            cell.suffixLabel.accessibilityIdentifier = self.timeInForceIdentifiers[index]
            cell.suffixLabel.accessibilityLabel = self.timeInForceIdentifiers[index]
            cell.suffixLabel.accessibilityHint = self.timeInForceIdentifiers[index]
        }
        timeInForceDropdown.selectionAction =  { [weak self] (index, item) in
            if item != self?.selectedTimeInForce {
                self?.selectedTimeInForce = item
                if self?.screenOrderType == .trailingStopMarket{
                    if index == 1{
                        self?.showPercentageView()
                    }else{
                        let currency = self?.selectedCurrencyPairData?.value(forKey: "quote") as! String
                        self?.setCurrencyUnitForView(currency: currency, unitView: self?.priceView ?? UIView())
                    }
                }
                self?.timeInForceDidChanged(item: item)
            }
        }
    }
    
    //MARK: - Price dropdown actions
    func priceChanged(name:String)  {
        if let priceTextfield = self.getTextFieldOf(unitView: priceView){
            priceTextfield.text = "0.0"
            if name == (localised("Last Price")){
                if let lastPriceVal = selectedCurrencyPairData!.valueForCaseInsensativeKey(forKey: "prev_price") as? Double{
                    priceTextfield.text = String(format: "%.9f", lastPriceVal)
                }
            }else if name == (localised("Ask Price")){
                if let lastPriceVal = self.getHighAndLowValues().low{
                    priceTextfield.text = "\(lastPriceVal)"
               }
            }else if name == (localised("Bid Price")){
                if let bidVal = self.getHighAndLowValues().high{
                     priceTextfield.text = "\(bidVal)"
                }
            }
        }
    }

    //MARK: - High Low value Helpers
    func getHighAndLowValues() -> (high:Double?,low:Double?) {
        var low : Double? = nil
        var high : Double? = nil
        if #available(iOS 13.0, *) {
            if var orderBookBuy = SocketHelper.shared.orderBookBuy{
                
                var mutableArray = NSMutableArray()
                   for eachData in orderBookBuy{
                       if let innerArray = eachData as? NSArray{
                           let price = innerArray[0]
                           let volume = innerArray[1]
                           let type = innerArray[2]
                           mutableArray.add(["rate":price,"volume":volume,"execution_side":type])
                           
                           
                       }
                   }
                orderBookBuy = mutableArray as NSArray
                let sortedArray = self.sortArrayByRate(array: orderBookBuy as! [NSDictionary])
                if let dict = sortedArray.first {
                    if let rate = dict.valueForCaseInsensativeKey(forKey: "rate") as? Double {
                        high = rate
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            if var orderBookSell = SocketHelper.shared.orderBookSell{
               
                var mutableArray = NSMutableArray()
                   for eachData in orderBookSell{
                       if let innerArray = eachData as? NSArray{
                           let price = innerArray[0]
                           let volume = innerArray[1]
                           let type = innerArray[2]
                           mutableArray.add(["rate":price,"volume":volume,"execution_side":type])
                           
                           
                       }
                   }
                orderBookSell = mutableArray as NSArray
                
                let sortedArray = self.sortArrayByRate(array: orderBookSell as! [NSDictionary])
                if let dict = sortedArray.last {
                    if let rate = dict.valueForCaseInsensativeKey(forKey: "rate") as? Double {
                        low = rate
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        return (high:high,low:low)
    }
    
    //MARK: - Sorting helpers
    func sortArrayByRate(array:[NSDictionary]) -> [NSDictionary] {
        let sortedArray = array.sorted { (item1, item2) -> Bool in
            if let rate1 = item1.valueForCaseInsensativeKey(forKey: "rate") as? Double,let rate2 = item2.valueForCaseInsensativeKey(forKey: "rate") as? Double  {
                                return rate1 > rate2
                            }
            return true
        }

        return sortedArray
    }
    
    func getbalaceInfo()  {
        let marketCurrency = selectedCurrencyPairData?.value(forKey: "quote") as! String
        let coinCurrency = selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "base") as! String
        if self.isBuyTypeScreen {
                self.balanceLabel.text = String(format: localised("fetching")+" %@",marketCurrency)
        }else {
                self.balanceLabel.text = String(format: localised("fetching")+" %@",coinCurrency)
        }
        DispatchQueue.global(qos: .background).async {
            
            if let balanceInfo = MDWalletHelper.shared.getWalletBalanceForCurrency(currency:   self.isBuyTypeScreen ? marketCurrency : coinCurrency){
                  DispatchQueue.main.async {
                // print(balanceInfo)
                    if self.isBuyTypeScreen {
                    if let balance = balanceInfo.valueForCaseInsensativeKey(forKey: "balance") as? Double {
                        self.balanceLabel.text = String(format: "%.7f %@", balance,marketCurrency)
                        self.availableBalance = balance
                    }
                    }else {
                      if let intrade = balanceInfo.valueForCaseInsensativeKey(forKey: "balance") as? Double {
                        self.balanceLabel.text = String(format: "%.7f %@", intrade,coinCurrency)
                        self.availableBalance = intrade
                    }
                    }
                }
            }
        }
    }
    
    func setHighLowData(){
       
       // DispatchQueue.main.async {
            let currency = self.selectedCurrencyPairData?.valueForCaseInsensativeKey(forKey: "quote") as! String
                
            if self.isBuyTypeScreen {
                if let lastPriceVal = self.getHighAndLowValues().low{
                    self.lastPriceLabel.text = localised("Lowest ask") + ": "+MDHelper.shared.getFormattedNumber(amount: lastPriceVal, minimumFractionDigits: self.decimalPricisonPrice)! + " " + currency
                    self.lastPriceLabel.textColor = Theme.current.primaryColor
                       }else {
                    self.lastPriceLabel.text = String(format: localised("Lowest ask")+": N/A %@",currency)
                    self.lastPriceLabel.textColor = Theme.current.primaryColor
                       }
                   }else{
                if let lastPriceVal = self.getHighAndLowValues().high{
                    self.lastPriceLabel.text = String(format: localised("Highest bid")+": %.\(self.decimalPricisonPrice)f %@", lastPriceVal,currency)
                    self.lastPriceLabel.text = localised("Highest bid") + ": "+MDHelper.shared.getFormattedNumber(amount: lastPriceVal, minimumFractionDigits: self.decimalPricisonPrice)! + " " + currency
                    self.lastPriceLabel.textColor = Theme.current.secondaryColor
                       }else {
                    self.lastPriceLabel.text = String(format: localised("Highest bid")+": N/A %@",currency)
                    self.lastPriceLabel.textColor = Theme.current.secondaryColor
                       }
                   }
    }
    
    
    //update Trading Price And Percentage
    private func updateTradingPriceAndPercentageLabel(data: NSDictionary?){
        if let updatedData = data{
            var detailsLabelText = ""
            if let lastPriceVal = updatedData["CurrentTradingPrice"] as? Double{
                detailsLabelText = String(format: "%.8f", lastPriceVal)
            }
            if let  percen = updatedData["ChangeInPrice"] as? Double{
                detailsLabelText = detailsLabelText + "    \(String(format: "%.2f", percen))%"
                detailLabel.textColor = percen < 0 ? Theme.current.primaryColor : Theme.current.secondaryColor
            }
            self.selectedCurrencyPairData = updatedData
            self.setHighLowData()
            self.detailLabel.text = detailsLabelText
            print("Updated")
        }
    }
    

    
    func getAcronyms(stringInput:String) -> String {
 
        let stringInputArr = stringInput.components(separatedBy: " ")
        var stringNeed = ""
        
        for string in stringInputArr {
            stringNeed = stringNeed + String(string.first!)
        }
        return stringNeed.uppercased()
    }
    
    //MARK: - Contente size helpers
    func updateContentSize(){
        var topSafeArea: CGFloat
        var bottomSafeArea: CGFloat
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
        let navigationControllerObject = UINavigationController()
        let defaultHeight = self.view.frame.height - (allOrderMyOrderBgView.frame.origin.y + allOrderMyOrderBgView.frame.size.height + tableColumnsView.frame.size.height) - (navigationControllerObject.navigationBar.frame.height) //- topSafeArea
        // Default table height is set to 180 from storyboard
        if buySellTableView.contentSize.height > defaultHeight {
            let upparPartHeight = allOrderMyOrderBgView.frame.size.height + tableColumnsView.frame.size.height
           
            if (buySellTableView.contentSize.height + upparPartHeight) > self.view.frame.size.height{

                // Dont consider safe area in landscape
               
                if UIApplication.shared.statusBarOrientation.isLandscape{
                    
                    //buySellTableViewHeightConstraint.constant = self.view.frame.size.height - (navigationControllerObject.navigationBar.frame.height) - upparPartHeight - topSafeArea + sellOrBuyOrdersLabels.frame.size.height
                        //- (sellOrBuyOrdersLabels.frame.size.height)
                }else{
                   // buySellTableViewHeightConstraint.constant = self.view.frame.size.height - (navigationControllerObject.navigationBar.frame.height) - upparPartHeight - topSafeArea
                }
                
                self.buySellTableView.isUserInteractionEnabled = true
            }else{
               // buySellTableViewHeightConstraint.constant = buySellTableView.contentSize.height
            }



        }else{
            //buySellTableViewHeightConstraint.constant = defaultHeight
        }
        
        
        
        
        
    }
    
    //MARK:- tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openOrders.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
            noDataLabel.text          = localised("No data available")
            noDataLabel.textColor     = Theme.current.titleTextColor
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            noDataLabel.backgroundColor = UIColor.clear
            tableView.backgroundView?.frame =  CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100)
            noDataLabel.font =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 15)
        }else{
             tableView.backgroundView  = nil
        }
        return openOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MDBuySellOrderCell
        
        var openOrdersMutable = [NSDictionary]()
        for data in openOrders{
            openOrdersMutable.append(data as? NSDictionary ?? NSDictionary())
        }
        if openOrdersMutable.indices.contains(indexPath.row){
            let cellData = openOrders[indexPath.row] as! NSDictionary
            let currency = selectedCurrencyPairData?.value(forKey: "base") as! String
            let currency2 = selectedCurrencyPairData?.value(forKey: "quote") as! String
            if isBuyTypeScreen == true{
                cell.priceLabel.textColor = Theme.current.secondaryColor
                cell.configureCell(data: cellData,currency:currency, decimalPrecision: self.decimalPricisonPrice)
            }else {
                cell.priceLabel.textColor = Theme.current.primaryColor
                cell.configureCell(data: cellData,currency:currency2, decimalPrecision: self.decimalPricisonPrice)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    //MARK:- sizes for tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    //MARK:- Server connection
    func getParamsForPlaceOrder() ->  [String : String]{
        
        let currency = selectedCurrencyPairData?.value(forKey: "base") as! String
        let currency2 = selectedCurrencyPairData?.value(forKey: "quote") as! String
        let currencies = [currency,currency2]
        let placeOrderData = self.getPlaceOrderData(marketName: selectedDropDownValue)
        let type = self.getMarketType(forString: selectedDropDownValue)
      
        let side = sellOrBuyButton.currentTitle! == localised("BUY") ? "BUY" : "SELL"
        let mutableParams = NSMutableDictionary.init(dictionary:[ "side":side,
            "market": currencies[1],
            "trade": currencies[0],
            "type":type,
            /*"clientOrderId": "\(arc4random())",*/
            "timestamp": "\(MDNetworkManager.shared.getCurrentTimeStamp())",
            "recvWindow": "1000"
            ]
        )
        if selectedDropDownValue == (localised("Trailing Stop Market")){
            mutableParams.setValue("GTC", forKey: "timeInForce")
            mutableParams.setValue(placeOrderData.priceOrLimit, forKey: "volume")
            mutableParams.setValue(placeOrderData.volume, forKey: "trail")
            if timeInForceForServer == trailValue.first!{
                mutableParams.setValue("false", forKey: "isTrailInPercentage")
            }else{
                mutableParams.setValue("true", forKey: "isTrailInPercentage")
            }
        }else if selectedDropDownValue == (localised("Stop Market")) {
//            mutableParams.setValue("GTC", forKey: "timeInForce")
            mutableParams.setValue(placeOrderData.volume, forKey: "volume")
            mutableParams.setValue(placeOrderData.priceOrLimit, forKey: "stop")
            
        }else if selectedDropDownValue == (localised("Stop")) {
            
            mutableParams.setValue(placeOrderData.volume, forKey: "volume")
            mutableParams.setValue(placeOrderData.priceOrLimit, forKey: "rate")
            mutableParams.setValue(placeOrderData.stop, forKey: "stop")
            
        }else if selectedDropDownValue == (localised("Limit")) {
            
          
            mutableParams.setValue(timeInForceForServer, forKey: "timeInForce")
             mutableParams.setValue(placeOrderData.volume, forKey: "volume")
             mutableParams.setValue(placeOrderData.priceOrLimit, forKey: "rate")
            
        }
        else if selectedDropDownValue == (localised("Market")) {
           mutableParams.setValue(timeInForceForServer, forKey: "timeInForce")
           mutableParams.setValue(placeOrderData.volume, forKey: "volume")
            
        }

        return mutableParams as! [String : String]
    }
    
    //MARK: - API Calls
    /// This will place order Either for sell or Buy
    func placeOrder(){
    
        let params = self.getParamsForPlaceOrder()
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
        
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .post,
                                            apiName: API.placeOrder,
                                            parameters: params as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        
                                                        if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
                                                            if let orderID = data.valueForCaseInsensativeKey(forKey: "orderid") as? Int {
                                                                if self.priceOrLimitTextField.text != localised("Market Price"){
                                                                    self.priceOrLimitTextField.text = ""
                                                                }
                                                                self.stopPriceTextField.text = ""
                                                               self.volumeTextField.text = ""
                                                                
                                                                self.totalTextField.text = ""
                                                                
                                                                
                                                                MDHelper.shared.showSucessAlert(message: localised("Order placed successfully."), viewController: self)
                                                            }
                                                        
                                                        }
                                                    }else{
                                                        if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                                                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                        }else{
                                                            MDHelper.shared.showErrorAlert(message: "Trade value invalid", viewController: self)
                                                        }
                                                    }
                                                }else{
                                                    if  error != nil{
                                                       // MDHelper.shared.showErrorAlert(message: (error?.localizedDescription)!, viewController: self)
                                                         MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                    }
                                                }
        }
        
    }

    //MARK: ------------ Fetch all Orders -----------
    /// Fetch all the orders to show in Orders section
    func fetchAllOrders(type:String,currency:String)  {
       self.openOrders = []
        self.buySellTableView.reloadData()
        if isBuyTypeScreen == true{
            if #available(iOS 13.0, *) {
                if let orderbookBuyData = SocketHelper.shared.orderBookBuy{
                    self.orderBookBuyDataReceived(response: orderbookBuyData)
                }
            } else {
                // Fallback on earlier versions
            }
            
        }else {
            if #available(iOS 13.0, *) {
                if let orderbookSellData = SocketHelper.shared.orderBookSell{
                    self.orderBookSellyDataReceived(response: orderbookSellData)
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
        } else {
            // Fallback on earlier versions
        }
//        MDHelper.shared.showHud(view: self.buySellTableView)
//        self.buySellTableView.backgroundView = nil
//        MDNetworkManager.shared.sendRequest(methodType: .get,
//                                            apiName: "\(API.orderList)/\(currency)/\(type)/20",
//            parameters: nil,
//            headers: nil) { (response, error) in
//
//                MDHelper.shared.hideHud(view: self.buySellTableView)
//                if response != nil && error == nil{
//                    if MDNetworkManager.shared.isResponseSucced(response: response!){
//                        self.handleOpenOrderResponse(response: response!)
//                    }
//                }
//        }
    }
    
    /// Fetch Myorders which are placed by me and till now its not traded
    func fetchMyOrders(type:String,currency:String)  {
        
        self.openOrders = []
        if #available(iOS 13.0, *) {
            if let pendingOrder = SocketHelper.shared.myPendingOrders{
                
                self.handleMyOrderResponse(pendingOrder: pendingOrder)
                
            }
        }
        
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
        } else {
            // Fallback on earlier versions
        }
//            MDHelper.shared.showHud(view: self.buySellTableView)
//        self.buySellTableView.backgroundView = nil
//        MDNetworkManager.shared.sendRequest(methodType: .get,
//                                            apiName: "\(API.orderList)/\(currency)/\(type)/20",
//            parameters: nil,
//            headers: nil) { (response, error) in
//
//                MDHelper.shared.hideHud(view: self.buySellTableView)
//                if response != nil && error == nil{
//                    if MDNetworkManager.shared.isResponseSucced(response: response!){
//                        self.handleOpenOrderResponse(response: response!)
//                    }
//                }
//
//        }
       
    }

    //MARK: - Response handlers
    
    /// This will parse the response for My orders
    func handleMyOrderResponse(pendingOrder:NSArray)  {
        
        
        if self.openOrders.count == 0 {
            self.openOrders = pendingOrder
            
        }else{
            
            for each in pendingOrder{
                if let pendigOrderDetails = each as? NSDictionary{
                    if (pendigOrderDetails.value(forKey: "status") as? Bool) == true{
                        self.removeOpenOrderFromExistingList(orderId: pendigOrderDetails.value(forKey: "order_id") as! Double)
                    }else{
                        self.addElementToOpenOrder(data: pendigOrderDetails)
                    }
                }
                
            }
            
            
        }
        
        
        
        let myPendingOrder : NSMutableArray = .init(array: self.openOrders)
 
        for each in pendingOrder{
            if let pendigOrderDetails = each as? NSDictionary{
                if (pendigOrderDetails.value(forKey: "status") as? Bool) == true{
                    self.removeOpenOrderFromExistingList(orderId: pendigOrderDetails.value(forKey: "order_id") as! Double)
                    //return
                }else{
                    myPendingOrder.addObjects(from: [pendigOrderDetails])
                }
            }
            
        }
        
        
        
        self.openOrders = self.openOrders.filter({ (element) -> Bool in
            if let side = (element as! NSDictionary).valueForCaseInsensativeKey(forKey: "side") as? String{
                if isBuyTypeScreen == true{
                    if side.lowercased() == "buy"{
                        return true
                    }
                }else{
                    if side.lowercased() == "sell"{
                        return true
                    }
                }
            }
            return false
            
        }) as NSArray
        
        
        self.sortOpenOrders()
        updateContentSize()
        self.buySellTableView.reloadData()
    }
    
    private
    func sortOpenOrders(){
 
        let sortResult = self.openOrders.sorted { sortOp1, sortOp2 in
            if let ele1 = sortOp1 as? NSDictionary, let ele2 = sortOp2 as? NSDictionary{
                let time1 = ele1.valueForCaseInsensativeKey(forKey: "timestamp") as! String
                let time2 = ele2.valueForCaseInsensativeKey(forKey: "timestamp") as! String
                return self.getDate(dateInString: time1) > self.getDate(dateInString: time2)
            }
            return false
        }
        let uniqueArray : NSMutableArray = []
        
        for ele in sortResult{
            if let ele = ele as? NSDictionary , let id = ele.value(forKey: "order_id") as? Double{
                let isContains = uniqueArray.contains(where: { eleMent in
                    if let ele2 = eleMent as? NSDictionary , let id2 = ele2.value(forKey: "order_id") as? Double{
                        if id2 == id{
                            return true
                        }else{
                            return false
                        }
                    }
                    return false
                })
                
                if !isContains{
                    if (ele.value(forKey: "status") as? Bool) != true{
                        uniqueArray.addObjects(from: [ele])
                    }
                }
                
            }
            
            
        }

        
        self.openOrders = uniqueArray
        
    }
    
    private
    func removeOpenOrderFromExistingList(orderId: Double){
        let arr : NSMutableArray = .init(array: self.openOrders)
        
        let index = arr.first { ele in
            ((ele as! NSDictionary).value(forKey: "order_id") as! Double) == orderId
        }
        
        if index != nil {
            arr.remove(index!)
        }
        self.openOrders = arr
//        self.sortOpenOrders()
//        updateContentSize()
//        self.buySellTableView.reloadData()
    }
    
    
    private
    func addElementToOpenOrder(data: NSDictionary){
        let arr : NSMutableArray = .init(array: self.openOrders)
        

        arr.addObjects(from: [data])
        
        self.openOrders = arr
//        self.sortOpenOrders()
//        updateContentSize()
//        self.buySellTableView.reloadData()
    }
    
    private
    func getDate(dateInString:String)->Date{
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"  ///2022-02-16T07:55:43.61Z
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current // set locale to reliable US_POSIX
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from:dateInString)!
    }
    
    /// This will parse response for All order that we are showing
    func handleOpenOrderResponse(response:NSDictionary){
        if let data = response.value(forKey:"data") as? NSDictionary{
            if let orders = data.value(forKey: "Orders") as? NSArray{
                self.openOrders = orders
                updateContentSize()
                self.buySellTableView.reloadData()
             }
        }
    }
    
    func handleOrderBookData(response:NSArray){
        //        let tableViewHeight = self.decimalAmoutTableView.frame.size.height
     //   let oldArray  = NSMutableArray(array: openOrders)
//        self.openOrders = response
        
        
        let oldArray  = NSMutableArray(array: openOrders)
        //        let unqiueElements = Set(oldArray)

        let oldSequnce = oldArray.compactMap { str in str as? NSDictionary }
        let newSequence = response.compactMap { str in str as? NSDictionary }

        let oldSet = Set(oldSequnce)
        let newSet = Set(newSequence)

        let combinedSet = newSet.union(oldSet)

        openOrders = NSArray.init(array: Array(combinedSet))
//
//        openOrders = oldArray.addingObjects(from:orderArrayFormated(fromArray: response, type: type) as! [Any]) as NSArray
//        if cellType == "All"{
//            let oldArray  = NSMutableArray(array: openOrders)
//
//            openOrders = oldArray.addingObjects(from:orderArrayFormated(fromArray: response, type: type) as! [Any]) as NSArray//oldArray.addingObjects(from: orders as! [Any]) as NSArray
//        }else{
//            openOrders = orderArrayFormated(fromArray: response,type: cellType)
//        }
//        if openOrders.count == 0{
//            self.tableViewHeightConstriants.constant = 470
//        }else{
//            self.tableViewHeightConstriants.constant = tableViewDefaultHeight
//        }
          updateContentSize()
        self.buySellTableView.reloadData()
    }
    
    
    
    // MARK: - Button Actions
    
    /// Time in force dropdown
    @IBAction func timeInForceTapped(_ sender: Any) {
        self.view.endEditing(true)
        timeInForceDropdown.show()
    }
    
    /// This will toggle Screen Ui between Sell/Buy
    @objc func screenChangeAction(_ : Any)  {
        self.view.endEditing(true)
        if let tv = navigationBarRightButton.viewWithTag(1080){
            tv.removeFromSuperview()
        }
        triangleView = TriangleView.init(frame: CGRect.init(x:navigationBarRightButton.frame.origin.x + navigationBarRightButton.frame.size.width-30 , y: navigationBarRightButton.frame.origin.y + navigationBarRightButton.frame.size.height - 12, width:12, height: 12))
        triangleView.backgroundColor = UIColor.clear
        triangleView.isOpaque = false
        triangleView.tag = 1080
        
       
        UIView.animate(withDuration: 0.3) {
            self.navigationBarRightButton.addSubview(self.triangleView)
            self.navigationBarRightButton.bringSubviewToFront(self.triangleView)
            self.imageViewOnRightButton.transform = CGAffineTransform(rotationAngle: .pi)
        }
        changeScreenDropDown.show()
    }

    @IBAction func sellOrBuyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateTextFields() {
            _ = MDAlertPopupView.showAlertPopupViewOnWidnow(title: localised("appTitle"), errorMessage: localised("Are you sure you want to place this order?"), alertDelegate: self)
        }
    }
    
    //MARK: - Validation
    
    func validateTextFields() ->Bool {
        var result = false
        var message = ""
        let volumeT = self.getTextFromTextFieldOf(unitView: volumeView)
        let priceT = self.getTextFromTextFieldOf(unitView: priceView)
        let stopT = self.getTextFromTextFieldOf(unitView: stopView)
        if selectedDropDownValue == (localised("Stop Market")) ||  selectedDropDownValue == (localised("Trailing Stop Market")){
            
            if priceT != "" {
                if let price = Double(priceT),price > 0{
                    if volumeT != "" {
                        if let volume = Double(volumeT),volume > 0{
                            result = true
                        }else{
                            result = false
                            message = localised("Please enter valid volume")
                        }
                    }else {
                        result = false
                        message = localised("Please enter volume value")
                    }
                }else{
                    result = false
                    message = localised("Please enter valid price")
                }
            }else {
                result = false
                message = localised("Please enter price value")
            }
        }else if selectedDropDownValue == (localised("Stop")) {
            
            if stopT != "" {
                if let stop = Double(stopT),stop > 0{
                    if priceT != "" {
                        if let price = Double(priceT),price > 0{
                            if volumeT != "" {
                                if let volume = Double(volumeT),volume > 0{
                                    result = true
                                }else{
                                    result = false
                                    message = localised("Please enter valid volume")
                                }
                            }else {
                                result = false
                                message = localised("Please enter volume value")
                            }
                        }else{
                            result = false
                            message = localised("Please enter valid price")
                        }
                    }else {
                        result = false
                        message = localised("Please enter price value")
                    }
                }else {
                    result = false
                    message = localised("Please enter valid stop value")
                }
            }else {
                result = false
                message = localised("Please enter stop value")
            }
            
        }else if selectedDropDownValue == (localised("Limit")) {
            
            if priceT != "" {
                if let price = Double(priceT),price > 0{
                    if volumeT != "" {
                        if let volume = Double(volumeT),volume > 0{
                            result = true
                        }else{
                            result = false
                            message = localised("Please enter valid volume")
                        }
                    }else {
                        result = false
                        message = localised("Please enter volume value")
                    }
                }else{
                    result = false
                    message = localised("Please enter valid price")
                }
            }else {
                result = false
                message = localised("Please enter price value")
            }
            
        }
        else if selectedDropDownValue == localised("Market") {
           
                if volumeT != "" {
                    if let volume = Double(volumeT),volume > 0{
                        result = true
                    }else{
                        result = false
                        message = localised("Please enter valid volume")
                    }
                }else {
                    result = false
                    message = localised("Please enter volume value")
                }
           
            
        }
        
        if selectedDropDownValue == localised("Market") {
            //price
            let marketPrice = selectedCurrencyPairData!.value(forKey: "price") as? Double ?? 0.0
            if ((Double(volumeT) ?? 0.0) * marketPrice) < Double(self.minOrderValue ?? 0.0){
                result = false
                message = "Minimum order value is \(self.minOrderValue ?? 0.0)"
            }
        }else{
            if ((Double(volumeT) ?? 0.0) * (Double(priceT) ?? 0.0)) < Double(self.minOrderValue ?? 0.0){
                result = false
                message = "Minimum order value is \(self.minOrderValue ?? 0.0)"
            }
        }
        
        
        if message != "" {
            MDHelper.shared.showErrorAlert(message:message, viewController:self)
        }
        return result
    }
    
    //MARK: - Actions
    @IBAction func contentViewTapped(_ sender: Any) {
        self.view.endEditing(true)
        
    }
    
    func timeInForceDidChanged(item : String)  {
        if let textField = self.getTextFieldOf(unitView: timeInforceView) {
            textField.text = "  \(item)"
            let index = timeInforceOptions.firstIndex(where: {$0 == item})
            let timeInForceOptionsEng = ["Good till cancelled","Immediate or cancel","Fill or Kill","Day only"]
            if let index = index{
             timeInForceForServer = self.getAcronyms(stringInput: timeInForceOptionsEng[index])
            }
        }
    }
    
    //MARK:-Order Type changed
    func screenDidChanged(name : String)  {
        selectedTimeInForce = timeInforceOptions[0]
        timeInForceDidChanged(item : selectedTimeInForce)
        self.getTextFieldOf(unitView: timeInforceView)?.isHidden = !(name == localised("Limit") || name == localised("Trailing Stop Market"))
        if let volumeT = self.getTextFieldOf(unitView: volumeView){
            volumeT.text = ""
        }
        if let priceT = self.getTextFieldOf(unitView: priceView){
            priceT.text = ""
        }
        if let stopT = self.getTextFieldOf(unitView: stopView){
            stopT.text = ""
        }
        if let totalT = self.getTextFieldOf(unitView: totalView){
            totalT.text = "0.00"
        }
        self.priceView.isUserInteractionEnabled = true
        let currency2 = selectedCurrencyPairData?.value(forKey: "base") as! String
        let currency = selectedCurrencyPairData?.value(forKey: "quote") as! String
        if name == localised("Limit"){
            self.screenOrderType = .limit
            priceViewHeightConstant.constant = 40
            volumeViewHieghtConstant.constant = 40
            totalViewHeightConstant.constant = 40
            timeInForceHeightConstant.constant = 40
            stopViewHeightConstant.constant = 0
            setTextFieldTitleForView(title: localised("Price"), unitView: priceView)
            setTextFieldTitleForView(title: localised("Total"), unitView: totalView)
            setTextFieldTitleForView(title: localised("Volume"), unitView: volumeView)
            setTextFieldTitleForView(title: localised("Time in Force"), unitView: timeInforceView)
            setCurrencyUnitForView(currency: currency, unitView: priceView)
            setCurrencyUnitForView(currency: currency2, unitView: volumeView)
            setCurrencyUnitForView(currency: currency, unitView: totalView)
            
            timeInForceDropdown.dataSource = timeInforceOptions
            timeInForceDropdown.reloadAllComponents()
            timeInForceDidChanged(item: timeInforceOptions.first!)

            if let textField = self.getTextFieldOf(unitView: priceView){
                textField.placeholder = String(format: "%.\(self.decimalPricisonPrice)f", 0)
            }

            if let textField = self.getTextFieldOf(unitView: volumeView){
                textField.placeholder = String(format: "%.\(self.decimalPricisionVolume)f", 0)
            }
            
            if let textField = self.getTextFieldOf(unitView: totalView){
                textField.placeholder = String(format: "%.8f", 0)
            }
            
        }else if name == localised("Market"){
            self.screenOrderType = .market
            self.priceView.isUserInteractionEnabled = false
            priceViewHeightConstant.constant = 40
            volumeViewHieghtConstant.constant = 40
            totalViewHeightConstant.constant = 0
            timeInForceHeightConstant.constant = 0
            stopViewHeightConstant.constant = 0
            
            setTextFieldTitleForView(title: localised("Price"), unitView: priceView)
            setTextFieldTitleForView(title: localised("Volume"), unitView: volumeView)
            setCurrencyUnitForView(currency: currency, unitView: priceView)
            setCurrencyUnitForView(currency: currency2, unitView: volumeView)
            if let textField = self.getTextFieldOf(unitView: priceView){
                textField.text = localised("Market Price")
            }
            
        }else if name == localised("Stop"){
            self.screenOrderType = .stop
            stopViewHeightConstant.constant = 40
            priceViewHeightConstant.constant = 40
            volumeViewHieghtConstant.constant = 40
            totalViewHeightConstant.constant = 40
            timeInForceHeightConstant.constant = 0
            setTextFieldTitleForView(title: "   "+localised("Price"), unitView: priceView)
            setTextFieldTitleForView(title: localised("Volume"), unitView: volumeView)
            setTextFieldTitleForView(title: localised("Total"), unitView: totalView)
            setTextFieldTitleForView(title: localised("Stop"), unitView: stopView)
            
            setCurrencyUnitForView(currency: currency, unitView: priceView)
            setCurrencyUnitForView(currency: currency2, unitView: volumeView)
            setCurrencyUnitForView(currency: currency, unitView: totalView)
            setCurrencyUnitForView(currency: currency, unitView: stopView)
            if let textField = self.getTextFieldOf(unitView: priceView){
                textField.placeholder = "0.00"
            }

        }else if name == localised("Stop Market"){
            self.screenOrderType = .stopMarket
            priceViewHeightConstant.constant = 40
            volumeViewHieghtConstant.constant = 40
            totalViewHeightConstant.constant = 0
            timeInForceHeightConstant.constant = 0
            stopViewHeightConstant.constant = 0
            
            setTextFieldTitleForView(title: localised("Price"), unitView: priceView)
            setTextFieldTitleForView(title: localised("Volume"), unitView: volumeView)
            setCurrencyUnitForView(currency: currency, unitView: priceView)
            setCurrencyUnitForView(currency: currency2, unitView: volumeView)
            
        }else if name == localised("Trailing Stop Market"){
            self.screenOrderType = .trailingStopMarket
            priceViewHeightConstant.constant = 40
            volumeViewHieghtConstant.constant = 40
            totalViewHeightConstant.constant = 0
            timeInForceHeightConstant.constant = 40
            stopViewHeightConstant.constant = 0
            
            setTextFieldTitleForView(title: localised("Trail"), unitView: priceView)
            setTextFieldTitleForView(title: localised("Amount"), unitView: volumeView)
            
            setCurrencyUnitForView(currency: currency, unitView: priceView)
            setCurrencyUnitForView(currency: currency2, unitView: volumeView)
            
            setTextFieldTitleForView(title: localised("Trail Value"), unitView: timeInforceView)
            if let textField = self.getTextFieldOf(unitView: timeInforceView){
                timeInForceDropdown.dataSource = trailValue
                timeInForceDropdown.reloadAllComponents()
                timeInForceDidChanged(item: trailValue.first!)
                
            }

        }else{
            print("None")
        }
            if let button = self.getTitleButtonForView(unitView: priceView){
                if button is MDButtonPrice {
                    let buttonWithImage = button as! MDButtonPrice
                    switch name{
                    case localised("Stop") , localised("Stop Market") , localised("Trailing Stop Market"):
                        buttonWithImage.setImage(nil, for: .normal)
                        buttonWithImage.contentSpacing = 0
                        buttonWithImage.contentHorizontalAlignment = .center
                        buttonWithImage.refreshButton()
                        button.imageView?.image = nil
                        button.layoutIfNeeded()
                        button.layoutSubviews()
                        buttonWithImage.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                    default:
                        buttonWithImage.setImage(UIImage.init(named: "Rectangle"), for: .normal)
                        buttonWithImage.contentSpacing = 10
                        buttonWithImage.contentHorizontalAlignment = .center
                        buttonWithImage.refreshButton()
                    }
                    
                    
                    buttonWithImage.addTargetClosure { (mybutton) in
                        if !name.contains(localised("Stop")) {
                            switch name {
                            case localised("Limit"):
                                self.view.endEditing(true)
                                self.priceDropdown.show()
                                print("button clicked")
                            default:
                                break
                            }
                          
                        }
                    }
                }
            }
    }
    
    //MARK: - Getter setter helpers for data
    func getTextFieldOf(unitView:UIView) ->UITextField? {
        let myUnitView = unitView.subviews[0]
     
        let subViews = myUnitView.subviews.filter { (view) -> Bool in
            return view is UITextField
        }
        
        if  let textField = subViews.first as? UITextField{
            return textField
        }
        return nil
    }
    
    func getPlaceOrderData(marketName :String) ->  (priceOrLimit:String,volume:String,stop:String,total:String){
       
        let volume = self.getTextFromTextFieldOf(unitView: volumeView)
        let stop = self.getTextFromTextFieldOf(unitView: stopView)
        let price = self.getTextFromTextFieldOf(unitView: priceView)
        let total = self.getTextFromTextFieldOf(unitView: totalView)
        
        var filteredVol = volume
        
        let volumeArray = volume.split(separator: ".")
        if volumeArray.count > 1 {
            if let afterDecimal = volumeArray[1] as? NSString{
                
                if let afterDecimalArray = "\(afterDecimal)".map( { String($0) }) as? [String]{
                    
                    //filteredVol = afterDecimalArray.joined(separator:"")
                    var finalDecimals = afterDecimalArray
                    
                    if afterDecimalArray.indices.contains(self.maxDecimalsAllowed){
                        
                        filteredVol = ""
                        finalDecimals = [String]()
                        
                        for i in 0..<self.maxDecimalsAllowed{
                            finalDecimals.append("\(afterDecimalArray[i])")
                        }
                    }
                    
                    filteredVol = String(volume.split(separator: ".").first ?? "") + "." + finalDecimals.joined(separator:"")
                    
                }
            }
        }
        
        
        
        return (priceOrLimit:price,volume:filteredVol,stop:stop,total:total)
    }
    
    func getTextFromTextFieldOf(unitView:UIView) ->String {
        let myUnitView = unitView.subviews[0]
        var text = ""
        let subViews = myUnitView.subviews.filter { (view) -> Bool in
            return view is UITextField
        }
        
        if  let textField = subViews.first as? UITextField{
            text = textField.text!
        }
        return text
    }
    
    func setCurrencyUnitForView(currency:String,unitView:UIView)  {
        let myUnitView = unitView.subviews[0]
        
        let subViews = myUnitView.subviews.filter { (view) -> Bool in
            return view.tag == ScreenTypeTextFieldTags.currency
        }
        
        if let currencyButton = subViews.first as? UIButton{
            currencyButton.setTitle(currency, for: .normal)
            currencyButton.backgroundColor = MDAppearance.Colors.buttonBGColorBuySell
        }
        
    }
    
    func showPercentageView() {
        let unitView = self.priceView
        if let myUnitView = unitView?.subviews[0]{
            
            let subViews = myUnitView.subviews.filter { (view) -> Bool in
                return view.tag == ScreenTypeTextFieldTags.currency
            }
            
            if let currencyButton = subViews.first as? UIButton{
                currencyButton.setTitle("%", for: .normal)
            }
        }
    }
    
    func getTitleButtonForView(unitView:UIView) -> UIButton? {
        let myUnitView = unitView.subviews[0]
        
        let subViews = myUnitView.subviews.filter { (view) -> Bool in
            return view.tag == ScreenTypeTextFieldTags.title
        }
        return subViews.first as? UIButton
    }
    
    func setTextFieldTitleForView(title:String,unitView:UIView)  {
        let myUnitView = unitView.subviews[0]
        
        let subViews = myUnitView.subviews.filter { (view) -> Bool in
            return view.tag == ScreenTypeTextFieldTags.title
        }
        
        if  let currencyButton = subViews.first as? UIButton{
            currencyButton.setTitle(title, for: .normal)
            currencyButton.backgroundColor = MDAppearance.Colors.buttonBGColorBuySell
            
        }
    }
    
    func getMarketType(forString : String)->String{
        if forString.contains(localised("Trailing Stop Market")){
            return "TRAILINGSTOPMARKET"
        }else if forString.contains(localised("Stop Market")){
            return "STOPMARKET"
        }else if forString.contains(localised("Stop")) {
            return "STOPLIMIT"
        }else if forString.contains(localised("Limit")) {
            return "LIMIT"
        }
        return "MARKET"
    }
    
    
    //MARK: - Screen toggler helpers
    /// This will toggle screen between and Sell/Buys
    func toggleBuySell()  {
        if isBuyTypeScreen {
            sellButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            buyButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            sellOrBuyButton.backgroundColor = Theme.current.secondaryColor
            sellOrBuyButton.setTitle(localised("BUY"), for: .normal)
            sellOrBuyOrdersLabels.text = localised("Buy Orders")
            allOrdersButton.setTitle(localised("All Buy Orders"), for: .normal)
            myOrdersButton.setTitle(localised("My Buy Orders"), for: .normal)
            //  cellType = "Buy"
        }else {
            buyButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            sellButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            
            sellOrBuyButton.backgroundColor = Theme.current.primaryColor
            sellOrBuyButton.setTitle(localised("SELL"), for: .normal)
            sellOrBuyOrdersLabels.text = localised("Sell Orders")
            allOrdersButton.setTitle(localised("All Sell Orders"), for: .normal)
            myOrdersButton.setTitle(localised("My Sell Orders"), for: .normal)
            //  cellType = "Sell"
        }
        toggleAllMyOrders()
        updateContentSize()
        getbalaceInfo()
        self.buySellTableView.reloadData()
    }
    
    /// We can toggle from allOrders to My orders and vice versa
    func toggleAllMyOrders()  {
        self.resetTextField()
        if isAllOrders {
            myOrdersButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            allOrdersButton.setTitleColor(Theme.current.primaryColor, for: .normal)
            self.fetchAllOrders(type: isBuyTypeScreen ? "Buy" : "Sell", currency: selectedCurrency)
        }else {
            allOrdersButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
            myOrdersButton.setTitleColor(Theme.current.primaryColor, for: .normal)
             self.fetchMyOrders(type: isBuyTypeScreen ? "Buy" : "Sell", currency: selectedCurrency)
        }
        setHighLowData()
        updateContentSize()
    }
    
    func resetTextField(){
        self.getTextFieldOf(unitView: self.volumeView)?.text = ""
        if self.screenOrderType != .market{
            self.getTextFieldOf(unitView: self.priceView)?.text = ""
        }
        self.totalTextField.text = "0.00"
    }
    
    //MARK: - Button Action
    @IBAction func allOrderButtonAction(_ sender: Any) {
        if isAllOrders == false {
            isAllOrders = true
            toggleAllMyOrders()
        }
    }
    
    @IBAction func myOrderButtonAction(_ sender: Any) {
         if isAllOrders == true {
            isAllOrders = false
            toggleAllMyOrders()
        }
    }
    
    @IBAction func buyButtonAction(_ sender: Any) {
        if isBuyTypeScreen == false {
            if let view = self.percentageBarView.subviews.first! as? MDPercentageSeekBarView{
                view.screenChanged()
            }
            isBuyTypeScreen = true
            toggleBuySell()
        }
    }
    
    @IBAction func sellButtonAction(_ sender: Any) {
        if isBuyTypeScreen == true {
            if let view = self.percentageBarView.subviews.first! as? MDPercentageSeekBarView{
                view.screenChanged()
            }
            isBuyTypeScreen = false
            toggleBuySell()
        }
    }
    
    //MARK:- navigation dropdown
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
            dropDownVC.marketType = navigationTitle.components(separatedBy: "/").last ?? ""
            var topSafeArea: CGFloat
            if #available(iOS 11.0, *) {
                topSafeArea = view.safeAreaInsets.top
            } else {
                topSafeArea = topLayoutGuide.length
            }
            bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
            bottomSheet?.delegate = self
            
            
            if UIApplication.shared.statusBarOrientation.isLandscape{
                bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: self.view.frame.size.height -  topSafeArea)
            }else{
                
                bottomSheet?.preferredContentSize = CGSize(width: self.view.frame.width + 2, height: self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! -  topSafeArea)
            }
            

            present(bottomSheet!, animated: true, completion: nil)
        }

    }
    
    func refreshDataWithChoosenCurrency(selectedCurrencyData:NSDictionary){
        
        //        let filteredVC = self.navigationController?.viewControllers.filter({ (viewController) -> Bool in
        //            viewController is MarketListVC
        //        })
        
        //        if let marketListVC = filteredVC?.first as? MarketListVC{
        if #available(iOS 13.0, *) {
            SocketHelper.shared.unsubscribeToSpecificEvents()
        } else {
            // Fallback on earlier versions
        }
        self.selectedCurrencyPairData = selectedCurrencyData
        self.selectedCurrency = selectedCurrencyPairData?.value(forKey: "base") as! String
        let marketType = selectedCurrencyPairData?.value(forKey: "quote") as! String
        self.navigationTitle = "\(selectedCurrency)/\(marketType)"
        MDSignalRManager.shared.joinGroups(marketType: marketType, currency: selectedCurrency)
        if #available(iOS 13.0, *) {
            SocketHelper.shared.delegate = self
            
            SocketHelper.shared.subscribeToSpecificEvents(coin: self.selectedCurrency + "_" + marketType)
            
            
        } else {
            // Fallback on earlier versions
        }
            
            setNavigationbar()
            setUpColors()
            setupDrowDown()
            toggleBuySell()
            toggleAllMyOrders()
            screenDidChanged(name: selectedDropDownValue)
            setHighLowData()
            getbalaceInfo()
            self.bottomSheet = nil
        
        }
    
    private func resetPercentageBar(){
        let view = self.percentageBarView.subviews.first! as! MDPercentageSeekBarView
        view.didChangedTotalTFManually(value: 0.0)
    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
         let view = self.percentageBarView.subviews.first! as! MDPercentageSeekBarView
             if let totalTextField = self.getTextFieldOf(unitView: self.totalView),
                 let volume = Double(self.getTextFromTextFieldOf(unitView: self.volumeView)),
                 let price = Double(self.getTextFromTextFieldOf(unitView: self.priceView)){
                 let total : Double = volume * price
                 
                 if self.isBuyTypeScreen{
                     let percentage : Double = (100 * total) / self.availableBalance
                     //if self.screenOrderType == .limit{
                     if textField == self.totalTextField{
                         print("Total text Field is Edited")
                         
                         return
                         
                     }else{
                         totalTextField.text = String(format: "%.7f", volume*price)
                         view.didChangedTotalTFManually(value: percentage)
                     }
                 }else{
                     let percentage = (volume / self.availableBalance) * 100
                     view.didChangedTotalTFManually(value: percentage)
                 }
                 return
             }
         if self.screenOrderType == .market{
             let volume : Double = Double(textField.text!) ?? 0.0
             if self.isBuyTypeScreen{
                 let total : Double = volume * self.marketValue
                 let percentage : Double = (100 * total) / self.availableBalance
                 print("total \(total) bal\(self.availableBalance) per \(percentage)")
                 view.didChangedTotalTFManually(value: percentage)
               }else{
                 let percentage = (volume / self.availableBalance) * 100
                 view.didChangedTotalTFManually(value: percentage)
             }
         }else{
             if !self.isBuyTypeScreen{
                 let volume : Double = Double(textField.text!) ?? 0.0
                 let percentage = (volume / self.availableBalance) * 100
                 view.didChangedTotalTFManually(value: percentage)
                 
             }
             
         }
     }
    }
    */
  //MARK: ---- TextField Delegate ----
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ".",(textField.text?.contains("."))!{
            return false
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            let view = self.percentageBarView.subviews.first! as! MDPercentageSeekBarView
            if (self.screenOrderType == .trailingStopMarket || self.screenOrderType == .stopMarket) && self.isBuyTypeScreen{
                view.didChangedTotalTFManually(value: 0) 
                return
            }

            if let totalTextField = self.getTextFieldOf(unitView: self.totalView),
               let volume = Double(self.getTextFromTextFieldOf(unitView: self.volumeView)),
               let price = Double(self.getTextFromTextFieldOf(unitView: self.priceView)){
                let total : Double = volume * price
                if textField != self.totalTextField{
                    totalTextField.text = String(format: "%.7f", volume*price)
                }
                if self.isBuyTypeScreen{
                    let percentage : Double = (100 * total) / self.availableBalance
                    if textField == self.totalTextField{
                        return
                    }else{
                        
                        totalTextField.text = String(format: "%.7f", volume*price)
                        view.didChangedTotalTFManually(value: percentage)
                    }
                }else{
                    let percentage = (volume / self.availableBalance) * 100
                    view.didChangedTotalTFManually(value: percentage)
                }
                return
            }
            if self.screenOrderType == .market{
                let volume : Double = Double(textField.text!) ?? 0.0
                if self.isBuyTypeScreen{
                    let total : Double = volume * self.marketValue
                    let percentage : Double = (100 * total) / self.availableBalance
                    print("total \(total) bal\(self.availableBalance) per \(percentage)")
                    view.didChangedTotalTFManually(value: percentage)
                }else{
                    let percentage = (volume / self.availableBalance) * 100
                    view.didChangedTotalTFManually(value: percentage)
                }
            }else{
                if !self.isBuyTypeScreen{
                    let volume : Double = Double(self.getTextFromTextFieldOf(unitView: self.volumeView)) ?? 0.0
                    let percentage = (volume / self.availableBalance) * 100
                    view.didChangedTotalTFManually(value: percentage)
                }
            }
        }
        
        let numberOfDecimalDigits : Int
        switch textField{
        case self.priceOrLimitTextField:
            numberOfDecimalDigits = self.decimalPricisonPrice
        case self.volumeTextField:
            numberOfDecimalDigits = self.decimalPricisionVolume
        case self.stopPriceTextField:
            numberOfDecimalDigits = self.decimalPricisonPrice
        case self.totalTextField:
            numberOfDecimalDigits = 0
            if self.isTextFieldJustBegin {
                self.isTextFieldJustBegin = false
                if let subString = totalTextField.text?.split(separator: ".").first{
                    self.totalTextField.text = String(subString)
                    self.didChangedTotalTextField()
                    return false
                }else{
                    return true
                }
            }else{
                self.didChangedTotalTextField()
            }
        default:
            numberOfDecimalDigits = 0
        }
        
        return validateDecimalPrecision(textField: textField, string: string , range: range , numberOfDigits: numberOfDecimalDigits)
        //return true
    }
    
    private
    func didChangedTotalTextField(){
        /// only For limit
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            let totalValue : Double = Double.init(self.totalTextField.text!) ?? 0.0
            print(totalValue)
            print("Needs to perform reverse calculation \(totalValue)")
            if let price = Double(self.getTextFromTextFieldOf(unitView: self.priceView)) {
                let volAmt : Double
                if let volumeTF = self.getTextFieldOf(unitView: self.volumeView){
                    if price == 0{
                        volumeTF.text = ""
                        return
                    }else{
                        volAmt = totalValue / price
                    }
                    volumeTF.text = String(format: "%.\(self.decimalPricisionVolume)f", volAmt)
                    let view = self.percentageBarView.subviews.first! as! MDPercentageSeekBarView
                    if self.isBuyTypeScreen{
                        view.didChangedTotalTFManually(value: totalValue / self.availableBalance * 100)
                    }else{
                        view.didChangedTotalTFManually(value: volAmt / self.availableBalance * 100)
                    }
                }
            }
        }
    }
    
    
    private
    func validateDecimalPrecision(textField : UITextField ,string : String , range : NSRange , numberOfDigits:Int) -> Bool{
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        if numberOfDigits == 0 {
            if string == "."{
                return false
            }
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= numberOfDigits
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let timeInForce = self.getTextFieldOf(unitView: timeInforceView){
            if timeInForce == textField {
                self.view.endEditing(true)
                timeInForceDropdown.show()
                return false
            }
        }
        
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
            //textField.text = "\(firstText!).\(secoundText!)"
        }
        
        
        if let totalTextField = self.getTextFieldOf(unitView: totalView){
            if let volume = Double(self.getTextFromTextFieldOf(unitView: volumeView)),let price = Double(self.getTextFromTextFieldOf(unitView: priceView)){
                //totalTextField.text = String(format: "%.7f", volume*price)
            }
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Text Did begin")
        self.isTextFieldJustBegin = true
    }
    
    //MARK:- dropdown
    func dropDownSelected(title: String, data: NSDictionary) {
        self.openOrders = []
        refreshDataWithChoosenCurrency(selectedCurrencyData: data)
    }
}
 
 
 //MARK: - Bottom Sheet Delegates
 
 extension MDBuySellVC : MDCBottomSheetControllerDelegate {
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        print(controller)
        self.bottomSheet = nil
    }
    
 }
 
 
extension MDBuySellVC:signalRDataDelegates{
    func marketSummeryDataReceived(response: NSArray) {
        
    }
    func orderBookBuyDataReceived(response: NSArray) {
        DispatchQueue.main.async {
            MDHelper.shared.hideHudOnWindow()
            self.setHighLowData()
            if self.isBuyTypeScreen == true && self.isAllOrders == true{
                
                var mutableArray = NSMutableArray()
                  for eachData in response{
                      if let innerArray = eachData as? NSArray{
                          let price = innerArray[0]
                          let volume = innerArray[1]
                          let type = innerArray[2]
                          mutableArray.add(["rate":price,"volume":volume,"execution_side":type])
                          
                          
                      }
                  }
                  self.openOrders = mutableArray as NSArray
                
                //self.openOrders = (Array(response.prefix(10))) as NSArray
                self.updateContentSize()
                self.buySellTableView.reloadData()
    //            handleOrderBookData(response:(Array(response.prefix(10))).reversed() as NSArray)
            }
        }
        
    }
    
    func orderBookSellyDataReceived(response: NSArray) {
        setHighLowData()
            MDHelper.shared.hideHudOnWindow()
        if isBuyTypeScreen == false && isAllOrders == true{
            
            var mutableArray = NSMutableArray()
             for eachData in response{
                 if let innerArray = eachData as? NSArray{
                     let price = innerArray[0]
                     let volume = innerArray[1]
                     let type = innerArray[2]
                     mutableArray.add(["rate":price,"volume":volume,"execution_side":type])
                     
                     
                 }
             }
             self.openOrders = mutableArray as NSArray
            
//            openOrders = (Array(response.prefix(10))) as NSArray
            updateContentSize()
            self.buySellTableView.reloadData()
//            handleOrderBookData(response:(Array(response.prefix(10))).reversed() as NSArray)
        }
    }
    
    func orderBookSellDataUpdatesReceived(response: NSArray) {
        MDHelper.shared.hideHudOnWindow()
        setHighLowData()
        if isBuyTypeScreen == true && isAllOrders == true{
//            openOrders = (Array(response.prefix(10))) as NSArray
//            updateContentSize()
//            self.buySellTableView.reloadData()
                        handleOrderBookData(response:(Array(response.prefix(10))).reversed() as NSArray)
        }
    }
    func orderBookBuyDataUpdatesReceived(response: NSArray) {
        setHighLowData()
        MDHelper.shared.hideHudOnWindow()
        if isBuyTypeScreen == false && isAllOrders == true{
//            openOrders = (Array(response.prefix(10))) as NSArray
//            updateContentSize()
//            self.buySellTableView.reloadData()
                        handleOrderBookData(response:(Array(response.prefix(10))).reversed() as NSArray)
        }
    }
    
    func pendingOrdersReceived(response: NSArray) {
        //New Pending Order Received
        DispatchQueue.main.async {
            if self.isAllOrders == false{
                self.handleMyOrderResponse(pendingOrder: response)
               }
        }
       
    }
    
    func tradeHistoryDataReceived(response: NSArray) {
        print("trade order history response")
    }
    
    func chartDataReceived(response: NSArray) {
        print("chart data received")
    }
}
 //MARK:-Alert Delegate
 extension MDBuySellVC:alertPopupDelegate{
    func alertPopupResponse(isAgree: Bool) {
        if isAgree == true {
            placeOrder()
        }
    }
 }
 
 extension MDBuySellVC: MDPercentageBarDelegate{
    func didBeginPercentageBarEditing() {
        self.scrollView.isScrollEnabled = false
    }
    
    func didEndPercentageBarEditing() {
        self.scrollView.isScrollEnabled = true
    }
    
    func didMovedPercentageBar(percentage: Int) {
        switch self.screenOrderType {
        case .limit , .stop:
            if let totalTextField = self.getTextFieldOf(unitView: self.totalView) ,
                let volumeTF = self.getTextFieldOf(unitView: self.volumeView){
                let priceTF = self.getTextFieldOf(unitView: self.priceView)
                let price : Double = Double(priceTF!.text!) ?? 0.0
                let total = ((Double(percentage)/100.00) * self.availableBalance)
                if self.isBuyTypeScreen{
                    totalTextField.text = String(format: "%.7f", total)
                    if price > 0{
                        volumeTF.text = String(format: "%.\(self.decimalPricisionVolume)f", total / price)
                    }else{
                        volumeTF.text = String(format: "%.\(self.decimalPricisionVolume)f", 0)
                    }
                }else{
                    volumeTF.text = String(format: "%.\(self.decimalPricisionVolume)f", total)
                    totalTextField.text = String(format: "%.7f", total * price)
                }
            }
            
        case .market:
             if let volumeTF = self.getTextFieldOf(unitView: self.volumeView){
                let total = ((Double(percentage)/100.00) * self.availableBalance)
                if self.isBuyTypeScreen{
                    if self.marketValue > 0{
                        volumeTF.text = String(format: "%.\(self.decimalPricisionVolume)f", total / self.marketValue)
                    }
                }else{
                    volumeTF.text = String(format: "%.\(self.decimalPricisionVolume)f", total)
                }
            }
            
        case .trailingStopMarket , .stopMarket:
            if let volumeTF = self.getTextFieldOf(unitView: self.volumeView){
                if !self.isBuyTypeScreen{
                    let total = ((Double(percentage)/100.00) * self.availableBalance)
                    //let total = 0
                    volumeTF.text = String(format: "%.\(self.decimalPricisionVolume)f", total)
                }else{
                    //let total = ((Double(percentage)/100.00) * self.availableBalance)
                    let total = 0
                    volumeTF.text = String(format: "%.\(self.decimalPricisionVolume)f", total)
                }
            }
            
        default : break
        }
    }
 }

 class TriangleView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        
        context.setFillColor(Theme.current.dropDownBgColor.cgColor)
        context.fillPath()
    }
 }
//
//{"method":"stream","event":"PO.ALL","data":[{"order_id":2434492243,"user_id":812347,"base":"LTC","quote":"USDT","rate":2.00000000,"volume":5.50000000,"pending":5.50000000,"type":"LIMIT","tif":"GTC","side":"BUY","stop_price":0.00000000,"timestamp":"2022-06-16T11:01:23.4574256Z","status":false},{"order_id":2431797278,"user_id":812347,"base":"LTC","quote":"USDT","rate":2.00000000,"volume":5.50000000,"pending":5.50000000,"type":"LIMIT","tif":"GTC","side":"BUY","stop_price":0.00000000,"timestamp":"2022-06-15T12:14:50.133Z","status":false},{"order_id":2431676956,"user_id":812347,"base":"LTC","quote":"USDT","rate":20.00000000,"volume":0.50000000,"pending":0.50000000,"type":"LIMIT","tif":"GTC","side":"BUY","stop_price":0.00000000,"timestamp":"2022-06-15T11:25:50.203Z","status":false},{"order_id":1968106032,"user_id":812347,"base":"ETH","quote":"USDT","rate":3.00000000,"volume":8.00000000,"pending":6.75120000,"type":"LIMIT","tif":"GTC","side":"BUY","stop_price":0.00000000,"timestamp":"2022-02-16T07:55:43.61Z","status":false},{"order_id":1818176400,"user_id":812347,"base":"ETH","quote":"USDT","rate":2.00000000,"volume":8.00000000,"pending":8.00000000,"type":"LIMIT","tif":"GTC","side":"BUY","stop_price":0.00000000,"timestamp":"2022-01-13T10:47:56.133Z","status":false}]}    1655377347.3877761
//
//struct MDOpenOrdersModel {
//    let order_id
//    let user_id
//    let
//
//    {"order_id":2434492243,"user_id":812347,"base":"LTC","quote":"USDT","rate":2.00000000,"volume":5.50000000,"pending":5.50000000,"type":"LIMIT","tif":"GTC","side":"BUY","stop_price":0.00000000,"timestamp":"2022-06-16T11:01:23.4574256Z","status":false}
//}


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
