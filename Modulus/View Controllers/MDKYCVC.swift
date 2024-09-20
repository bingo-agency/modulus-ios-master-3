//
//  MDKYCVC.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 20/05/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import Alamofire

class MDKYCVC: UIViewController {

    static let openKYC = "openKYC"
    var kycFields:[KYCField] = []
    var serviceProviderName = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var kycCollectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var kycStatusBackground: UIView!
    @IBOutlet weak var kycStatusLabel: UILabel!
    @IBOutlet weak var kycLevelView: UIView!
    @IBOutlet weak var approveScreenView: UIView!
    @IBOutlet weak var yourAccountHasVerifiedText: UILabel!
    
    var approveLevel : Int = 0
    
    var isPartiallyDone : Bool = false
    
    var maxLevel : Int = 0
    
    private var selectedKycPage : Int = 0
    private var level_array : [String] = []
    var dict : NSDictionary? = nil
    var valuesDict : NSDictionary? = nil
    var error : Error? = nil
    
    //MARK: - View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbar()
        setColors()
        //fetchKYCForm()
        setKYCStatus()
        self.setLocalisedLabels()
        self.setKYCStatus()
        if self.approveLevel != 0{
            self.selectedKycPage = self.approveLevel - 1
            self.fetchKYCUserForm() ///fetch KYC form to get users entered data
        }else{
            print("Not submitted Yet!!!!")
        }
        self.setUpLevelHeaderView(maxLevel: self.maxLevel)
        DispatchQueue.main.async {
            self.kycCollectionView.scrollToItem(at: IndexPath(item:  self.approveLevel - 1 , section: 0) , at: .left, animated: true)
        }
        self.handleKYCFormResponse(response: self.dict)
    }
    
    private
    func setLocalisedLabels(){
        submitButton.setTitle(localised("SUBMIT"), for: .normal)
    }
    //MARK: - KYC Reasons
    func setKYCStatus(){
        //self.kycCollectionView.
        self.kycCollectionView.register(UINib(nibName: "MDMarketOptionCollectionCell", bundle: nil), forCellWithReuseIdentifier: MDMarketOptionCollectionCell.indentifier)
        self.kycCollectionView.dataSource = self
        self.kycCollectionView.delegate = self
        self.kycLevelView.backgroundColor = Theme.current.navigationBarColor
        self.approveScreenView.backgroundColor = Theme.current.navigationBarColor
        
        if let profile = UserDefaults.standard.value(forKey: "profile") as? NSDictionary {
            if let kycStatus = profile.valueForCaseInsensativeKey(forKey: "kycStatus") as? String,
                kycStatus != "Approved"{
                kycStatusBackground.isHidden = false
                kycStatusLabel.text = "\(kycStatus)"
                if let kycStatusReason = profile.valueForCaseInsensativeKey(forKey: "kycRejectReason") as? String{
                    kycStatusLabel.text = "\(kycStatus) : \(kycStatusReason)"
                }
            }else{
                kycStatusBackground.isHidden = true
            }
        }
    }
    
    //MARK: -  navigation bar helpers
    func setNavigationbar(){
        
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        //For Automation
        self.navigationItem.backBarButtonItem?.isAccessibilityElement = true
        
        
        self.navigationItem.backBarButtonItem?.accessibilityTraits = UIAccessibilityTraits.button
        self.navigationItem.backBarButtonItem?.accessibilityIdentifier = "NavigationBackButton"
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "NavigationBackButton"
        self.navigationItem.backBarButtonItem?.accessibilityValue = "NavigationBackButton"
        
        
        
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = localised("KYC Verification")
        self.navigationItem.titleView = label
    }
    
    
    //MARK: - Data Helpers
    func fetchKYCUserForm(){
        print("Fetch User Form")
        if appDelegate.isConnectedToInternet() == true{
            MDHelper.shared.showHudOnWindow()
            let headers = ["Authorization":MDNetworkManager.shared.authToken,
                           "Content-Type":"application/json"] as NSDictionary
            
            MDNetworkManager.shared.sendRequest(methodType: .post,
                                                apiName: "api/GOKYC_Get_User_KYC",
                                                parameters: nil,
                                                headers: headers as NSDictionary) { (response, error) in
                MDHelper.shared.hideHudOnWindow()
                guard response != nil else {return}
                self.valuesDict = response
            }
        }else{
            MDSnackBarHelper.shared.showErroMessage(message: "The internet appears to be offline")
            submitButton.isHidden = true
        }
    }
    
    func filterResponseForValues(response:NSDictionary){
        //Set Auto values to fields
        print("Set auto values to fields")
        if let fieldsList = response.value(forKey: "data") as? [[String:Any]]{
            for field in fieldsList{
                do{
                    let fieldData = try JSONSerialization.data(withJSONObject:field, options: .prettyPrinted)
                    let showDetails = try JSONDecoder().decode(KYCField.self, from: fieldData)
                    let updatedData = self.kycFields.first(where: {$0.fieldName == showDetails.fieldName})
                    updatedData?.value = showDetails.value
                    print("Values \(showDetails.value!)")
                }catch let error as NSError {
                    print(error)
                }
            }
            
            print("Values")
            for each in self.kycFields{
                print(each.value as Any)
            }
            self.setUpFieldsUI(fieldList: self.kycFields)
        }
    }
    
    
    func handleKYCFormResponse(response:NSDictionary? , isAlreadyApprovedAndIsContainValues : Bool = false ){
        if response != nil , error == nil{
            if MDNetworkManager.shared.isResponseSucced(response: response!){
                if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? [String:Any]{
                    if let serviceProvider = data["serviceProviderName"] as? String{
                        self.serviceProviderName = serviceProvider
                    }
                    var maxLevel : Int = 0
                    if let fieldsList = data["fieldsList"] as? [[String:Any]]{
                        for field in fieldsList{
                            
                            do{
                                let fieldData = try JSONSerialization.data(withJSONObject:field, options: .prettyPrinted)
                                let showDetails = try JSONDecoder().decode(KYCField.self, from: fieldData)
                                maxLevel = max(maxLevel , showDetails.level)
                                print("Max Level \(maxLevel)")
                                //showDetails
                                if showDetails.level <= self.selectedKycPage + 1{
                                    self.kycFields.append(showDetails)
                                }
                            }catch let error as NSError {
                                print(error)
                            }
                        }
                        print(kycFields.count)
                        self.setUpLevelHeaderView(maxLevel: maxLevel)
                        self.toggleUIForTypeOfVerfication(selectedType: "select")
                        if self.selectedKycPage < self.approveLevel{
                            self.showVerifiedStatus()
                        }else{
                            if isAlreadyApprovedAndIsContainValues{
                                self.filterResponseForValues(response: self.valuesDict!)
                            }else{
                                self.setUpFieldsUI(fieldList: kycFields)
                            }
                        }
                    }
                }
            }else{
                let message = response?.valueForCaseInsensativeKey(forKey:"Message" ) as? String ?? "Something Went Wrong"//{
                MDHelper.shared.showErrorAlert(message: message, viewController: self)
            }
        }else{
            var message = "Failed to fetch KYC , Error = nil"
            if error != nil{
               message = error!.localizedDescription
            }
             MDSnackBarHelper.shared.showErroMessage(message: message)
        }
    }
    
    
    //MARK: - UI Helper
    func setUpFieldsUI(fieldList:[KYCField],parentField:KYCField? = nil){
        
        for field in fieldList{
            var kycFieldViewGenerated:kycFieldView? = nil
            switch field.inputType{
            case KYCField.inputTypes.TextBox.rawValue , KYCField.inputTypes.Date.rawValue:
                kycFieldViewGenerated = setTextBox(field: field)
                break
            case KYCField.inputTypes.DropDown.rawValue , KYCField.inputTypes.RadioButton.rawValue :
                kycFieldViewGenerated = setDropDown(field: field)
                break
            case KYCField.inputTypes.Panel.rawValue :
                kycFieldViewGenerated = setPanel(field: field)
                break
            case KYCField.inputTypes.File.rawValue :
                kycFieldViewGenerated = setImageField(field: field)
                break
            default:
                break
            }
            
            kycFieldViewGenerated?.parentField = parentField
            // If it has nested fields
            if let nestedFieldList = field.fieldsList {
                setUpFieldsUI(fieldList: nestedFieldList,parentField: field)
            }
            
        }
    }
    
    private
    func setUpLevelHeaderView(maxLevel : Int){
        self.level_array.removeAll()
        for i in 0..<maxLevel{
            level_array.append("KYC Level \(i+1)")
        }
        DispatchQueue.main.async {
            self.kycCollectionView.reloadData()
        }
    }
    
    func setColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
