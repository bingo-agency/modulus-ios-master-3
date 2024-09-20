//
//  MDIPWhiteListingCell.swift
//  Modulus
//
//  Created by Abhijeet on 10/19/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
protocol  MDIPWhiteListingCellDelegate : class{
    func deleteSelected(cell : MDIPWhiteListingCell)
}
class MDIPWhiteListingCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dlt_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_date.textColor = Theme.current.titleTextColor
        self.lbl_ipaddress.textColor = self.btn_date.textColor
        self.lbl_type.textColor = self.btn_date.textColor
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.dlt_btn.setTitleColor(Theme.current.btnTextColor, for: .normal)
        self.dlt_btn.backgroundColor = Theme.current.primaryColor
    }
    weak var delegate : MDIPWhiteListingCellDelegate?
    @IBOutlet weak var lbl_ipaddress: UILabel!
    @IBOutlet weak var lbl_type: UILabel!
    
    @IBOutlet weak var btn_date: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btn_deleteAction(_ sender: Any) {
        self.delegate?.deleteSelected(cell:self)
    }
}
