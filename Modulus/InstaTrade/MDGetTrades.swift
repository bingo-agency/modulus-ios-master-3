//
//  MDGetTrades.swift
//  Modulus
//
//  Created by Pranay on 27/10/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
//getInstaTrades
class MDGetTrades: UIViewController {

    @IBOutlet weak var tradeTbl: UITableView!
    @IBOutlet weak var topFilterView: UIView!
    @IBOutlet weak var dateStaticLbl: UILabel!
    @IBOutlet weak var purchaseStaticLbl: UILabel!
    @IBOutlet weak var spentStaticLbl: UILabel!
    @IBOutlet weak var feesstaticLbl: UILabel!
    
    var dataSource = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTrades()
        self.setUpColors()
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        
        self.tradeTbl.backgroundColor = Theme.current.backgroundColor
        for labels in [dateStaticLbl,
        purchaseStaticLbl,
        spentStaticLbl,
        feesstaticLbl]{
            labels?.textColor = Theme.current.titleTextColor
        }
        
        //self.topFilterView.backgroundColor = Theme.current.navigationBarColor
    }
    
    //MARK: - API calls
    func getTrades(){
        MDHelper.shared.showHudOnWindow()
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
        ]
        
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .post,
                                            apiName: API.get_insta_trades,
                                            parameters: nil,
                                            headers: headers as NSDictionary) { (response, error) in
                                                //Handle Response Here
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if let data = response?.value(forKey: "data") as? [NSDictionary]{
                                                            self.dataSource = data
                                                            DispatchQueue.main.async { [weak self] in
                                                                self?.tradeTbl.reloadData()
                                                            }
                                                        }
                                                    }else{
                                                        let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String ?? "Error occured"
                                                          MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                    }
                                                }else{
                                                    if  error != nil{
                                                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                    }
                                                }

        }
        
    }

}
extension MDGetTrades : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDInstaTradeCells", for: indexPath) as! MDInstaTradeCells
        cell.configureUI(data: self.dataSource[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


class MDInstaTradeCells : UITableViewCell {
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var purchaseLbl: UILabel!
    @IBOutlet weak var spentLbl: UILabel!
    @IBOutlet weak var feesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initiateCell()
    }
    
    private
    func initiateCell(){
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.dateLbl.textColor = Theme.current.titleTextColor
        self.purchaseLbl.textColor = self.dateLbl.textColor
        self.spentLbl.textColor = self.dateLbl.textColor
        self.feesLbl.textColor = self.dateLbl.textColor
        
    }
    /*
     "id": 118,
           "baseAmount": 0.2,
           "baseCurrency": "BTC",
           "quoteAmount": 5.459189,
           "quoteCurrency": "ETH",
           "requestedOn": "2019-06-05T08:08:03.58",
           "rate": 28.73256852,
           "commission": 5,
           "status": false
     */
    func configureUI(data : NSDictionary){
        
        
        
        let date = self.formatDate(date: data.value(forKey: "requestedOn") as? String ?? "")
        let status = data.value(forKey: "status") as? Bool ?? true == true ? "Completed" : "Pending"
        self.statusImgView.image = status == "Completed" ? UIImage(named: "checked") : UIImage(named: "cross")
        let baseAmount = data.value(forKey: "baseAmount") as? Double ?? 0
        let baseCurrency = data.value(forKey: "baseCurrency") as? String ?? ""
        
        let quoteAmount = data.value(forKey: "quoteAmount") as? Double ?? 0.0
        let quoteCurrency = data.value(forKey: "quoteCurrency") as? String ?? ""
        
        let rate = data.value(forKey: "rate") as? Double ?? 0.0
        
        self.dateLbl.text = "\(date)"
        self.purchaseLbl.text = "\(baseAmount)\n\(baseCurrency)"
        self.spentLbl.text = "\(quoteAmount)\n\(quoteCurrency)"
        self.feesLbl.text = "\(rate)\n\(quoteCurrency)"
        
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
