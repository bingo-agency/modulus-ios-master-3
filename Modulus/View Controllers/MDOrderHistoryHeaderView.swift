//
//  MDOrderHistoryHeaderView.swift
//  Modulus
//
//  Created by Rahul on 05/10/20.
//  Copyright © 2020 Bhavesh Sarwar. All rights reserved.
//

import UIKit

protocol MDOrderHistoryHeaderViewProtocol {
    func didPressNumberOfRowsButton()
    func didPressCurrencyPairButton()
}

class MDOrderHistoryHeaderView: UIView {
static let identifier = "MDOrderHistoryHeaderView"
    @IBOutlet weak var numberOfRowsLabel: UILabel!
    @IBOutlet weak var currencyPairLabel: UILabel!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var currencypairView: UIView!
    @IBOutlet var arrows: [UIImageView]!
    var delegate : MDOrderHistoryHeaderViewProtocol?
    override func awakeFromNib() {
        for view in [numberView,currencypairView]{
            view?.layer.cornerRadius = 2
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGray.cgColor
        }
        self.backgroundColor = Theme.current.backgroundColor
        self.numberOfRowsLabel.textColor = Theme.current.titleTextColor
        self.currencyPairLabel.textColor = Theme.current.titleTextColor
        self.arrows.forEach({$0.tintColor = Theme.current.subTitleColor})
        
    }
    
    @IBAction func numberofRowsButtonPressed(_ sender: UIButton) {
        delegate?.didPressNumberOfRowsButton()
    }
    
    @IBAction func currencyPairButtonPressed(_ sender: Any) {
        delegate?.didPressCurrencyPairButton()
    }
    
     func getCurrentViewController() -> UIViewController? {

        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil

    }
    
}


