//
//  MDKYCTextField.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 20/05/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDKYCTextField: kycFieldView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underLine: UIView!
    
    let dateFormatter = DateFormatter.init()
    
    let datePicker = UIDatePicker.init()
//    var field:KYCField?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    
    func configure(field:KYCField){
        self.field = field
        titleLabel.text = field.fieldTitle
        textField.placeholder = field.description
        textField.text = field.value
        if field.inputType == KYCField.inputTypes.Date.rawValue{
            datePicker.datePickerMode = .date
            let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dateDidSelect(sender:)))
            textField.inputAccessoryView = toolBar
            textField.inputView = datePicker
        }
        
    }
    
    @objc func dateDidSelect(sender:Any){
        dateFormatter.dateFormat = "MM/dd/yyyy"
        textField.resignFirstResponder()
        textField.text = "\(dateFormatter.string(from: datePicker.date))"
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        titleLabel.textColor = Theme.current.titleTextColor
        self.backgroundColor = UIColor.clear
        bgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        textField.textColor = Theme.current.titleTextColor
        textField.placeHolderColorCustom = Theme.current.subTitleColor
        underLine.backgroundColor = Theme.current.titleTextColor
    }
 

}
