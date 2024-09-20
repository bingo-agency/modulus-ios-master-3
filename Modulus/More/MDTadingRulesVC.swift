//
//  MDTadingRulesVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/19/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
enum MDTradeSortScreen {
    case minTrade
    case minPrice
    case minOrder
    case pair
}
class MDTadingRulesVC: UIViewController {
    let navigationTitle = localised("Trading Rules")
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var pairlbl: UILabel!
    @IBOutlet weak var minTradeAmtLbl: UILabel!
    @IBOutlet weak var minPriceLbl: UILabel!
    @IBOutlet weak var minOrderSizeLbl: UILabel!
    
    @IBOutlet weak var filterView: UIView!
    
    
    
    @IBOutlet weak var tbl_View: UITableView!
    @IBOutlet weak var search_bar: UISearchBar!
    var data_arry : [[String:Any]] = []
    var temp_Arr : [[String:Any]] = []
    
    @IBOutlet weak var name_up: UIImageView!
    @IBOutlet weak var name_down: UIImageView!
    
    @IBOutlet weak var ticker_up: UIImageView!
    @IBOutlet weak var ticker_down: UIImageView!
    
    @IBOutlet weak var deposit_up: UIImageView!
    @IBOutlet weak var deposit_down: UIImageView!
    
    
    @IBOutlet weak var pairs_up: UIImageView!
    @IBOutlet weak var pairs_down: UIImageView!
  
    var selected_sort : (MDAssetSort,MDTradeSortScreen) = (.up,.minTrade)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigation()
        self.tbl_View.delegate = self
        self.tbl_View.dataSource = self
        self.getcointStats()
        let textFieldInsideSearchBar = search_bar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = Theme.current.titleTextColor
        search_bar.placeholder = localised("Enter your search")
        self.setUpColors()
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.searchBarView.backgroundColor = Theme.current.navigationBarColor

        self.pairlbl.textColor = Theme.current.titleTextColor
        self.minTradeAmtLbl.textColor = self.pairlbl.textColor
        self.minPriceLbl.textColor = self.pairlbl.textColor
        self.minOrderSizeLbl.textColor = self.pairlbl.textColor
        
        self.filterView.backgroundColor = Theme.current.navigationBarColor
        
        self.tbl_View.backgroundColor = Theme.current.backgroundColor
    }
    
    //MARK:- navigation bar helprs
    /// Set up navigation bar titles and back button
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = localised("Trading Rules")
        self.navigationItem.titleView = label
    }
    func getcointStats(){
        //Curency
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.getSettings, parameters: nil, headers: nil) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dict = response?["data"] as? [String:Any] , let dataArray = dict["trade_setting"] as? NSArray {
                self.data_arry = dataArray as! [[String : Any]]
                self.temp_Arr = dataArray as! [[String : Any]]
                self.reloadData()
            }
            
        }
    }
    func reloadData(){
        DispatchQueue.main.async {
            self.tbl_View.reloadData()
        }
    }
    @IBAction func btn_sorAction(_ sender: UIButton) {
        switch sender.tag {
        case 1 :
            if self.selected_sort.1 == .minTrade && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.minTrade)
            }else{
                self.selected_sort = (.up,.minTrade)
            }
            break
        case 2 :
            if self.selected_sort.1 == .minPrice && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.minPrice)
            }else{
                self.selected_sort = (.up,.minPrice)
            }
            break
        case 3 :
            if self.selected_sort.1 == .minOrder && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.minOrder)
            }else{
                self.selected_sort = (.up,.minOrder)
            }
            break
        case 4 :
            if self.selected_sort.1 == .pair && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.pair)
            }else{
                self.selected_sort = (.up,.pair)
            }
            break
        default :break
        }
        self.sort_currentData()
    }
}//MARK: Filter, Sort
extension MDTadingRulesVC{
    func sort_currentData(){
        switch selected_sort.1{
        case .minTrade:
            self.data_arry = self.data_arry.sorted(by: { (dict1, dict2) -> Bool in
                if selected_sort.0 == .up {
                    return (Decimal((dict1["minTradeAmount"] as? Double ?? 0))) > (Decimal((dict2["minTradeAmount"] as? Double ?? 0)))
                }else{
                    return  (Decimal((dict1["minTradeAmount"] as? Double ?? 0))) < (Decimal((dict2["minTradeAmount"] as? Double ?? 0)))
                }
            })
            
        case .minPrice: self.data_arry = self.data_arry.sorted(by: { (dict1, dict2) -> Bool in
            if selected_sort.0 == .up {
                return (Decimal((dict1["minTickSize"] as? Double ?? 0))) > (Decimal((dict2["minTickSize"] as? Double ?? 0)))
            }else{
                return  (Decimal((dict1["minTickSize"] as? Double ?? 0))) < (Decimal((dict2["minTickSize"] as? Double ?? 0)))
            }
        }) ;break
        
        case .minOrder:self.data_arry = self.data_arry.sorted(by: { (dict1, dict2) -> Bool in
            if selected_sort.0 == .up {
                return (Decimal((dict1["minOrderValue"] as? Double ?? 0))) > (Decimal((dict2["minOrderValue"] as? Double ?? 0)))
            }else{
                return (Decimal((dict1["minOrderValue"] as? Double ?? 0))) < (Decimal((dict2["minOrderValue"] as? Double ?? 0)))
            }
        }) ; break
        
        case .pair:self.data_arry = self.data_arry.sorted(by: { (dict1, dict2) -> Bool in
            if selected_sort.0 == .up {
                return ((dict1["coinName"] as? String ?? "")) > ((dict2["coinName"] as? String ?? ""))
            }else{
                return ((dict1["coinName"] as? String ?? "")) < ((dict2["coinName"] as? String ?? ""))
            }
        }) ; break
            
        }
        DispatchQueue.main.async {
            self.setUpImage()
            self.tbl_View.reloadData()
        }
    }
    func setUpImage(){
        let selectedSortColor : UIColor = Theme.current.primaryColor

        self.name_up.tintColor = self.selected_sort.1 == .minTrade && self.selected_sort.0 == .up ? selectedSortColor : .lightGray
        self.name_down.tintColor =  self.selected_sort.1 == .minTrade && self.selected_sort.0 == .down ? selectedSortColor : .lightGray
        
        self.ticker_up.tintColor = self.selected_sort.1 == .minPrice && self.selected_sort.0 == .up ? selectedSortColor : .lightGray
        self.ticker_down.tintColor =  self.selected_sort.1 == .minPrice && self.selected_sort.0 == .down ? selectedSortColor : .lightGray
        
        self.deposit_up.tintColor =  self.selected_sort.1 == .minOrder && self.selected_sort.0 == .up ? selectedSortColor : .lightGray
        self.deposit_down.tintColor =  self.selected_sort.1 == .minOrder && self.selected_sort.0 == .down ? selectedSortColor : .lightGray
        
        self.pairs_up.tintColor =  self.selected_sort.1 == .pair && self.selected_sort.0 == .up ? selectedSortColor : .lightGray
        self.pairs_down.tintColor =  self.selected_sort.1 == .pair && self.selected_sort.0 == .down ? selectedSortColor : .lightGray
    }
}

