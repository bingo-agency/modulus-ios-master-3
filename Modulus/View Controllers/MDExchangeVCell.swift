//
//  MDExchangeVCell.swift
//  Modulus
//
//  Created by Abhijeet on 10/18/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDExchangeVCell: UITableViewCell {
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_tier: UILabel!
    @IBOutlet weak var lbl_holding: UILabel!
    @IBOutlet weak var cellSeperatorView: UIView!
    override func awakeFromNib() {
        self.lbl_discount.textColor = Theme.current.titleTextColor
        self.lbl_tier.textColor = self.lbl_discount.textColor
        self.lbl_holding.textColor = self.lbl_discount.textColor
        self.cellSeperatorView.backgroundColor = Theme.current.accountCellSeparator
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
