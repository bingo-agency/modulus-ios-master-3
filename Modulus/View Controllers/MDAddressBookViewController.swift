//
//  MDAddressBookViewController.swift
//  Modulus
//
//  Created by Abhijeet on 10/20/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDAddressBookViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theAddressBookStaticLabel: UILabel!
    
    @IBOutlet weak var lbl_enable_disabled: UILabel!
    @IBOutlet weak var switch_: UISwitch!
    @IBOutlet weak var btn_add_address: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var whenWhitlistingStaticLabel: UILabel!
    @IBOutlet weak var addressesStaticLabel: UILabel!
    @IBOutlet weak var currencyStaticLabel: UILabel!
    @IBOutlet weak var labelStaticLabel: UILabel!
    @IBOutlet weak var addStaticLbl: UILabel!
    @IBOutlet weak var addAddInfoView: UIViewX!
    @IBOutlet weak var disabledInfoView: UIViewX!
    @IBOutlet weak var marketHeaderBGColor: UIView!
    @IBOutlet weak var sep1: UIView!
    @IBOutlet weak var sep2: UIView!
    var isenabled:Bool = false
    
    var dataSource = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switch_.isOn = false
        self.getwithdrawl_whitelisting_status()
        self.getAddressBook()
        self.setUpNavigation()
        self.setupTableView()
        self.setUpColors()
        self.setEnablDisableState()
        // Do any additional setup after loading the view.
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        self.theAddressBookStaticLabel.textColor = Theme.current.titleTextColor
        self.btn_add_address.setTitleColor(Theme.current.btnTextColor, for: .normal)
        self.btn_add_address.backgroundColor = Theme.current.primaryColor
        
        self.whenWhitlistingStaticLabel.textColor = self.theAddressBookStaticLabel.textColor
        self.addressesStaticLabel.textColor = self.theAddressBookStaticLabel.textColor
        
        self.currencyStaticLabel.textColor = self.theAddressBookStaticLabel.textColor
        self.labelStaticLabel.textColor = self.theAddressBookStaticLabel.textColor
        self.addStaticLbl.textColor = self.theAddressBookStaticLabel.textColor
        
        self.lbl_enable_disabled.textColor = self.theAddressBookStaticLabel.textColor
        
        self.tableView.backgroundColor = Theme.current.backgroundColor
        
        self.marketHeaderBGColor.backgroundColor =  Theme.current.mainTableCellsBgColor
        
        self.addAddInfoView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.disabledInfoView.backgroundColor = Theme.current.mainTableCellsBgColor
    
        self.switch_.onTintColor = Theme.current.primaryColor

    }
    
    func setupTableView(){
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = localised("Address Book")
        self.navigationItem.titleView = label
    }
    
    private
    func setEnablDisableState(){
        self.lbl_enable_disabled.text = switch_.isOn ? localised("Enabled") : localised("Disabled")
    }
    
    @IBAction func switch_action(_ sender: Any) {
        let action = self.switch_.isOn
        self.shouldEnabledWhitelisitng(url: action ? API.Enable_Withdrawal_Address_Whitelisting : API.Disable_Withdrawal_Address_Whitelisting)
        self.setEnablDisableState()
    }
    
    @IBAction func btn_add_address(_ sender: Any) {
        let controller = MDAddIPAddressWhiteListingVC()
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension MDAddressBookViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDAddressCell", for: indexPath) as! MDAddressCell
        cell.selectionStyle = .none
        cell.configureUI(data: self.dataSource[indexPath.row])
        return cell
    }
}


//MARK: Api Calls
extension MDAddressBookViewController {
    func getwithdrawl_whitelisting_status(){
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
                    ]
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.Get_Withdrawal_Address_Whitelisting_Status, parameters: nil, headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? Bool {
                self.switch_.isOn = dataArray
                self.setEnablDisableState()
                
            }
        }
    }
    func getAddressBook(){
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
                    ]
        let params = ["Currency":"All"]
        MDNetworkManager.shared.sendRequest(methodType: .post,
                                            apiName: API.Get_AddressBook,
                                            parameters: params as NSDictionary,
                                            headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? [NSDictionary] {
                self.dataSource = dataArray
                DispatchQueue.main.async { [weak self] in
                    self?.noDataLbl.isHidden = dataArray.count > 0
                    self?.tableView.reloadData()
                }
            }else{
                self.noDataLbl.isHidden = false
            }
            
        }
    }
    func shouldEnabledWhitelisitng(url:String){
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
                    ]
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName:url, parameters: nil, headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray {
            }
        }
    }
    func delete_crptyo_whitelisting(id:String,label:String){
        MDHelper.shared.showHudOnWindow()
        let headers = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"
                    ]
        let parameter  = [ "Label":label,"ID":id] as NSDictionary
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName:API.Delete_AddressBook, parameters: parameter, headers: headers as NSDictionary) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if let dataArray = response?.valueForCaseInsensativeKey(forKey: "data") as? NSArray {
            }
        }
    }
}

class MDAddressCell : UITableViewCell {
    
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var currencyAddress: UILabel!
    /*
     {
           "ID": 1,
           "Currency": "XRP",
           "Label": "testing",
           "Address": "rPEPPER7kfTD9w2To4CQk6UCfuHM9c6GDY",
           "DT_Memo": "12345"
         }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyName.textColor = Theme.current.titleTextColor
        currencyLbl.textColor = currencyName.textColor
        currencyAddress.textColor = currencyName.textColor
    }
    
    func configureUI(data : NSDictionary){
        self.currencyName.text = data.value(forKey: "Currency") as? String ?? ""
        self.currencyLbl.text = data.value(forKey: "Label") as? String ?? ""
        self.currencyAddress.text = data.value(forKey: "Address") as? String ?? ""
    }
}
