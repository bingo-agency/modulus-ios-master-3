//
//  MDReferralVC.swift
//  Modulus
//
//  Created by Pranay on 02/04/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import DropDown

enum TableType {
    case commission
    case refferred
}

enum CurrencyPrice {
    case d_30
    case d_60
    case d_90
    case d_120
    case alltime
    
    
}

class MDReferralVC: UIViewController {

    //UI Components
    @IBOutlet weak var tipVi: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLable: UILabel!
    
    
    
    @IBOutlet weak var referralStaticLbl: UILabel!
    @IBOutlet weak var referralLinkStaticLbl: UILabel!
    @IBOutlet weak var referralCOdeStaticLbl: UILabel!
    @IBOutlet weak var referralLinkLbl: UILabel!
    @IBOutlet weak var reffrealCodeLbl: UILabel!
    
    //Tier1
    
    @IBOutlet weak var shareYourRefStaticLbl: UILabel!
    @IBOutlet weak var tier1StaticLbl: UILabel!
    @IBOutlet weak var t1View: UIView!
    @IBOutlet weak var t1FreeShare: UILabel!
    @IBOutlet weak var t1Referrals: UILabel!
    
    //Tier2
    
    @IBOutlet weak var referralTiersStaticLbl: UILabel!
    @IBOutlet weak var tier2StaticLbl: UILabel!
    @IBOutlet weak var t2View: UIView!
    @IBOutlet weak var t2FreeShare: UILabel!
    @IBOutlet weak var t2Refferals: UILabel!
    
    //Tier3
    
    @IBOutlet weak var tier3StaticLbl: UILabel!
    @IBOutlet weak var t3View: UIView!
    @IBOutlet weak var t3FreeShares: UILabel!
    @IBOutlet weak var t3Referralsw: UILabel!
    
    //All time
    
    @IBOutlet weak var referralEarningsStaticLbl: UILabel!
    @IBOutlet weak var allTimeView: UIView!
    @IBOutlet weak var allTimeStaticLbl: UILabel!
    
    @IBOutlet weak var allTimeBTC: UILabel!
    @IBOutlet weak var allTimeRefferals: UILabel!
    
    
    @IBOutlet weak var last60View: UIView!
    @IBOutlet weak var last60DaysStaicLbl: UILabel!
    @IBOutlet weak var last60BTC: UILabel!
    @IBOutlet weak var last60referraks: UILabel!
    
    
    @IBOutlet weak var last90View: UIView!
    @IBOutlet weak var last90DaysStaticLbl: UILabel!
    @IBOutlet weak var last90BTC: UILabel!
    @IBOutlet weak var last90Referrals: UILabel!
    
    @IBOutlet weak var last120View: UIView!
    @IBOutlet weak var last120DaysStaticLbl: UILabel!
    @IBOutlet weak var last120BTC: UILabel!
    @IBOutlet weak var last120Referrals: UILabel!
    
    //Currency View
    @IBOutlet weak var currencyStaticLbl: UILabel!
    @IBOutlet weak var dateOfTransStaticLbl: UILabel!
    
    @IBOutlet weak var creditStaicLbl: UILabel!
    @IBOutlet weak var userIdStaticLbl: UILabel!
    @IBOutlet weak var emailStaticLbl: UILabel!
    @IBOutlet weak var commisionHistBtn: UIButton!
    @IBOutlet weak var commisionHistTV: UITableView!
    @IBOutlet weak var commisoinTVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var userRefBtn: UIButton!
    @IBOutlet weak var joinDatestaticLbl: UILabel!
    @IBOutlet weak var refferanceTV: UITableView!
    @IBOutlet weak var referenceTvHeight: NSLayoutConstraint!
    

    @IBOutlet weak var coinTableView: UITableView!
    @IBOutlet weak var coinTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commissionBGView: UIView!
    @IBOutlet weak var currencyViewBg: UIView!
    @IBOutlet weak var userRefBgView: UIView!
    
