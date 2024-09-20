//
//  MDWalletHistoryVC.swift
//  Modulus
//
//  Created by Pathik  on 29/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDWalletHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - StoryBoard outlets
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shadowImagView: UIImageView!
    @IBOutlet weak var historyTableView: UITableView!
    
    /**Top View Table header*/
    @IBOutlet weak var headerFilterView: UIView!
    @IBOutlet weak var columnHeader1: UILabel!
    @IBOutlet weak var columnHeader2: UILabel!
    @IBOutlet weak var columnHeader3: UILabel!
    @IBOutlet weak var columnHeader4: UILabel!
    
    
    //MARK: - Variables
    var selectedCurrency = ""
    var screenType : WalletType = .Deposit
    var historyDataArray : NSArray = []
    var navigationTitle = ""
    var isNetworkCallGoing = false
    
    //MARK: - Constants
    let rowHeight = CGFloat(70)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MDHistoryTableViewCell.registerCell(tableView: self.historyTableView)
        setNavigationbar()
        fetchWalletHistory()
        setUpColors()
        self.setlocalisedLables()
        
    }
    
    //MARK: - Navigation bar helpers
    func setNavigationbar(){
        
        self.navigationItem.backBarButtonItem?.title = ""
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = navigationTitle
        self.navigationItem.titleView = label
        
    }
    
    func setUpColors(){
        bgView.backgroundColor = Theme.current.backgroundColor
        shadowImagView.tintColor = Theme.current.backgroundColor
        
        self.headerFilterView.backgroundColor = Theme.current.navigationBarColor
        self.columnHeader1.textColor = Theme.current.titleTextColor
        self.columnHeader2.textColor = Theme.current.titleTextColor
        self.columnHeader3.textColor = Theme.current.titleTextColor
        self.columnHeader4.textColor = Theme.current.titleTextColor
        
    }
    
    private
    func setlocalisedLables(){
        self.columnHeader1.text = localised("Requested")
        self.columnHeader4.text = localised("Status")
        switch self.screenType{
        case .Deposit:
            self.columnHeader2.text = localised("Deposited")
            self.columnHeader3.text = localised("Deposit Amount")
            
        case .Withdraw:
            self.columnHeader2.text = localised("Type")
            self.columnHeader3.text = localised("Withdrawal Amount")
        }
    }
    
    
    
    //MARK: - Network calls
    /// This will fetch wallet history from server (Deposite/Withdrawal)
    
    
    func fetchWalletHistory(){
        switch screenType {
        case .Deposit:
            if let selectedCurrencyDetails = appDelegate.currencySettings.filter({$0.shortName?.lowercased() == self.selectedCurrency.lowercased()}).first{
                
                if selectedCurrencyDetails.walletType == walletTypes.fiatPG.rawValue ||
                    selectedCurrencyDetails.walletType == walletTypes.fiatManual.rawValue{
                    self.fetchFiatManualWalletHistory()
                }else{
                    self.fetchCrypoCurrencyWalletHistory()
                }
            }else{
                self.fetchCrypoCurrencyWalletHistory()
            }
        case .Withdraw:
            self.fetchCrypoCurrencyWalletHistory()
        }
    }
    
    func fetchCrypoCurrencyWalletHistory(){
        isNetworkCallGoing = true
        self.historyTableView.reloadData()
        let params = [
            "currency": "\(selectedCurrency)",
            "timestamp": "\(MDNetworkManager.shared.getCurrentTimeStamp())",
            "recvWindow": "10"
        ]
        
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: params as NSDictionary)] as [String : Any]
        let apiName : String
        switch self.screenType {
        case .Deposit:
            apiName = API.getDepositHistory
        case .Withdraw:
            apiName = API.getWithdrawHistory
        }
        
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .post,
                                            apiName: apiName,
                                            parameters: params as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if response != nil && error == nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    let keyPath = self.screenType == .Deposit ? "data.deposits" : "data.withdrawals"
                    if let data = response?.value(forKeyPath: keyPath) as? NSArray{
                        self.historyDataArray = data
                        
                    }
                }else{
                    if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                        MDHelper.shared.showErrorAlert(message: message, viewController: self)
                    }
                }
            }else{
                if  error != nil{
                    //                                                        MDHelper.shared.showErrorAlert(message: (error?.localizedDescription)!, viewController: self)
                    MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                }
            }
            self.isNetworkCallGoing = false
            self.historyTableView.reloadData()
            //                                                print("Get wallet details")
        }
        
    }
    
    
    func fetchFiatManualWalletHistory(){
        isNetworkCallGoing = true
        self.historyTableView.reloadData()
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        
        let apiName = "\(API.ListFiatManualDepositRequests)?currency=\(selectedCurrency)"
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl: API.baseURL,
                                            methodType: .get,
                                            apiName: apiName,
                                            parameters:nil,
                                            headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if response != nil && error == nil{
                if MDNetworkManager.shared.isResponseSucced(response: response!){
                    //                                                        let keyPath = self.isDepositHistory ? "data.deposits" : "data.withdrawals"
                    if let data = response?.value(forKeyPath: "data") as? NSArray{
                        self.historyDataArray = data.reversed() as NSArray
                        
                    }
                }else{
                    if let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String{
                        MDHelper.shared.showErrorAlert(message: message, viewController: self)
                    }
                }
            }else{
                if  error != nil{
                    //                                                        MDHelper.shared.showErrorAlert(message: (error?.localizedDescription)!, viewController: self)
                    MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                }
            }
            self.isNetworkCallGoing = false
            self.historyTableView.reloadData()
            //                                                print("Get wallet details")
        }
        
    }
    
    
    // MARK: - TableView Delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  historyDataArray.count == 0 && isNetworkCallGoing == false{
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
        return historyDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MDHistoryTableViewCell.getCell(tableView: tableView, indexPath: indexPath)
        let cellData = historyDataArray[indexPath.row] as! NSDictionary
        switch self.screenType {
        case .Deposit:
            cell.configureCellForDeposite(data: cellData as! [String : Any])
        case .Withdraw:
            cell.configureCellForWithdrawal(data: cellData as! [String : Any])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if screenType == .Deposit{
            return 50
        }
        return 0.0000001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init(frame: .zero)
        v.backgroundColor = .clear
        return v
    }
}
