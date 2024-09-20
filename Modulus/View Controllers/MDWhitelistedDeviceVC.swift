//
//  MDWhitelistedDeviceVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/5/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDWhitelistedDeviceVC: UIViewController {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sep1: UIView!
    @IBOutlet weak var sep2: UIView!
    var listArr:[[String:Any]] = []
    var temp_listArr:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigation()
        self.setupSearchBar()
        self.getwhiteListedDeviceList()
        self.setUpColors()
        //print(getIPAddress())
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        self.searchBarView.backgroundColor = Theme.current.backgroundColor
        self.tableView.backgroundColor = Theme.current.backgroundColor
        let textFieldInsideSearchBar = searchbar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = Theme.current.titleTextColor
        textFieldInsideSearchBar?.font = UIFont.systemFont(ofSize: 15)
        
        self.sep1.backgroundColor = Theme.current.backgroundColor
        self.sep2.backgroundColor = self.sep1.backgroundColor
    }
    
    func setUpNavigation(){
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = localised("Whitelisted Device")
        self.navigationItem.titleView = label
    }
    //MARK: - Setup searchbar
    func setupSearchBar(){
        self.searchbar.delegate = self
        self.searchbar.layer.cornerRadius = 12
        self.searchbar.layer.masksToBounds = false
    }
    func reloadTableView()  {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
//MARK:// APi Call Functions
extension MDWhitelistedDeviceVC{
    private func showLoader(){
        MDHelper.shared.showHudOnWindow()
    }
    private func hideLoader(){
        MDHelper.shared.hideHudOnWindow()
    }
    func getwhiteListedDeviceList(){
        self.showLoader()
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDNetworkManager.shared.sendJSONRequest(methodType: .get, apiName: API.getwhitelisted, parameters: nil, headers: headers as NSDictionary){ (dictionar, error) in
            self.hideLoader()
            self.listArr = dictionar?["data"] as? [[String:Any]] ?? []
            self.temp_listArr = self.listArr
            self.reloadTableView()
        }
    }
    
    
    func delete_device_fromWhiteListed(device_id :Int){
        self.showLoader()
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        let params = ["id":device_id] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: API.deletedwhitelisted, parameters: params as NSDictionary, headers: headers as NSDictionary) { (dictionar, error) in
            self.getwhiteListedDeviceList()
            self.hideLoader()
            self.reloadTableView()
        }
    }
}
//MARK: // Tableview Delegate and DataSource
extension MDWhitelistedDeviceVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.listArr[indexPath.item]
        let cell_ = tableView.dequeueReusableCell(withIdentifier: "MDWhiteListedTableViewCell", for: indexPath) as! MDWhiteListedTableViewCell
        cell_.configureCell(model: self.getCellModel_fromDictionary(dict: data))
        cell_.backgroundColor = .clear
        cell_.delegate = self
        return cell_
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
//MARK: MDWhiteListedTableViewCellDelegate
extension MDWhitelistedDeviceVC :MDWhiteListedTableViewCellDelegate {
    func didDeletedPressCall(id: Int) {
        var popUpWindow: PopUpWindow!
        popUpWindow = PopUpWindow(title: "Error", text: "Sorry, that email address is already used!", buttontext: "OK")
        popUpWindow.isYesIsPresses = { (isyes) in
            if isyes {
                self.delete_device_fromWhiteListed(device_id: id)
            }
        }
        self.present(popUpWindow, animated: true, completion: nil)
        
    }
}
//MARK: // Searchbardelegate
extension MDWhitelistedDeviceVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let queryText = self.searchbar.text,queryText.count > 0 {
            self.listArr =  self.temp_listArr.filter({ (dict) -> Bool in
              let date :String = self.formatDate(date: dict["addedOn"] as? String ?? "")
                let browser :String = self.formatDate(date: dict["browser"] as? String ?? "")
               return date.prefix(queryText.count).lowercased().contains(queryText.lowercased()) ||
                browser.prefix(queryText.count).lowercased().contains(queryText.lowercased())
           })
        }else{
            self.listArr =  self.temp_listArr
        }
        self.reloadTableView()
    }
}
//MARK: // conversion Helper
extension MDWhitelistedDeviceVC {
    
   
    
    func getCellModel_fromDictionary(dict:[String:Any]) -> MDWhiteListedCellHelperStruct{
        let date :String = self.formatDate(date: dict["addedOn"] as? String ?? "")
        let device :String = dict["device"] as? String ?? ""
        let browser :String = dict["browser"] as? String ?? ""
        let ip_add :String = dict["ip"] as? String ?? ""
        let device_id :String = dict["deviceID"] as? String ?? ""
        let os :String = dict["os"] as? String ?? ""
        let id :Int = dict["id"] as? Int ?? 0
        return MDWhiteListedCellHelperStruct(id: id, date: date, device: device, browser: browser, ip: ip_add, device_id: device_id, OS: os)
    }
}
extension UIViewController {
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

 func getIPAddress() -> String? {
       var address: String?
       var ifaddr: UnsafeMutablePointer<ifaddrs>?
       if getifaddrs(&ifaddr) == 0 {
           var ptr = ifaddr
           while ptr != nil {
               defer { ptr = ptr?.pointee.ifa_next }
               let interface = ptr?.pointee
               let addrFamily = interface?.ifa_addr.pointee.sa_family
               if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6),
                   let cString = interface?.ifa_name,
                   String(cString: cString) == "en0",
                   let saLen = (interface?.ifa_addr.pointee.sa_len) {
                   var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                   let ifaAddr = interface?.ifa_addr
                   getnameinfo(ifaAddr,
                               socklen_t(saLen),
                               &hostname,
                               socklen_t(hostname.count),
                               nil,
                               socklen_t(0),
                               NI_NUMERICHOST)
                   address = String(cString: hostname)
               }
           }
           freeifaddrs(ifaddr)
       }
       return address
   }
