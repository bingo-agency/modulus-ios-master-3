//
//  MDDropDownCell.swift
//  Modulus
//
//  Created by Pathik  on 16/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import DropDown
class MDDropDownCell: DropDownCell {
    @IBOutlet weak var suffixLabel: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
