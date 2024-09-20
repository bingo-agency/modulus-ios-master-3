//
//  MDMarketOptionsView.swift
//  Modulus
//
//  Created by Abhijeet on 10/1/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
protocol  MDMarketOptionsViewDelegate : class{
    func selectedIndexID(_ id:String)
}
class MDMarketOptionsView: UIView {
    static let nibName = "MDMarketOptionsView"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate :MDMarketOptionsViewDelegate?
    var optionData:[MDMarketTabModel] = []
    var selectedIndex:String?{
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    var market_model_instance = Market_Tabbar.shared_instance
    func markedGroupAdded(){
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name.init("market_group_added"), object: nil)
    }
    @objc func reloadData(){
        DispatchQueue.main.async { [weak self] in
            self?.optionData = MDHelper.shared.getMarketetData()
            self?.collectionView.reloadData()
        }
    }
    func commoninit(){
        Bundle.main.loadNibNamed(MDMarketOptionsView.nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.layer.cornerRadius = 14.0
        self.collectionView.register(UINib(nibName: "MDMarketOptionCollectionCell", bundle: nil), forCellWithReuseIdentifier: MDMarketOptionCollectionCell.indentifier)
        self.collectionView.reloadData()
        self.markedGroupAdded()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commoninit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
}
//MARK: // CollectionView Delegate and Datasource
extension MDMarketOptionsView :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MDMarketOptionCollectionCell.indentifier, for: indexPath) as! MDMarketOptionCollectionCell
        let data = self.optionData[indexPath.item]
        cell.configureCell(text: data.title, shouldimageshow: indexPath.item == 0)
        cell.setupView_unselected()
        if let selected_marketName = self.selectedIndex , data.title == selected_marketName{
            cell.setupView_Selected()
        }else if (self.selectedIndex == nil || self.selectedIndex?.count ?? 0 == 0) && indexPath.item == 1{
            self.selectedIndex = data.title
            MarketListVC.selected_option = data.title
            cell.setupView_Selected()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.optionData.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = MDMarketOptionCollectionCell.getWidth_Cell(text:  self.optionData[indexPath.item].title, isimageVisible: indexPath.item == 0, size:CGSize(width: self.collectionView.frame.width, height: 1000))
        return CGSize(width: width, height: self.collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data =  self.optionData[indexPath.row]
        self.selectedIndex = nil
        self.collectionView.reloadData()
        self.collectionView.layoutSubviews()
        self.selectedIndex = data.title
        let cell = collectionView.cellForItem(at: indexPath) as! MDMarketOptionCollectionCell
        cell.setupView_Selected()
        self.delegate?.selectedIndexID(data.title)
    }
}

//
//  UIViewX.swift
//  DesignableX
//
//  Copyright © 2020 Tingle 2 INC. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewX: UIView {
    
    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
}

class Market_Tabbar{
    static let shared_instance : Market_Tabbar = Market_Tabbar()
    var is_market_group_present:Bool = false
    var list:[Market] = []{
        didSet{
            if list.contains(where: {$0.market_name.contains(Market.favName)}) == false {
                self.list.insert(Market.fav_option, at: 0)
            }
        }
    }
//    func getOptionList()->[Market]{
//        if self.is_market_group_present{
//            var map = self.list.filter({$0.market_group != nil})
//            map.removeAll(where: {$0.market_name.contains(Market.fav_option.market_name)})
//            map.insert(Market.fav_option, at: 0)
//            let user_arr = Array(Set(map))
//            return user_arr.sorted { (model1, model2) -> Bool in
//                return model1.id < model2.id
//            }
//        }else{
//            var map =  self.list.filter({$0.market_group == nil})
//            map.removeAll(where: {$0.market_name.contains(Market.fav_option.market_name)})
//            map.insert(Market.fav_option, at: 0)
//            let user_arr = Array(Set(map))
//            return user_arr.sorted { (model1, model2) -> Bool in
//                return model1.id < model2.id
//            }
//        }
//    }
    
     func getMarket(market_name :String)->Market?{
        if self.is_market_group_present {
            let market_groups_arr = self.list.filter({$0.market_group != nil})
            return market_groups_arr.first(where: {$0.market_name.contains(market_name)})
            
        }else{
            return self.list.first(where: {$0.market_name.contains(market_name)})
        }
    }
}
struct Market_Groups{
    var market_group_title:String
    var markets_groups:[Market] = []
}
struct Market  {
    var id :Int
    var market_name:String
    var market_list : [String]
    var displayQuoteCurrency:Bool
    var market_group:Market_Groups?
}
extension Market : Hashable{
    static func == (lhs: Market, rhs: Market) -> Bool {
        return lhs.market_name == rhs.market_name
    }
    
    func hash(into hasher: inout Hasher) { // Generated automatically
      hasher.combine(market_name)
    }
}
//MARK: Some Localised strings
extension Market{
    static let favName : String = localised("Favorites")
    static let crypto : String = localised("Crypto Pairs")
    static let fiat_option : String = localised("Fiat Pairs")
}
//MARK: Some Localised strings
extension Market{
    static let fav_option : Market = Market(id: 0, market_name: Market.favName, market_list: [], displayQuoteCurrency: false, market_group: Market_Groups(market_group_title: Market.favName))

}






//class NewTabOptions:Codable{
//    var id:Int
//    var name:String
//    var marketNames:[String] = []
//    var displayQuoteCurrency:Bool = true
//    init(id:Int,name:String) {
//        self.id = id
//        self.name = name
//    }
//    static func getStringOptions() -> [String]{
//        return NewTabOptions.getoption().map({$0.name})
//    }
//    static func getoption() -> [NewTabOptions]{
//        let arr = [NewTabOptions(id: 1, name: "Favorites"),
//                   NewTabOptions(id: 2, name: "Crypto Pairs"),
//                   NewTabOptions(id: 3, name: "Fiat Pairs"),
//                    ]
//
//        return arr
//    }
//}
//class TabOptions{
//    static let shared :TabOptions = TabOptions()
//    var marketName:[String] = []
//    var isMarket_Groupavailable:Bool = false
//    var option_Arry : [NewTabOptions] = NewTabOptions.getoption()
//    static func getselectedOptionMarketName(str:String) -> NewTabOptions?{
//        return TabOptions.shared.option_Arry.first(where: {$0.name == str})
//    }
//}
//extension TabOptions  {
//    func getOptionList() -> [String] {
//        return self.isMarket_Groupavailable ? option_Arry.map({$0.name}) : marketName.map({"  \($0) "})
//    }
//}
