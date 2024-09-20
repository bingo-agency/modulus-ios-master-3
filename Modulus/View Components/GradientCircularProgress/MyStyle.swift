//
//  MyStyle.swift
//  GradientCircularProgress
//
//  Created by keygx on 2015/11/25.
//  Copyright (c) 2015年 keygx. All rights reserved.
//
import UIKit

public struct MyStyle: StyleProperty {
    /*** style properties **********************************************************************************/
    
    // Progress Size
    public var progressSize: CGFloat = 75
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 16
    public var startArcColor: UIColor = UIColor.clear
    public var endArcColor: UIColor = Theme.current.primaryColor
    
    // Base Circular
    public var baseLineWidth: CGFloat? = 16
    public var baseArcColor: UIColor? = UIColor.clear
    
    // Ratio
    public var ratioLabelFont: UIFont? = UIFont(name: "Verdana-Bold", size: 16.0)
    public var ratioLabelFontColor: UIColor? = UIColor.white
    
    // Message
    public var messageLabelFont: UIFont? = UIFont.systemFont(ofSize: 16.0)
    public var messageLabelFontColor: UIColor? = UIColor.white
    
    // Background
    public var backgroundStyle: BackgroundStyles = .transparent
    
    // Dismiss
    public var dismissTimeInterval: Double? = 0.0 // 'nil' for default setting.
    
    /*** style properties **********************************************************************************/
    
    public init() {}
}
