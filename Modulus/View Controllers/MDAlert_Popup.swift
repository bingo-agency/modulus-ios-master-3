//
//  MDAlert_Popup.swift
//  Modulus
//
//  Created by Abhijeet on 10/5/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
protocol MDAlert_PopupDelegate : class{
    func yesAction()
    func noAction()
}
class MDAlert_Popup: UIView {
    static let nibName :String = "MDAlert_Popup"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btn_yes: UIButton!
    @IBOutlet weak var btn_no: UIButton!
    weak var delegate :MDAlert_PopupDelegate?
    @IBOutlet weak var lbl_text: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    func commoninit(){
        Bundle.main.loadNibNamed(MDAlert_Popup.nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        self.btn_yes.layer.cornerRadius = 8.0
        self.btn_no.layer.cornerRadius = 8.0
        
        self.lbl_text.textColor = Theme.current.titleTextColor
        self.btn_no.backgroundColor = Theme.current.primaryColor
        self.btn_yes.backgroundColor = Theme.current.primaryColor
        self.btn_no.setTitleColor(Theme.current.btnTextColor, for: .normal)
        self.btn_yes.setTitleColor(Theme.current.btnTextColor, for: .normal)
        self.bgView.backgroundColor = Theme.current.navigationBarColor
        
    }
    init() {
        super.init(frame: CGRect.zero)
        commoninit()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commoninit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    @IBAction func btn_yesAction(_ sender: Any) {
        self.delegate?.yesAction()
    }
    @IBAction func btn_noAction(_ sender: Any) {
        self.delegate?.noAction()
    }
}
class PopUpWindow: UIViewController, MDAlert_PopupDelegate {
    func yesAction() {
        self.isYesIsPresses?(true)
        self.dismissView()
    }
    
    func noAction() {
        self.isYesIsPresses?(false)
        self.dismissView()
    }
    private var popUpWindowView : MDAlert_Popup?
    var isYesIsPresses :((Bool)->())?
    init(title: String, text: String, buttontext: String) {
        super.init(nibName: nil, bundle: nil)
        popUpWindowView = MDAlert_Popup(frame: CGRect(x: 40, y: self.view.frame.height / 2 - (180) , width: self.view.frame.width - 80, height: 400))
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
     
        popUpWindowView?.delegate = self
        view.addSubview(popUpWindowView!)
     }

     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     
     @objc func dismissView(){
         self.dismiss(animated: true, completion: nil)
     }
    

}
