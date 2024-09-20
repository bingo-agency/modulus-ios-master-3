//
//  MDOptionsViewCell.swift
//  Modulus
//
//  Created by Abhijeet on 10/13/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDOptionsViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(name:String,imageString:String?,image:UIImage?){
        self.lbl_Name.text = name
        if let imagestr = imageString{
            self.imageView?.downloaded(from: URL(string: imagestr)!)
        }else if let image = image{
            self.imageView?.image = image
        }
    }
    
}
