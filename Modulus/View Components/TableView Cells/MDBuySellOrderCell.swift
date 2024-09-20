//
//  MDBuySellOrderCell.swift
//  Modulus
//
//  Created by Pathik  on 03/11/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDBuySellOrderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func draw(_ rect: CGRect) {
        self.bgView.backgroundColor = Theme.current.BuySellScreentextFiledBgColor
        self.volumeLabel.textColor = Theme.current.titleTextColor
    }

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell(data:NSDictionary,currency:String , decimalPrecision : Int){
        
        if let price = data.valueForCaseInsensativeKey(forKey: "Rate") as? Double{
            priceLabel.text = MDHelper.shared.getFormattedNumber(amount: price, minimumFractionDigits: decimalPrecision) ?? "" + " " + currency
        }
        if let volume = data.valueForCaseInsensativeKey(forKey: "Volume") as? Double{
            volumeLabel.text = String(format: "%.\(decimalPrecision)f", volume)//"\("\(volume)".prefix(8))"
            volumeLabel.text = MDHelper.shared.getFormattedNumber(amount: volume, minimumFractionDigits: 4) 
            
        }
        if let volume = data.valueForCaseInsensativeKey(forKey: "PendingVolume") as? Double{
            volumeLabel.text = String(format: "%.\(decimalPrecision)f", volume)//"\("\(volume)".prefix(8))"
        }
        
    }
}
