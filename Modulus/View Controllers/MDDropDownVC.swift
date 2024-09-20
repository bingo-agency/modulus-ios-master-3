//
//  MDDropDownVC.swift
//  Modulus
//
//  Created by Pathik  on 25/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import MaterialComponents.MDCTabBar
import IQKeyboardManagerSwift
//import flagKit
protocol customDropDownDelegates {
    func dropDownSelected(title:String,data:NSDictionary)
}

enum dropDownType {
    case currencyPairsList
    case currencyList
    case countryCode
    case orderHistoryOptionList
    case none
}

class MDDropDownVC: UIViewController {
    //MARK: - StoryBoard outlets
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var yourChoiceLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarHeightConstraintLandScape: NSLayoutConstraint!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBar: MDCTabBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var yourChoiceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var selectedCurrencyBgView: UIView!
    @IBOutlet weak var shadowImageView: UIImageView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButtonBottomView: UIView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    var marketType = ""
    var selectedCurrency = ""
    var selectedPair = ""
    var tempSelectedPair = ""
    var selectedCountry = ""
    var selectedIndex:Int?
    var initialSelectedIndex:Int = 0
    var delegate:customDropDownDelegates?
    var type:dropDownType = dropDownType.currencyPairsList
    var data:NSMutableArray = NSMutableArray()
    var unfilteredData:NSMutableArray  = NSMutableArray()
    var unfilteredCurrencyData:NSMutableArray = NSMutableArray()
    var marketSummary:NSMutableArray = NSMutableArray()
    var searchBarPlaceHolder = localised("Search Coin")
    var selectedTab = ""
    var initialViewHeight = CGFloat(0)
    var navigationTitle = ""
    var tabs  = ["★  " + localised("Favorites"),"BTC","ETH","ETC","BCH","LTC","ZEC","DASH","XMR","XRP","BTG"]
    
    //MARK: - Constants
    @objc let appDel = UIApplication.shared.delegate as! AppDelegate
    let flags = Flag.all
    let tabBarHeight = CGFloat(56)
    let yourChoiceHeght = CGFloat(34)
    let currencyPairCell = "dropDownCell"
    var alreadySelectedIndex : Int = 0
    
