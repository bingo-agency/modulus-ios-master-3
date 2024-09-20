//
//  MDKYCDropDownField.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 21/05/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import MaterialComponents.MDCBottomSheetController


class MDKYCDropDownField: kycFieldView {
    
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var bottomSheet : MDCBottomSheetController? = nil
//    var field:KYCField?
    var selectedText = ""
    
    func configure(field:KYCField){
        self.field = field
        titleLabel.text = field.fieldTitle
        if field.value != nil {
            if let data = field.options?.first(where: { $0.value == field.value}){
                dropDownButton.setTitle("   \(data.key.capitalized)        ", for: .normal)
                self.selectedText = field.value!
            }
        }else{
            dropDownButton.setTitle("   Select       ", for: .normal)
        }
    }
    
    //MARK: -  Buttona action
    
    @IBAction func dropdownButtonAction(_ sender: Any) {
    
        let storyboard = UIStoryboard(name: "CustomDropDown", bundle: nil)
        let dropDownVC = storyboard.instantiateViewController(withIdentifier: "dropdown") as! MDDropDownVC
        dropDownVC.type = .none
        dropDownVC.delegate = self
        
        //Convert options in to the nsmutableArray
        let mutableData = NSMutableArray()
        var selectedIndex = 0
        if field?.fieldName == "KYCType"{
            mutableData.add(["title" : "select",
                             "key": "select",
                             "value": "select"])
        }
        for (index,key) in field!.options!.keys.sorted().enumerated() {
            let title = field!.options![key] as? String ?? ""
            var selectedData = ["title" : key,
                               "key":key,
                               "value":field!.options![key],
                               "selected":false] as [String : Any]
            
            if key.replacingOccurrences(of: " ", with: "").lowercased() == dropDownButton.titleLabel?.text!.replacingOccurrences(of: " ", with: "").lowercased(){
                selectedData["selected"] = true
            }
            mutableData.add((selectedData as! NSDictionary).mutableCopy() as! NSMutableDictionary)
        }
        
        dropDownVC.data = mutableData
        dropDownVC.initialSelectedIndex = selectedIndex
//        dropDownVC.selectedCountry = countryTextField.text!
        dropDownVC.searchBarPlaceHolder = "Search \(titleLabel.text ?? "")"
        bottomSheet = MDCBottomSheetController(contentViewController: dropDownVC)
        bottomSheet?.delegate = self
        bottomSheet?.preferredContentSize = CGSize(width: self.viewController()!.view.frame.width + 2,
                                                   height: self.viewController()!.view.frame.size.height)
        self.viewController()!.present(bottomSheet!, animated: true, completion: nil)
    
    }
    
    


    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        titleLabel.textColor = Theme.current.titleTextColor
        dropDownButton.backgroundColor = Theme.current.navigationBarColor
        dropDownButton.setTitleColor(Theme.current.titleTextColor, for: .normal)
        dropDownButton.borderColorV = Theme.current.titleTextColor
    }
}
extension MDKYCDropDownField:customDropDownDelegates{
    func dropDownSelected(title: String, data: NSDictionary) {
//        print("selected Title : \(title)")
        selectedText = data.valueForCaseInsensativeKey(forKey: "value") as? String ?? ""
        dropDownButton.setTitle("   \(title.capitalized)       ", for: .normal)
        if field?.fieldName == "KYCType"{
            if let kycVc = self.viewController() as? MDKYCVC{
                kycVc.toggleUIForTypeOfVerfication(selectedType: title)
            }
        }
    }
}

extension MDKYCDropDownField:MDCBottomSheetControllerDelegate{
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {

    }
}
