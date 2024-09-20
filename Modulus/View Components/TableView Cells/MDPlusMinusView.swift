//
//  MDPlusMinusView.swift
//  Modulus
//
//  Created by Pathik  on 16/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
@IBDesignable
class MDPlusMinusView: UIView {

   
    @IBOutlet weak var plusMinusView: UIView!
    // Connect the custom button to the custom class
   // @IBOutlet weak var view: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // setup()
    }
    
    func setup() {
        plusMinusView = loadViewFromNib()
        plusMinusView.frame = bounds

        plusMinusView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                          UIView.AutoresizingMask.flexibleHeight]

        addSubview(plusMinusView)

        // Add our border here and every custom setup
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.white.cgColor
//        view.titleLabel!.font = UIFont.systemFont(ofSize: 40)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
