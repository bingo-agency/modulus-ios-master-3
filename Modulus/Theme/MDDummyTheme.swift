//
//  MDDummyTheme.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 26/12/18.
//  Copyright © 2018 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDDummyTheme: ThemeProtocol {
    
    var backgroundColor: UIColor = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)//UIColor.init(hex: 0x120F22)
    var dropDownBgColor: UIColor = UIColor.gray
    var navigationBarColor: UIColor = UIColor.init(red: 69/255, green: 148/255, blue: 250/255, alpha: 1.0)
    var primaryColor: UIColor = UIColor.init(red: 245/255, green: 146/255, blue: 47/255, alpha: 1.0) // App RED COLOR
    var secondaryColor: UIColor = UIColor.purple

    var titleTextColor: UIColor = UIColor.black
    var btnTextColor: UIColor =  UIColor.white
    var subTitleColor: UIColor = UIColor.black.withAlphaComponent(0.7)

    var textFieldIconsTintColorActive: UIColor = UIColor.black
    var textFieldIconsTintColorInActive: UIColor = UIColor.black.withAlphaComponent(0.7)
    
    var customValuesBoxWithSidebarColor: UIColor = UIColor.brown.withAlphaComponent(0.5)
    
    //    var buySellBoxColor: UIColor = UIColor.brown.withAlphaComponent(0.7)
    var BuySellScreentextFiledLabelBgColor:UIColor = UIColor.brown.withAlphaComponent(0.25)
    var BuySellScreentextFiledBgColor:UIColor = UIColor.brown.withAlphaComponent(0.25)
    
    var mainTableCellsBgColor:UIColor = UIColor.brown.withAlphaComponent(0.5)
    var selectedCellBgColor:UIColor = UIColor.brown.withAlphaComponent(0.8)
    
    var profileInitialLabelBgColor:UIColor = UIColor.brown.withAlphaComponent(0.8)
    var accountCellSeparator: UIColor = UIColor.gray
    
    
    var redColor : UIColor = UIColor.init(red: 213/255, green: 38/255, blue: 46/255, alpha: 1.0)
    
    var percentageBarBgColor: UIColor = UIColor.white.withAlphaComponent(0.5)
}
