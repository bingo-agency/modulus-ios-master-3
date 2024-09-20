//
//  MDIPWhiteListingVCViewController.swift
//  Modulus
//
//  Created by Abhijeet on 10/18/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDIPWhiteListingVCViewController: UIViewController {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var sep1: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var sep2: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var ipAddressHeaderView: UIView!
    @IBOutlet weak var ipAddView: MarketListHeaders!
    @IBOutlet weak var txt_field_ip: UITextField!
    @IBOutlet weak var btn_ipAdd: UIButton!
    var listArr : [[String:Any]] = []
    var temp_list_arr : [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegate()
        btn_ipAdd.layer.cornerRadius = 6.0
        btn_ipAdd.layer.masksToBounds = false
        self.setUpNavigation()
        self.enableButton()
        self.getIPWhiteList()
        txt_field_ip.delegate = self
        txt_field_ip.returnKeyType = .done
        let textFieldInsideSearchBar = searchbar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.font = UIFont.systemFont(ofSize: 15)
        self.setUpColors()
        // Do any additional setup after loading the view.
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.searchBarView.backgroundColor = Theme.current.backgroundColor
        self.sep1.backgroundColor = Theme.current.navigationBarColor
        self.sep2.backgroundColor = self.sep1.backgroundColor
        
        self.ipAddressHeaderView.backgroundColor = Theme.current.navigationBarColor
        self.btn_ipAdd.backgroundColor = Theme.current.primaryColor
        self.ipAddView.backgroundColor = Theme.current.navigationBarColor
        self.tblView.backgroundColor = Theme.current.backgroundColor
      
        let textFieldInsideSearchBar = searchbar.value(forKey: "searchField") as? UITextField

        textFieldInsideSearchBar?.textColor = Theme.current.titleTextColor
        
        self.txt_field_ip.textColor = Theme.current.titleTextColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btn_ipAdd.setTitleColor(Theme.current.btnTextColor, for: .normal)
        }
        
    }
    
    // Setup Delegate
    func setupDelegate(){
        self.searchbar.delegate = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    func enableButton(){
        let shouldEnable : Bool =  self.txt_field_ip.text?.count ?? 0 > 0
        self.btn_ipAdd.isUserInteractionEnabled = shouldEnable
        self.btn_ipAdd.alpha = shouldEnable ? 1.0 : 0.6
    }
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = "IP WhiteListing"
        self.navigationItem.titleView = label
    }
    @IBAction func btn_addIPAddress(_ sender: Any) {
        self.addIPList(cidr: self.txt_field_ip.text ?? "")
    }
    
    
}
//MARK: API Call
extension MDIPWhiteListingVCViewController{
    func getIPWhiteList(){
        MDHelper.shared.showHudOnWindow()
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.Get_IP_Whitelist, parameters:nil, headers: headers as NSDictionary) { (dict, err) in
            MDHelper.shared.hideHudOnWindow()
            if let data = dict as? [String:Any] , let data_ = data["data"] as? [[String:Any]]{
                self.listArr = data_
                self.temp_list_arr = data_
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    func addIPList(cidr:String){
        MDHelper.shared.showHudOnWindow()
        let headers = ["Authorization":MDNetworkManager.shared.authToken,"Content-Type": "application/json","Accept":"application/json"] as [String : Any]
        let param = ["cidr": cidr + "/32","type":"Login"]
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: API.Add_IP_Whitelist, parameters:param as NSDictionary, headers: headers as NSDictionary) { (dict, err) in
            MDHelper.shared.hideHudOnWindow()
            if let data = dict as? [String:Any] , let data_ = data["status"] as? String , data_.lowercased() == "success"{
                self.txt_field_ip.text = nil
                self.enableButton()
                self.getIPWhiteList()
            }
        }
    }
    func delete_ip_listing(cidr:String,type:String){
        MDHelper.shared.showHudOnWindow()
        let headers = ["Authorization":MDNetworkManager.shared.authToken,"Content-Type": "application/json"] as [String : Any]
        let param = ["cidr": cidr,"type":type]
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: API.Delete_IP_Whitelist, parameters:param as NSDictionary, headers: headers as NSDictionary) { (dict, err) in
            MDHelper.shared.hideHudOnWindow()
            if let data = dict as? [String:Any] , let data_ = data["status"] as? String , data_.lowercased() == "success"{
                if cidr == self.getIP(){
                    MDHelper.shared.logOut()
                    return
                }
                self.getIPWhiteList()
            }
        }
        
    }
    func getIP()-> String? {

    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {

        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee

            let interface = ptr?.pointee
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                 let name: String = String(cString: (interface?.ifa_name)!)
                if name == "en0" { // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }

            }
        }
        freeifaddrs(ifaddr)
      }

      return address
    }
}
//MARK: // Tableview Delegate and DataSource
extension MDIPWhiteListingVCViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.listArr[indexPath.item]
        let cell_ = tableView.dequeueReusableCell(withIdentifier: "MDIPWhiteListingCell", for: indexPath) as! MDIPWhiteListingCell
        cell_.lbl_type.text = data["type"] as? String ?? ""
        cell_.lbl_ipaddress.text = data["cidr"] as? String ?? ""
        cell_.btn_date.text = self.formatDate(date: data["addedOn"] as? String ?? "")
        cell_.delegate = self
        return cell_
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
//MARK: // Searchbardelegate
extension MDIPWhiteListingVCViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let queryText = self.searchbar.text,queryText.count > 0 {
            self.listArr =  self.temp_list_arr.filter({ (dict) -> Bool in
                let date :String =  dict["cidr"] as? String ?? ""
                let browser :String =  dict["type"] as? String ?? ""
                return date.prefix(queryText.count).lowercased().contains(queryText.lowercased()) ||
                    browser.prefix(queryText.count).lowercased().contains(queryText.lowercased())
            })
        }else{
            self.listArr =  self.temp_list_arr
        }
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}
extension MDIPWhiteListingVCViewController : MDIPWhiteListingCellDelegate {
    func deleteSelected(cell: MDIPWhiteListingCell) {
        if let indexpath = self.tblView.indexPath(for: cell){
            let data = self.listArr[indexpath.item]
            self.delete_ip_listing(cidr: data["cidr"] as? String ?? "", type: data["type"] as? String ?? "")
        }
    }
}
extension MDIPWhiteListingVCViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.enableButton()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.enableButton()
    }
}