//        kycStatusBackground.backgroundColor = UIColor.init(red: 100/255, green: 81/255, blue: 82/255, alpha: 1)
        kycStatusLabel.textColor = MDDarkTheme().primaryColor//Theme.current.primaryColor
        submitButton.backgroundColor = Theme.current.primaryColor
    }
    
    
    
    // MARK: - KYC Field helpers
    func setTextBox(field:KYCField)->kycFieldView{
        let kycCompennetsNib = UINib.init(nibName: "KYCFieldViews", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)
        let textFieldView = kycCompennetsNib[0] as! MDKYCTextField
        textFieldView.frame = CGRect(x: 0, y: 0, width: stackView.frame.size.width, height: 70)
        textFieldView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        textFieldView.configure(field: field)
        stackView.insertArrangedSubview(textFieldView, at: stackView.arrangedSubviews.count-1)
        return textFieldView
    }
    
    func setDropDown(field:KYCField)->kycFieldView{
        let kycCompennetsNib = UINib.init(nibName: "KYCFieldViews", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)
        let dropDownField = kycCompennetsNib[1] as! MDKYCDropDownField
        dropDownField.configure(field: field)
        dropDownField.frame = CGRect(x: 0, y: 0, width: stackView.frame.size.width, height: 70)
        dropDownField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        stackView.insertArrangedSubview(dropDownField, at: stackView.arrangedSubviews.count-1)
        return dropDownField
    }
    
    func setPanel(field:KYCField)->kycFieldView{
        let kycCompennetsNib = UINib.init(nibName: "KYCFieldViews", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)
        let panelField = kycCompennetsNib[2] as! MDKYCPanelField
        panelField.configure(field: field)
        panelField.frame = CGRect(x: 0, y: 0, width: stackView.frame.size.width, height: 50)
        panelField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.insertArrangedSubview(panelField, at: stackView.arrangedSubviews.count-1)
        return panelField
    }
    
    func setImageField(field:KYCField)->kycFieldView{
        let kycCompennetsNib = UINib.init(nibName: "KYCFieldViews", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)
        let imagePicker = kycCompennetsNib[3] as! MDKYCImagePicker
        imagePicker.configure(field: field)
        imagePicker.frame = CGRect(x: 0, y: 0, width: stackView.frame.size.width, height: 50)
        imagePicker.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        stackView.insertArrangedSubview(imagePicker, at: stackView.arrangedSubviews.count-1)
        return imagePicker
    }
    
    //MARK: -  Ui toggle helpers
    func toggleUIForTypeOfVerfication(selectedType:String){
        let kyctypeField = self.kycFields.filter({$0.fieldName ?? "" == "KYCType"})
        for (index,field) in self.kycFields.enumerated(){
            var shouldShowField = false
            if selectedType.lowercased().replacingOccurrences(of: " ", with: "") == "individual"{
                if let isCorporate = field.isCorporate{
                    if isCorporate == false{
                        shouldShowField = true
                    }
                }else{
                    shouldShowField = true
                }
            }else if selectedType.lowercased().replacingOccurrences(of: " ", with: "") == "corporate"{
                if let isCorporate = field.isCorporate{
                    if isCorporate == true{
                        shouldShowField = true
                    }
                }else{
                    shouldShowField = true
                }
            }else if selectedType.lowercased().replacingOccurrences(of: " ", with: "") == "select"{
                if kyctypeField.count > 0 {
                    if field.isCorporate != nil{
                        if field.isCorporate! == false{
                            shouldShowField = false
                        }
                    }else{
                        shouldShowField = true
                    }
                        
                }else{
                    shouldShowField = true
                }
            }
            
            if (index + 1) < stackView.arrangedSubviews.count{
                let fieldView = stackView.arrangedSubviews[index + 1]
                fieldView.isHidden = !shouldShowField
            }

        }
        setResponsders()
    }
    
    
    func setResponsders(){
        let textboxesCurrentlyUsing = stackView.arrangedSubviews.filter({$0 is MDKYCTextField && $0.isHidden == false})
        
        for textBox in textboxesCurrentlyUsing as! [MDKYCTextField]{
            textBox.textField.returnKeyType = .next
            textBox.textField.delegate = self
        }
        
        if let lastTextBox = textboxesCurrentlyUsing.last as? MDKYCTextField{
            lastTextBox.textField.returnKeyType = .done
        }
    }
    
    
    //MARK: -  Button actions
    
    @IBAction func submitAction(_ sender: Any) {
        let inputs = validateAndGetParams(fieldList: kycFields)
        if inputs.0 == true{
            if appDelegate.isConnectedToInternet() == true{
                self.submitKYC(params: ["ServiceProviderName":serviceProviderName,
                                   "FieldsList":inputs.1] as NSDictionary)
            }else{
                MDSnackBarHelper.shared.showErroMessage(message: "The internet appears to be offline")
            }

        }
    }
    
    
    

    //MARK: - validation
