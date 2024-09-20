//
//  MDAlertPopupView.swift
//  Modulus
//
//  Created by Pathik  on 20/11/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
@objc protocol alertPopupDelegate {
    @objc func alertPopupResponse(isAgree:Bool)
}
class MDAlertPopupView: UIView , UIGestureRecognizerDelegate {
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var widthConstant: NSLayoutConstraint!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var popupMessage: UILabel!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    var delegate:alertPopupDelegate? = nil
    var shouldMeOnOutSideTap = true
    
    
    var blackView = UIView()
    
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        [unowned self] in
        let panGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnBackground))
        panGesture.delegate = self
        
        return panGesture
        }()
    
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        backgroundView.backgroundColor = UIColor.clear
        popupView.backgroundColor = Theme.current.navigationBarColor
        popupTitle.textColor = Theme.current.titleTextColor
        popupMessage.textColor = Theme.current.subTitleColor
        
        yesButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        yesButton.backgroundColor = Theme.current.primaryColor
        
        noButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        noButton.backgroundColor = Theme.current.primaryColor
    }
 

    static func showAlertPopupViewOnWidnow(title:String = "Please Confirm",errorMessage:String = "Are you sure you want to place this order?",alertDelegate : alertPopupDelegate?,shoudlDimissOutSide:Bool = true)  {
        
        let bounds = UIScreen.main.bounds
        
        if let alertPopup = (UIApplication.shared.delegate as! AppDelegate).customAlertPopupWindow{
            alertPopup.removeFromSuperview()
            (UIApplication.shared.delegate as! AppDelegate).customAlertPopupWindow = nil
        }
        let alertPopup = MDAlertPopupView().loadNib() as! MDAlertPopupView
        alertPopup.yesButton.setTitle(localised("YES"), for: .normal)
        alertPopup.noButton.setTitle(localised("NO"), for: .normal)
        alertPopup.shouldMeOnOutSideTap = shoudlDimissOutSide
        alertPopup.popupTitle.text = title
        alertPopup.popupMessage.text = errorMessage
        
        if let window = UIApplication.shared.keyWindow{
            alertPopup.frame = window.bounds
            alertPopup.clipsToBounds = true
            
            window.addSubview(alertPopup)
            window.bringSubviewToFront(alertPopup)
            //        popView.frame = bounds
            //        popView.translatesAutoresizingMaskIntoConstraints = false
           
            
            alertPopup.blackView = UIView()
            alertPopup.blackView.backgroundColor = Theme.current.backgroundColor.withAlphaComponent(0.7)
            window.addSubview( alertPopup.blackView)
            
            
            alertPopup.blackView.translatesAutoresizingMaskIntoConstraints = false
            alertPopup.blackView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            alertPopup.blackView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            alertPopup.blackView.widthAnchor.constraint(equalTo: window.widthAnchor).isActive = true
            alertPopup.blackView.heightAnchor.constraint(equalTo: window.heightAnchor, multiplier: 1).isActive = true
            
            
            alertPopup.blackView.addGestureRecognizer(alertPopup.tapGesture)
            
            
            
            window.bringSubviewToFront(alertPopup)
            
            
            alertPopup.translatesAutoresizingMaskIntoConstraints = false
            alertPopup.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            alertPopup.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            
            
            
            if UIApplication.shared.statusBarOrientation.isLandscape{
                
                alertPopup.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < UIScreen.main.bounds.height ? bounds.size.width : bounds.size.height).isActive = true
                
                alertPopup.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < UIScreen.main.bounds.height ? bounds.size.width : bounds.size.height).isActive = true
                
            }else{
                
                alertPopup.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < UIScreen.main.bounds.height ? bounds.size.width : bounds.size.height).isActive = true
                
                alertPopup.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < UIScreen.main.bounds.height ? bounds.size.width : bounds.size.height).isActive = true
                
            }
            
            
            
            
            
            
//            alertPopup.heightConstant.constant = bounds.size.height
//            alertPopup.widthConstant.constant = bounds.size.width
//            alertPopup.center = window.center
            (UIApplication.shared.delegate as! AppDelegate).customAlertPopupWindow = alertPopup
                alertPopup.delegate = alertDelegate
            //return popView
        }
    }
    @IBAction @objc func tappedOnBackground(_ sender: UITapGestureRecognizer) {
        if shouldMeOnOutSideTap == true{
            dismissAlertPopupView()
        }
    }
    func dismissAlertPopupView()  {
        if let popup =  (UIApplication.shared.delegate as! AppDelegate).customAlertPopupWindow{
            popup.removeFromSuperview()
            self.blackView.removeFromSuperview()
            
            (UIApplication.shared.delegate as! AppDelegate).customAlertPopupWindow = nil
        }
    }
    @IBAction func yesButtonAction(_ sender: UIButton) {
       dismissAlertPopupView()
        if self.delegate != nil{
            self.delegate?.alertPopupResponse(isAgree: true)
        }
    }
    @IBAction func noButtonAction(_ sender: UIButton) {
        dismissAlertPopupView()
        if self.delegate != nil{
            self.delegate?.alertPopupResponse(isAgree: false)
        }
    }
    
}
