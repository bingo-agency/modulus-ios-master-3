//
//  MDOrderHistoryCell.swift
//  Modulus
//
//  Created by Pranay Jadhav on 05/06/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDOrderHistoryCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var currencyPairLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var usdPriceLabel: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    var cellData :NSDictionary?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        bgView.backgroundColor = Theme.current.mainTableCellsBgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(data:NSDictionary,selected: Bool = false){
        cellData = data
        //print("Data \(data)")
        let pairName : String
        
        if let currencyPair = data.valueForCaseInsensativeKey(forKey: "currencyPair") as? String{
            pairName = currencyPair
            currencyPairLabel.text = pairName.replacingOccurrences(of: "-", with: "/")
        }else{
            if let trade = data.value(forKey: "trade") as? String , let market = data.value(forKey: "market"){
                pairName = "\(trade)-\(market)"
                self.currencyPairLabel.text = "\(trade)/\(market)"
            }else{
                pairName = ""
                self.currencyPairLabel.text = "N/A"
            }
        }
            
            
        if let rate = data.valueForCaseInsensativeKey(forKey: "tradePrice") as? String{
            let rateDouble = self.getDoubleValueFromString(str: rate)
            let splitCurrency = pairName.components(separatedBy: "-")
            self.priceLabel.text = "\(rateDouble)" + " " + splitCurrency[1]
                if let volumeStr = data.valueForCaseInsensativeKey(forKey: "size") as? String{
                    let volumeDouble = self.getDoubleValueFromString(str: volumeStr)
                    volume.text = "\(volumeDouble)"
                    totalAmount.text = "\(rateDouble * volumeDouble)"
                    if splitCurrency.count > 1{
                        usdPriceLabel.text = MDHelper.shared.getFiatEstimatedPriceString(amount: rateDouble , baseCurrency:splitCurrency[1])
                    }
                }
        
        }else{
            if let rate = data.value(forKey: "rate") as? Double ,let market = data.value(forKey: "market") as? String,
               let volume = data.value(forKey: "volume") as? Double{
                self.priceLabel.text = String(rate) + " " + market
                self.usdPriceLabel.text = MDHelper.shared.getFiatEstimatedPriceString(amount: rate , baseCurrency:market)
                self.volume.text = "\(volume)"
                self.totalAmount.text = "\(rate * volume)"
            }
        }
        
        
        if let side = data.valueForCaseInsensativeKey(forKey: "side") as? String{
            switch side {
                case "BUY":
                    self.setTextColour(color: Theme.current.secondaryColor)
                case "SELL":
                    self.setTextColour(color: Theme.current.redColor)
                default:
                    break
            }
            
        }
        if selected == true{
            bgView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        }else{
            if #available(iOS 11.0, *) {
                bgView.backgroundColor = Theme.current.mainTableCellsBgColor
            } else {
                // Fallback on earlier versions
                //#FFFFFF
                bgView.backgroundColor = Theme.current.mainTableCellsBgColor
            }
        }
    }
    
    func setTextColour(color : UIColor){
      
        self.currencyPairLabel.textColor = color
        self.priceLabel.textColor = color
        self.usdPriceLabel.textColor = color
        self.volume.textColor = color
        self.totalAmount.textColor = color
        
    }
    
    func getDoubleValueFromString(str:String)->Double{
        let sep = str.components(separatedBy: .whitespaces)
        if sep.count > 0{
            guard sep.first != nil else {return 0}
            if Double(sep.first!) != nil{
                return sep.first!.toDouble()
            }
        }
        return 0
    }

}