    var tableType : TableType = .commission
    var commission = [NSDictionary]()
    var referrals = [NSDictionary]()
    var currencies = [NSDictionary]()
    var filterType : CurrencyPrice = .alltime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpColors()
        self.getAffiliate_Summary()
        self.getAffiliate_Summary_stats()
        self.getMy_Affiliate()
        self.getAffiliate_Commission()
    }
    
    /***Set up colors ***/
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        self.referralStaticLbl.textColor = Theme.current.titleTextColor
        self.tier1StaticLbl.textColor = self.referralStaticLbl.textColor
        self.tier2StaticLbl.textColor = self.referralStaticLbl.textColor
        self.tier3StaticLbl.textColor = self.referralStaticLbl.textColor
        
        self.referralLinkStaticLbl.textColor = self.referralStaticLbl.textColor
        self.referralLinkLbl.textColor = self.referralStaticLbl.textColor
        
        self.referralTiersStaticLbl.textColor = self.referralStaticLbl.textColor
        
        self.referralCOdeStaticLbl.textColor = self.referralStaticLbl.textColor
        self.reffrealCodeLbl.textColor = self.referralStaticLbl.textColor
        
        self.shareYourRefStaticLbl.textColor = self.referralStaticLbl.textColor
        self.t1FreeShare.textColor = self.referralStaticLbl.textColor
        self.t1Referrals.textColor = self.referralStaticLbl.textColor
        
        self.t2FreeShare.textColor = self.referralStaticLbl.textColor
        self.t2Refferals.textColor = self.referralStaticLbl.textColor
        
        self.t3FreeShares.textColor = self.referralStaticLbl.textColor
        self.t3Referralsw.textColor = self.referralStaticLbl.textColor
        
        self.referralEarningsStaticLbl.textColor = self.referralStaticLbl.textColor
        
        self.allTimeStaticLbl.textColor = self.referralStaticLbl.textColor
        self.allTimeBTC.textColor = self.referralStaticLbl.textColor
        self.allTimeRefferals.textColor = self.referralStaticLbl.textColor
        
        self.last60DaysStaicLbl.textColor = self.referralStaticLbl.textColor
        self.last60BTC.textColor = self.referralStaticLbl.textColor
        self.last60referraks.textColor = self.referralStaticLbl.textColor
        
        self.last90DaysStaticLbl.textColor = self.referralStaticLbl.textColor
        self.last90BTC.textColor = self.referralStaticLbl.textColor
        self.last90Referrals.textColor = self.referralStaticLbl.textColor
        
        self.last120DaysStaticLbl.textColor = self.referralStaticLbl.textColor
        self.last120BTC.textColor = self.referralStaticLbl.textColor
        self.last120Referrals.textColor = self.referralStaticLbl.textColor
        
        self.currencyStaticLbl.textColor = self.referralStaticLbl.textColor
        self.filterLable.textColor = self.referralStaticLbl.textColor
        
        self.commisionHistBtn.setTitleColor(self.filterLable.textColor,
                                            for: .normal)
        
        self.creditStaicLbl.textColor = self.referralStaticLbl.textColor
        self.dateOfTransStaticLbl.textColor = self.referralStaticLbl.textColor
        self.creditStaicLbl.textColor = self.referralStaticLbl.textColor
        
        self.userIdStaticLbl.textColor = self.referralStaticLbl.textColor
        self.joinDatestaticLbl.textColor = self.referralStaticLbl.textColor
        self.emailStaticLbl.textColor = self.referralStaticLbl.textColor
        
        self.userRefBtn.setTitleColor(self.referralStaticLbl.textColor,
                                      for: .normal)
        
        for each in [self.tipVi , self.t1View , self.t2View , self.t3View , self.allTimeView , self.last60View , self.last90View , self.last120View]{
            each?.backgroundColor = Theme.current.navigationBarColor
        }
    }
    
    func getAffiliate_Commission(){
             
             
             let headers = ["Authorization":MDNetworkManager.shared.authToken,
                            "hmac":MDNetworkManager.shared.generateHmacForParams(params: [:] as NSDictionary)] as [String : Any]
             
             MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                                           methodType: .get,
                                                           apiName: "api/Affiliate_Commission",
                                                           parameters: nil,
                                                           headers: headers as NSDictionary) { (response, error) in
                                                               //print(response)
                                                              if let data = response?.value(forKey: "data") as? [NSDictionary]{
                                                                  self.commission = data
                                                              }
                                                            DispatchQueue.main.async {
                                                                 self.commisoinTVHeight.constant = CGFloat(self.commission.count * 50)
                                                                self.commisionHistTV.reloadData()
                                                            }
                       }
         }
    
    func getMy_Affiliate(){
          
          
          let headers = ["Authorization":MDNetworkManager.shared.authToken,
                         "hmac":MDNetworkManager.shared.generateHmacForParams(params: [:] as NSDictionary)] as [String : Any]
          
          MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                                        methodType: .get,
                                                        apiName: "api/My_Affiliate",
                                                        parameters: nil,
                                                        headers: headers as NSDictionary) { (response, error) in
                                                           // print(response)
                                                            if let data = response?.value(forKey: "data") as? [NSDictionary]{
                                                                self.referrals = data
                                                            }
                                                           DispatchQueue.main.async {
                                                            self.referenceTvHeight.constant = CGFloat(self.referrals.count * 50)
                                                               self.refferanceTV.reloadData()
                                                           }

                    }
      }
    
    func getAffiliate_Summary_stats(){
        
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: [:] as NSDictionary)] as [String : Any]
        
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                                      methodType: .get,
                                                      apiName: "api/Affiliate_Summary_stats",
                                                      parameters: nil,
                                                      headers: headers as NSDictionary) { (response, error) in
                                                          //print(response)
                                                        if let data = response?.value(forKey: "data") as? NSDictionary{
                                                            if let totalEarnings = data.value(forKey: "totalEarnings") as? NSDictionary{
                                                                //print(totalEarnings)
                                                                if let d_120 = totalEarnings.value(forKey: "120d") as? NSDictionary{
                                                                    if let btcValue = d_120.value(forKey: "btcValue") as? Double{
                                                                        self.last120BTC.text = "- \(btcValue) BTC"
                                                                    }
                                                                    if let usdValue = d_120.value(forKey: "usdValue") as? Double{
                                                                        self.last120Referrals.text = "- $\(usdValue)"
                                                                    }
                                                                }
                                                                if let d_90 = totalEarnings.value(forKey: "60d") as? NSDictionary{
                                                                   if let btcValue = d_90.value(forKey: "btcValue") as? Double{
                                                                       self.last90BTC.text = "- \(btcValue) BTC"
                                                                   }
                                                                   if let usdValue = d_90.value(forKey: "usdValue") as? Double{
                                                                       self.last90Referrals.text = "- $\(usdValue)"
                                                                   }
                                                                }
                                                                if let d_60 = totalEarnings.value(forKey: "90d") as? NSDictionary{
                                                                   if let btcValue = d_60.value(forKey: "btcValue") as? Double{
                                                                       self.last60BTC.text = "- \(btcValue) BTC"
                                                                   }
                                                                   if let usdValue = d_60.value(forKey: "usdValue") as? Double{
                                                                       self.last60referraks.text = "- $\(usdValue)"
                                                                   }
                                                                }
                                                                if let allTime = totalEarnings.value(forKey: "allTime") as? NSDictionary{
                                                                   if let btcValue = allTime.value(forKey: "btcValue") as? Double{
                                                                        self.allTimeBTC.text = "- \(btcValue) BTC"
                                                                   }
                                                                   if let usdValue = allTime.value(forKey: "usdValue") as? Double{
                                                                       self.allTimeRefferals.text = "- $\(usdValue)"
                                                                   }
                                                                }
                                                            }
                                                            
                                                            self.currencies.removeAll()
                                                            
                                                            if let earningsByCurrency = data.value(forKey: "earningsByCurrency") as? NSDictionary{
                                                                //print(earningsByCurrency)
                                                                if let earningKeys = earningsByCurrency.allKeys as? [String]{
                                                                    if let earningValues = earningsByCurrency.allValues as? [NSDictionary]{
                                                                        for i in 0..<earningKeys.count{
                                                                            self.currencies.append([earningKeys[i]:earningValues[i]])
                                                                        }
                                                                        
                                                                    }
                                                                }
                                                                DispatchQueue.main.async {
                                                                    self.coinTableHeight.constant = CGFloat(self.currencies.count * 50)
                                                                    self.coinTableView.reloadData()
                                                                }
                                                            }
                                                        }
                                                         

                  }
    }
    
    func getAffiliate_Summary(){
           
           
           let headers = ["Authorization":MDNetworkManager.shared.authToken,
                          "hmac":MDNetworkManager.shared.generateHmacForParams(params: [:] as NSDictionary)] as [String : Any]
           
           MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                                         methodType: .get,
                                                         apiName: "api/Affiliate_Summary",
                                                         parameters: nil,
                                                         headers: headers as NSDictionary) { (response, error) in
                                                             //print(response)
                                                            if let data = response?.value(forKey: "data") as? NSDictionary{
                                                        
                                                                if let r_Level_1 = data.value(forKey: "r_Level_1") as? Int{
                                                                    if let r_Level_1_Perc = data.value(forKey: "r_Level_1_Perc") as? Int{
                                                                        self.t1FreeShare.text = "Fee Share: \(r_Level_1_Perc)%"
                                                                    }
                                                                    self.t1Referrals.text = "Referrals: \(r_Level_1)"
                                                                    
                                                                }
                                                                if let r_Level_2 = data.value(forKey: "r_Level_2") as? Int{
                                                                    if let r_Level_2_Perc = data.value(forKey: "r_Level_2_Perc") as? Int{
                                                                        self.t2FreeShare.text = "Fee Share: \(r_Level_2_Perc)%"
                                                                    }
                                                                    self.t2Refferals.text = "Referrals: \(r_Level_2)"
                                                                }
                                                                if let r_Level_3 = data.value(forKey: "r_Level_3") as? Int{
                                                                    if let r_Level_3_Perc = data.value(forKey: "r_Level_3_Perc") as? Int{
                                                                        self.t3FreeShares.text = "Fee Share: \(r_Level_3_Perc)%"
                                                                    }
                                                                    self.t3Referralsw.text = "Referrals: \(r_Level_3)"
                                                                }
                                                                if let referralID = data.value(forKey: "referralID") as? String{
                                                                    self.reffrealCodeLbl.text = referralID
                                                                }
                                                                if let referralLink = data.value(forKey: "referralLink") as? String{
                                                                    self.referralLinkLbl.text = "\(referralLink)"
                                                                }
                                                            }
                                                            

                     }
       }
    
    func setUpView(){
        self.tipVi.layer.cornerRadius = 5
        self.filterView.layer.cornerRadius = 5
        self.t1View.layer.cornerRadius = 5
        self.t2View.layer.cornerRadius = 5
        self.t3View.layer.cornerRadius = 5
        self.allTimeView.layer.cornerRadius = 5
        self.last60View.layer.cornerRadius = 5
        self.last90View.layer.cornerRadius = 5
        self.last120View.layer.cornerRadius = 5
        
        self.filterView.layer.borderWidth = 1
        self.filterView.layer.borderColor = Theme.current.titleTextColor.cgColor
        
        self.tipVi.clipsToBounds = true
        self.filterView.clipsToBounds = true
        self.t1View.clipsToBounds = true
        self.t2View.clipsToBounds = true
        self.t3View.clipsToBounds = true
        self.allTimeView.clipsToBounds = true
        self.last60View.clipsToBounds = true
        self.last90View.clipsToBounds = true
        self.last120View.clipsToBounds = true
        
        self.filterLable.text = "All Time"
        self.referenceTvHeight.constant = 0
        self.coinTableHeight.constant = 0
        self.commisoinTVHeight.constant = 0
        self.commissionBGView.backgroundColor = Theme.current.navigationBarColor
        
        self.currencyViewBg.backgroundColor = self.commissionBGView.backgroundColor
        
        self.commissionBGView.backgroundColor = self.commissionBGView.backgroundColor
        
        self.userRefBgView.backgroundColor = self.commissionBGView.backgroundColor
    }
    
    @IBAction func filterDD(_ sender: Any) {
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = self.filterView
        dropDown.direction = .top// UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["All Time", "30 days", "60 days","90 days","120 days"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.filterLable.text = item
            switch item {
                case "All Time":
                    self.filterType = .alltime
                break
                case "30 days":
                    self.filterType = .d_30
                break
                case "60 days":
                    self.filterType = .d_60
                break
                case "90 days":
                    self.filterType = .d_90
                break
                case "120 days":
                    self.filterType = .d_120
                break
                
            default:
                break
            }
            DispatchQueue.main.async {
                self.coinTableView.reloadData()
            }
            
        }

        //dropDownLeft.width = 200
        dropDown.show()
    }
    
    @IBAction func copyLink(_ sender: Any) {
        
        UIPasteboard.general.string = self.referralLinkLbl.text ?? ""
        MDHelper.shared.showSucessAlert(message: "Link Copied", viewController: self)
    }
    
    @IBAction func codeCopy(_ sender: Any) {
        
        UIPasteboard.general.string = self.reffrealCodeLbl.text ?? ""
        MDHelper.shared.showSucessAlert(message: "Code Copied", viewController: self)
    }
    
    
    @IBAction func commisionHistAction(_ sender: Any) {
        
    }
    
    
    @IBAction func userRefAction(_ sender: Any) {
        
    }
    
}

