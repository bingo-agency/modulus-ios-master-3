//
//  MDMarketListCell.swift
//  Modulus
//
//  Created by Pathik  on 16/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDMarketListCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var symbolImageView: UIImageView!
    
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var volumnTitle: UILabel!
    
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var usdValue: UILabel!
    
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var percentImageView: UIImageView!
    @IBOutlet weak var lbl_highcurreny: UILabel!
    @IBOutlet weak var lbl_higcurrency_value: UILabel!
    
    @IBOutlet weak var lbl_lowcurreny: UILabel!
    @IBOutlet weak var lbl_lowcurrency_value: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var cellData:NSDictionary = [:]
    var title:String = ""
    var reloadData :((Bool)->())?
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var btn_favAction: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        usdValue.text = ""
        
        bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        
        currencyTitle.textColor = Theme.current.titleTextColor
        lastPrice.textColor = Theme.current.titleTextColor
        self.usdValue.textColor = Theme.current.titleTextColor
        volumnTitle.textColor = Theme.current.subTitleColor
        self.imgStar.tintColor = .white
        btn_favAction.addTarget(self, action: #selector(fav_action), for: .touchUpInside)
        self.volumnTitle.adjustsFontSizeToFitWidth = true
        self.percentage.adjustsFontSizeToFitWidth = true
        self.currencyTitle.adjustsFontSizeToFitWidth = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        self.imgStar.tintColor = .white
    }
    @objc func fav_action(){
        let flag = UserDefaults.standard.shouldSaveCurreny(data: cellData as! [String : Any])
        self.imgStar.tintColor =  flag ? Theme.current.primaryColor : .white
        if flag == false {
            self.reloadData?(true)
        }
    }
    func configureCellForMarket(data:NSDictionary , isSecurityGroup:Bool){
        cellData = data
        let base = data["base"] as? String ?? ""
        let quote = data["quote"] as? String ?? ""
        self.symbolImageView.image = MDHelper.shared.getImageByCurrencyCode(code: base)
        if isSecurityGroup{
            if let fullName : String = (appDelegate.currencySettings.first(where: {$0.shortName == base})?.fullName) {
                self.title = fullName
            }
            self.title.append(" (\(base))")
        }else{
            self.title = "\(base)/\(quote)"
        }
        
        
        
        self.imgStar.tintColor = (UserDefaults.standard.checkIsDataPresent(data: data as! [String : Any]) != nil) ? Theme.current.primaryColor : .white
        //        if let title = data.allKeys.first as? String{
        currencyTitle.text = title.replacingOccurrences(of: "_", with: "/")
        //        }
        if let baseVol = data.valueForCaseInsensativeKey(forKey: "base_volume") as? Double,
           let min_order_value = data.value(forKey: "min_order_value") as? Double{
            let numberOfDig = MDHelper.shared.getNumberOFDecimals(double: min_order_value)
            volumnTitle.text = localised("Vol") + " " + MDHelper.shared.getFormattedNumber(amount: baseVol, minimumFractionDigits: numberOfDig)!
        }
              
        if let lastPriceVal = data.valueForCaseInsensativeKey(forKey: "price") as? Double {
            let decimalPrecision = MDHelper.shared.getDecimalPrecision(base: base, quote: quote)

            lastPrice.text = MDHelper.shared.getFormattedNumber(amount: lastPriceVal,
                                                                minimumFractionDigits: decimalPrecision.0)
            
            if title == "LTC/BTC"{
                print("Debug")
            }
            
            usdValue.text = MDHelper.shared.getFiatEstimatedPriceString(amount: lastPriceVal,
                                                                        baseCurrency: title.components(separatedBy: "/").last ?? "",
                                                                        shouldUsedForOnlyFiatEstimateViewing: true)
        }

        if let percen = data.valueForCaseInsensativeKey(forKey: "change_in_price") as? Double{
            let percent = String(format: "%.2f %%", percen).replacingOccurrences(of: "-", with: "")
            let prefix = percen < 0 ? "- " : "+ "
            percentage.text = prefix + percent
            
            percentImageView.isHidden = true
            percentage.textColor = percen < 0 ? Theme.current.redColor : Theme.current.secondaryColor
        }
    }
    func forTrailingZero(temp: Double) -> String {
        return String(format: "%g", temp)
    }
}

extension UserDefaults {
    //check isData isPresent
    func checkIsDataPresent(data:[String:Any]) -> (Int?){
        let arr = UserDefaults.standard.array(forKey: "FavCurrency") as? [String] ?? []
        if let index = arr.firstIndex(where: { (dict) -> Bool in
            let check = dict
            let check_to = "\(data["base"] as! String)_\(data["quote"] as! String)"
            return check_to == check
        }){
            return(index)
        }
        return nil
    }
    
    func shouldSaveCurreny(data:[String:Any]) -> Bool{
        var arr = UserDefaults.standard.array(forKey: "FavCurrency") as? [String] ?? []
        let is_present = self.checkIsDataPresent(data: data)
        if let index = is_present {
            arr.remove(at: index)
            self.handleArr_Fav(arr: arr)
            return false
        }else{
            let data = self.getSaveArr(data: [data])
            arr.append(contentsOf: data)
            self.handleArr_Fav(arr: arr)
            return true
        }
    }
    func getSaveArr(data:[[String:Any]])->[String]{
        return data.compactMap { (dict) -> String in
            return  "\(dict["base"] as! String)_\(dict["quote"] as! String)"
        }
    }
    
    func handleArr_Fav(arr:[String]){
        removeAllFav()
        saveArrayFav(arr: arr)
        self.getFavoriteList(arr: arr)
    }
    func removeAllFav(){
        removeObject(forKey: "FavCurrency")
    }
    func saveArrayFav(arr:[String]){
        setValue(arr, forKey: "FavCurrency")
    }
    func getFavArray() -> NSArray{
        object(forKey: "FavCurrency") as! NSArray
    }
    func getFavoriteList(arr:[String]){
        guard UserDefaults.standard.value(forKey: "AccessToken") != nil else { return }
        MDHelper.shared.showHudOnWindow()
        let parameter : [String:Any] = ["data":arr]
        let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: API.Customer_Favourite_Coins, parameters:parameter as NSDictionary, headers: headers as NSDictionary) { (dict, err) in
            MDHelper.shared.hideHudOnWindow()
            dump(dict)
            if let data = dict as? [String:Any] , let data_ = data["status"] as? String , data_.lowercased() == "success",let Arry = data["data"] as? [String]{
                UserDefaults.standard.handleArr_Fav(arr:Arry)
            }
        }
        
    }
}
