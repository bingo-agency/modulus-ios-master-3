//
//  MDKYCImagePicker.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 23/05/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import Photos
class MDKYCImagePicker: kycFieldView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imagePreviewLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldBgView: UIView!
    @IBOutlet weak var imagNameTextField: UITextField!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    
    let imagePicker = UIImagePickerController.init()
//    var field:KYCField?
    
    
    func configure(field:KYCField){
        self.field = field
        if let title = field.fieldTitle{
            titleLabel.text = title
        }
        if let description = field.description{
            imagNameTextField.placeholder = description
        }
        
        if field.value != nil {
            print("There are already an Image")
            self.imageView.downloaded(from: field.value!, isbase64: true)
            self.imagePreviewLabel.isHidden = true
            self.crossButton.isHidden = false
            self.imagNameTextField.text = ""
        }else{
            self.imagePreviewLabel.text = localised("Image Preview")
            self.chooseButton.setTitle(localised("Choose"), for: .normal)
        }
    }
    @IBAction func chooseButtonAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.viewController()?.present(imagePicker, animated: true, completion: nil)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        chooseButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        chooseButton.backgroundColor = Theme.current.primaryColor
        imagePreviewLabel.layer.borderColor = Theme.current.titleTextColor.cgColor
//        imageView.layer.borderColor = Theme.current.titleTextColor.cgColor
        titleLabel.textColor = Theme.current.titleTextColor
        self.backgroundColor = UIColor.clear
        textFieldBgView.backgroundColor = Theme.current.customValuesBoxWithSidebarColor
        imagNameTextField.textColor = Theme.current.titleTextColor
        imagNameTextField.placeHolderColorCustom = Theme.current.subTitleColor
        underLine.backgroundColor = Theme.current.titleTextColor
        
        imagePreviewLabel.textColor = Theme.current.titleTextColor
        crossButton.tintColor = Theme.current.primaryColor
    }
    @IBAction func crossButtonAction(_ sender: Any) {
        imageView.image = nil
        imagePreviewLabel.isHidden = false
        imagNameTextField.text = ""
        crossButton.isHidden = true
    }
    
}

extension MDKYCImagePicker:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        imagePreviewLabel.isHidden = true
        if let img = info[.originalImage] as? UIImage{
            imageView.image = img
            crossButton.isHidden = false
        }
        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            imagNameTextField.text = asset?.value(forKey: "filename") as? String
            print(asset?.value(forKey: "filename"))
            
        }
    }
}