extension MDTadingRulesVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_arry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradingRulesCell", for: indexPath) as! TradingRulesCell
        let data =  self.data_arry[indexPath.item]
           let coinName = data["coinName"] as! String
        let marketName = data["marketName"] as! String
           let minTradeAmount = (data["minTradeAmount"] as? Double ?? 0)
           let minTickSize = (data["minTickSize"] as? Double ?? 0)
           let minOrderValue = (data["minOrderValue"] as? Double ?? 0)
       
        cell.currencyPairLabel.text = "\(coinName)/\(marketName)"
        cell.priceLabel.text = "\((Decimal(minTradeAmount))) \(coinName)"
        cell.volume.text =  "\((Decimal(minTickSize))) \(marketName)"
        cell.totalAmount.text =  "\((Decimal(minOrderValue))) \(marketName)"
        cell.imgView.image = MDHelper.shared.getImageByCurrencyCode(code:data["coinName"] as! String)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func forTrailingZero(temp: Double) -> String {
        return String(format: "%g", temp)
    }
}
//
//
//MARK: // Searchbardelegate
extension MDTadingRulesVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let queryText = self.search_bar.text,queryText.count > 0 {
            self.data_arry =  self.temp_Arr.filter({ (dict) -> Bool in
              let date :String = dict["coinName"] as? String ?? ""
                let browser :String = dict["marketName"] as? String ?? ""
               return date.prefix(queryText.count).lowercased().contains(queryText.lowercased()) ||
                browser.prefix(queryText.count).lowercased().contains(queryText.lowercased())
           })
        }else{
            self.data_arry =  self.temp_Arr
        }
        self.sort_currentData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

class TradingRulesCell :UITableViewCell{
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var currencyPairLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var cellData :NSDictionary?
    
    override func awakeFromNib() {
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        
        super.awakeFromNib()
        if let priceLbl = priceLabel {
            priceLbl.textColor = Theme.current.titleTextColor
        }
        currencyPairLabel.textColor = Theme.current.titleTextColor
        volume.textColor = Theme.current.titleTextColor
        totalAmount.textColor = Theme.current.titleTextColor
        // Initialization code
    }

    func setTextColour(color : UIColor){
        currencyPairLabel.textColor = color
        priceLabel.textColor = color
        volume.textColor = color
        totalAmount.textColor = color
    }
    

}
