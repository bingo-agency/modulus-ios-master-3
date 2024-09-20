//
//  MDExchangeFeesVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/25/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
enum MDExchangeFeeScrenType{
    case exchange_fee
    case deposit_withdrawal
}

enum ExchangeSorter {
    case makerUp
    case makerDown
    
    case tradeup
    case tradeDown
    
    case takerUp
    case takerDown
}

class MDExchangeFeesVC: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var exchange_line_view: UIView!
    @IBOutlet weak var deposit_line_view: UIView!
    @IBOutlet weak var exchange_lbl_line: UILabel!
    @IBOutlet weak var deposit_lbl_line: UILabel!
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var lbl_header_2: UILabel!
    @IBOutlet weak var lbl_header1: UILabel!
    @IBOutlet weak var lbl_header3: UILabel!
    
    
    @IBOutlet weak var tradingPairUpImg: UIImageView!
    @IBOutlet weak var tradingPairDownImg: UIImageView!
    
    @IBOutlet weak var makerFeeUpImg: UIImageView!
    @IBOutlet weak var makerFeeDownImg: UIImageView!
    
    @IBOutlet weak var takerFeeUpImg: UIImageView!
    @IBOutlet weak var takerFeeDownImg: UIImageView!
    
    var sortHelper : ExchangeSorter = .tradeup{
        didSet{
            self.sortList()
        }
    }
    
    var screen_type : MDExchangeFeeScrenType = .exchange_fee
    
    var list_Arry : [[String:Any]] = []
    var currency_list : [Currency] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.setUpNavigation()
        self.showExchangeScreen()
        self.setUpColors()
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.exchange_lbl_line.textColor = Theme.current.primaryColor
        self.headerView.backgroundColor = Theme.current.navigationBarColor
        self.filterView.backgroundColor = Theme.current.navigationBarColor
        self.lbl_header1.textColor = Theme.current.titleTextColor
        self.lbl_header_2.textColor = Theme.current.titleTextColor
        self.lbl_header3.textColor = Theme.current.titleTextColor
        self.tblView.backgroundColor = Theme.current.backgroundColor

    }
    //MARK:- navigation bar helprs
    /// Set up navigation bar titles and back button
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = localised("Exchange Trading fees")
        self.navigationItem.titleView = label
    }
    func changeColor(isExchangeSelected:Bool){
        self.exchange_lbl_line.textColor = isExchangeSelected ? Theme.current.primaryColor : Theme.current.titleTextColor
        self.exchange_line_view.backgroundColor = isExchangeSelected ? Theme.current.primaryColor :  Theme.current.titleTextColor
        self.deposit_lbl_line.textColor = !isExchangeSelected ? Theme.current.primaryColor :  Theme.current.titleTextColor
        self.deposit_line_view.backgroundColor = !isExchangeSelected ? Theme.current.primaryColor :  Theme.current.titleTextColor
     
    }
    func showExchangeScreen(){
        self.screen_type = .exchange_fee
        self.changeColor(isExchangeSelected: true)
        self.lbl_header1.text = "Trading Pair"
        self.lbl_header_2.text = "Maker Fee"
        self.lbl_header3.text = "Taker Fee"
        self.getSettings()
        
    }
    func showDepositScreen(){
        self.screen_type = .deposit_withdrawal
        self.changeColor(isExchangeSelected: false)
        self.lbl_header1.text = "Currency"
        self.lbl_header_2.text = "Deposit Fee"
        self.lbl_header3.text = "Withdrawal Fee"
        self.getCurrencySettings()
    }
    
    func sortList(){
      
        //Up - Descending
        //Down - Ascending
        switch self.sortHelper {
        case .tradeup:
            self.list_Arry = self.list_Arry.sorted(by: { (dict1, dict2) -> Bool in
                return ((dict1["coinName"] as? String)!) > ((dict2["coinName"] as? String)!)
            })
            
            self.currency_list = self.currency_list.sorted { (dict1, dict2) -> Bool in
                return dict1.shortName ?? "" > dict2.shortName ?? ""
            }
            
            break
        case .tradeDown:
            self.list_Arry = self.list_Arry.sorted(by: { (dict1, dict2) -> Bool in
                return ((dict1["coinName"] as? String)!) < ((dict2["coinName"] as? String)!)
            })
            
            self.currency_list = self.currency_list.sorted { (dict1, dict2) -> Bool in
                return dict1.shortName ?? "" < dict2.shortName ?? ""
            }
            
            break
        case .makerUp:
            self.list_Arry = self.list_Arry.sorted(by: { (dict1, dict2) -> Bool in
                return ((dict1["makerFee"] as? Double)!) > ((dict2["makerFee"] as? Double)!)
            })
            break
        case .makerDown:
            self.list_Arry = self.list_Arry.sorted(by: { (dict1, dict2) -> Bool in
                return ((dict1["makerFee"] as? Double)!) < ((dict2["makerFee"] as? Double)!)
            })
            break
        case .takerUp:
            self.list_Arry = self.list_Arry.sorted(by: { (dict1, dict2) -> Bool in
                return (dict1["takerFee"] as? Double ?? 0) > (dict2["takerFee"] as? Double ?? 0)
            })
            self.currency_list = self.currency_list.sorted { (dict1, dict2) -> Bool in
                return dict1.withdrawalServiceCharge ?? 0.0 > dict2.withdrawalServiceCharge ?? 0.0
            }
            break
        case .takerDown:
            self.list_Arry = self.list_Arry.sorted(by: { (dict1, dict2) -> Bool in
                return (dict1["takerFee"] as? Double ?? 0) < (dict2["takerFee"] as? Double ?? 0)
            })
            self.currency_list = self.currency_list.sorted { (dict1, dict2) -> Bool in
                return dict1.withdrawalServiceCharge ?? 0.0 < dict2.withdrawalServiceCharge ?? 0.0
            }
            break
        
        }
        DispatchQueue.main.async { [weak self] in
            self?.setUpImageColors()
            self?.reloadTableView()
       }
    }
    
    func setUpImageColors(){
        
        self.tradingPairUpImg.tintColor = self.sortHelper == .tradeup ? Theme.current.primaryColor : .gray
        self.tradingPairDownImg.tintColor = self.sortHelper == .tradeDown ? Theme.current.primaryColor : .gray
        
        self.makerFeeUpImg.tintColor = self.sortHelper == .makerUp ? Theme.current.primaryColor : .gray
        self.makerFeeDownImg.tintColor = self.sortHelper == .makerDown ? Theme.current.primaryColor : .gray
        
        self.takerFeeUpImg.tintColor = self.sortHelper == .takerUp ? Theme.current.primaryColor : .gray
        self.takerFeeDownImg.tintColor = self.sortHelper == .takerDown ? Theme.current.primaryColor : .gray
        
        
    }
    
    @IBAction func btn_exchange_fee(_ sender: Any) {
        self.showExchangeScreen()
    }
    
    @IBAction func btn_deposit_action(_ sender: Any) {
        self.showDepositScreen()
        
    }
    
    @IBAction func changeTradeAction(_ sender: Any) {
        self.sortHelper = self.sortHelper == .tradeup ? .tradeDown : .tradeup
        
    }
    
    @IBAction func changeMakerAction(_ sender: Any) {
        self.sortHelper = self.sortHelper == .makerUp ? .makerDown : .makerUp
        
    }
    
    @IBAction func changeTakerPercAction(_ sender: Any) {
        self.sortHelper = self.sortHelper == .takerUp ? .takerDown : .takerUp
        
    }
}
//MARK: API Call
extension MDExchangeFeesVC{
    func getCurrencySettings(){
        MDHelper.shared.showHudOnWindow()
        let data = (UIApplication.shared.delegate as! AppDelegate).currencySettings
        if data.count > 0{
            self.currency_list = data
            self.currency_list = self.currency_list.sorted(by: {$0.shortName ?? "" < $1.shortName ?? ""})
            self.reloadTableView()
            MDHelper.shared.hideHudOnWindow()
        }else{
            //call Api
        }
    }
    func getSettings(){
        MDHelper.shared.showHudOnWindow()
        if self.list_Arry.count > 0 {
            self.reloadTableView()
            MDHelper.shared.hideHudOnWindow()
        }else{
            MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.getSettings, parameters: nil, headers: nil) { (response, error) in
                MDHelper.shared.hideHudOnWindow()
                if let dict = response?["data"] as? [String:Any] , let dataArray = dict["trade_setting"] as? NSArray {
                    self.list_Arry = dataArray as! [[String : Any]]
                    
                    self.reloadTableView()
                    MDHelper.shared.hideHudOnWindow()
                }
                
            }
        }
    }
    func reloadTableView(){
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}
//MARK: TableView Delegate and Datasource
extension MDExchangeFeesVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch self.screen_type {
        case .exchange_fee: return self.list_Arry.count;
        case .deposit_withdrawal: return self.currency_list.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDOrdersListCell", for: indexPath) as! MDOrdersListCell
        switch self.screen_type {
        case .exchange_fee:
            let data = self.list_Arry[indexPath.item]
            cell.currencyPairLabel.text = "\(data["coinName"] as! String)/\(data["marketName"] as! String)"
            cell.volume.text = "\(data["makerFee"] as! CGFloat)%"
            cell.totalAmount.text = "\(data["takerFee"] as! CGFloat)%"
            cell.coinImgViewWidth.constant = 25
            cell.coinImgView.image = MDHelper.shared.getImageByCurrencyCode(code: data["coinName"] as? String ?? "")
        case .deposit_withdrawal:
            let data = self.currency_list[indexPath.item]
            cell.currencyPairLabel.text = "\(data.shortName ?? "") (\(data.fullName ?? ""))"
            cell.volume.text = (data.depositEnabled ?? false) ? "Free" : "Free"
            if ((data.withdrawalServiceChargeType?.lowercased().contains("percentage")) ?? false){
                cell.totalAmount.text =  "\(data.withdrawalServiceCharge ?? 0.0)%"
            }else{
                cell.totalAmount.text =  "\(data.withdrawalServiceCharge ?? 0.0) \(data.shortName ?? "")"
            }
            cell.coinImgViewWidth.constant = 25
            cell.coinImgView.image = MDHelper.shared.getImageByCurrencyCode(code: data.shortName ?? "")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
