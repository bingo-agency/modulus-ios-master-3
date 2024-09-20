//
//  MDWhiteListedTableViewCell.swift
//  Modulus
//
//  Created by Abhijeet on 10/5/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
protocol MDWhiteListedTableViewCellDelegate:class {
    func didDeletedPressCall(id:Int)
}
class MDWhiteListedTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_deviceName: UILabel!
    @IBOutlet weak var lbl_browserName: UILabel!
    @IBOutlet weak var lbl_ip: UILabel!
    @IBOutlet weak var lbl_os: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    weak var delegate :MDWhiteListedTableViewCellDelegate?
    var selectedModel: MDWhiteListedCellHelperStruct?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.lbl_date.textColor = Theme.current.titleTextColor
        self.lbl_deviceName.textColor = self.lbl_date.textColor
        self.lbl_browserName.textColor = self.lbl_date.textColor
        self.lbl_ip.textColor = self.lbl_date.textColor
        self.lbl_os.textColor = self.lbl_date.textColor
        self.btn_delete.backgroundColor = Theme.current.primaryColor
        self.btn_delete.setTitleColor(Theme.current.btnTextColor, for: .normal)
    }
    func configureCell(model:MDWhiteListedCellHelperStruct){
        self.selectedModel = model
        self.btn_delete.layer.cornerRadius = 6.0
        self.btn_delete.isHidden = model.device_id == "this" ? true : false
        self.btn_delete.layer.masksToBounds = false
        self.lbl_date.text = model.date
        self.lbl_deviceName.text = model.device
        self.lbl_browserName.text = "Browser: \(model.browser)"
        self.lbl_ip.text = "IP: \(model.ip)"
        self.lbl_os.text = "OS: \(model.OS)"
    }

    @IBAction func btn_deleteAction(_ sender: Any) {
        guard let model = self.selectedModel else {return}
        self.delegate?.didDeletedPressCall(id: model.id)
    }
}
struct MDWhiteListedCellHelperStruct{
    var id :Int
    var date:String
    var device:String
    var browser:String
    var ip:String
    var device_id:String
    var OS:String
}
