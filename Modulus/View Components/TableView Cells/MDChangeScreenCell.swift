//
//  MDDropDownCell.swift
//  Modulus
//
//  Created by Pathik  on 16/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import DropDown
class MDChangeScreenCell: DropDownCell {
    @IBOutlet weak var suffixLabel: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


        // Configure the view for the selected state
    }
    override func layoutSubviews() {
//        if UIApplication.shared.topMostViewController() is UINavigationController{
//            if let buysellVC = (UIApplication.shared.topMostViewController() as! UINavigationController).visibleViewController as? MDBuySellVC{
//                print(buysellVC.selectedDropDownValue)
//                if buysellVC.selectedDropDownValue == suffixLabel.text{
//                    suffixLabel.backgroundColor = MDAppearance.Colors.dropdownSelectedBgColor
//                }else{
//                    suffixLabel.backgroundColor = UIColor.init(red: 63/255, green: 60/255, blue: 76/255, alpha: 1.0) //MDAppearance.Colors.highlightBackgroundColor
//                }
//            }else{
//                  suffixLabel.backgroundColor = UIColor.init(red: 63/255, green: 60/255, blue: 76/255, alpha: 1.0)//MDAppearance.Colors.highlightBackgroundColor
//            }
//        }else if UIApplication.shared.topMostViewController() is UITabBarController{
//            if ((UIApplication.shared.topMostViewController() as! UITabBarController).viewControllers?.first is UINavigationController){
//                if let buysellVC = ((UIApplication.shared.topMostViewController() as! UITabBarController).viewControllers?.first as! UINavigationController).visibleViewController as? MDBuySellVC{
//                    print(buysellVC.selectedDropDownValue)
//                    if buysellVC.selectedDropDownValue == suffixLabel.text{
//                        suffixLabel.backgroundColor = MDAppearance.Colors.dropdownSelectedBgColor
//                    }else{
//                        suffixLabel.backgroundColor = UIColor.init(red: 63/255, green: 60/255, blue: 76/255, alpha: 1.0) //MDAppearance.Colors.highlightBackgroundColor
//                    }
//                }
//            }else{
//                suffixLabel.backgroundColor = UIColor.init(red: 63/255, green: 60/255, blue: 76/255, alpha: 1.0)//MDAppearance.Colors.highlightBackgroundColor
//            }
//           
//        }
    }
    
}
