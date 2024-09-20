//
//  MDGoogleAuthVC.swift
//  Modulus
//
//  Created by Pathik  on 21/11/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SkyFloatingLabelTextField
//import Kingfisher
//import PocketSVG

class MDGoogleAuthVC: UIViewController {
    //MARK: - Constants
    static let  segueId = "GoogleAuthenticator"
    
    //MARK: - Variables
    var navigationTitle = ""
    var isGoogl2FAenabled = false
    
    //MARK: - StoryBoard outlets
    @IBOutlet weak var adressCodeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var addressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var enableButton: UIButton!
    @IBOutlet weak var qrCodeImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var paringCodeBgView: UIView!
    
    @IBOutlet weak var infoLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrCodeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoLabelF2AEnableConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    //landscapeConstraints
    @IBOutlet weak var infoLabelLandscapeEnableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeTextFieldLandscapeEnableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeTextFieldLandscapeDisableCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoLabelLandscapeEnableWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoLableLandscapeEnableCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeTextFieldEnableCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoLableLandscapeDisableWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoLabelLandscapeDisableBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var codeTextFieldLandsapeDisableCenterYConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var enableButtonLandscapeDisableTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var enableButtonLandscapeEnableTopConstraint: NSLayoutConstraint!
    
    
    
    
    
    
    //MARK: - Automation identifiers
    func addAutomationIdentifiers(){
        
        self.copyButton.accessibilityLabel = "googleAuthenticationCopyButton"
        self.copyButton.accessibilityIdentifier = "googleAuthenticationCopyButton"
        self.copyButton.accessibilityValue = "googleAuthenticationCopyButton"
    }
    
 
    
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.allowsEditingTextAttributes = false
        addAutomationIdentifiers()
        setUpColors()
        
        IQKeyboardManager.shared.enable = true
        
        self.scrollView.isScrollEnabled = false
        
      IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        infoLabel.text = localised("Two-factor authentication (2fa) greatly increases security by requiring both your password and another form of authentication. Cryptosa implements 2fa utilizing Google Authenticator. To enable this feature simply download Google Authenticator on your mobile device and scan the QRCode.")
            
        
        copyButton.setTitle(localised("COPY").localizedUppercase, for: .normal)
            
