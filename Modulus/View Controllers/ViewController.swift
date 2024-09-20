//
//  ViewController.swift
//  Modulus
//
//  Created by Pathik  on 09/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let depthChartView : INDepthChartView = UIView.fromNib()
        self.view.addSubview(depthChartView)
        depthChartView.translatesAutoresizingMaskIntoConstraints = false
        
        depthChartView.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height*0.6)
        depthChartView.center = self.view.center;
        NSLayoutConstraint(item: depthChartView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.size.width).isActive = true
        NSLayoutConstraint(item:depthChartView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.size.height*0.6).isActive = true
       
        depthChartView.configureDepthChartView()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

