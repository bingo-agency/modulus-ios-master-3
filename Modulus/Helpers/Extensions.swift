//
//  Extensions.swift
//  Modulus
//
//  Created by Pathik  on 11/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class Extensions: NSObject {

    
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

extension String {
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
}
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color1.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    public func viewController()->UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
}

extension UIColor {
    func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension NSDictionary{
    
    func valueForCaseInsensativeKey(forKey:String)->Any?{
        let allKeys = self.allKeys
        for keyToCompare in allKeys{
            if forKey.lowercased() == (keyToCompare as! String).lowercased(){
                return self.value(forKey:keyToCompare as! String)
            }
        }
        return nil
    }
}
extension UINavigationController{
    open override func viewWillLayoutSubviews() {
        self.navigationBar.subviews.first?.backgroundColor = UIColor.red
        for view in self.navigationBar.subviews{
            if view is UIButton{
                
            }else{
                view.backgroundColor = Theme.current.navigationBarColor
            }
        }
        if let _ = self.navigationBar.viewWithTag(212121){
            
        }else{
            let subview = UIView(frame: CGRect(x: 0,
                                               y: -UIApplication.shared.statusBarFrame.height,
                                               width: self.navigationBar.bounds.width,
                                               height: UIApplication.shared.statusBarFrame.height))
            subview.backgroundColor = Theme.current.navigationBarColor
            subview.tag = 212121
            self.navigationBar.addSubview(subview)
        }
    }
    
}

extension UITextField {
    
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return true
//    }
    
    enum PaddingMode {
        case left
        case right
    }
    func isEmpty()->Bool{
        return self.text?.count == 0 
    }
    func disableSuggestionsAndAutoCorrect(){
        self.keyboardToolbar.isHidden = true
        self.autocorrectionType = .no
    }
    @IBInspectable var placeHolderColorCustom: UIColor? {
        get {
            return self.placeHolderColorCustom
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
        
    func addPaddingView(mode : PaddingMode,imageWidth:CGFloat = 25,paddingHeightPercent: CGFloat = 1,paddingWidthPercent: CGFloat = 1,image : UIImage,onActionClosure : UIButtonTargetClosure?) {
        
        let eyeButtonWidthHeight = self.frame.size.height*paddingHeightPercent
       let paddingButton = UIButton.init(type: .custom)
      
        
        paddingButton.showsTouchWhenHighlighted = false
        paddingButton.imageView?.contentMode = .scaleAspectFit
        paddingButton.imageView?.clipsToBounds = true
        if let closure = onActionClosure{
            paddingButton.addTargetClosure(closure: closure)
        }
        paddingButton.setImage(image, for: .normal)
        
        paddingButton.contentVerticalAlignment = .center
        paddingButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        if mode == .left {
              paddingButton.frame = CGRect.init(x: self.frame.size.width - eyeButtonWidthHeight , y: self.frame.size.height - eyeButtonWidthHeight - 10, width: imageWidth, height: eyeButtonWidthHeight-10)
            self.leftView = paddingButton
            self.leftViewMode = .always
            paddingButton.contentHorizontalAlignment = .left
        }else {
              paddingButton.frame = CGRect.init(x: 0 , y: self.frame.size.height - eyeButtonWidthHeight - 10
                , width: imageWidth, height: eyeButtonWidthHeight-10)
            self.rightView = paddingButton
            self.rightViewMode = .always
            paddingButton.contentHorizontalAlignment = .right
            
        }
    }
    
    
    func addPaddingViews(mode : PaddingMode,imageWidth:CGFloat = 400,paddingHeightPercent: CGFloat = 1,paddingWidthPercent: CGFloat = 1,image : UIImage,onActionClosure : UIButtonTargetClosure?) {
        
        let eyeButtonWidthHeight = self.frame.size.height*paddingHeightPercent
       let paddingButton = UIButton.init(type: .custom)
      
        
        paddingButton.showsTouchWhenHighlighted = false
        paddingButton.imageView?.contentMode = .scaleAspectFit
        paddingButton.imageView?.clipsToBounds = true
        if let closure = onActionClosure{
            paddingButton.addTargetClosure(closure: closure)
        }
        paddingButton.setImage(image, for: .normal)
        
        paddingButton.contentVerticalAlignment = .center
        paddingButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        if mode == .left {
              paddingButton.frame = CGRect.init(x: 0 , y: 0  , width: 200, height: 50)
            self.leftView = paddingButton
            self.leftViewMode = .always
            paddingButton.contentHorizontalAlignment = .left
        }else {
              paddingButton.frame = CGRect.init(x: 0 , y: self.frame.size.height - eyeButtonWidthHeight - 10
                , width: imageWidth, height: eyeButtonWidthHeight-10)
            self.rightView = paddingButton
            self.rightViewMode = .always
            paddingButton.contentHorizontalAlignment = .right
            
        }
    }
    
    
    
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}



typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.viewController() != nil{
            self.viewController()?.view.endEditing(true)
        }
    }
}
class MDButtonWithImage: UIButton {
    override func draw(_ rect: CGRect) {
        alignVertical(spacing: 10) 
    }
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}
class MDButtonWithImageOnRight: UIButton {
    @IBInspectable var spacingBetweenImage: CGFloat = 6.0
    
    override func draw(_ rect: CGRect) {
        alignVertical(spacing: spacingBetweenImage)
    }
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left:0.0 , bottom: 0.0, right: imageSize.width )
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        let leftSpacing = self.frame.size.width - 20 - imageSize.width
        self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: leftSpacing, bottom: 0.0, right:-(titleSize.width + spacing))
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: edgeOffset, bottom: 0.0, right: edgeOffset)
    }
}
class MDButtonPrice: UIButton {
    @IBInspectable var spacingBetweenImage: CGFloat = 2.0
    var contentSpacing : CGFloat = 10.0
    override func draw(_ rect: CGRect) {
        alignVertical(spacing: spacingBetweenImage)
    }
    func alignVertical(spacing: CGFloat ) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left:0.0 , bottom: 0.0, right: imageSize.width+10 )
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        let leftSpacing = self.frame.size.width  - imageSize.width - contentSpacing
        let rightSpacing = titleSize.width + spacing
        self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: leftSpacing, bottom: 0.0, right:-rightSpacing)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: edgeOffset-contentSpacing, bottom: 0.0, right: edgeOffset)
    }
    func refreshButton()  {
         alignVertical(spacing: spacingBetweenImage)
    }
}
@IBDesignable
class MDSideCornerView: UIView {
    
    override func draw(_ rect: CGRect) {
        roundCorners(corners: [.topLeft, .bottomLeft], radius:10)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

@IBDesignable
class MDSideCornerLeftButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        roundCorners(corners: [.topLeft, .bottomLeft], radius:3)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
@IBDesignable
class MDSideCornerRightButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        roundCorners(corners: [.topRight, .bottomRight], radius:3)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
extension Date {
    func toMillis() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
}

extension Float {
    var avoidNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}