        codeTextField.placeholder = localised("Input your 6-digit authenticator code")
        codeTextField.selectedTitle = localised("Input your 6-digit authenticator code")
        codeTextField.title = localised("Input your 6-digit authenticator code")
        
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        self.view.isUserInteractionEnabled = true
//        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationbar()
        DispatchQueue.main.async {
        
        if self.isGoogl2FAenabled == false{
            self.fetchQrCode()
            self.qrCodeImageView.isHidden = false
            self.qrCodeImageViewWidth.constant = (self.view.frame.size.width * 0.45)
            self.addressViewHeight.constant = (self.view.frame.size.width * 0.25)
            self.adressCodeLabel.isHidden = false
            self.addressLabel.isHidden = false
            self.copyButton.isHidden = false
            
            self.qrCodeTopConstraint.isActive = true
            self.infoLabelTopConstraint.isActive = false
            self.infoLabelF2AEnableConstraint.isActive = true
            
            
            self.enableButton.setTitle(localised("Enable 2FA").uppercased(), for: .normal)
        }else{
        
                self.qrCodeImageViewWidth.constant = 0
                self.addressViewHeight.constant = 0
                self.adressCodeLabel.isHidden = true
                self.addressLabel.isHidden = true
                self.copyButton.isHidden = true
                self.paringCodeBgView.isHidden = true
                
            
                
                self.enableButton.setTitle(localised("Disable 2FA").uppercased(), for: .normal)
                
            
            if UIApplication.shared.statusBarOrientation.isLandscape{
                
                self.codeTextFieldLandsapeDisableCenterYConstraint.isActive = false
                self.infoLabelF2AEnableConstraint.isActive = false
                self.codeTextFieldLandscapeDisableCenterXConstraint.isActive = false
                self.infoLableLandscapeDisableWidthConstraint.isActive = false
                self.infoLabelLandscapeDisableBottomConstraint.isActive = false
                self.enableButtonLandscapeDisableTopConstraint.isActive = false
                
                
                self.infoLabelLandscapeEnableTopConstraint.isActive = true
                self.codeTextFieldLandscapeEnableTopConstraint.isActive = true
                self.infoLabelLandscapeEnableWidthConstraint.isActive = true
                self.infoLableLandscapeEnableCenterXConstraint.isActive = true
                self.codeTextFieldEnableCenterXConstraint.isActive = true
                self.enableButtonLandscapeEnableTopConstraint.isActive = true
                
                
                

            }else{
                
                
                self.qrCodeTopConstraint.isActive = false
                self.infoLabelTopConstraint.isActive = true
                self.infoLabelF2AEnableConstraint.isActive = false
                
                
                
            }
            
            
            
            
            }
            
       
            
            self.view.layoutIfNeeded()
        
        
//        viewTopConstraint.constant = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.shared.statusBarFrame.height

        }
    }

    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        DispatchQueue.main.async { [unowned self] in
            
            
            
            if UIApplication.shared.statusBarOrientation.isLandscape{
                // activate landscape changes
                
                if self.isGoogl2FAenabled == false{
             
//                    self.adressCodeLabel.isHidden = false
//                    self.addressLabel.isHidden = false
//                    self.copyButton.isHidden = false
//
//                    self.qrCodeTopConstraint.isActive = true
//                    self.infoLabelTopConstraint.isActive = false
//                    self.infoLabelF2AEnableConstraint.isActive = true
//
                    
                    
                }else{
                    
                    self.qrCodeImageViewWidth.constant = 0
                    self.addressViewHeight.constant = 0
                    self.adressCodeLabel.isHidden = true
                    self.addressLabel.isHidden = true
                    self.copyButton.isHidden = true
                    self.paringCodeBgView.isHidden = true
//
//                    self.qrCodeTopConstraint.isActive = false
//                    self.infoLabelTopConstraint.isActive = true
//                    self.infoLabelF2AEnableConstraint.isActive = false
                   
                    
                    self.codeTextFieldLandsapeDisableCenterYConstraint.isActive = false
                    self.infoLabelF2AEnableConstraint.isActive = false
                    self.codeTextFieldLandscapeDisableCenterXConstraint.isActive = false
                    self.infoLableLandscapeDisableWidthConstraint.isActive = false
                    self.infoLabelLandscapeDisableBottomConstraint.isActive = false
                    self.enableButtonLandscapeDisableTopConstraint.isActive = false


                    self.infoLabelLandscapeEnableTopConstraint.isActive = true
                    self.codeTextFieldLandscapeEnableTopConstraint.isActive = true
                    self.infoLabelLandscapeEnableWidthConstraint.isActive = true
                    self.infoLableLandscapeEnableCenterXConstraint.isActive = true
                    self.codeTextFieldEnableCenterXConstraint.isActive = true
                    self.enableButtonLandscapeEnableTopConstraint.isActive = true
                    
                }
                
            } else {
                // activate portrait changes
                
                if self.isGoogl2FAenabled == false{
                    self.adressCodeLabel.isHidden = false
                    self.addressLabel.isHidden = false
                    self.copyButton.isHidden = false
                    
                    self.qrCodeTopConstraint.isActive = true
                    self.infoLabelTopConstraint.isActive = false
                    self.infoLabelF2AEnableConstraint.isActive = true
                    
                    
                    
                }else{
                    
                    self.qrCodeImageViewWidth.constant = 0
                    self.addressViewHeight.constant = 0
                    self.adressCodeLabel.isHidden = true
                    self.addressLabel.isHidden = true
                    self.copyButton.isHidden = true
                    self.paringCodeBgView.isHidden = true
                    
                    self.qrCodeTopConstraint.isActive = false
                    self.infoLabelTopConstraint.isActive = true
                    self.infoLabelF2AEnableConstraint.isActive = false
                    
              
                    
                    
                }
                
                
                
                
            }
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
    }
    
    
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    //MARK: - Navigation bar helper
    func setNavigationbar(){
        
        //For Automation
        self.navigationItem.backBarButtonItem?.isAccessibilityElement = true
        self.navigationItem.backBarButtonItem?.accessibilityIdentifier = "NavigationBackButton"
        self.navigationItem.backBarButtonItem?.accessibilityLabel = "NavigationBackButton"
        
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = navigationTitle
        self.navigationItem.titleView = label
        
    }
    
    func setUpColors(){
        bgView.backgroundColor = Theme.current.backgroundColor
        infoLabel.textColor = Theme.current.titleTextColor
        
        codeTextField.placeholderColor = Theme.current.subTitleColor
        codeTextField.titleColor = Theme.current.titleTextColor
        codeTextField.lineColor = Theme.current.subTitleColor
        codeTextField.selectedLineColor  = Theme.current.subTitleColor
        codeTextField.selectedTitleColor = Theme.current.subTitleColor
        codeTextField.textColor = Theme.current.titleTextColor
        
        enableButton.backgroundColor = Theme.current.primaryColor
        enableButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        
        paringCodeBgView.backgroundColor = Theme.current.navigationBarColor
        copyButton.backgroundColor = Theme.current.primaryColor
        copyButton.setTitleColor(Theme.current.btnTextColor, for: .normal)
        addressLabel.textColor = Theme.current.titleTextColor
        addressLabel.text = localised("Pairing Code : ")
        adressCodeLabel.textColor = Theme.current.titleTextColor
        
    }
    
    
    //MARK:- Button Actions

    /// This will copy the human redable code
    @IBAction func copyButtonAction(_ sender: UIButton) {
        if adressCodeLabel.text != "N/A"{
            let pasteboard = UIPasteboard.general
            pasteboard.string = adressCodeLabel.text
            MDSnackBarHelper.shared.showSuccessMessage(message: localised("Paring code copied"),duration: 1)
        }
    }
    /// This will Enable/Disable google autheticator
    @IBAction func enable2FAAction(_ sender: Any) {
        self.view.endEditing(true)
        if codeTextField.text?.count == 6{
            let headers = ["Authorization":MDNetworkManager.shared.authToken] as [String : Any]
            let params = ["GAuth_Code":codeTextField.text!]
            MDHelper.shared.showHudOnWindow()
            MDNetworkManager.shared.sendRequest(methodType: .post, apiName:isGoogl2FAenabled == true ? API.googleAuthDisable : API.googleAuthEnableStep2, parameters: params as NSDictionary, headers: headers as NSDictionary) { (response, error) in
                MDHelper.shared.hideHudOnWindow()
                if response != nil && error == nil{
                    self.codeTextField.text = ""
                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                         let message = response?.valueForCaseInsensativeKey(forKey: "message") as? String ?? "null"
                            MDHelper.shared.showSucessAlert(message: message, viewController: self)
                            self.navigationController?.popViewController(animated: true)
                        //}
                    }else{
                         let message = response?.valueForCaseInsensativeKey(forKey: "message") as? String ?? "null"
                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                        //}
                    }
                }else{
                    if error != nil{
                        MDHelper.shared.showErrorAlert(message: error?.localizedDescription ?? "Error", viewController: self)
                    }
                }
            }
        }else{
            MDHelper.shared.showErrorAlert(message: localised("Please enter your 6-digit authenticator code"), viewController: self)
        }
    }
    
    //MARK - Network Calls
    
    /// This will fetch qrCode and human readable code from the server
    func fetchQrCode(){
         let headers = ["Authorization":MDNetworkManager.shared.authToken]
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.googleAuthEnableStep1,
                                            parameters: nil, headers: headers as NSDictionary) {[unowned self] (response, error) in
                                                if response != nil && error == nil{
                                                    MDHelper.shared.hideHudOnWindow()
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? NSDictionary{
                                                            if let qrCOdeUrlString = data.valueForCaseInsensativeKey(forKey: "qr_code") as? String{
                                                                self.qrCodeImageView.downloaded(from: qrCOdeUrlString,isbase64:true)
                                                                if let pairingCode = data.valueForCaseInsensativeKey(forKey: "pairingCode") as? String{
                                                                    self.adressCodeLabel.text = pairingCode
                                                                }
                                                            }
                                                        }
                                                    }else{
                                                        if let message = response?.valueForCaseInsensativeKey(forKey: "message") as? String{
                                                            
                                                            MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                        }
                                                    }
                                                }else{
                                                    if error != nil{
                                                        MDHelper.shared.showErrorAlert(message: error?.localizedDescription ?? "Error", viewController: self)
                                                    }
                                                }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MDGoogleAuthVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count)!>=6{
            if string == ""{
                return true
            }
            return false
        }
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        IQKeyboardManager.shared.reloadLayoutIfNeeded()
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        
        
        
        return true
    }
    
    
    
    
    
    
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
                MDHelper.shared.hideHudOnWindow()
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill,isbase64:Bool) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        
        if isbase64{
            guard let url = URL(string: link) else {return}
            let data = try! Data(contentsOf: url)
            self.image = UIImage(data: data)
//            downloaded(from: link, isbase64: true)
        }else{
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
       
    }
    
    /***Set currency Logo*/
