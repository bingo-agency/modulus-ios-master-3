//
//  MDHistoryTableViewCell.swift
//  Modulus
//
//  Created by Abhijeet on 12/29/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lbl_request_date: UILabel!
    @IBOutlet weak var lbl_depositDate: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialiseCell()
    }
    
    private
    func initialiseCell(){
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
       for each in [self.lbl_request_date , lbl_depositDate , lbl_amount , lbl_status]{
        each?.textColor = Theme.current.titleTextColor
       }
    }
    
    func configureCellForDeposite(data : [String:Any]){
        var amount = "\(data["depositAmount"] as? Double ?? 0) \(data["depositType"] as? String ?? "")"
        
        let status : String
        if let depStatus = data["status"] as? String{
          status = depStatus
            if status == "Pending"{
                amount =  "\(data["requestAmount"] as? Double ?? 0)"
            }
        }else{
            status = (data["depositReqDate"] as? String) == nil ? "Fail" : "Completed"
        }
        
        let requiredDate = data["depositReqDate"] as? String ?? data["requestDate"] as? String ?? ""
        let confirmDate = data["depositConfirmDate"] as? String ?? ""
        self.lbl_request_date.text = requiredDate.getDateForString()?.getFormattedDate(format: "MM/dd/yyyy HH:mm") ?? ""
        self.lbl_depositDate.text =  confirmDate.getDateForString()?.getFormattedDate(format: "MM/dd/yyyy HH:mm") ?? ""
        self.lbl_amount.text =  amount
        self.lbl_status.text = status
    }
    
    func configureCellForWithdrawal(data : [String:Any]){
        let amount = "\(data["withdrawalAmount"] as? Double ?? 0) \(data["withdrawalType"] as? String ?? "")"
        let type = data["type"] as? String ?? ""
        let status = (data["withdrawalStatus"] as? String)
        let requiredDate = data["withdrawalReqDate"] as? String ?? ""
        self.lbl_request_date.text = requiredDate.getDateForString()?.getFormattedDate(format: "MM/dd/yyyy HH:mm")
        self.lbl_depositDate.text = type
        self.lbl_amount.text =  amount
        self.lbl_status.text = status
    }
    
    static func registerCell(tableView:UITableView){
        let nib = UINib(nibName: "MDHistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MDHistoryTableViewCell")
    }
    static func getCell(tableView:UITableView,indexPath:IndexPath) -> MDHistoryTableViewCell{
        return tableView.dequeueReusableCell(withIdentifier: "MDHistoryTableViewCell",for: indexPath) as! MDHistoryTableViewCell
    }
}
extension String{
    func getDateForString() -> Date?{
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // Convert String to Date
        return dateFormatter.date(from: self)
    }
}
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