//    func isValidInputs()->(Bool,[[String:Any?]]){
//
//
//        var message = ""
//        var parms:[[String:Any?]] = []
//        for view in stackView.arrangedSubviews{
//
//            // handle dropdown
//            if let dropDownView = view as? MDKYCDropDownField{
//                if dropDownView.isHidden == false{
//                    // Collect the params in required format
//                    let fieldData = ["FieldName":dropDownView.field?.fieldName ?? "",
//                                     "Value":dropDownView.selectedText ?? "",
//                                     "FieldsList":nil,
//                                     "IsIgnored":dropDownView.field?.isIgnored ?? false] as [String : Any?]
//                    parms.append(fieldData)
//
//                    // Validation
//                    if dropDownView.field?.mandatory == true{
//                        if let dropDownbuttonTitle = dropDownView.titleLabel.text{
//                            if dropDownbuttonTitle.lowercased().replacingOccurrences(of: " ", with: "") == "select"{
//                                message = "Please select \(dropDownView.titleLabel.text ?? "required details")"
//                                break
//                            }else{
//
//                            }
//                        }
//                    }
//                }
//
//            // Handle textBox and Date fileds
//            }else if let textBoxView = view as? MDKYCTextField{
//                if textBoxView.isHidden == false{
//                    // Collect the params in required format
//                    let fieldData = ["FieldName":textBoxView.field?.fieldName ?? "",
//                                     "Value":textBoxView.textField.text ?? "",
//                                     "FieldsList":nil,
//                                     "IsIgnored":textBoxView.field?.isIgnored ?? false] as [String : Any?]
//                    parms.append(fieldData)
//
//                    // Validation
//                    if textBoxView.field?.mandatory == true,textBoxView.isHidden == false{
//                        if textBoxView.textField.text == ""{
//                            message = "Plese fill \(textBoxView.titleLabel.text ?? "required details")"
//                            break
//                        }
//                    }
//                }
//            // Handle image picker
//            }else if let imagePickerView = view as? MDKYCImagePicker{
//                if imagePickerView.isHidden == false{
//                    // Collect the params in required format
//                    let fieldData = ["FieldName":imagePickerView.field?.fieldName ?? "",
//                                     "Value":imagePickerView.imageView.image?.pngData()?.base64EncodedString(),
//                                     "FieldsList":nil,
//                                     "IsIgnored":imagePickerView.field?.isIgnored ?? false] as [String : Any?]
//                    parms.append(fieldData)
//
//                    if let manadatory = imagePickerView.field?.mandatory, manadatory == true,imagePickerView.isHidden == false{
//                        if imagePickerView.imageView.image == nil{
//                            message = "Please select \(imagePickerView.titleLabel.text ?? "required details")"
//                            break
//                        }
//                    }
//                }
//            }
//
//        }
//        if message != ""{
//            MDSnackBarHelper.shared.showErroMessage(message: message)
//            return (false,parms)
//        }
//        return (true,parms)
//    }
    
    
    
    func validateAndGetParams(fieldList:[KYCField],parentField:KYCField? = nil)->(Bool,[[String:Any]]?){
        var message = ""
        var params:[[String:Any]] = []
        
        for field in fieldList{
            if let viewOfField = stackView.arrangedSubviews.filter({ (subView) -> Bool in
                if let kycView = subView as? kycFieldView{
                    if parentField != nil{
                        if kycView.field!.fieldName! == field.fieldName! , kycView.parentField?.fieldName! == parentField?.fieldName{
                            return true
                        }
                    }else{
                        if kycView.field!.fieldName! == field.fieldName!{
                            return true
                        }
                    }
                }
                return false
            }).first{
                
                var value:String = ""
                // handle dropdown
                if let dropDownView = viewOfField as? MDKYCDropDownField{
                    if !dropDownView.isHidden{
                        // Validation
                        if dropDownView.field?.mandatory == true{
                            if let dropDownbuttonTitle = dropDownView.titleLabel.text{
                                if dropDownbuttonTitle.lowercased().replacingOccurrences(of: " ", with: "") == "select"{
                                    message = "Please select \(dropDownView.titleLabel.text ?? "required details")"
                                    break
                                }else{
                                    
                                }
                            }
                        }
                        value = dropDownView.selectedText
                    }else{
                        value = ""
                    }
                }else if let textBoxView = viewOfField as? MDKYCTextField{
                    if textBoxView.isHidden == false{
                        // Validation
                        if textBoxView.field?.mandatory == true,textBoxView.isHidden == false{
                            if textBoxView.textField.text == ""{
                                message = "Plese fill \(textBoxView.titleLabel.text ?? "required details")"
                                break
                            }
                        }
                        value = textBoxView.textField.text ?? ""
                    }else{
                        value = ""
                    }
                    // Handle image picker
                }else if let imagePickerView = viewOfField as? MDKYCImagePicker{
                    if imagePickerView.isHidden == false{
                        if let manadatory = imagePickerView.field?.mandatory, manadatory == true,imagePickerView.isHidden == false{
                            if imagePickerView.imageView.image == nil{
                                message = "Please select \(parentField?.fieldName ?? "") \(imagePickerView.titleLabel.text ?? "required details")"
                                break
                            }
                        }
                        if imagePickerView.imageView.image != nil{
                            let resizedImage = imagePickerView.imageView.image!.resizeImage(targetSize: CGSize(width: 100, height: 100))
                            value = "data:image/jpeg;base64,\(resizedImage.pngData()?.base64EncodedString() ?? "")"
                        }
                    }else{
                        value = ""
                    }
                    
                }
                
                //Nesting field List
                var nestedFieldList:(Bool,[[String:Any]]?) = (false,nil)
                if let nestedFields = field.fieldsList{
                    nestedFieldList = validateAndGetParams(fieldList: nestedFields,parentField: field)
                    if nestedFieldList.0 == false{
                        return (false,nil)
                    }
                }
                
                // Collect the params in required format
                let fieldData = ["FieldName":field.fieldName!,
                                 "Value":nestedFieldList.1 == nil ? value : nil ?? nil,
                                 "FieldsList":nestedFieldList.1 == nil ? nil  : nestedFieldList.1 ?? nil,
                                 "IsIgnored":viewOfField.isHidden] as [String : Any]
                params.append(fieldData as [String : Any])
                
                for each in params{
                    for every in each{
                        print("\(each.keys) => \(each.values)")
                    }
                }
            }
        }
        
        if message != ""{
            MDSnackBarHelper.shared.showErroMessage(message: message)
            return (false,nil)
        }
        return (true,params)
    }
    
    //MARK: - Netweork calls
    func submitKYC(params:NSDictionary){
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "Content-Type":"application/json"] as NSDictionary
        
        
        for each in params{
            print("\(each.key) ===> \(String(describing: each.value))")
        }
        
        let baseUrl = "\(API.baseURL)\(API.submitKyc)" + "?level=\(self.selectedKycPage + 1)"
        
        //Make first url from this queryStringParam using URLComponents
        let urlComponent = URLComponents(string: baseUrl)!
        
        //Now make `URLRequest` and set body and headers with it
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        request.allHTTPHeaderFields = (headers as! [String : String])
        
        for each in request.allHTTPHeaderFields!{
            print("\(each.key) ===> \(String(describing: each.value))")
        }
        
        MDHelper.shared.showHudOnWindow()
        Alamofire.request(request).responseJSON { response in
            MDHelper.shared.hideHudOnWindow()
            switch (response.result) {
            case .success:
                if let responseDict = response.result.value as? NSDictionary{
                    print("Dict \(responseDict)")
                    if MDNetworkManager.shared.isResponseSucced(response: responseDict)
                    {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.fetchProfile()
                        self.navigationController?.popViewController(animated: true)
                        MDSnackBarHelper.shared.showSuccessMessage(message: "Kyc has been submitted")
                        self.appDelegate.fetchProfile(isFromWithoutLogin: false)
                    }else{
                        print("Dict \(responseDict)")
                        if let dataMessage = responseDict.valueForCaseInsensativeKey(forKey: "data") as? String{
                            MDSnackBarHelper.shared.showErroMessage(message: dataMessage)
                        }else{
                            if let dataMessage = responseDict.valueForCaseInsensativeKey(forKey: "Message") as? String{
                                MDSnackBarHelper.shared.showErroMessage(message: dataMessage)
                            }else{
                                MDSnackBarHelper.shared.showErroMessage(message: "Something went wrong!!!")
                            }
                        }
                    }
                }
                break
                //success code here
                
            case .failure(let error):
                 MDSnackBarHelper.shared.showErroMessage(message: error.localizedDescription)
                break
            }
        }
    }
    
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension MDKYCVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textboxesCurrentlyUsing = stackView.arrangedSubviews.filter({$0 is MDKYCTextField && $0.isHidden == false})
        
        for (index,textBox) in (textboxesCurrentlyUsing as! [MDKYCTextField]).enumerated(){
            if textBox.textField == textField{
                if index != textboxesCurrentlyUsing.count - 1{
                    if let nextTextBox = textboxesCurrentlyUsing[index + 1] as? MDKYCTextField{
                        nextTextBox.textField.becomeFirstResponder()
                        break
                    }
                }else{
                    textField.resignFirstResponder()
//                    submitAction(self)
                }
            }
        }
        return false
    }
}

