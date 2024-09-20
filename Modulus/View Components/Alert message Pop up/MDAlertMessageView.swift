//
//  MDAlertMessageView.swift
//  Modulus
//
//  Created by Pathik  on 30/11/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
@objc protocol alertPopupMessageDelegate {
    @objc func alertPopupMessage(presedOk:Bool)
}
class MDAlertMessageView: UIView {
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    
    var delegate:alertPopupMessageDelegate? = nil
    
    var blackView = UIView()
    
    
//    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
//        [unowned self] in
//        let panGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnBackground))
//        panGesture.delegate = self
//
//        return panGesture
//        }()
    
    
    
    
    
    
    @IBOutlet weak var widthConstant: NSLayoutConstraint!
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        backgroundView.backgroundColor = UIColor.clear
        messageView.backgroundColor = Theme.current.navigationBarColor
        okButton.backgroundColor = Theme.current.primaryColor
        okButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         okButton.setTitle(localised("OK"), for: .normal)
    }
    
    
    override func layoutSubviews() {
        okButton.isAccessibilityElement = true
        okButton.accessibilityLabel          = "OKButton"
        okButton.accessibilityIdentifier     = "OKButton"
        okButton.accessibilityValue          = "OKButton"
        self.backgroundColor = UIColor.clear
        
    }
    
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        if let popup =  (UIApplication.shared.delegate as! AppDelegate).customMessagePopupWindow{
            popup.removeFromSuperview()
            self.blackView.removeFromSuperview()
            
            (UIApplication.shared.delegate as! AppDelegate).customMessagePopupWindow = nil
        }
        if self.delegate != nil{
            
            self.delegate?.alertPopupMessage(presedOk: true)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    
    static func showMessagePopupViewOnWidnow(message:String,alertDelegate : alertPopupMessageDelegate?)  {
        let bounds = UIScreen.main.bounds
        
        if let alertPopup = (UIApplication.shared.delegate as! AppDelegate).customMessagePopupWindow{
            alertPopup.removeFromSuperview()
            (UIApplication.shared.delegate as! AppDelegate).customMessagePopupWindow = nil
        }
        let alertPopup = MDAlertMessageView().loadNib() as! MDAlertMessageView
        alertPopup.okButton.setTitle(localised("OK"), for: .normal)
        alertPopup.messageLabel.text = message
        
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
            
            
          //  alertPopup.blackView.addGestureRecognizer(alertPopup.tapGesture)
            
            
            
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
//
//            alertPopup.center = window.center
            
            
            
            
            (UIApplication.shared.delegate as! AppDelegate).customMessagePopupWindow = alertPopup
            alertPopup.delegate = alertDelegate
            //return popView
        }
    }
}