extension MDReferralVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.commisionHistTV{
            return self.commission.count
        }else if tableView == self.refferanceTV{
            return self.referrals.count
        }else if tableView == self.coinTableView{
            return self.currencies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if tableView == self.commisionHistTV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MDCommissionCell", for: indexPath) as! MDCommissionCell
            cell.selectionStyle = .none
            cell.configureCommUI(commData : self.commission[indexPath.row])
            return cell
        }else if tableView == self.refferanceTV{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "MDRefferalCell", for: indexPath) as! MDRefferalCell
            cell2.selectionStyle = .none
            cell2.configureRefUI(commData : self.referrals[indexPath.row])
            return cell2
               //cell.configureRefUI(refData : self.referrals[indexPath.row])
        }else if tableView == self.coinTableView{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "MDCurrencyCell", for: indexPath) as! MDCurrencyCell
            cell2.selectionStyle = .none
            cell2.configureRefUI(commData : self.currencies[indexPath.row], currencyType: self.filterType)
            return cell2
               //cell.configureRefUI(refData : self.referrals[indexPath.row])
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}

class MDCommissionCell : UITableViewCell {
    
    @IBOutlet weak var commisionView: UIStackView!
    
    @IBOutlet weak var commCredit: UILabel!
    @IBOutlet weak var commDOT: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.commCredit.textColor = Theme.current.titleTextColor
        self.commDOT.textColor = self.commCredit.textColor
        
    }
    
    
    func configureCommUI(commData : NSDictionary){
        
        
        if let execDate = commData.value(forKey: "execDate") as? String{
            self.commDOT.text = self.formatDate(date: execDate)
        }
        if let amount = commData.value(forKey: "amount") as? Double{
            if let fromCID_Paid_Curr = commData.value(forKey: "fromCID_Paid_Curr") as? String{
                self.commCredit.text = "\(amount) \(fromCID_Paid_Curr)"
            }
        }
    }
    
    
    func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        print("Date is : ",date)
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        if let dateObj: Date = dateFormatterGet.date(from: date){
            let showDate = dateFormatter.string(from: dateObj)
            return showDate
        }else{
            return date
        }
        

        
    }
}