extension MDKYCVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.level_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MDMarketOptionCollectionCell.indentifier, for: indexPath) as! MDMarketOptionCollectionCell
        cell.configureCell(text: self.level_array[indexPath.row], shouldimageshow: false)
        if self.selectedKycPage == indexPath.row{
            cell.setupView_Selected()
        }else{
            cell.setupView_unselected()
        }
        return cell
    }
}

extension MDKYCVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedKycPage = indexPath.row
        collectionView.reloadData()
        self.reloadKYCFields()
    }
    
    private
    func reloadKYCFields(){
        self.stackView.arrangedSubviews.forEach { (view) in
            if view.tag != 10{
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        self.kycFields.removeAll()
        if self.selectedKycPage < self.approveLevel{
            self.showVerifiedStatus()
            return
        }else{
            self.approveScreenView.isHidden = true
            MDHelper.shared.showHudOnWindow()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            MDHelper.shared.hideHudOnWindow()
            self.handleKYCFormResponse(response: self.dict , isAlreadyApprovedAndIsContainValues: self.valuesDict != nil)
        }
    }
    
    private func showVerifiedStatus(){
        self.approveScreenView.isHidden = false
        self.yourAccountHasVerifiedText.text = "Your Account Identity Verification is Level \(self.approveLevel)"
    }
}

extension MDKYCVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = MDMarketOptionCollectionCell.getWidth_Cell(text:  self.level_array[indexPath.row],
                                                               isimageVisible: false, size:CGSize(width: collectionView.frame.width, height: 1000))
        return CGSize(width: width, height: collectionView.frame.height)
    }
}

