//
//  MDExchangeTokenVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/18/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDExchangeTokenVC: UIViewController {
    @IBOutlet weak var sep1: UIView!
    @IBOutlet weak var payTradingFeesBgView: UIView!
    @IBOutlet weak var sep2: UIView!
    @IBOutlet weak var payTradingFeesLbl: UILabel!
    @IBOutlet weak var whenYouEnrollLbl: UILabel!
    @IBOutlet weak var yourTradingFeeDisLbl: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbl_enrollStatus: UILabel!
    @IBOutlet weak var switch_: UISwitch!
    @IBOutlet weak var tierLbl: UILabel!
    @IBOutlet weak var holdingLbl: UILabel!
    @IBOutlet weak var discLbl: UILabel!
    @IBOutlet weak var headerOptViews: UIView!
    @IBOutlet weak var tradinglblBGView: UIViewX!
    @IBOutlet weak var tradinglblbgView: UIViewX!
    var discount_array : [[String:Any]] = []
    let coinName : String = (UIApplication.shared.delegate as! AppDelegate).tdM_Token_Name

    var isEnrolled:Bool = false {
        didSet{
            self.lbl_enrollStatus.text = isEnrolled ? "Disenroll" : "Enroll"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switch_.isOn = false
        self.setUpNavigation()
        self.setupTableView()
        self.getDiscountTier()
        self.getstatus()
        self.setUpLocalizedLabels()
        self.setUpColors()
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.tblView.backgroundColor = Theme.current.backgroundColor
        self.payTradingFeesLbl.textColor = Theme.current.titleTextColor
        self.whenYouEnrollLbl.textColor = self.payTradingFeesLbl.textColor
        
        self.lbl_enrollStatus.textColor = self.payTradingFeesLbl.textColor
        self.yourTradingFeeDisLbl.textColor = self.payTradingFeesLbl.textColor
        
        self.tierLbl.textColor = self.payTradingFeesLbl.textColor
        self.holdingLbl.textColor = self.payTradingFeesLbl.textColor
        self.discLbl.textColor = self.payTradingFeesLbl.textColor
        
        self.sep1.backgroundColor = Theme.current.backgroundColor
        
        self.sep2.backgroundColor = self.sep1.backgroundColor
        
        self.headerOptViews.backgroundColor = Theme.current.navigationBarColor
        
        self.tradinglblBGView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.tradinglblbgView.backgroundColor = self.tradinglblBGView.backgroundColor
        self.payTradingFeesBgView.backgroundColor = Theme.current.backgroundColor
        
        self.switch_.onTintColor = Theme.current.primaryColor
        
    }
    
    @IBAction func btn_switchAction(_ sender: Any) {
        self.setEnrollStatus(str: self.isEnrolled ? API.dis_Enroll_ExchangeTokenDiscount : API.setExchangeTokenDiscountEnrollment)
    }
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = "Exchange Token Fee Discount"
        self.navigationItem.titleView = label
    }
    func setupTableView(){
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    private
    func setUpLocalizedLabels(){
        self.payTradingFeesLbl.text =
            String(format: localised("Pay_trading_fees_with_currency"),coinName)
        self.whenYouEnrollLbl.text = String(format: localised("when_you_enroll_pay_with"),coinName,coinName)
        self.yourTradingFeeDisLbl.text = String(format: localised("your_trading_disc_will"),coinName)
    }
}
//MARK: API Call
extension MDExchangeTokenVC{
    func getDiscountTier(){
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.getDiscountTier, parameters:nil, headers: headers as NSDictionary) { (dict, err) in
            if let data = dict as? [String:Any] , let data_ = data["data"] as? [[String:Any]]{
                self.discount_array = data_
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    func getstatus(){
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.GetExchangeTokenDiscountEnrollmentStatus, parameters:nil, headers: headers as NSDictionary) { (dict, err) in
            if let data = dict as? [String:Any] , let data_ = data["data"] as? Bool{
                self.isEnrolled = data_
                self.switch_.isOn = data_
                
            }
        }
    }
    func setEnrollStatus(str : String){
        MDHelper.shared.showHudOnWindow()
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: str, parameters:nil, headers: headers as NSDictionary) { (dict, err) in
            MDHelper.shared.hideHudOnWindow()
            if let data = dict as? [String:Any] , let data_ = data["status"] as? String , data_.lowercased() == "success"{
                self.switch_.isOn = self.isEnrolled ? false : true
                self.isEnrolled = self.isEnrolled ? false : true
            }
        }
        
    }
    
}
extension MDExchangeTokenVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discount_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDExchangeVCell", for: indexPath) as! MDExchangeVCell
        let data = self.discount_array[indexPath.item]
        cell.lbl_holding.text = "\(data["holding"] as? Int ?? 0) \(self.coinName)"
        cell.lbl_tier.text = data["tier"] as? String
        cell.lbl_discount.text =  "\(data["discount"] as? Int ?? 0)%"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