//    func setImage(icon : String){
//        let svgUrl = URL(string: "https://demo.modulusexchange.com/assets/cryptocurrency-icons/color/\(icon.lowercased()).svg")!
//               let processor = SVGProcessor(size: CGSize(width: 20, height: 20))
//               KingfisherManager.shared.retrieveImage(with: svgUrl, options: [.processor(processor), .forceRefresh]) {  result in
//                       switch (result){
//                           case .success(let value):
//                               self.image = value.image
//                           case .failure(let error):
//                               print("error", error.localizedDescription)
//                       }
//               }
//        
//        
//    }
}

//struct SVGProcessor: ImageProcessor {
//
//    // `identifier` should be the same for processors with the same properties/functionality
//    // It will be used when storing and retrieving the image to/from cache.
//    let identifier = "svgprocessor"
//    var size: CGSize!
//    init(size: CGSize) {
//        self.size = size
//    }
//    // Convert input data/image to target image and return it.
//    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> UIImage? {
//        switch item {
//        case .image(let image):
//            return image
//        case .data(let data):
//            if let svgString = String(data: data, encoding: .utf16){
//                print(svgString)
//                let path = SVGBezierPath.paths(fromSVGString: svgString)
//                let layer = SVGLayer()
//                layer.paths = path
//                let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//                layer.frame = frame
//                let img = self.snapshotImage(for: layer)
//                return img
//            }
//            return nil
//        }
//    }
//    func snapshotImage(for view: CALayer) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        view.render(in: context)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//}
