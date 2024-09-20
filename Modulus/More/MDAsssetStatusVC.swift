//
//  MDAsssetStatusVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/19/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
enum MDAssetSort {
    case up
    case down
}
enum MDAssetSortScreen {
    case name
    case ticker
    case deposit
    case withdrawl
    case trade
}
class MDAsssetStatusVC: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tradingRulesFilterView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tickerLbl: UILabel!
    @IBOutlet weak var depositLbl: UILabel!
    @IBOutlet weak var withdrawalsLbl: UILabel!
    @IBOutlet weak var tradeLbl: UILabel!
    
    
    
    @IBOutlet weak var name_up: UIImageView!
    @IBOutlet weak var name_down: UIImageView!
    
    @IBOutlet weak var ticker_up: UIImageView!
    @IBOutlet weak var ticker_down: UIImageView!
    
    @IBOutlet weak var deposit_up: UIImageView!
    @IBOutlet weak var deposit_down: UIImageView!
    
    @IBOutlet weak var withdrawal_up: UIImageView!
    @IBOutlet weak var withdrawal_down: UIImageView!
    
    @IBOutlet weak var trade_up: UIImageView!
    @IBOutlet weak var _down: UIImageView!
    
    var selected_sort : (MDAssetSort,MDAssetSortScreen) = (.up,.name)
    
    var data_arr : [[String:Any]] = []
    var temp_listArr : [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.searchbar.delegate = self
        self.setUpNavigation()
        self.getCurrencySetting()
        let textFieldInsideSearchBar = searchbar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        self.setUpColors()
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.tradingRulesFilterView.backgroundColor = Theme.current.navigationBarColor
        self.nameLbl.textColor = Theme.current.titleTextColor
        self.tickerLbl.textColor = self.nameLbl.textColor
        self.depositLbl.textColor = self.nameLbl.textColor
        self.withdrawalsLbl.textColor = self.nameLbl.textColor
        self.tradeLbl.textColor = self.nameLbl.textColor
        self.tblView.backgroundColor = Theme.current.backgroundColor
        
    }
    
    //MARK:- navigation bar helprs
    /// Set up navigation bar titles and back button
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = localised("Asset Status")
        self.navigationItem.titleView = label
    }
    @IBAction func btn_sorAction(_ sender: UIButton) {
        switch sender.tag {
        case 1 :
            if self.selected_sort.1 == .name && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.name)
            }else{
                self.selected_sort = (.up,.name)
            }
            break
        case 2 :
            if self.selected_sort.1 == .ticker && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.ticker)
            }else{
                self.selected_sort = (.up,.ticker)
            }
            break
        case 3 :
            if self.selected_sort.1 == .deposit && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.deposit)
            }else{
                self.selected_sort = (.up,.deposit)
            }
            break
        case 4 :
            if self.selected_sort.1 == .withdrawl && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.withdrawl)
            }else{
                self.selected_sort = (.up,.withdrawl)
            }
            break
        case 5 :
            if self.selected_sort.1 == .trade && self.selected_sort.0 == .up{
                self.selected_sort = (.down,.trade)
            }else{
                self.selected_sort = (.up,.trade)
            }
            break
        default :break
        }
        self.sort_currentData()
    }
}
//MARK: Filter, Sort
extension MDAsssetStatusVC{
    func sort_currentData(){
        switch selected_sort.1{
        case .name:
            self.data_arr = self.data_arr.sorted(by: { (dict1, dict2) -> Bool in
                if selected_sort.0 == .up {
                    return ((dict1["fullName"] as? String)!) < ((dict2["fullName"] as? String)!)
                }else{
                    return ((dict1["fullName"] as? String)!) > ((dict2["fullName"] as? String)!)
                }
            })
            
        case .ticker: self.data_arr = self.data_arr.sorted(by: { (dict1, dict2) -> Bool in
            if selected_sort.0 == .up {
                return ((dict1["shortName"] as? String)!) < ((dict2["shortName"] as? String)!)
            }else{
                return ((dict1["shortName"] as? String)!) > ((dict2["shortName"] as? String)!)
            }
        }) ;break
        
        case .deposit:self.data_arr = self.data_arr.sorted(by: { (dict1, dict2) -> Bool in
            if selected_sort.0 == .up {
                return ((dict1["depositEnabled"] as? Int)!) > ((dict2["depositEnabled"] as? Int)!)
            }else{
                return ((dict1["depositEnabled"] as? Int)!) < ((dict2["depositEnabled"] as? Int)!)
            }
        }) ; break
        
        case .withdrawl: self.data_arr = self.data_arr.sorted(by: { (dict1, dict2) -> Bool in
            if selected_sort.0 == .up {
                return ((dict1["withdrawalEnabled"] as? Int)!) > ((dict2["withdrawalEnabled"] as? Int)!)
            }else{
                return ((dict1["withdrawalEnabled"] as? Int)!) < ((dict2["withdrawalEnabled"] as? Int)!)
            }
        }) ;break
        
        case .trade: self.data_arr = self.data_arr.sorted(by: { (dict1, dict2) -> Bool in
            if selected_sort.0 == .up {
                return ((dict1["tradeEnabled"] as? Int)!) > ((dict2["tradeEnabled"] as? Int)!) 
            }else{
                return ((dict1["tradeEnabled"] as? Int)!) < ((dict2["tradeEnabled"] as? Int)!)
            }
        }) ;break     
        }
        DispatchQueue.main.async {
            self.setUpImage()
            self.tblView.reloadData()
        }
    }
    func setUpImage(){
        let selectedSortColor : UIColor = Theme.current.primaryColor
        self.name_up.tintColor = self.selected_sort.1 == .name && self.selected_sort.0 == .up ? selectedSortColor : .lightGray
        self.name_down.tintColor =  self.selected_sort.1 == .name && self.selected_sort.0 == .down ? selectedSortColor  : .lightGray
        
        self.ticker_up.tintColor = self.selected_sort.1 == .ticker && self.selected_sort.0 == .up ? selectedSortColor  : .lightGray
        self.ticker_down.tintColor =  self.selected_sort.1 == .ticker && self.selected_sort.0 == .down ? selectedSortColor : .lightGray
        
        self.deposit_up.tintColor =  self.selected_sort.1 == .deposit && self.selected_sort.0 == .up ? selectedSortColor : .lightGray
        self.deposit_down.tintColor =  self.selected_sort.1 == .deposit && self.selected_sort.0 == .down ? selectedSortColor : .lightGray
        
        self.withdrawal_up.tintColor =  self.selected_sort.1 == .withdrawl && self.selected_sort.0 == .up ? selectedSortColor : .lightGray
        self.withdrawal_down.tintColor =  self.selected_sort.1 == .withdrawl && self.selected_sort.0 == .down ? selectedSortColor : .lightGray
        
        self.trade_up.tintColor =  self.selected_sort.1 == .trade && self.selected_sort.0 == .up ? selectedSortColor : .lightGray
        self._down.tintColor =  self.selected_sort.1 == .trade && self.selected_sort.0 == .down  ? selectedSortColor : .lightGray
        
    }
}
//MARK: API Call
extension MDAsssetStatusVC {
    func getCurrencySetting(){
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.getCurrencySetting, parameters: nil, headers: nil) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray {
                self.data_arr = dataArray as? [[String:Any]] ?? []
                self.temp_listArr = dataArray as? [[String:Any]] ?? []
                self.sort_currentData()
            }
        }
    }
}
extension MDAsssetStatusVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDAssestCell", for: indexPath) as! MDAssestCell
        let data = self.data_arr[indexPath.item]
        cell.configureCell(data: data)
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
//MARK: // Searchbardelegate
extension MDAsssetStatusVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let queryText = self.searchbar.text,queryText.count > 0 {
            self.data_arr =  self.temp_listArr.filter({ (dict) -> Bool in
              let date :String = dict["fullName"] as? String ?? ""
                let browser :String = dict["shortName"] as? String ?? ""
               return date.prefix(queryText.count).lowercased().contains(queryText.lowercased()) ||
                browser.prefix(queryText.count).lowercased().contains(queryText.lowercased())
           })
        }else{
            self.data_arr =  self.temp_listArr
        }
        self.sort_currentData()
    }
}
