//
//  MDAssestCell.swift
//  Modulus
//
//  Created by Abhijeet on 10/19/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit


class MDAssestCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialiseCell()
    }
    @IBOutlet weak var cellBgView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    let checkMarkImg : UIImage?  =  UIImage(named: "checkmark_2")
    @IBOutlet weak var imgDeposit: UIImageView!
    @IBOutlet weak var lbl_depo_enable: UILabel!
    
    @IBOutlet weak var img_withdrawals: UIImageView!
    @IBOutlet weak var lbl_withdrawalas_enable: UILabel!
    
    @IBOutlet weak var imtrade: UIImageView!
    @IBOutlet weak var lbl_trade_enable: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_ticker: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialiseCell(){
        self.lbl_name.textColor = Theme.current.titleTextColor
        self.lbl_ticker.textColor = self.lbl_name.textColor
        self.lbl_depo_enable.textColor = self.lbl_name.textColor
        self.lbl_withdrawalas_enable.textColor = self.lbl_name.textColor
        self.lbl_trade_enable.textColor = self.lbl_name.textColor
        
        self.cellBgView.backgroundColor = Theme.current.mainTableCellsBgColor
       // self.contentView.backgroundColor = 
    }
    
    override func prepareForReuse() {
        self.lbl_depo_enable.text = nil
        self.imgDeposit.image = nil
        self.lbl_withdrawalas_enable.text = nil
        self.img_withdrawals.image = nil
        self.lbl_trade_enable.text = nil
        self.imtrade.image = nil
    }

    func configureCell(data : [String:Any]){
        self.lbl_name.text = data["fullName"] as? String ?? ""
        self.lbl_ticker.text = data["shortName"] as? String ?? ""
        let isdepositEnable = data["depositEnabled"] as? Bool ?? false
        self.lbl_depo_enable.text = isdepositEnable ? "" : "" // "Enabled" : "Disabled"
        self.imgDeposit.image = self.getEnableDisable_Image(flag: isdepositEnable)
        self.imgDeposit.tintColor = isdepositEnable ? .green : .red
        let iswithdrawalEnable = data["withdrawalEnabled"] as? Bool ?? false
        self.lbl_withdrawalas_enable.text = iswithdrawalEnable ? "" : "" // "Enabled" : "Disabled"
        self.img_withdrawals.image = self.getEnableDisable_Image(flag: iswithdrawalEnable)
        self.img_withdrawals.tintColor = iswithdrawalEnable ? .green : .red
        let istradeEnable = data["tradeEnabled"] as? Bool ?? false
        self.lbl_trade_enable.text = istradeEnable ? "" : "" // "Enabled" : "Disabled"
        self.imtrade.image = self.getEnableDisable_Image(flag: istradeEnable)
        self.imtrade.tintColor = istradeEnable ? .green : .red
        let coinName : String = data["shortName"] as? String ?? ""
        iconImgView.image = MDHelper.shared.getImageByCurrencyCode(code: coinName)
        
    }
    private func getEnableDisable_Image(flag:Bool) -> UIImage?{
        if flag {
            return self.checkMarkImg
        }else{
            return (UIImage(named: "crossCircle"))
        }
    }
}
