//
//  MDSnackBarHelper.swift
//  Modulus
//
//  Created by Pathik  on 28/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import TSMessages

class MDSnackBarHelper: NSObject {

    static let shared = MDSnackBarHelper()
    private override init() {}
    
    
    func showErroMessage(message:String){
        
        let _ = TSMessage.showNotification(in:UIApplication.shared.topMostViewController(), title: message, subtitle: "", type: .error, duration: 5)
//        TSMessage.showNotification(withTitle: message, subtitle: <#T##String!#>, type: <#T##TSMessageNotificationType#>)
    }
    
    func showSuccessMessage(message:String,duration : TimeInterval = 5){
        
        _ = TSMessage.showNotification(in:UIApplication.shared.topMostViewController(), title: message, subtitle: "", type: .success, duration: duration)
        
    }
    
}
