//
//  MDOrderTradeCell.swift
//  Modulus
//
//  Created by Pathik  on 19/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDOrderTradeCell: UITableViewCell {
    @IBOutlet weak var tradeLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    var cellData:NSDictionary = NSDictionary()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        let celltype = cellData.valueForCaseInsensativeKey(forKey: "execution_side") as? String
        if celltype?.lowercased() == "buy"{
            self.tradeLabel.textColor = Theme.current.secondaryColor
            self.amountLabel.textColor = Theme.current.secondaryColor
            self.volumeLabel.textColor = Theme.current.secondaryColor
        }else if celltype?.lowercased() == "sell"{
            self.tradeLabel.textColor = Theme.current.redColor
            self.amountLabel.textColor = Theme.current.redColor
            self.volumeLabel.textColor = Theme.current.redColor
        }else{
            self.tradeLabel.textColor = Theme.current.redColor
            self.amountLabel.textColor = Theme.current.redColor
            self.volumeLabel.textColor = Theme.current.redColor
        }
    }
    
    override func layoutSubviews() {
        let celltype = cellData.valueForCaseInsensativeKey(forKey: "execution_side") as? String
        if celltype?.lowercased() == "buy"{
            self.tradeLabel.textColor = Theme.current.secondaryColor
            self.amountLabel.textColor = Theme.current.secondaryColor
            self.volumeLabel.textColor = Theme.current.secondaryColor
        }else if celltype?.lowercased() == "sell"{
            self.tradeLabel.textColor = Theme.current.redColor
            self.amountLabel.textColor = Theme.current.redColor
            self.volumeLabel.textColor = Theme.current.redColor
        }else{
            self.tradeLabel.textColor = Theme.current.redColor
            self.amountLabel.textColor = Theme.current.redColor
            self.volumeLabel.textColor = Theme.current.redColor
        }
    }
    
    func configureCell(data:NSDictionary,isTrade :Bool , decimalPrecision : Int){
        cellData = data
       tradeLabel.text = ""
        amountLabel.text = ""
        volumeLabel.text = ""
        if isTrade {
            if let rate = data.valueForCaseInsensativeKey(forKey: "Rate") as? Double{
                tradeLabel.text = MDHelper.shared.getFormattedNumberWithTrailingZero(amount: rate)
            }
            
            if let volume = data.valueForCaseInsensativeKey(forKey: "Volume") as? Double{
                amountLabel.text = MDHelper.shared.getFormattedNumberWithTrailingZero(amount: volume)
            }
            if let time = data.valueForCaseInsensativeKey(forKey: "timestamp") as? String{
                volumeLabel.text = self.formatDate(date: time)
            }
        }else{
            
            if let price = data.valueForCaseInsensativeKey(forKey: "Rate") as? Double{
                tradeLabel.text = MDHelper.shared.getFormattedNumber(amount: price, minimumFractionDigits: decimalPrecision)
            }
            if let volume = data.valueForCaseInsensativeKey(forKey: "Volume") as? Double{
                amountLabel.text = MDHelper.shared.getFormattedNumber(amount: volume, minimumFractionDigits: 4)
            }
            if let price = data.valueForCaseInsensativeKey(forKey: "Rate") as? Double,let volume = data.valueForCaseInsensativeKey(forKey: "Volume") as? Double{
                volumeLabel.text = MDHelper.shared.getFormattedNumber(amount: price*volume, minimumFractionDigits: 6)
            }
        }
    }
    
    private
    func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        if let dateObj: Date = dateFormatterGet.date(from: date){
            let showDate = dateFormatter.string(from: dateObj)
            return showDate
        }else{
            return date
        }
    }
}
