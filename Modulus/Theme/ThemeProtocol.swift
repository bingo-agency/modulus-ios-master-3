//
//  ThemeProtocol.swift
//  MBolder
//
//  Created by Pathik Botadra on 12/12/18.
//  Copyright © 2018 Inspeero. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeProtocol {
    
    // Colors
    var backgroundColor:UIColor  { get set}
    var dropDownBgColor:UIColor{get set}
    var navigationBarColor:UIColor  { get set}
    
    var primaryColor:UIColor { get set}
    var secondaryColor:UIColor { get set}
    
    var mainTableCellsBgColor :UIColor{ get set}
    var selectedCellBgColor :UIColor{ get set}
    //Text Colors
    var titleTextColor:UIColor { get set}
    var btnTextColor:UIColor { get set}
    var subTitleColor:UIColor { get set}
    // Textfields
    var textFieldIconsTintColorActive:UIColor { get set}
    var textFieldIconsTintColorInActive:UIColor { get set}
    
    //MARKET OVERVIEW SCREEN
    var customValuesBoxWithSidebarColor:UIColor { get set}
    
    //BUYSELL SCREEN
    var BuySellScreentextFiledLabelBgColor:UIColor{ get set}
    var BuySellScreentextFiledBgColor:UIColor{ get set}
    
    // Profile
    var profileInitialLabelBgColor:UIColor { get set }
    var accountCellSeparator:UIColor{get set}
    
    //Fonts
    var redColor : UIColor {get}
    
    var percentageBarBgColor : UIColor {get}

}
