//
//  MDHistoryCell.swift
//  Modulus
//
//  Created by Pathik  on 29/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
enum WalletType {
    case Deposit
    case Withdraw
}
class MDHistoryCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    var selectedCurrency = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpColors()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        setUpColors()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(cellData:NSDictionary,type:WalletType) {
        setUpColors()
        if type == WalletType.Deposit{
            if let requestAmount = cellData.valueForCaseInsensativeKey(forKey: "requestAmount") as? Double,let type = cellData.valueForCaseInsensativeKey(forKey: "type") as? String{
                currencyLabel.text = "\(selectedCurrency)  \(type)  \(requestAmount)"
                
            }
            if let depositType = (cellData.valueForCaseInsensativeKey(forKey: "depositType") as? String) {
                var amountText = ""
                
                if let amount = (cellData.valueForCaseInsensativeKey(forKey: "depositAmount") as? Double){
                    amountText = String(amount)
                }
//                if let requestAmount = cellData.valueForCaseInsensativeKey(forKey: "requestAmount") as? Double,let type = cellData.valueForCaseInsensativeKey(forKey: "type") as? String{
//                    currencyLabel.text = "\(selectedCurrency) Type:\(type) Amount:\(requestAmount)"
//
//                }else{
                    currencyLabel.text = "\(depositType) \(amountText)"
//                }
            }
            if let depositStatus = (cellData.valueForCaseInsensativeKey(forKey: "depositStatus") as? String ?? cellData.valueForCaseInsensativeKey(forKey: "status") as? String){
                statusLabel.text = depositStatus
            }
            if let reqDateStr = (cellData.valueForCaseInsensativeKey(forKey: "depositReqDate") as? String ?? cellData.valueForCaseInsensativeKey(forKey: "requestDate") as? String){
                timeLabel.text = self.getStringFromDateForTrasactionHistory(dateStr: reqDateStr)
            }
        }else if type == WalletType.Withdraw {
            
            if let withdrawalType = cellData.valueForCaseInsensativeKey(forKey: "withdrawalType") as? String{
                var amountText = ""
                
                if let amount = cellData.valueForCaseInsensativeKey(forKey: "withdrawalAmount") as? Double {
                    amountText = String(amount)
                }
                currencyLabel.text = "\(withdrawalType) \(amountText)"
            }
            if let withdrawalStatus = cellData.valueForCaseInsensativeKey(forKey: "withdrawalStatus") as? String{
                statusLabel.text = withdrawalStatus
            }
            
            if let reqDateStr = cellData.valueForCaseInsensativeKey(forKey: "withdrawalReqDate") as? String{
                timeLabel.text = self.getStringFromDateForTrasactionHistory(dateStr: reqDateStr)
            }
        }
    }
    func getStringFromDateForTrasactionHistory(dateStr : String) ->String {
        var dateToReturn = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
          formatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = formatter.date(from: dateStr)
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter2.timeZone = .current
        if let date = localDate {
            dateToReturn = formatter2.string(from: date)
        }
        return dateToReturn
    }
    
    func setUpColors(){
        bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        currencyLabel.textColor = Theme.current.titleTextColor
        timeLabel.textColor = Theme.current.subTitleColor
        statusLabel.textColor = Theme.current.subTitleColor
    }
}

