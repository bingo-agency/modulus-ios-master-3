//
//  MDMarketListHeader.swift
//  Modulus
//
//  Created by Pathik  on 11/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

enum sortOptions:Int {
    case up = 0
    case down = 1
    case bothSelected = 2
    case bothDeselected = 3
    
}


class MarketListHeaders: UIView {

    @IBOutlet weak var firstColumnSortStackView: sortIndicatorStackView!
    @IBOutlet weak var thirdColumnSortStackView: sortIndicatorStackView!
    // First Column
    
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.backgroundColor = Theme.current.navigationBarColor
        for view in self.subviews{
            for label in view.subviews{
                if label is UILabel{
                    (label as! UILabel).textColor = Theme.current.titleTextColor
                }
            }
        }
        // Drawing code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("layoutsubview")
    }
    func refreshDataWithVolumeSort(shoudMoveToTop :Bool = true)  {
        if let marketListVC = self.viewController() as? MarketListVC{
            if firstColumnSortStackView.tag == sortOptions.up.rawValue {
                
                
                
                
                let sortedArray = marketListVC.dataArray.sorted { (first, secound) -> Bool in
                    (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "base_volume") as! Double > (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "base_volume") as! Double
                }
                marketListVC.dataArray = sortedArray.reversed() as NSArray
            }else if firstColumnSortStackView.tag == sortOptions.down.rawValue{
                let sortedArray = marketListVC.dataArray.sorted { (first, secound) -> Bool in
                    let double1 = (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "base_volume") as! Double
                    let double2 = (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "base_volume") as! Double
                      return double1 < double2
                }
                marketListVC.dataArray = sortedArray.reversed() as NSArray
                //  marketListVC.dataArray = marketListVC.dataArray.reversed() as NSArray
                
            }else{
                marketListVC.dataArray = marketListVC.getFilteredDataforSelectedTab()
                
            }
            marketListVC.tableView.reloadData()
           if shoudMoveToTop == true {
                if marketListVC.dataArray.count > 0 {
                    marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    func refreshDataWithChangeSort(shoudMoveToTop :Bool = true)  {
        if let marketListVC = self.viewController() as? MarketListVC{
            if thirdColumnSortStackView.tag == sortOptions.up.rawValue {
                let sortedArray = marketListVC.dataArray.sorted { (first, secound) -> Bool in
                    (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "change_in_price") as! Double > (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "change_in_price") as! Double
                }
                marketListVC.dataArray = sortedArray.reversed() as NSArray
            }else if thirdColumnSortStackView.tag == sortOptions.down.rawValue{
                let sortedArray = marketListVC.dataArray.sorted { (first, secound) -> Bool in
                    ((first as! NSDictionary).valueForCaseInsensativeKey(forKey: "change_in_price") as! Double) < ((secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "change_in_price") as! Double)
                    
                }
                marketListVC.dataArray = sortedArray.reversed() as NSArray
                //marketListVC.dataArray = marketListVC.dataArray.reversed() as NSArray
                
            }else{
                marketListVC.dataArray = marketListVC.getFilteredDataforSelectedTab()
            }
            marketListVC.tableView.reloadData()
           if shoudMoveToTop {
                if marketListVC.dataArray.count > 0 {
                    marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    @IBAction func firstColumnAction(_ sender: Any) {
        // Deselecting other sort
        thirdColumnSortStackView.tag = sortOptions.down.rawValue
        thirdColumnSortStackView.sortIndicatorPressed()
        //performing new sort
        firstColumnSortStackView.sortIndicatorPressed()
        if let marketListVC = self.viewController() as? MarketListVC{
            if firstColumnSortStackView.tag == sortOptions.up.rawValue {
                
                
                
                
                let sortedArray = marketListVC.dataArray.sorted { (first, secound) -> Bool in
                    (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "base_volume") as! Double > (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "base_volume") as! Double
                }
                marketListVC.dataArray = sortedArray.reversed() as NSArray
            }else if firstColumnSortStackView.tag == sortOptions.down.rawValue{
                marketListVC.dataArray = marketListVC.dataArray.reversed() as NSArray

            }else{
                marketListVC.dataArray = marketListVC.getFilteredDataforSelectedTab()
                
            }
            marketListVC.tableView.reloadData()
            if marketListVC.dataArray.count > 0 {
                marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
    }
    @IBAction func thirdColumnAction(_ sender: Any) {
        // Deselecting other sort
        firstColumnSortStackView.tag = sortOptions.down.rawValue
        firstColumnSortStackView.sortIndicatorPressed()
        //performing new sort
        thirdColumnSortStackView.sortIndicatorPressed()
        
        if let marketListVC = self.viewController() as? MarketListVC{
            if thirdColumnSortStackView.tag == sortOptions.up.rawValue {
                let sortedArray = marketListVC.dataArray.sorted { (first, secound) -> Bool in
                    (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "change_in_price") as! Double > (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "change_in_price") as! Double
                }
                marketListVC.dataArray = sortedArray.reversed() as NSArray
            }else if thirdColumnSortStackView.tag == sortOptions.down.rawValue{
                marketListVC.dataArray = marketListVC.dataArray.reversed() as NSArray
                
            }else{
                marketListVC.dataArray = marketListVC.getFilteredDataforSelectedTab()
            }
            marketListVC.tableView.reloadData()
             if marketListVC.dataArray.count > 0 {
                marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
        }

    }

    func resetHeaders(){
        firstColumnSortStackView.tag = sortOptions.down.rawValue
        firstColumnSortStackView.sortIndicatorPressed()
        thirdColumnSortStackView.tag = sortOptions.down.rawValue
        thirdColumnSortStackView.sortIndicatorPressed()
    }
    
    func sortIndictorStateMaintain(){
        if firstColumnSortStackView.tag != sortOptions.down.rawValue{
            firstColumnSortStackView.sortIndicatorPressed()
        }
        if thirdColumnSortStackView.tag != sortOptions.down.rawValue{
            thirdColumnSortStackView.sortIndicatorPressed()
        }
        
    }
    
    
}
class OrderListHeaders: UIView {
    @IBOutlet weak var secoundColumnSortStackView: sortIndicatorStackView!
    @IBOutlet weak var thirdColumnSortStackView: sortIndicatorStackView!
    @IBOutlet weak var fourthColumnSortStackView: sortIndicatorStackView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.backgroundColor = Theme.current.navigationBarColor
        for view in (self.subviews.first?.subviews)!{
            for label in view.subviews{
                if label is UILabel{
                    (label as! UILabel).textColor = Theme.current.titleTextColor
                }
            }
        }

        // Drawing code
    }
    @IBAction func secoundColumnAction(_ sender: Any) {
    
        if let marketListVC = self.viewController() as? MarketListVC{
            
            if marketListVC.isOrderHistoryScreen {
                return
            }else{
                marketListVC.orderListSorted = secondColumnSortingHelper(listToBeSorted: marketListVC.orderListSorted)
            }
            
            marketListVC.tableView.reloadData()
            if marketListVC.orderListSorted.count > 0 {
                marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
            if marketListVC.orderHistorySorted.count > 0 {
                marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        
    }
    
    @IBAction func thirdColumnAction(_ sender: Any) {
        
        if let marketListVC = self.viewController() as? MarketListVC{
            
            if marketListVC.isOrderHistoryScreen == true{
                return
            }else{
                marketListVC.orderListSorted = thirdColumnSortingHelper(listToBeSorted: marketListVC.orderListSorted)
            }
            
            marketListVC.tableView.reloadData()
            if marketListVC.orderListSorted.count > 0 {
                marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
            if marketListVC.orderHistorySorted.count > 0 {
                marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
    }
    
    @IBAction func fourthColumnAction(_ sender: Any) {
        
        if let marketListVC = self.viewController() as? MarketListVC{
            
            if marketListVC.isOrderHistoryScreen == true{
                return
            }else{
                marketListVC.orderListSorted = fourthColumnSortingHelper(listToBeSorted: marketListVC.orderListSorted)
            }
            
            marketListVC.tableView.reloadData()
            if marketListVC.orderListSorted.count > 0 {
                marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
            if marketListVC.orderHistorySorted.count > 0 {
                marketListVC.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
    }

    //MARK: - Helper to sort lists
    func secondColumnSortingHelper(listToBeSorted : NSArray) -> NSArray{
        
        secoundColumnSortStackView.sortIndicatorPressed()
        // Deselecting other sort
        thirdColumnSortStackView.tag = sortOptions.down.rawValue
        thirdColumnSortStackView.sortIndicatorPressed()
        fourthColumnSortStackView.tag = sortOptions.down.rawValue
        fourthColumnSortStackView.sortIndicatorPressed()
        return self.sortForSecondColumn(listToBeSorted: listToBeSorted)
    }
    
    func sortForSecondColumn(listToBeSorted : NSArray)->NSArray{
        if let marketListVC = self.viewController() as? MarketListVC{
            let sortedArray = listToBeSorted.sorted { (first, secound) -> Bool in
                if let firstPrice = (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "rate") as? Double,
                   let secoundPrice = (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "rate") as? Double{
                    if firstPrice > secoundPrice{
                        return true
                    }
                }else if let firstPrice = (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "tradePrice") as? Double,
                         let secoundPrice = (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "tradePrice") as? Double{
                    if firstPrice > secoundPrice{
                        return true
                    }
                }
                return false
            }
            if secoundColumnSortStackView.tag == sortOptions.up.rawValue {
                return sortedArray.reversed() as NSArray
            }else if secoundColumnSortStackView.tag == sortOptions.down.rawValue{
                if marketListVC.isOrderHistoryScreen {
                    return marketListVC.orderHistorySorted.reversed() as NSArray
                    
                }else{
                    return sortedArray as NSArray
                }
            }else{
                return marketListVC.isOrderHistoryScreen == true ?  marketListVC.getFilteredDataforSelectedTabOrderHistoryList() : marketListVC.getFilteredDataForOrderHistory()
            }
        }else{
            return listToBeSorted
        }
    }
    
    func thirdColumnSortingHelper(listToBeSorted : NSArray) -> NSArray{
        
        thirdColumnSortStackView.sortIndicatorPressed()
        // Deselecting other sort
        secoundColumnSortStackView.tag = sortOptions.down.rawValue
        secoundColumnSortStackView.sortIndicatorPressed()
        fourthColumnSortStackView.tag = sortOptions.down.rawValue
        fourthColumnSortStackView.sortIndicatorPressed()
        return self.sortForThirdColumn(listToBeSorted: listToBeSorted)
    }
    
    func sortForThirdColumn(listToBeSorted : NSArray)->NSArray{
        if let marketListVC = self.viewController() as? MarketListVC{
            let sortedArray = listToBeSorted.sorted { (first, secound) -> Bool in
                if let firstPrice = (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "volume") as? Double,
                   let secoundPrice = (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "volume") as? Double{
                    if firstPrice > secoundPrice{
                        return true
                    }
                }else if let firstPrice = (first as! NSDictionary).valueForCaseInsensativeKey(forKey: "totalOrderSize") as? Double,
                         let secoundPrice = (secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "totalOrderSize") as? Double{
                    if firstPrice > secoundPrice{
                        return true
                    }
                }
                return false
            }
            if thirdColumnSortStackView.tag == sortOptions.up.rawValue {
                return sortedArray.reversed() as NSArray
            }else if thirdColumnSortStackView.tag == sortOptions.down.rawValue{
                if marketListVC.isOrderHistoryScreen {
                    return marketListVC.orderHistorySorted.reversed() as NSArray
                }else{
                    return sortedArray as NSArray
                }
            }else{
                return marketListVC.isOrderHistoryScreen == true ?  marketListVC.getFilteredDataforSelectedTabOrderHistoryList() : marketListVC.getFilteredDataForOrderHistory()
            }
        }else{
            return listToBeSorted
        }
    }
    
    
    func getDoubleValueFromString(str:String)->Double{
        let sep = str.components(separatedBy: .whitespaces)
        if sep.count > 0{
            guard sep.first != nil else {return 0}
            if Double(sep.first!) != nil{
                return sep.first!.toDouble()
            }
        }
        return 0
    }
    
    func fourthColumnSortingHelper(listToBeSorted : NSArray) -> NSArray{
        fourthColumnSortStackView.sortIndicatorPressed()
        thirdColumnSortStackView.tag = sortOptions.down.rawValue
        thirdColumnSortStackView.sortIndicatorPressed()
        secoundColumnSortStackView.tag = sortOptions.down.rawValue
        secoundColumnSortStackView.sortIndicatorPressed()
        return self.sortForFourthColumn(listToBeSorted: listToBeSorted)
    }
    
    func sortForFourthColumn(listToBeSorted: NSArray)->NSArray{
        if let marketListVC = self.viewController() as? MarketListVC{
            var sortedArray : NSArray!
            sortedArray = listToBeSorted.sorted { (first, secound) -> Bool in
                
                ((first as! NSDictionary).valueForCaseInsensativeKey(forKey: "rate") as! Double * ((first as! NSDictionary).valueForCaseInsensativeKey(forKey: "volume") as! Double)) >
                    ((secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "rate") as! Double * ((secound as! NSDictionary).valueForCaseInsensativeKey(forKey: "volume") as! Double))
                } as NSArray
            if fourthColumnSortStackView.tag == sortOptions.up.rawValue {
                if marketListVC.isOrderHistoryScreen {
                    sortedArray = marketListVC.orderHistorySorted.sorted { (first, second) -> Bool in
                        if let firstDict = first as? NSDictionary , let secondDict = second as? NSDictionary{
                            if let tradeStr1 = firstDict.value(forKey: "tradePrice") as? String ,
                                let size1 = firstDict.value(forKey: "size") as? String,
                                let tradeStr2 = secondDict.value(forKey: "tradePrice") as? String,
                                let size2 =  secondDict.value(forKey: "size") as? String{
                                let tradeDouble1 = self.getDoubleValueFromString(str: tradeStr1)
                                let tradeDouble2 = self.getDoubleValueFromString(str: tradeStr2)
                                let sizeDouble1 =  self.getDoubleValueFromString(str: size1)
                                let sizeDouble2 =  self.getDoubleValueFromString(str: size2)
                                return (tradeDouble1 * sizeDouble1) > (tradeDouble2 * sizeDouble2)
                            }
                        }
                        return false
                        } as NSArray
                }
                return sortedArray.reversed() as NSArray
            }else if fourthColumnSortStackView.tag == sortOptions.down.rawValue{
                if marketListVC.isOrderHistoryScreen{
                    return marketListVC.orderHistoryList.reversed() as NSArray
                }else{
                    return sortedArray
                }
                
            }else{
                return marketListVC.isOrderHistoryScreen == true ?  marketListVC.orderHistoryList : marketListVC.getFilteredDataForOrderHistory()
            }
        }
        return listToBeSorted
    }
    
}

class sortIndicatorStackView:UIStackView{
    
    let deSelectedColor = Theme.current.subTitleColor
    let selectedColor = Theme.current.primaryColor
    
    override func draw(_ rect: CGRect) {
        if let firstSubView = self.arrangedSubviews.first as? UIImageView{
            firstSubView.image = UIImage(named: "sort_up")
        }
        if let secondSubView = self.arrangedSubviews.last as? UIImageView{
            secondSubView.image = UIImage(named: "sort_down")
        }
    }
    func configureStack()  {
        self.tag = sortOptions.down.rawValue
        sortIndicatorPressed()
    }
    func sortIndicatorPressed(){
        switch sortOptions.init(rawValue: self.tag){
        case .bothDeselected?:
            self.tag = sortOptions.up.rawValue
            self.arrangedSubviews.first?.tintColor = selectedColor
            self.arrangedSubviews.last?.tintColor = deSelectedColor
            break
        case sortOptions.up?:
            self.tag = sortOptions.down.rawValue
            self.arrangedSubviews.first?.tintColor = deSelectedColor
            self.arrangedSubviews.last?.tintColor = selectedColor
            break
            
        case sortOptions.down?:
            self.tag = sortOptions.bothDeselected.rawValue
            self.arrangedSubviews.first?.tintColor = deSelectedColor
            self.arrangedSubviews.last?.tintColor = deSelectedColor
            break

//        case sortOptions.bothSelected?:
//            self.tag = sortOptions.bothDeselected.rawValue
//            self.arrangedSubviews.first?.tintColor = deSelectedColor
//            self.arrangedSubviews.last?.tintColor = deSelectedColor
//            break

        default:
            break
        }
    }
}
