//
//  MDVolumeDiscountVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/20/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDVolumeDiscountVC: UIViewController {
    @IBOutlet weak var lbl_first_discount: UILabel!
    @IBOutlet weak var lbl_first_tier: UILabel!
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var sep1: UIView!
    @IBOutlet weak var infoBgView: UIView!
    @IBOutlet weak var sep2: UIView!
    
    @IBOutlet weak var infobubble1: UIViewX!
    @IBOutlet weak var infobubble2: UIViewX!
    @IBOutlet weak var marketListHeadres: MarketListHeaders!
    @IBOutlet weak var lbl_second_discount: UILabel!
    @IBOutlet weak var lbl_second_tier: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var everyDayTradingLbl: UILabel!
    var listArr:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.getVolumeDiscount()
        self.setUpNavigation()
        self.setUPColors()
    }
    
    private
    func setUPColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.tblView.backgroundColor = Theme.current.backgroundColor
        self.infoBgView.backgroundColor = Theme.current.backgroundColor
        self.sep2.backgroundColor = Theme.current.backgroundColor
        self.sep1.backgroundColor = Theme.current.backgroundColor
        self.marketListHeadres.backgroundColor = Theme.current.mainTableCellsBgColor
        
        self.infobubble1.backgroundColor = Theme.current.mainTableCellsBgColor
        self.infobubble2.backgroundColor = self.infobubble1.backgroundColor
        self.lbl_first_discount.textColor = Theme.current.titleTextColor
        self.lbl_first_tier.textColor = lbl_first_discount.textColor
        self.lbl_second_discount.textColor = lbl_first_discount.textColor
        self.lbl_second_tier.textColor = lbl_first_discount.textColor
        self.everyDayTradingLbl.textColor = lbl_first_discount.textColor
        
    }
    
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = "Trading Volume Discount"
        self.navigationItem.titleView = label
    }}
//MARK: API Call
extension MDVolumeDiscountVC{
    func getVolumeDiscount(){
        MDHelper.shared.showHudOnWindow()
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.get_User_Volume_Discount_Limits, parameters:nil, headers: headers as NSDictionary) { (dict, err) in
            MDHelper.shared.hideHudOnWindow()
            if let data = dict as? [String:Any] , let data_ = data["data"] as? [[String:Any]]{
                self.listArr = data_
                self.listArr =  self.listArr.sorted(by: {($0["currency"] as! String) < ($1["currency"] as! String)})
                self.lbl_header.text = "Trade Volume BTC"
                self.listArr.insert(["currency":"BTC","tradedVolume":0,"tradedVolumeLimit":0,"discount":0], at: 0)
                DispatchQueue.main.async {
                    let profileDict =  UserDefaults.standard.object(forKey: "profile") as! [String:Any]
                    let discount_dict = profileDict["discounts"] as? [String:Any]
                    let volume_discount =   discount_dict?["volume_discount"] as? Int ?? 0
                    if volume_discount == 0 {
                        DispatchQueue.main.async {
                        self.lbl_first_tier.text = "Tier 0"
                        self.lbl_first_discount.text = "0 \(data_.first?["currency"] as? String ?? "") (0% Discount)"
                        self.lbl_second_tier.text = "Tier 1"
                        self.lbl_second_discount.text =  "20 \(data_.first?["currency"] as? String ?? "")"
                        }
                    }else{
                        if let index = self.listArr.firstIndex(where: { (dict) -> Bool in
                            return dict["discount"] as? Int ?? 0 == volume_discount
                        }){
                            if index == self.listArr.count - 1{
                                DispatchQueue.main.async {
                                let dict = self.listArr[index]
                                self.lbl_first_tier.text = "Tier \(index)"
                                self.lbl_first_discount.text = "0 \(dict["currency"] as? String ?? "") (\(dict["discount"] as? Int ?? 0 )% Discount)"
                                self.lbl_second_tier.text = "Tier \(index)"
                                self.lbl_second_discount.text =  "\(dict["tradedVolumeLimit"] as? Int ?? 0) \(dict["currency"] as? String ?? "")"
                            
                                }
                            }else{
                                let dict = self.listArr[index]
                                let dict_2 : [String:Any] = self.listArr[index + 1]
                                DispatchQueue.main.async {
                                    self.lbl_first_tier.text = "Tier \(index)"
                                    self.lbl_first_discount.text = "0 \(dict["currency"] as? String ?? "") (\(dict["discount"] as? Int ?? 0 )% Discount)"
                                    self.lbl_second_tier.text = "Tier \(index + 1)"
                                    self.lbl_second_discount.text =  "\(dict_2["tradedVolumeLimit"] as? Int ?? 0) \(dict_2["currency"] as? String ?? "")"
                                }
                               
                            }
                            
                        }
                        
                    }
                    self.tblView.reloadData()
                }
            }
        }
    }
}
//MARK: // Tableview Delegate and DataSource
extension MDVolumeDiscountVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.listArr[indexPath.item]
        let cell_ = tableView.dequeueReusableCell(withIdentifier: "MDExchangeVCell", for: indexPath) as! MDExchangeVCell
        cell_.lbl_tier.text =  "Tier \(indexPath.item)"
        cell_.lbl_holding.text =  "\(data["tradedVolumeLimit"] as? Int ?? 0) \(data["currency"] as? String ?? "")"
        cell_.lbl_discount.text = "\(data["discount"] as? Int ?? 0)%"
        return cell_
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
