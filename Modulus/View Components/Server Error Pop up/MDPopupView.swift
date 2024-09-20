//
//  MDPopupView.swift
//  Modulus
//
//  Created by Pathik  on 31/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class MDPopupView: UIView , UIGestureRecognizerDelegate {

    @IBOutlet weak var widthConstrints: NSLayoutConstraint!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var heightConstrints: NSLayoutConstraint!
    
    var blackView = UIView()
    
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        [unowned self] in
        let panGesture = UITapGestureRecognizer(target: self, action: #selector(backgrooundTapped))
        panGesture.delegate = self
     
        return panGesture
        }()
    
    
    
    
    
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //backgroundView.backgroundColor = Theme.current.backgroundColor.withAlphaComponent(0.7)
        backgroundView.backgroundColor = UIColor.clear
        
        popupView.backgroundColor = Theme.current.navigationBarColor
        okButton.backgroundColor = Theme.current.primaryColor
        okButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        okButton.setTitle(localised("OK"), for: .normal)
        imageView.image = UIImage(named: "sad")?.imageWithColor(color1: Theme.current.titleTextColor)
        errorTitle.textColor = Theme.current.titleTextColor
        errorMessage.textColor = Theme.current.subTitleColor
        
    }
 

     static func showErrorPopupViewOnWidnow(title:String = localised("server error"),errorMessage:String = localised("Ooops…something wrong, try one more time"),messageImage: UIImage? = nil)  {
        let bounds = UIScreen.main.bounds
        DispatchQueue.main.async {
            if let popup = (UIApplication.shared.delegate as! AppDelegate).customPopupWindow{
                popup.removeFromSuperview()
                (UIApplication.shared.delegate as! AppDelegate).customPopupWindow = nil
            }
        
        
        let popView = MDPopupView().loadNib() as! MDPopupView
        
       
        popView.errorTitle.text = title.uppercased()
        popView.errorMessage.text = errorMessage
        if let image = messageImage {
            popView.imageView.image = image
        }
        if let window = UIApplication.shared.keyWindow{
        popView.frame = window.bounds
        popView.clipsToBounds = true
        
        window.addSubview(popView)
        
//        popView.frame = bounds
//        popView.translatesAutoresizingMaskIntoConstraints = false
        
            
            popView.blackView = UIView()
            popView.blackView.backgroundColor = Theme.current.backgroundColor.withAlphaComponent(0.7)
            window.addSubview( popView.blackView)


         popView.blackView.translatesAutoresizingMaskIntoConstraints = false
         popView.blackView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
         popView.blackView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
         popView.blackView.widthAnchor.constraint(equalTo: window.widthAnchor).isActive = true
         popView.blackView.heightAnchor.constraint(equalTo: window.heightAnchor, multiplier: 1).isActive = true
            
            
        popView.blackView.addGestureRecognizer(popView.tapGesture)
            
            
            
        window.bringSubviewToFront(popView)
            
            
        popView.translatesAutoresizingMaskIntoConstraints = false
        popView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        popView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            
            if UIApplication.shared.statusBarOrientation.isLandscape{
                
                popView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < UIScreen.main.bounds.height ? bounds.size.height : bounds.size.width).isActive = true
                
                popView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < UIScreen.main.bounds.height ? bounds.size.width : bounds.size.height).isActive = true
                
            }else{
                
                popView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < UIScreen.main.bounds.height ? bounds.size.width : bounds.size.height).isActive = true
                
                popView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < UIScreen.main.bounds.height ? bounds.size.width : bounds.size.height).isActive = true
                
            }
        
       

            
       // popView.heightAnchor.constraint(equalTo: window.heightAnchor, multiplier: 1).isActive = true
        
        
           // popView.heightConstrints.constant = bounds.size.height
           // popView.widthConstrints.constant = bounds.size.width
          //  popView.center = window.center
            
            
            
        
            
        (UIApplication.shared.delegate as! AppDelegate).customPopupWindow = popView
        //return popView
            }
        }
    }
    
    @IBAction @objc func backgrooundTapped(_ sender: UITapGestureRecognizer) {
        if let popup =  (UIApplication.shared.delegate as! AppDelegate).customPopupWindow{
            popup.removeFromSuperview()
            self.blackView.removeFromSuperview()
            self.removeGestureRecognizer(self.tapGesture)
            (UIApplication.shared.delegate as! AppDelegate).customPopupWindow = nil
        }
        
    }
    @IBAction func okButtonAction(_ sender: UIButton) {
        if let popup =  (UIApplication.shared.delegate as! AppDelegate).customPopupWindow{
            popup.removeFromSuperview()
            self.blackView.removeFromSuperview()
            self.removeGestureRecognizer(self.tapGesture)
            (UIApplication.shared.delegate as! AppDelegate).customPopupWindow = nil
        }
    }
}
extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
