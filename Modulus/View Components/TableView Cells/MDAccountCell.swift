//
//  MDAccountCell.swift
//  Modulus
//
//  Created by Pathik  on 12/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDAccountCell: UITableViewCell {
    @IBOutlet weak var cellSeperatorView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var logoutImageView: UIImageView!
    
    @IBOutlet weak var accesoryLabel: UILabel!
    static let resuableID = "MDAccountCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpColors()
    }
    func configureCell(name:String,isLogout: Bool = false) {
        setUpColors()
        let symbol = "\u{232A}"
        self.cellNameLabel.text = name
        self.logoutImageView.isHidden = false
        
        //For Automation Testing
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = name
        self.accessibilityLabel = name
        
        
        
        
        self.accesoryLabel.text = symbol//U+27EB
        accesoryLabel.isHidden = false
        
        if name == localised("Fiat Currency"){
            if let selectedCurrencyDetails = UserDefaults.standard.value(forKey: "fiatSelectedCurrency") as? [String:Any],
                let currencyName = selectedCurrencyDetails["currency"] as? String{
                self.accesoryLabel.text = "\(currencyName)  \(symbol)"
            }
            
            
    
        }
        if name == localised("Language") {
            self.accesoryLabel.text = "\(LocalizationSystem.sharedInstance.getLanguage().uppercased())  \(symbol)"
        }
        if isLogout {
            self.cellSeperatorView.backgroundColor = .clear
            self.logoutImageView.isHidden = false
            self.logoutImageView.image = UIImage.init(named: "logout")
            self.logoutImageView.tintColor = Theme.current.primaryColor
            self.cellNameLabel.textColor = Theme.current.primaryColor
            accesoryLabel.isHidden = true
        }else{
            self.logoutImageView.isHidden = true
        }
    }
    //MARK:- setup appeareance
    func setUpColors(){
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.cellSeperatorView.backgroundColor = Theme.current.accountCellSeparator
        self.cellNameLabel.textColor = Theme.current.titleTextColor
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
