//
//  MDAppearance.swift
//  Modulus
//
//  Created by Pathik  on 11/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDAppearance: NSObject {

    
    struct Colors {
//        static let mainBackgroundColor = UIColor.init(hex: 0x120F22)//UIColor.init(red: 18/255, green: 15/255, blue: 33/255, alpha: 1.0)
//        static let appRedColor = UIColor.init(red: 213/255, green: 38/255, blue: 46/255, alpha: 1.0)
//        static let navigationBarColor = UIColor.init(red: 33/255, green: 31/255, blue: 47/255, alpha: 1.0)
//        static let initialLabelColor = UIColor.init(hex: 0x706E78)
//        static let accountCellSeparator = UIColor.init(hex: 0x2A2738)
//        static let appGreenColor = UIColor.init(hex: 0x56BE19)
        static let highlightBackgroundColor = UIColor.init(hex: 0x2E2C3C)
        static let dropdownSelectedBgColor = UIColor.init(red: 111/255, green: 109/255, blue: 120/255, alpha: 1.0)
        static let buttonBGColorBuySell = UIColor.init(red: 73/255, green: 71/255, blue: 89/255, alpha: 1.0)
    }
    
    struct Fonts {
        static let largeNavigationTitleFont = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 35)
        static let smallNavigationTitleFont = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 25)
        static let rightNavigationTitle = UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 30)
        
        static let tabsTitle =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 18)
         static let tabsTitleSmall =  UIFont.init(name: MDAppearance.Proxima_Nova.regular, size: 14)
    }
    
    struct Proxima_Nova {
        static let semiBold = "ProximaNovaA-Semibold"
        static let regular = "ProximaNovaA-Regular"
        static let medium = "Roboto-Medium"
        static let italic = "Roboto-Italic"
        static let bold = "ProximaNovaA-Bold"
        static let thin = "Roboto-Thin"
        static let light = "Roboto-Light"
        static let black = "Roboto-Black"
        static let mediunItalic = "Roboto-MediumItalic"
        static let boldItalic = "Roboto-BoldItalic"
        static let lightItalic = "Roboto-LightItalic"
    }
    
    struct tags {
        static let hudTag = 1000
        static let windowHud = 1001
    }
    
}
