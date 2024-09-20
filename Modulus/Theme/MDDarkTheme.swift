//
//  MDDarkTheme.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 26/12/18.
//  Copyright © 2018 Bhavesh Sarwar. All rights reserved.
//

import Foundation
import UIKit

class MDDarkTheme: ThemeProtocol {
    var btnTextColor: UIColor = UIColor.black

    var backgroundColor: UIColor = UIColor.init(hex: 0x000000)
    var dropDownBgColor: UIColor = UIColor.init(hex: 0x111111)
//    var navigationBarColor: UIColor = UIColor.init(red: 33/255, green: 31/255, blue: 47/255, alpha: 1.0)
    var navigationBarColor: UIColor = UIColor.init(red: 13/255, green: 13/255, blue: 13/255, alpha: 1.0)
    
    var primaryColor: UIColor = UIColor(named: "primaryColor")!
    var secondaryColor: UIColor = UIColor.init(hex: 0x00FFC1)

    var titleTextColor: UIColor = UIColor.white
    var subTitleColor: UIColor = UIColor.gray

    var textFieldIconsTintColorActive: UIColor = UIColor.black
    var textFieldIconsTintColorInActive: UIColor = UIColor.gray

    var customValuesBoxWithSidebarColor: UIColor = UIColor.init(hex: 0x131313)

//    var buySellBoxColor: UIColor = UIColor.brown.withAlphaComponent(0.7)
    var BuySellScreentextFiledLabelBgColor:UIColor = UIColor.white.withAlphaComponent(0.07)
    var BuySellScreentextFiledBgColor:UIColor = UIColor.black.withAlphaComponent(0.07)

//    var mainTableCellsBgColor:UIColor = UIColor.white.withAlphaComponent(0.12)
    var mainTableCellsBgColor:UIColor = UIColor.init(hex: 0x131313)
    var selectedCellBgColor:UIColor = UIColor.white.withAlphaComponent(0.35)

     var profileInitialLabelBgColor:UIColor = UIColor.init(hex: 0x706E78)
    var accountCellSeparator: UIColor = UIColor.init(hex: 0x131313)


    var redColor : UIColor = UIColor.init(red: 213/255, green: 38/255, blue: 46/255, alpha: 1.0)

    var percentageBarBgColor : UIColor = UIColor.white.withAlphaComponent(0.5)
}


class MDLightTheme: ThemeProtocol {
    var backgroundColor: UIColor = UIColor(named: "lightBackground")!
    var dropDownBgColor: UIColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    var navigationBarColor: UIColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)

    var primaryColor: UIColor = #colorLiteral(red: 0.262745098, green: 0.07843137255, blue: 0.431372549, alpha: 1) // App RED COLOR
    var secondaryColor: UIColor = UIColor.init(hex: 0x56BE19)

    var titleTextColor: UIColor = UIColor.black
    var btnTextColor: UIColor =  UIColor.white

    var subTitleColor: UIColor = UIColor.gray

    var textFieldIconsTintColorActive: UIColor = UIColor.black
    var textFieldIconsTintColorInActive: UIColor = UIColor.gray

    var customValuesBoxWithSidebarColor: UIColor = UIColor.black.withAlphaComponent(0.12)

//    var buySellBoxColor: UIColor = UIColor.brown.withAlphaComponent(0.7)
    var BuySellScreentextFiledLabelBgColor:UIColor = UIColor.white
    var BuySellScreentextFiledBgColor:UIColor = UIColor.black.withAlphaComponent(0.07)

    var mainTableCellsBgColor:UIColor = UIColor.black.withAlphaComponent(0.12)
    var selectedCellBgColor:UIColor = UIColor.black.withAlphaComponent(0.35)

     var profileInitialLabelBgColor:UIColor = UIColor.init(hex: 0x706E78)
    var accountCellSeparator: UIColor = UIColor.black


    var redColor : UIColor = UIColor.init(red: 213/255, green: 38/255, blue: 46/255, alpha: 1.0)

    var percentageBarBgColor : UIColor = UIColor.white.withAlphaComponent(0.5)
}
