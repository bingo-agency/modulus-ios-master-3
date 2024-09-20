//
//  MDCurrencyVC.swift
//  Modulus
//
//  Created by Pathik  on 25/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDCurrencyVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var data = [("KRW (₩)",false),("KRW (₩)",false),("KRW (₩)",false),("KRW (₩)",false),("KRW (₩)",true),("KRW (₩)",false)]
    var languageData = [(localised("English"),false,"en"),
                        (localised("Chinese"),false,"zh-Hans")]
    
    
    let currencyCellIdentifier = "currencyCell"
    let languageCellIdentifier = "languageCell"
    var selectedIndexPath:IndexPath? = nil
    var isLanguage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUPVC()
    }
    
    private
    func setUPVC(){
        self.view.backgroundColor = .green
        self.tableView.backgroundColor = Theme.current.backgroundColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        setNavigationbar()
    }
    
    //MARK:- navigation bar helprs
    func setNavigationbar(){
        
        //For Automation
        self.navigationItem.backBarButtonItem?.isAccessibilityElement = true
        self.navigationItem.backBarButtonItem?.accessibilityIdentifier = "NavigationBackButton"
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "NavigationBackButton"
        
        
        self.navigationItem.backBarButtonItem?.title = ""
    
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = isLanguage == false ? "Currency" :localised("Language")
        label.textColor = Theme.current.titleTextColor
        self.navigationItem.titleView = label
    }
}

extension MDCurrencyVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLanguage == false ?  data.count : languageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        if isLanguage == false{
           let currencyCell = tableView.dequeueReusableCell(withIdentifier: currencyCellIdentifier) as! currencyCell
            let cellData = data[indexPath.row]
            currencyCell.configure(data: cellData)
            cell = currencyCell
        }else{
            let currencyCell = tableView.dequeueReusableCell(withIdentifier: languageCellIdentifier) as! languageCell
            let cellData = languageData[indexPath.row]
            currencyCell.configure(data: cellData)
            cell = currencyCell
        }
            

        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        for (index, _) in data.enumerated(){
//            if index == indexPath.row{
//                data[index].1 = true
//            }else{
//                data[index].1 = false
//            }
//        }
        if isLanguage == true{
            selectedIndexPath = indexPath
            MDAlertPopupView.showAlertPopupViewOnWidnow(title: localised("appName"), errorMessage:localised("Are you sure you want to change language to")+" "+localised(languageData[indexPath.row].0)+" ?", alertDelegate: self)
        }
        
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}

extension MDCurrencyVC:alertPopupDelegate{
    func alertPopupResponse(isAgree: Bool) {
        if isAgree == true{
            if selectedIndexPath != nil{
                let selectedLanguageData = languageData[selectedIndexPath!.row]
                LocalizationSystem.sharedInstance.setLanguage(languageCode: selectedLanguageData.2)
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let viewc = storyboard.instantiateViewController(withIdentifier: "baseTabBarNavigationController")
                DispatchQueue.main.async {
                    self.appDelegate.window?.rootViewController = viewc
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(.init(name: NSNotification.Name.init("market_group_added")))
                }
            }
        }
    }
    
    
}



class currencyCell:UITableViewCell{
    //MARK: - StoryBoard outlets
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var tickIcon: UIImageView!
    @IBOutlet weak var cellSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellSeparatorView.backgroundColor = Theme.current.accountCellSeparator
    }
    
    func configure(data:(String,Bool)){
        currencyTitle.text = data.0
        if data.1 == true{
            currencyTitle.textColor = UIColor.init(hex: 0x56BE19)
            tickIcon.isHidden = false
            currencyTitle.font = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 17)
        }else{
            currencyTitle.textColor = UIColor.init(hex: 0xFFFFFF)
            tickIcon.isHidden = true
            currencyTitle.font = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 17)
        }
    }
}

//MARK: - Lang Cell -
class languageCell:UITableViewCell{
    //MARK: - StoryBoard outlets
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var cellSeparatorView: UIView!
    @IBOutlet weak var tickIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.currencyTitle.textColor = Theme.current.titleTextColor
        self.cellSeparatorView.backgroundColor = Theme.current.accountCellSeparator
        self.contentView.backgroundColor = Theme.current.backgroundColor
    }
    
    func configure(data:(String,Bool,String)){
        currencyTitle.text = data.0
        if data.2.contains(LocalizationSystem.sharedInstance.getLanguage()){
            tickIcon.isHidden = false
            currencyTitle.font = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 17)
        }else{
            tickIcon.isHidden = true
            currencyTitle.font = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 17)
        }
    }
}