class MDRefferalCell : UITableViewCell {
    
    @IBOutlet weak var refData: UILabel!
    @IBOutlet weak var refUID: UILabel!
    @IBOutlet weak var refEmail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.refData.textColor = Theme.current.titleTextColor
        self.refUID.textColor = self.refData.textColor
        self.refEmail.textColor = self.refData.textColor
    }
    
    
    func configureRefUI(commData : NSDictionary){
        
        if let doj = commData.value(forKey: "doj") as? String{
            self.refData.text = self.formatDate(date: doj)
        }
        if let email = commData.value(forKey: "email") as? String{
            self.refEmail.text = email
        }
        if let name = commData.value(forKey: "name") as? String{
            self.refUID.text = name
        }

    }
    
    
   
    
    func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        print("Date is : ",date)
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        if let dateObj: Date = dateFormatterGet.date(from: date){
            let showDate = dateFormatter.string(from: dateObj)
            return showDate
        }else{
            return date
        }
        

        
    }
}

class MDCurrencyCell : UITableViewCell{
    
    @IBOutlet weak var currencyImgView: UIImageView!
    @IBOutlet weak var currenncyName: UILabel!
    @IBOutlet weak var currencyPricw: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.currencyPricw.textColor = Theme.current.titleTextColor
        self.currenncyName.textColor = Theme.current.titleTextColor

    }
    
       
    func configureRefUI(commData : NSDictionary,currencyType : CurrencyPrice){
            let coinName = commData.allKeys.first as? String ?? ""
            self.currencyImgView.image = MDHelper.shared.getImageByCurrencyCode(code: coinName)
            self.currenncyName.text = coinName.uppercased()
        
        
        //print(commData)
        if let parsedData = commData.allValues.first as? NSDictionary{
            switch currencyType {
                       case .d_30:
                           self.currencyPricw.text = "\(parsedData.value(forKey: "30d") as? Double ?? 0) " + coinName.uppercased()
                       break
                       case .d_60:
                            self.currencyPricw.text = "\(parsedData.value(forKey: "60d") as? Double ?? 0) " + coinName.uppercased()
                       break
                       case .d_90:
                            self.currencyPricw.text = "\(parsedData.value(forKey: "90d") as? Double ?? 0) " + coinName.uppercased()
                       break
                       case .d_120:
                            self.currencyPricw.text = "\(parsedData.value(forKey: "120d") as? Double ?? 0) " + coinName.uppercased()
                       break
                       case .alltime:
                            self.currencyPricw.text = "\(parsedData.value(forKey: "allTime") as? Double ?? 0) " + coinName.uppercased()
                       break
                  
                   }
        }
       
            

       }
}
