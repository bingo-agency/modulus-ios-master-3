//
//  MDKYCPanelField.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 21/05/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDKYCPanelField: kycFieldView {

    @IBOutlet weak var titleLabel: UILabel!
//    var field:KYCField?
    
    func configure(field:KYCField){
        self.field = field
        titleLabel.text = field.fieldTitle
        
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
         titleLabel.textColor = Theme.current.titleTextColor
    }
    

}