    //MARK: - Automation Identifiers
    func addAutomationIdentifiers(){
        
        // For Automation
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityLabel = "dropDownSearchBar"
        searchBar.accessibilityIdentifier = "dropDownSearchBar"
        
        confirmButton.accessibilityLabel = "confirmButton"
        confirmButton.accessibilityIdentifier = "confirmButton"
    }
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        var tabsArray : [String] = [tabs[0]]
        tabsArray.append(contentsOf: appDel.listOfMarket as! [String])
        self.tabs = tabsArray
        setUpTabBar()
        setUpColors()
        addAutomationIdentifiers()
        // Do any additional setup after loading the view.
        if self.type == .orderHistoryOptionList{
            searchBar.isHidden = true
            searchBarHeightConstraint.constant = 0
        }else{
        searchBar.placeholder = searchBarPlaceHolder
        }
        confirmButton.setTitle(localised("CONFIRM"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.favHasChangedMannuallyFromDropDown),
                                               name: .init(rawValue: "fav_change_from_drop_down"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpInitialData()
        setUpFrames()
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        if self.tabBarController != nil{
            self.tabBarController?.tabBar.isHidden = true
            self.edgesForExtendedLayout = UIRectEdge.bottom
            self.view.cornerRadiusV = 0
            setNavigationbar()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        initialViewHeight = self.view.frame.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        setUpFrames()
        
//        if UIDevice.current.orientation.isLandscape{
        
            
//            if type == dropDownType.currencyPairsList{
//                tabBarHeightConstraint.constant = tabBarHeight
//                yourChoiceLabelHeightConstraint.constant = yourChoiceHeght
//                yourChoiceLabel.isHidden = false
//            }else{
//                tabBarHeightConstraint.constant = 0
//                yourChoiceLabelHeightConstraint.constant = 0
//                yourChoiceLabel.isHidden = true
//
//            }
            
            
            
            
            
            
//        }else{
//
//
//
//            if type == dropDownType.currencyPairsList{
//                tabBarHeightConstraint.constant = tabBarHeight
//                yourChoiceLabelHeightConstraint.constant = yourChoiceHeght
//                yourChoiceLabel.isHidden = false
//            }else{
//                tabBarHeightConstraint.constant = 0
//                yourChoiceLabelHeightConstraint.constant = 0
//                yourChoiceLabel.isHidden = true
//
//            }
//
//
//
//        }
//
        
        
        
        
        
        
        
        
    }
    
    
    //MARK: - navigation bar helper
    func setNavigationbar(){
        //For Automation
        self.navigationItem.backBarButtonItem?.isAccessibilityElement = true
        self.navigationItem.backBarButtonItem?.accessibilityIdentifier = "NavigationBackButton"
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "NavigationBackButton"
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = navigationTitle
        self.navigationItem.titleView = label
    }
    
    
    
    
    
    
    
    
    
    //MARK: -  Touch Delegates
    /// Dismiss presented keyboard if you click anywhere outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Initial Data
    func setUpInitialData(){
        if type == .currencyPairsList{
            tabBar.selectedItem = tabBar.items[1]
            for  tab in self.tabBar.items{
                let title = (tab.title)!
                if title.lowercased() == marketType.lowercased() {
                    tabBar.selectedItem = tab
                    break
                }
            }

            unfilteredData = marketSummary
            data = getFilteredDataforSelectedTab().mutableCopy() as! NSMutableArray
            for (index,key) in data.enumerated(){
                let cellData = key as! NSDictionary
                let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
                if cellData.valueForCaseInsensativeKey(forKey: "base") as! String == selectedCurrency && marketType == cellData.valueForCaseInsensativeKey(forKey: "quote") as! String{
                    confirmButton.isUserInteractionEnabled = false
                    confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    mutatedDict.setValue(true, forKey: "selected")
                }
                data.replaceObject(at: index, with: mutatedDict)
            }
            tableView.reloadData()
            yourChoiceLabel.text = localised("Your choice")+": \(selectedCurrency)"
        }else if type == .currencyList{
            unfilteredCurrencyData = data
            for (index,key) in data.enumerated(){
                let cellData = key as! NSDictionary
                let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
                

                    if cellData.valueForCaseInsensativeKey(forKey: "currency") as! String == selectedPair{
                        confirmButton.isUserInteractionEnabled = false
                        confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                        mutatedDict.setValue(true, forKey: "selected")
                    }
                data.replaceObject(at: index, with: mutatedDict)
            }
        }else if type == .countryCode{
            //let flagWithDetails = NSMutableArray()
            var flagsArray : [NSDictionary] = []
            for flag in flags{
                let dict = NSMutableDictionary(dictionary: ["data":flag,"selected":false])
                //flagWithDetails.add(dict)
                flagsArray.append(dict)
            }
            let sortedArray = flagsArray.sorted { (item1, item2) -> Bool in
                let flagObject1 = item1.valueForCaseInsensativeKey(forKey: "data") as! Flag
                let flagObject2 = item2.valueForCaseInsensativeKey(forKey: "data") as! Flag
                return flagObject1.localizedName.compare(flagObject2.localizedName) == .orderedAscending
                //flagObject.localizedName
                
            }
            data = NSMutableArray.init(array: sortedArray)
        }else if type == .none{
            unfilteredCurrencyData = data
        }
    }
    
    /// Filter data as per the selected Market Tab
    func getFilteredDataforSelectedTab()->NSArray{
        data = marketSummary
        let selectedTab = tabBar.selectedItem?.title
        if selectedTab?.contains("★") == true{
            //Fav Tab
            return data.filter { (dict) -> Bool in
                return UserDefaults.standard.checkIsDataPresent(data: (dict as! [String:Any])) != nil
            } as NSArray
            
        }
        return data.filter { (dict) -> Bool in
            ((dict as! NSDictionary).valueForCaseInsensativeKey(forKey: "quote") as! String) == selectedTab
            //            "\((str as! String).prefix((selectedTab?.count)!))" == selectedTab
        } as NSArray
    }
    
    // MARK: - Set up Helpers
    func setUpTabBar(){
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
    }
    
    func setUpColors(){
        tabBar.backgroundColor = UIColor.clear
        tabBar.tintColor = Theme.current.primaryColor
        tabBar.selectedItemTintColor = Theme.current.primaryColor
        tabBar.unselectedItemTintColor = Theme.current.titleTextColor
        
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = Theme.current.titleTextColor
        confirmButton.backgroundColor = Theme.current.titleTextColor.withAlphaComponent(0.4)
        bgView.backgroundColor = Theme.current.dropDownBgColor
        selectedCurrencyBgView.backgroundColor = Theme.current.backgroundColor
        yourChoiceLabel.textColor = Theme.current.titleTextColor
        shadowImageView.tintColor = Theme.current.dropDownBgColor
        
        confirmButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        
        
    }

    func setUpFrames(){
        if type == dropDownType.currencyPairsList{
            tabBarHeightConstraint.constant = tabBarHeight
//            tabBarHeightConstraintLandScape.constant = tabBarHeight
            yourChoiceLabelHeightConstraint.constant = yourChoiceHeght
            yourChoiceLabel.isHidden = false
        }else{
            tabBarHeightConstraint.constant = 0
//            tabBarHeightConstraintLandScape.constant = 0
            yourChoiceLabelHeightConstraint.constant = 0
            yourChoiceLabel.isHidden = true

        }
    }

    //MARK: - Button Actions
    @IBAction func confirmButtonAction(_ sender: Any) {
        if delegate != nil{
            
            if type == .currencyPairsList{
                if tempSelectedPair == ""{
                    
                }else{
                   if selectedIndex != nil && data.count == 0 {
                        
                    data = getFilteredDataforSelectedTab().mutableCopy() as! NSMutableArray
                    for (index,key) in data.enumerated(){
                        let cellData = key as! NSDictionary
                        let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
                        if cellData.valueForCaseInsensativeKey(forKey: "base") as! String == tempSelectedPair{
                            if  marketType == cellData.valueForCaseInsensativeKey(forKey: "quote") as! String {
                                mutatedDict.setValue(true, forKey: "selected")
                            }else {
                                
                                mutatedDict.setValue(false, forKey: "selected")
                            }
                        }
                        yourChoiceLabel.text = localised("Your choice")+": \(selectedCurrency)"
                        data.replaceObject(at: index, with: mutatedDict)
                    }

                        
                        
                }
                    
                    
                    
                    delegate?.dropDownSelected(title: tempSelectedPair, data: data[selectedIndex!] as! NSDictionary)
                }
            }else if type == .currencyList{
                
                if selectedIndex != nil{
                    let coinDetail = data[selectedIndex!] as! NSDictionary
                    delegate?.dropDownSelected(title: coinDetail.valueForCaseInsensativeKey(forKey: "currency") as! String, data: coinDetail)                }
            }else if type == .countryCode{
                
                if selectedIndex != nil{
                    let countryDetail = data[selectedIndex!] as! NSMutableDictionary
                    let flag = countryDetail.valueForCaseInsensativeKey(forKey: "data") as! Flag
                    delegate?.dropDownSelected(title:flag.localizedName ,data: NSDictionary(dictionary: ["flagName":flag.localizedName,"countryCode":flag.countryCode]))
                    
                }
            }else if type == .none{
                if selectedIndex != nil{
                    let selectedData = data[selectedIndex!] as! [String:Any]
                    delegate?.dropDownSelected(title: (selectedData["title"] as! String), data: selectedData as! NSDictionary)
                }
            }else if type == .orderHistoryOptionList{
                if selectedIndex != nil{
                    let selectedData = data[selectedIndex!] as! [String:Any]
                    delegate?.dropDownSelected(title: (selectedData["title"] as! String), data: selectedData as NSDictionary)
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - Keyboard handlers
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
//            topSpaceConstraint.constant = keyboardHeight
//            UIView.animate(withDuration: 1) {
//                            self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.height - keyboardHeight - UIApplication.shared.statusBarFrame.height)
            
//            viewBottomConstraint.constant = keyboardHeight
            tableViewBottomConstraint.constant = -keyboardHeight + confirmButtonBottomView.frame.size.height
//            }

        }

    }
    
    @objc func keyboardWillHide(notification: NSNotification){
//        topSpaceConstraint.constant = 0
//        UIView.animate(withDuration: 1) {
//            self.preferredContentSize =  CGSize(width: self.view.frame.size.width, height: self.initialViewHeight)
//        viewBottomConstraint.constant = 0
        tableViewBottomConstraint.constant = 0
//        }
    }
    
    @objc func favHasChangedMannuallyFromDropDown(){
        DispatchQueue.main.async { [weak self] in
            if self?.selectedTab.contains("★") ?? false {
                self?.searchBar.text = ""
                self?.tempSelectedPair = ""
                self?.setUpTabBarTableView()
            }
        }
    }

}


extension MDDropDownVC:MDCTabBarDelegate{
    
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        searchBar.text = ""
        self.tempSelectedPair = ""
        if self.selectedTab != tabBar.selectedItem?.title! {
            self.setUpTabBarTableView()
        }
    }
    
    func setUpTabBarTableView(){
        self.selectedTab = (tabBar.selectedItem?.title)!
        confirmButton.isUserInteractionEnabled = false
        confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        data = getFilteredDataforSelectedTab().mutableCopy() as! NSMutableArray
        for (index,key) in data.enumerated(){
            let cellData = key as! NSDictionary
            let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
            if cellData.valueForCaseInsensativeKey(forKey: "base") as! String == selectedCurrency{
                if  marketType == cellData.valueForCaseInsensativeKey(forKey: "quote") as! String {
                    mutatedDict.setValue(true, forKey: "selected")
                }else {
                    
                    mutatedDict.setValue(false, forKey: "selected")
                }
            }
            yourChoiceLabel.text = localised("Your choice")+": \(selectedCurrency)"
            data.replaceObject(at: index, with: mutatedDict)
        }
        tableView.reloadData()
        if data.count > 0 {
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func tabBar(_ tabBar: MDCTabBar, willSelect item: UITabBarItem) {
        print("will select  element")
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
         print("did highlight select  element")
    }
}


extension MDDropDownVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0{
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
            
        if type == .currencyPairsList{
            let currencyPair = tableView.dequeueReusableCell(withIdentifier: currencyPairCell) as! currencyPairDropdownCell
//            let key = data[indexPath.row]
            let cellData = data[indexPath.row] as! NSDictionary
          
            
            var titleCell = cellData.valueForCaseInsensativeKey(forKey: "base") as! String
            if let tabTitle = tabBar.selectedItem?.title{
                if tabTitle.contains("★"){
                    let market = cellData.value(forKey: "quote") as! String
                      titleCell = "\(titleCell)/\(market)"
                }else{
                    titleCell = "\(titleCell)/\(tabTitle)"
                }
                
            }

            currencyPair.title = titleCell
           
            currencyPair.configure(data: cellData)
            currencyPair.myViewC = self
            cell = currencyPair
        }else if type == .currencyList{
            
            let currency = tableView.dequeueReusableCell(withIdentifier: currencyDropdownCell.identifier) as! currencyDropdownCell
            let cellData = data[indexPath.row] as! NSDictionary
            currency.configure(data: cellData)
            cell = currency

        }else if type == .countryCode{
            let mutableDict = data[indexPath.row] as! NSMutableDictionary
//            let flag = data[indexPath.row] as! Flag
            let countryCodeCell = tableView.dequeueReusableCell(withIdentifier: "countryCodeCell") as! CountryCodeCell
            let flagObject = mutableDict.valueForCaseInsensativeKey(forKey: "data") as! Flag
            if selectedCountry == flagObject.localizedName {
                  //if selecteCountry == coountryName.text {
                mutableDict.setValue(true, forKey: "selected")
            }else {
                 mutableDict.setValue(false, forKey: "selected")
            }
            countryCodeCell.configure(data: mutableDict)
            cell = countryCodeCell

        }else{
            if self.type == .orderHistoryOptionList{
                     let cellData =  data[indexPath.row] as! [String : Any]
                            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as! CommonDropDownCell
                            defaultCell.configure(data: cellData)
                            defaultCell.tickImage.isHidden = true
                            if let selected = cellData["selected"] as? Bool, selected == true{
                                defaultCell.bgView.backgroundColor = Theme.current.selectedCellBgColor
                            }else{
                                defaultCell.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
                            }
                            cell = defaultCell
            }else{
                let cellData =  data[indexPath.row] as! [String : Any]
                let defaultCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as! CommonDropDownCell
                defaultCell.configure(data: cellData)
                defaultCell.tickImage.isHidden = true
                defaultCell.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
                
                if let selected = cellData["selected"] as? Bool, selected == true{
                    defaultCell.tickImage.isHidden = false
                }else{

                }
                cell = defaultCell
            }
        }
        
        cell!.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        for (index,key) in data.enumerated(){
            if type == .currencyPairsList{
                let celldata = data[index] as! NSDictionary
                let mutableDict = celldata.mutableCopy() as! NSMutableDictionary
                if index == indexPath.row{
                    tempSelectedPair = celldata.valueForCaseInsensativeKey(forKey: "base") as! String
                    yourChoiceLabel.text = localised("Your choice")+": \(tempSelectedPair)"
                     mutableDict.setValue(true, forKey: "selected")
                    if tempSelectedPair == selectedCurrency && marketType == celldata.valueForCaseInsensativeKey(forKey: "quote") as! String{
                        confirmButton.isUserInteractionEnabled = false
                        confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }else{
                        confirmButton.isUserInteractionEnabled = true
                        confirmButton.backgroundColor = Theme.current.primaryColor
                    }
                }else{
    //                 confirmButton.isUserInteractionEnabled = false
                     mutableDict.setValue(false, forKey: "selected")
                }
                data.replaceObject(at: index, with: mutableDict)
        }
            else if type == .currencyList{
                let cellData = key as! NSDictionary
                let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
                
                if index == indexPath.row{
                    mutatedDict.setValue(true, forKey: "selected")
                    confirmButton.isUserInteractionEnabled = true
                    confirmButton.backgroundColor = Theme.current.primaryColor
                    if cellData.valueForCaseInsensativeKey(forKey: "currency") as! String == selectedPair{
                        confirmButton.isUserInteractionEnabled = false
                        confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }
                }else{
                    mutatedDict.setValue(false, forKey: "selected")
                }
                data.replaceObject(at: index, with: mutatedDict)
                
            }
            else if type == .countryCode{
                let cellData = key as! NSDictionary
                let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
                
                let flagObject = mutatedDict.valueForCaseInsensativeKey(forKey: "data") as! Flag
               
                if index == indexPath.row{
                    selectedCountry = flagObject.localizedName
                    (key as! NSMutableDictionary).setValue(true, forKey: "selected")
                    confirmButton.isUserInteractionEnabled = true
                    confirmButton.backgroundColor = Theme.current.primaryColor
                }else{
                    
                    (key as! NSMutableDictionary).setValue(false, forKey: "selected")
                }
            }
            else if type == .none{
                let cellData = key as! NSDictionary
                let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
                
                if index == indexPath.row{
                    mutatedDict.setValue(true, forKey: "selected")
                    confirmButton.isUserInteractionEnabled = true
                    confirmButton.backgroundColor = Theme.current.primaryColor
//                    if cellData.valueForCaseInsensativeKey(forKey: "currency") as! String == selectedPair{
//                        confirmButton.isUserInteractionEnabled = false
//                        confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
//                    }
                }else{
                    mutatedDict.setValue(false, forKey: "selected")
                }
                data.replaceObject(at: index, with: mutatedDict)
            }else if type == .orderHistoryOptionList{
                print("Handle")
                let cellData = key as! NSDictionary
                let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
                  
                if index == indexPath.row{
                    mutatedDict.setValue(true, forKey: "selected")
                    confirmButton.isUserInteractionEnabled = true
                    confirmButton.backgroundColor = Theme.current.primaryColor
                    if index == alreadySelectedIndex{
                        confirmButton.isUserInteractionEnabled = false
                        confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }
            
                  }else{
                      mutatedDict.setValue(false, forKey: "selected")
                  }
                  data.replaceObject(at: index, with: mutatedDict)
            }
        }
        
        if type == .none{
            let seletedData = data.object(at: indexPath.row) as! NSDictionary
            let mutableData = NSMutableArray()
            for dict in unfilteredCurrencyData{
                let mutableDict = ((dict as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                mutableDict.setValue(false, forKey: "selected")
                if let title = mutableDict.valueForCaseInsensativeKey(forKey: "title") as? String{
                    if let selectedCellTitle = seletedData.valueForCaseInsensativeKey(forKey: "title") as? String{
                        if selectedCellTitle == title{
                            mutableDict.setValue(true, forKey: "selected")
                        }
                    }
                }
                mutableData.add(mutableDict)
            }
            
            unfilteredCurrencyData = mutableData
        }
        
         tableView.reloadData()
    }
}

extension MDDropDownVC:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if type == .currencyPairsList{
            data = ((getFilteredDataforSelectedTab().copy() as! NSArray).filter({ (dict) -> Bool in
//                if let ticker = (dict as! NSDictionary).valueForCaseInsensativeKey(forKey: "CoinFullName") as? String{
//                    if ticker.lowercased().contains(searchBar.text!.lowercased()){
//                        return  true
//                    }
//                }
                if let name = (dict as! NSDictionary).valueForCaseInsensativeKey(forKey: "base") as? String{
                    if name.lowercased().contains(searchBar.text!.lowercased()){
                        return  true
                    }
                }
                return false
            }) as NSArray).mutableCopy() as! NSMutableArray

            if searchBar.text == "" {
                data = getFilteredDataforSelectedTab().mutableCopy() as! NSMutableArray
            }
        }
        else if type == .currencyList{
            
            data = ((unfilteredCurrencyData.copy() as! NSArray).filter({ (dict) -> Bool in
                if let ticker = (dict as! NSDictionary).valueForCaseInsensativeKey(forKey: "currency") as? String{
                    if ticker.lowercased().contains(searchBar.text!.lowercased()){
                        return  true
                    }
                }
//                if let name = (dict as! NSDictionary).valueForCaseInsensativeKey(forKey: "Coin_Name") as? String{
//                    if name.lowercased().contains(searchBar.text!.lowercased()){
//                        return  true
//                    }
//                }
                return false
            }) as NSArray).mutableCopy() as! NSMutableArray
            if searchBar.text == "" {
                data = unfilteredCurrencyData
            }
            
            let filtredValue = data.filter { (dict) -> Bool in
                return (((dict as! NSMutableDictionary).value(forKey: "selected") as? Bool) ?? false)
            }
            
            if filtredValue.count > 0{
                selectedIndex = data.index(of: filtredValue.first!)
                confirmButton.isUserInteractionEnabled = true
                confirmButton.backgroundColor = Theme.current.primaryColor
            }else{
                confirmButton.isUserInteractionEnabled = false
                confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            }
        }
        else if type == .countryCode{
            
            let flagWithDetails = NSMutableArray()
            for flag in flags{
                var selectedValue = false
                let dict = NSMutableDictionary(dictionary: ["data":flag,"selected":selectedValue])
                flagWithDetails.add(dict)
            }
            
            let mutableArray = NSMutableArray()
            for dict in flagWithDetails{
                if let flagName = ((dict as! NSMutableDictionary).valueForCaseInsensativeKey(forKey: "data") as? Flag)?.localizedName{
                    if flagName.lowercased().contains((searchBar.text?.lowercased())!){
                        mutableArray.add(dict)
                    }
                }
            }
            data = mutableArray
            
            if searchBar.text == "" {

//                data = flagWithDetails
                var flagsArray : [NSDictionary] = []
                for flag in flags{
                    let dict = NSMutableDictionary(dictionary: ["data":flag,"selected":false])
                    //flagWithDetails.add(dict)
                    flagsArray.append(dict)
                }
                let sortedArray = flagsArray.sorted { (item1, item2) -> Bool in
                    let flagObject1 = item1.valueForCaseInsensativeKey(forKey: "data") as! Flag
                    let flagObject2 = item2.valueForCaseInsensativeKey(forKey: "data") as! Flag
                    return flagObject1.localizedName.compare(flagObject2.localizedName) == .orderedAscending
                    //flagObject.localizedName
                    
                }
                data = NSMutableArray.init(array: sortedArray)
            }
            let filtredValue = data.filter { (dict) -> Bool in
                return ((dict as! NSMutableDictionary).value(forKey: "data") as! Flag).localizedName == self.selectedCountry
            }
            
            if filtredValue.count > 0{
                selectedIndex = data.index(of: filtredValue.first!)
                confirmButton.isUserInteractionEnabled = true
                confirmButton.backgroundColor = Theme.current.primaryColor
            }else{
                confirmButton.isUserInteractionEnabled = false
                confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            }
        }else if type == .none{
            
            data = ((unfilteredCurrencyData.copy() as! NSArray).filter({ (dict) -> Bool in
                if let ticker = (dict as! NSDictionary).valueForCaseInsensativeKey(forKey: "title") as? String{
                    if ticker.lowercased().contains(searchBar.text!.lowercased()){
                        return  true
                    }
                }
                return false
            }) as NSArray).mutableCopy() as! NSMutableArray
            
            if searchBar.text == "" {
                data = unfilteredCurrencyData
            }
            
            let filtredValue = data.filter { (dict) -> Bool in
                
                return (((dict as! NSDictionary).value(forKey: "selected") as? Bool) ?? false)
            }
            
            if filtredValue.count > 0{
                selectedIndex = data.index(of: filtredValue.first!)
                confirmButton.isUserInteractionEnabled = true
                confirmButton.backgroundColor = Theme.current.primaryColor
            }else{
                confirmButton.isUserInteractionEnabled = false
                confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            }
            
            
        }
        tableView.reloadData()
        if data.count > 0 {
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }

        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


class currencyPairDropdownCell:UITableViewCell{
    //MARK: - StoryBoard outlets
    @IBOutlet weak var pairTitleLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var percentageImageView: UIImageView!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    //MARK: - Variables
    var myViewC : MDDropDownVC?
    var title = ""
    var cellData:NSMutableDictionary?
    
    //MARK: - Automation Identifiers
    func addAutomationIdentifiers(){
        //For Automation
        self.isAccessibilityElement = true
        self.accessibilityValue = "currencyPairDropdownCell"
        self.accessibilityIdentifier = "currencyPairDropdownCell"
        self.accessibilityLabel = "currencyPairDropdownCell"
    }
    
    func setUpColors(){
        pairTitleLabel.textColor = Theme.current.titleTextColor
        lastPriceLabel.textColor = Theme.current.titleTextColor
//        bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        
    }
    override func draw(_ rect: CGRect) {
        setUpColors()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addAutomationIdentifiers()
        self.pairTitleLabel.adjustsFontSizeToFitWidth = true
        self.lastPriceLabel.adjustsFontSizeToFitWidth = true

    }
    
    func configure(data:NSDictionary){
     
        cellData = (data.mutableCopy() as! NSMutableDictionary)
        
        percentage.textColor = Theme.current.secondaryColor
        let base = cellData?.valueForCaseInsensativeKey(forKey: "base") as? String ?? ""
        let qoute = cellData?.valueForCaseInsensativeKey(forKey: "quote") as? String ?? ""
        //        if let title = data.allKeys.first as? String{
        pairTitleLabel.text = title.replacingOccurrences(of: "_", with: "/")
        //        }
        if let lastPriceVal = data.valueForCaseInsensativeKey(forKey: "price") as? Double{
            let decimal = MDHelper.shared.getDecimalPrecision(base: base, quote: qoute)
            lastPriceLabel.text = MDHelper.shared.getFormattedNumber(amount: lastPriceVal, minimumFractionDigits: decimal.0) ?? ""
        }
        if let percen = data.valueForCaseInsensativeKey(forKey: "change_in_price") as? Double{
            //percentage.text = String(format: "%.4f %%", percen).replacingOccurrences(of: "-", with: "")
            let percent = String(format: "%.2f %", percen).replacingOccurrences(of: "-", with: "")
            percentage.text = "\(String(percent.prefix(8))) %"
            percentageImageView.image = percen < 0 ?  UIImage(named: "redPriceDrop")?.imageWithColor(color1: Theme.current.primaryColor) : UIImage(named: "greenPriceUp")?.imageWithColor(color1: Theme.current.secondaryColor)
            percentage.textColor = percen >= 0 ? Theme.current.secondaryColor : Theme.current.primaryColor
        }
        
        if let selected = data.valueForCaseInsensativeKey(forKey: "selected") as? Bool,selected == true{
            bgView.backgroundColor = Theme.current.selectedCellBgColor
        }else{
            bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        }
        

        //Fav Set up
        
        let color = (UserDefaults.standard.checkIsDataPresent(data: data as! [String : Any]) != nil) ? Theme.current.primaryColor : .white
        self.favouriteButton.setTitleColor(color, for: .normal)
        
//        if let favourite = UserDefaults.standard.value(forKey: "\(base)_\(qoute)" ) as? Bool{
//            if favourite == true{
//
//                favouriteButton.tag = 1
//            }
//        }else{
//            favouriteButton.setTitleColor(Theme.current.titleTextColor.withAlphaComponent(0.75), for: .normal)
//            favouriteButton.tag = 0
//        }
        
        
    }
    
    override func layoutSubviews() {
        if let selected = cellData!.valueForCaseInsensativeKey(forKey: "selected") as? Bool,selected == true{
            bgView.backgroundColor = Theme.current.selectedCellBgColor
        }else{
            bgView.backgroundColor = Theme.current.mainTableCellsBgColor
            
        }
        let base = cellData?.valueForCaseInsensativeKey(forKey: "base") as? String ?? ""
        let qoute = cellData?.valueForCaseInsensativeKey(forKey: "quote") as? String ?? ""
        
//        if let favourite = UserDefaults.standard.value(forKey: "\(base)_\(qoute)" ) as? Bool{
//            if favourite == true{
//                favouriteButton.setTitleColor(Theme.current.primaryColor, for: .normal)
//                favouriteButton.tag = 1
//            }
//        }else{
//            favouriteButton.setTitleColor(Theme.current.titleTextColor.withAlphaComponent(0.75), for: .normal)
//            favouriteButton.tag = 0
//        }
    }
    
    //MARK: - Button Actions
    @IBAction func favouriteButtonAction(_ sender: Any) {
        let flag = UserDefaults.standard.shouldSaveCurreny(data: cellData as! [String : Any])
        self.favouriteButton.setTitleColor(flag ? Theme.current.primaryColor : .white, for: .normal)
        NotificationCenter.default.post(name: .init(rawValue: "fav_change_from_drop_down"), object: nil)
        
//        if favouriteButton.tag == 0 {
//            //Should select as favourite
//            let base = cellData?.valueForCaseInsensativeKey(forKey: "base") as? String ?? ""
//            let qoute = cellData?.valueForCaseInsensativeKey(forKey: "quote") as? String ?? ""
//
//            UserDefaults.standard.set(true, forKey: "\(base)_\(qoute)")
//            favouriteButton.setTitleColor(Theme.current.primaryColor, for: .normal)
//            favouriteButton.tag = 1
//
//        }else{
//              if let vc = myViewC {
////                vc.confirmButton.isUserInteractionEnabled = false
////                vc.confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
//            }
//            //Should deselect as favourite
//            let base = cellData?.valueForCaseInsensativeKey(forKey: "base") as? String ?? ""
//            let qoute = cellData?.valueForCaseInsensativeKey(forKey: "quote") as? String ?? ""
//
//            UserDefaults.standard.removeObject(forKey:"\(base)_\(qoute)")
//            favouriteButton.setTitleColor(Theme.current.titleTextColor.withAlphaComponent(0.75), for: .normal)
//            favouriteButton.tag = 0
//        }
//        if let vc = myViewC {
//            vc.data = vc.getFilteredDataforSelectedTab().mutableCopy() as! NSMutableArray
//
//            for (index,key) in  vc.data.enumerated(){
//                let cellData = key as! NSDictionary
//                let mutatedDict = cellData.mutableCopy() as! NSMutableDictionary
//                var pair = ""
//                 if  vc.marketType == cellData.valueForCaseInsensativeKey(forKey: "quote") as! String {
//                    pair = vc.tempSelectedPair=="" ? vc.selectedCurrency : vc.tempSelectedPair
//                 }else{
//                    pair = vc.tempSelectedPair
//                }
//
//                if cellData.valueForCaseInsensativeKey(forKey: "base") as! String == pair{
//                    mutatedDict.setValue(true, forKey: "selected")
////                    vc.confirmButton.isUserInteractionEnabled = true
////                    vc.confirmButton.backgroundColor = Theme.current.primaryColor
//                    let selectedTab = vc.tabBar.selectedItem?.title
//                    if selectedTab?.contains("★") == true{
//                        if  vc.marketType == cellData.valueForCaseInsensativeKey(forKey: "quote") as! String{
//                                     vc.confirmButton.isUserInteractionEnabled = false
//                                    vc.confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
//                                }else{
//                                    vc.confirmButton.isUserInteractionEnabled = true
//                                    vc.confirmButton.backgroundColor = Theme.current.primaryColor
//                                }
//                    }
//                    }else {
//
////                    vc.confirmButton.isUserInteractionEnabled = false
////                    vc.confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
////                        mutatedDict.setValue(false, forKey: "selected")
//                    }
//                 vc.data.replaceObject(at: index, with: mutatedDict)
//            }
//
//            vc.tableView.reloadData()
//        }
    }
    
}


class currencyDropdownCell:UITableViewCell{
    static let identifier = "currencyDropdownCell"

    //MARK: - StoryBoard outlets
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var priceInUSD: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isAccessibilityElement = true
        self.accessibilityValue = "currencyWalletDropdownCell"
        self.accessibilityIdentifier = "currencyWalletDropdownCell"
        self.accessibilityLabel = "currencyWalletDropdownCell"
        
        
    }

    func setUpColors(){
        currencyTitle.textColor = Theme.current.titleTextColor
        priceInUSD.textColor = Theme.current.titleTextColor
        totalLabel.textColor = Theme.current.titleTextColor
        currencyName.textColor = Theme.current.subTitleColor
    }
    override func draw(_ rect: CGRect) {
        setUpColors()
    }
    
    func configure(data:NSDictionary){
        if let name = data.valueForCaseInsensativeKey(forKey: "currency") as? String{
            totalLabel.isHidden = false
            currencyTitle.text = name
            if name == "ALL"{
                self.priceInUSD.text = ""
                self.totalLabel.text = ""
            }else{
                self.totalLabel.text = localised("Total")
                if let balance = data.valueForCaseInsensativeKey(forKey: "balance") as? Double{
                    priceInUSD.text = String(format: "%.2f \(name)", balance)
                }else{
                    priceInUSD.text = ""
                    totalLabel.isHidden = true
                }
            }
            if let selected = data.valueForCaseInsensativeKey(forKey: "selected") as? Bool,selected == true{
                bgView.backgroundColor = Theme.current.selectedCellBgColor
            }else{
                bgView.backgroundColor = Theme.current.mainTableCellsBgColor
            }
        }
        currencyName.text = ""
    }
}


class CountryCodeCell:UITableViewCell{
    //MARK: - StoryBoard outlets
    /// Flag Icon imageview
    @IBOutlet weak var flag: UIImageView!
    /// Flag selected green tick icon
    @IBOutlet weak var tick: UIImageView!
    /// Flag name
    @IBOutlet weak var coountryName: UILabel!
    
    //MARK: - Variables
    /// Dictionary of key values for showing flag info
    var cellData:NSMutableDictionary?
    
    /// Cell default method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Automation
        coountryName.isAccessibilityElement = true
        coountryName.accessibilityIdentifier = "CountryNameLabel"
        coountryName.accessibilityLabel = "CountryNameLabel"
        
    }
    /// Configure cell with flag data which includes Flag object for key data and boolean value for selected key 
    func configure(data:NSMutableDictionary){
       
        cellData = data
        let flagObject = data.valueForCaseInsensativeKey(forKey: "data") as! Flag
        flag.image = flagObject.image(style: .none)
        coountryName.text = flagObject.localizedName
        
        if let selected = cellData!.valueForCaseInsensativeKey(forKey: "selected") as? Bool,selected == true{
            tick.image = UIImage.init(named: "tick")?.imageWithColor(color1: Theme.current.secondaryColor)
            tick.isHidden = false
            coountryName.textColor = Theme.current.secondaryColor
        }else{
            
            tick.isHidden = true
            coountryName.textColor = Theme.current.profileInitialLabelBgColor
        }
    }
    
    override func layoutSubviews() {
        if let selected = cellData!.valueForCaseInsensativeKey(forKey: "selected") as? Bool,selected == true{
            tick.isHidden = false
            coountryName.textColor = Theme.current.secondaryColor
        }else{
            tick.isHidden = true
            coountryName.textColor = Theme.current.titleTextColor
        }

    }
}




// Default Cell
class CommonDropDownCell:UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        self.titleLabel.textColor = Theme.current.titleTextColor
    }
    
    func configure(data:[String:Any]){
        if let title = data["title"] as? String{
            let sepratedString = title.components(separatedBy: " ")
            if sepratedString.count >= 2{
            titleLabel.text = title.capitalized
            }else{
                if title.count == 3 {
                    titleLabel.text = title.uppercased()
                }else{
                    titleLabel.text = title
                }
            }
        }
    }
}
