//
//  MDMoreVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/19/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDMoreVC: UIViewController {
    //MARK: - StoryBoard outlets
    /// Tableview
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    let supoortUrl:String = API.supportURL
    /// Navigation title
    let navigationTitle = localised("More")
    var accountSettings : [moreOptions] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
        self.setNavigationbar()
        self.setUpColors()
        self.check_isBuySellInstaTradeisPresent { (isPresent) in
            DispatchQueue.main.async {
                if isPresent {
                    self.accountSettings = moreOptions.optionslist()
                }else{
                    var data_present = moreOptions.optionslist()
                    data_present.removeAll(where: {$0.index == 6})
                    self.accountSettings = data_present
                }
                self.accountTableView.reloadData()
            }
        }
    }
    
    //MARK:- navigation bar helprs
    /// Set up navigation bar titles and back button
    func setNavigationbar(){
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = MDAppearance.Fonts.largeNavigationTitleFont
        label.text = navigationTitle
        label.textColor = Theme.current.titleTextColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }
    
    //MARK:- setup appeareance
    /// Set up all the colors on this screen
    func setUpColors(){
        self.view.backgroundColor = Theme.current.navigationBarColor
        backgroundView.backgroundColor  = Theme.current.backgroundColor
        self.accountTableView.backgroundColor = .clear
    }
    func check_isBuySellInstaTradeisPresent(completionHandler : @escaping(Bool)->()){
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .get,
                                            apiName: API.get_insta_pairs,
                                            parameters: nil,
                                            headers: nil) { (response, error) in
                                                //Handle Response Here
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if (response?.value(forKey: "data") as? [NSDictionary]) != nil{
                                                            completionHandler(true)
                                                        }
                                                    }else{
                                                        completionHandler(false)
                                                    }
                                                }else{
                                                    if  error != nil{
                                                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                    }
                                                }
        }
    }

}
extension MDMoreVC : UITableViewDelegate , UITableViewDataSource {
    ///Default
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettings.count
    }
    
    ///Default
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    ///Default
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let accountCell = tableView.dequeueReusableCell(withIdentifier: MDAccountCell.resuableID) as! MDAccountCell
        let data = accountSettings[indexPath.row]
        accountCell.configureCell(name: data.name, isLogout: data.index == 10)
        
        return accountCell
    
    }
    
    ///Default
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let data = accountSettings[indexPath.row]
        
        switch data.index {
        case 1: self.performSegue(withIdentifier: "showCurrency", sender: self)
            break
        case 2:self.performSegue(withIdentifier: "CHShowAssest", sender: self); break
        case 3: self.performSegue(withIdentifier: "CHExchangeFeeSegue", sender: self); break
        case 4:self.performSegue(withIdentifier: "MDShowTradingVC", sender: self); break
        case 5: UIApplication.shared.open(URL(string:supoortUrl)!, options: [:], completionHandler: nil) ;break
        case 6: self.performSegue(withIdentifier: "CHIntsaTrade", sender: self); break;
        default:
            break
        }
    }
}
struct moreOptions{
    var index:Int
    var name:String
}
extension moreOptions {
    static func optionslist() -> [moreOptions]{
        return [moreOptions(index: 6, name: localised("Buy/Sell")),
               moreOptions(index: 1, name: localised("Currencies")),
                moreOptions(index: 2, name: localised("Asset Status")),
                moreOptions(index: 3, name: localised("Exchange Fees")),
                moreOptions(index: 4, name: localised("Trading Rules")),
                moreOptions(index: 5, name: localised("Support")),
              ]
    }
}
