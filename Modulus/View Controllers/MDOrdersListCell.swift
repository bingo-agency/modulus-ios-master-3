//
//  MDOrdersListCell.swift
//  Modulus
//
//  Created by Pathik  on 16/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDOrdersListCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var currencyPairLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var usdPriceLabel: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var coinImgView: UIImageView!
    @IBOutlet weak var coinImgViewWidth: NSLayoutConstraint!
    
    var cellData :NSDictionary?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        if let priceLbl = priceLabel {
            priceLbl.textColor = Theme.current.titleTextColor
        }
        currencyPairLabel.textColor = Theme.current.titleTextColor
       
        if let usbpriceLbl = self.usdPriceLabel {
            usbpriceLbl.textColor = Theme.current.subTitleColor
        }
       
        volume.textColor = Theme.current.titleTextColor
        totalAmount.textColor = Theme.current.titleTextColor
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
//        bgView.backgroundColor = Theme.current.mainTableCellsBgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(data:NSDictionary,selected: Bool = false){
     
        cellData = data
        
        if let market = data.valueForCaseInsensativeKey(forKey: "market") as? String , let trade = data.valueForCaseInsensativeKey(forKey: "trade") as? String{
            
            currencyPairLabel.text = "\(trade)/\(market)"
        }
        
        if let rate = data.valueForCaseInsensativeKey(forKey: "rate") as? Double{
            priceLabel.text = String(format: "%.8f %", rate)
            usdPriceLabel.text = MDHelper.shared.getFiatEstimatedPriceString(amount: rate, baseCurrency: data.valueForCaseInsensativeKey(forKey: "trade") as? String ?? "")

            if let volumeStr = data.valueForCaseInsensativeKey(forKey: "volume") as? Double{
                volume.text = "\(volumeStr)"
                totalAmount.text = String(format: "%.8f", (rate * volumeStr))

            }
            
            
        }
        
//            if let USD = MDHelper.shared.getCurrencyValueInUSD(currency: data.valueForCaseInsensativeKey(forKey: "trade") as? String ?? ""){
//                usdPriceLabel.text = String(format: "%.2f USD", USD)
//            }else{
//                usdPriceLabel.text = ""
//
//            }
        if let side = data.valueForCaseInsensativeKey(forKey: "side") as? String{
            switch side {
            case "BUY":
            self.setTextColour(color: Theme.current.secondaryColor)
            case "SELL":
            self.setTextColour(color: Theme.current.primaryColor)
            default:
                break
            }
        }
        
        
        
        if selected == true{
            bgView.backgroundColor = Theme.current.selectedCellBgColor//UIColor.white.withAlphaComponent(0.4)
        }else{
            bgView.backgroundColor = Theme.current.mainTableCellsBgColor//UIColor.init(named: "cardsBgColorWithoutOpacity")
        }
        
    }
    
    func setTextColour(color : UIColor){
        currencyPairLabel.textColor = color
        priceLabel.textColor = color
        usdPriceLabel.textColor = color
        volume.textColor = color
        totalAmount.textColor = color
    }
    
}
