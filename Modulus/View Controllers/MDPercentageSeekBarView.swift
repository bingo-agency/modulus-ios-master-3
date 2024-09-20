//
//  MDPercentageSeekBarView.swift
//  Modulus
//
//  Created by Rahul on 09/12/20.
//  Copyright © 2020 Bhavesh Sarwar. All rights reserved.
//

import UIKit
class MDPercentageSeekBarView: UIView {
    static let identifier = "MDPercentageSeekBarView"
    @IBOutlet weak var percentageBar: UIView!
    @IBOutlet weak var completedBarView: UIView!
    var circularViewArray : [UIView] = []
    var thumbView = UIView()
    var bubbleView = UIView()
    var percentageLabel = UILabel()
    var isBuyTypeScreen : Bool = false
    var delegate : MDPercentageBarDelegate?
    @IBOutlet weak var completedPathConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.setUpView()
    }

    
    private func setUpView(){
        self.percentageBar.layer.cornerRadius = 10
        self.percentageBar.backgroundColor = Theme.current.percentageBarBgColor
        self.initPosOfThumb()
        self.setFiveCircles()
    }
    
    //set thumb pos to start of percentageBar
    //set label to display percentage and triangular corner view at bottom
    private func initPosOfThumb(){
        DispatchQueue.main.async {
            let thumbView = UIView.init(frame: CGRect.init(x: -11, y: -2.5, width: 25, height: 25))
            thumbView.backgroundColor = .red
            thumbView.layer.cornerRadius = 25/2
            thumbView.backgroundColor = .white
            self.addSubview(thumbView)
            self.thumbView = thumbView
            self.bubbleView.frame = CGRect.init(x: 0, y: -50, width: 50, height: 30)
            self.percentageLabel.frame = CGRect.init(x: 0, y: 0, width: 50, height: 30)
            self.percentageLabel.textAlignment = .center
            self.percentageLabel.font = .systemFont(ofSize: 13)
            self.bubbleView.addSubview(self.percentageLabel)
            self.percentageLabel.clipsToBounds = true
            self.percentageLabel.text = "0%"
            self.bubbleView.isHidden = true
            let bgColor = UIColor.init(red: 0.247, green: 0.235, blue: 0.298, alpha: 1)
            self.percentageLabel.textColor = .white
            self.circularEdges(view: self.percentageLabel)
            self.percentageLabel.backgroundColor = bgColor
            self.addSubview(self.bubbleView)

            //draw triangular path
            let path = UIBezierPath()
            path.move(to: CGPoint(x:self.bubbleView.frame.width / 2 - 10, y: self.bubbleView.frame.height - 2))
            path.addLine(to: CGPoint(x: self.bubbleView.frame.width / 2 + 10, y: self.bubbleView.frame.height - 2))
            path.addLine(to: CGPoint(x: self.bubbleView.frame.width / 2, y: self.bubbleView.frame.height + 8))
            path.addLine(to: CGPoint(x:self.bubbleView.frame.width / 2 - 10, y: self.bubbleView.frame.height - 2))
            path.close()

            let shape = CAShapeLayer()
            shape.fillColor = bgColor.cgColor
            shape.path = path.cgPath

            self.bubbleView.layer.addSublayer(shape)
            self.percentageLabel.layer.cornerRadius = 10
        }
    }
    
    func didChangedTotalTFManually(value : Double){
        print("value \(value)")
        let posAndValue = self.getXPosAndValueFormPercentage(value: value)
        DispatchQueue.main.async {
            self.thumbView.center.x = posAndValue.0
            self.completedPathConstraint.constant = posAndValue.0
            self.updateCircles(percentage: posAndValue.1)
        }
       
    }
    
    private func getXPosAndValueFormPercentage(value : Double)->(CGFloat,Int){
        if value >= 100{
            return (self.frame.width , 100)
        }
        if value > 0{
            return ((self.frame.width * CGFloat(value) / 100),Int(value))
        }
        return (0.0 , 0)
    }
    
    
    //set five circles that represents the percentages (0 - 25 - 50 - 100)
    func setFiveCircles(){
         DispatchQueue.main.async {
            let bgColor = self.isBuyTypeScreen ? Theme.current.secondaryColor : Theme.current.primaryColor
            for i in 0...4{
                let xPos = self.xPosForCircularView(for: i)
                let circularView = UIView.init(frame: CGRect.init(x: xPos , y: -1, width: 22, height: 22))
                circularView.backgroundColor = bgColor
                self.addSubview(circularView)
                self.circularEdges(view: circularView)
                self.circularViewArray.append(circularView)
            }
            self.completedBarView.backgroundColor = bgColor
            self.bringSubviewToFront(self.thumbView)
            self.addPercentageBarForEachCircle()
        }
    }
    
    //Buy or sell button tapped from view controller
    func screenChanged(){
        self.isBuyTypeScreen.toggle()
        let bgColor = self.isBuyTypeScreen ? Theme.current.secondaryColor : Theme.current.primaryColor
        for each in circularViewArray{
            each.backgroundColor = bgColor
        }
        self.completedBarView.backgroundColor = bgColor
        self.thumbView.center.x = 0
        self.completedPathConstraint.constant = 0
        DispatchQueue.main.async {
            self.updateCircles(percentage: 0)
        }
    }
    
    //Called when orientation of view will change eg.moving from portrait Landscape view and vice - verca
    func ViewWillTransit(){
        for each in circularViewArray{
            each.removeFromSuperview()
        }
        self.circularViewArray.removeAll()
        self.setFiveCircles()
        let percentage = self.percentageLabel.text?.split(separator: "%")
        let string = String(percentage!.first!)
        let float = (string as NSString).floatValue
        let width = self.frame.width
        let pos = (width * CGFloat(float)) / 100
        self.thumbView.center.x = pos
        self.completedPathConstraint.constant = pos
        DispatchQueue.main.async {
            self.updateSeekBar(percentage: CGFloat(float))
        }
    }
    
    // add percentage label at bottom of Circle
    private func addPercentageBarForEachCircle(){
        for (i,view) in self.circularViewArray.enumerated(){
            let label = UILabel.init(frame: CGRect.init(x: -5, y: view.frame.height + 2 , width: 40, height: 20))
            label.font = .boldSystemFont(ofSize: 12)
            label.text = "\(i * 25)%"
            label.textAlignment = .center
            label.textColor = Theme.current.titleTextColor
            label.backgroundColor = .clear
            view.addSubview(label)
        }
    }
    
    //calculate position for Circular view on percentage Bar
    private func xPosForCircularView(for index : Int)->CGFloat{
         let posPercentage : CGFloat = CGFloat(index) / CGFloat(4.0)
         return ((self.frame.width) * posPercentage - 11)
     }
    
    
    //Rounded edges for view
    private func circularEdges(view : UIView){
        view.layer.cornerRadius = view.frame.height / 2.0
    }
    
    //calculate percentage when bar is moved
    private func calculatePercentage(xPos : CGFloat) -> CGFloat{
        if xPos == 0{
            return 0
        }
        let width = self.frame.width
        let percentage = ((xPos) / width) * 100
        return percentage
    }
    
    //disable scroll view of view controller while moving thumb i.e. white Circular head
    private func disableScrollView(){
        delegate?.didBeginPercentageBarEditing()
    }
    
    //Re-enable after done moving thumb to specific pos
    private func enabledScrollView(){
        delegate?.didEndPercentageBarEditing()
    }
    
    //Update View after bar is moving
    private func updateSeekBar(percentage : CGFloat){
        let intValue = Int.init(round(percentage))
        self.percentageLabel.text = "\(intValue)%"
        delegate?.didMovedPercentageBar(percentage: intValue)
        self.updateCircles(percentage: intValue)
    }
    
    private func updateCircles(percentage : Int){
        let noOfcirclesCoverBySeekBar : Int
        if percentage == 100{
            noOfcirclesCoverBySeekBar = 3
        }else{
            noOfcirclesCoverBySeekBar = Int(percentage / 25)
        }
        
        for each in  0...noOfcirclesCoverBySeekBar{
            if (noOfcirclesCoverBySeekBar != self.circularViewArray.count-1){
                self.addBorder(view: self.circularViewArray[each])
            }
        }
        if noOfcirclesCoverBySeekBar+1 < self.circularViewArray.count-1{
            for index in noOfcirclesCoverBySeekBar+1...self.circularViewArray.count-1{
                self.removeBorder(view: self.circularViewArray[index])
            }
        }
    }
    
    //Add border for circle who comes inside competed percentage bar
    private func addBorder(view : UIView){
         view.layer.borderColor = UIColor.white.cgColor
         view.layer.borderWidth = 3
     }
     
     //Remove border for circle who comes inside competed percentage bar
     private func removeBorder(view : UIView){
         view.layer.borderWidth = 0
     }
    
    
    //MARK:- Detect Touches on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            self.disableScrollView()
            self.bubbleView.isHidden = false
            var pos = touch.location(in: self).x
            DispatchQueue.main.async{
            var percentage = self.calculatePercentage(xPos: pos)
            if percentage >= 100 {
                pos = self.frame.width
                percentage = 100
            }else if percentage <= 0{
                pos = 0
                percentage = 0
                }
            
                self.completedPathConstraint.constant = pos
                self.thumbView.center.x = pos
                self.bubbleView.center.x = pos
                self.updateSeekBar(percentage: percentage)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            var pos = touch.location(in: self).x
            DispatchQueue.main.async{
            var percentage = self.calculatePercentage(xPos: pos)
            if percentage >= 100 {
                pos = self.frame.width
                percentage = 100
            }else if percentage <= 0{
                pos = 0
                percentage = 0
                }
               
                self.completedPathConstraint.constant = pos
                self.thumbView.center.x = pos
                self.bubbleView.center.x = pos
                self.updateSeekBar(percentage: percentage)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.enabledScrollView()
        self.bubbleView.isHidden = true
    }
}


protocol MDPercentageBarDelegate {
    func didMovedPercentageBar(percentage : Int)
    func didBeginPercentageBarEditing()
    func didEndPercentageBarEditing()
}
