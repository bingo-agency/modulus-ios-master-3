//
//  MDMarketOptionCollectionCell.swift
//  Modulus
//
//  Created by Abhijeet on 10/1/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDMarketOptionCollectionCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIViewX!
    static let indentifier = "MDMarketOptionCollectionCell"
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewConst: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        self.imgViewConst.constant = 0
        self.imgView.isHidden = true
        self.setupView_unselected()
    }
    func configureCell(text:String,shouldimageshow:Bool){
        self.imgView.isHidden = shouldimageshow ? false : true
        self.imgViewConst.constant = shouldimageshow ? 22 : 0
        self.layoutSubviews()
        self.lbl_name.text = text
        self.setupView_unselected()
    }
    func setupView_Selected(){
        self.cardView.borderColor = Theme.current.primaryColor
        self.lbl_name.textColor = Theme.current.primaryColor
        self.imgView.tintColor = Theme.current.primaryColor
    }
    func setupView_unselected(){
        self.cardView.borderColor = Theme.current.titleTextColor
        self.lbl_name.textColor = Theme.current.titleTextColor
        self.imgView.tintColor = Theme.current.titleTextColor
    }
    static func getWidth_Cell(text:String,isimageVisible:Bool,size:CGSize) -> CGFloat{
        let spacing = 12
        let esitmateBounds = text.getestimatedBounds(with: size.width == 0 ? CGSize(width: 100, height: 40):size, with: 20.0)
        return CGFloat((spacing * (isimageVisible ? 3 : 2)) + (isimageVisible ? 22 : 0)) + esitmateBounds.width + 4
    }
    
}
extension String{
    func getestimatedBounds(with respectiveBound :CGSize , with fontSize : CGFloat = 15.8)-> CGRect{
        let optionSet = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estmatedFrame = NSString(string: self).boundingRect(with: respectiveBound, options: optionSet, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize, weight: .regular)], context: nil)
        return estmatedFrame
    }
}
