//
//  INDepthChartView.swift
//  Modulus
//
//  Created by Pathik  on 05/10/18.
//  Copyright © 2018 Inspeero Technologies. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}
class INDepthChartView: UIView {

    var shouldFormatDoubles = false{
        didSet{
        self.depthChart.shouldFormatDoubles = shouldFormatDoubles
        }
    }
  //  @IBOutlet weak var leftLabeView: UIView!
  //  @IBOutlet weak var depthChartView: UIView!
    var leftLayerToAddToView : CHTextLayer?
    //Maximum depth
    var maxAmount: Float = 0
    
    ///data source
    var depthDatas: [CHKDepthChartItem] = [CHKDepthChartItem]()
    
    /// 深度图:Note the depth chart at left-sell orders did not test the feasibility
    /// ****
    // Important things to pay attention to：The abscissa of the depth map is based on the number of gear positions, so there is no intermediate gap. The horizontal coordinate of the depth map on the market is the price range as the horizontal coordinate length ****
    lazy var depthChart: CHDepthChartView = {
        
        //If you use a third-party layout, you need to give a depth map when you create it.frame,Otherwise not displayed
        let view = CHDepthChartView(frame: CGRect(x: 0, y: 0, width: 100, height: 180))
        view.delegate = self
        view.style = .depthStyle
        view.mySuperView = self
        
        //        view.yAxis.referenceStyle = .solid(color:UIColor(hex:0x2E3F53))
        view.yAxis.referenceStyle = .none
        return view
    }()
    
    ///When the sell order is used to calculate the data source, pay attention to the calculation of that data.
    var bids = [MarketDepthData](){
        didSet{
            self.decodeDatasToAppend(datas: bids.reversed(), type: .bid)
            self.depthChart.reloadData()
        }
    }
    
    var asks = [MarketDepthData](){
        didSet{
            if self.depthDatas.count > 0{
                self.depthDatas.removeAll()
            }
            self.maxAmount = 0
            self.decodeDatasToAppend(datas: asks, type: .ask)
        }
    }
    
    var leftTextLayer : CHTextLayer?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        configureDepthChartView()
//        if let lfL = self.depthChartView.leftTextLayer{
//            lfL.frame = self.leftView.frame
//            lfL.alignmentMode = kCAAlignmentRight
//            self.leftView.layer.addSublayer(lfL)
       // }

        
    }
  
    func configureDepthChartView()  {
        self.depthChart.removeFromSuperview()
        self.addSubview(self.depthChart)
        self.depthChart.clearConstraints()
        self.depthChart.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self.frame.size.width)
            make.height.equalTo(self.frame.size.height)

        }
    }

    
    
    
    
    func configureDepthChart(response : NSDictionary) {
        
        
        // Get files randomly
//        let index = arc4random() % 4 + 1
//        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Market\(index)", ofType: "json")!))
//        guard let json = try? JSON(data: data!) else {
//            return
//        }
        let json = JSON.init(response)
        //Let datas = json["datas"]
        let datas = json["data"]
        let asksArr = datas["asks"].arrayValue
        let bidsArr = datas["bids"].arrayValue
        
        
        
        if bidsArr.count>0 || asksArr.count>0{
        var asks = [MarketDepthData]()
        for asksJson in asksArr {
            let mutableArray = (asksJson.arrayObject! as NSArray).mutableCopy() as! NSMutableArray
            mutableArray.replaceObject(at: 0, with: String(format: "%.6f", Double((asksJson.array?.first?.string ?? "\(asksJson.array?.first ?? 0.00)"))! ))
            let array = mutableArray.copy() as! NSArray
            let json = JSON.init(array)
            let ask = MarketDepthData(json: json, currencyType: "", exchangeType: ExchangeType.Sell)
            asks.append(ask)
        }
      
        var bids = [MarketDepthData]()
        for bidsJson in bidsArr {
            let mutableArray = (bidsJson.arrayObject! as NSArray).mutableCopy() as! NSMutableArray
            mutableArray.replaceObject(at: 0, with: String(format: "%.6f", Double((bidsJson.array?.first?.string ?? "\(bidsJson.array?.first ?? 0.00)"))! ))
            let array = mutableArray.copy() as! NSArray
            let json = JSON.init(array)
            let bid = MarketDepthData(json: json, currencyType: "", exchangeType: ExchangeType.Buy)
            bids.append(bid)
        }
        self.asks = asks
        self.bids = bids
        }
    }
    /// Analytical analysis
    func decodeDatasToAppend(datas: [MarketDepthData], type: CHKDepthChartItemType) {
        var total: Float = 0
        
        if datas.count > 0 {
            for data in datas {
                let item = CHKDepthChartItem()
                item.value = CGFloat(data.price)
                item.amount = CGFloat(data.quantity.toDouble())
                item.type = type
                
                self.depthDatas.append(item)
                
                total += Float(item.amount)
            }
        }
        
        if total > self.maxAmount {
            self.maxAmount = total
        }
    }
    
}
//MARK:-Depth chart delegate
extension INDepthChartView : CHKDepthChartDelegate {
    
    /// The total number of charts
    ///Total = buyer + seller
    /// - Parameter chart:
    /// - Returns:
    func numberOfPointsInDepthChart(chart: CHDepthChartView) -> Int {
        return self.depthDatas.count
    }
    
    
    /// Numerical item displayed at each point
    ///
    /// - Parameters:
    ///   - chart:
    ///   - index:
    /// - Returns:
    func depthChart(chart: CHDepthChartView, valueForPointAtIndex index: Int) -> CHKDepthChartItem {
        return self.depthDatas[index]
    }
    
    
    /// The y axis is established with the base value
    ///
    /// - Parameter depthChart:
    /// - Returns:
    func baseValueForYAxisInDepthChart(in depthChart: CHDepthChartView) -> Double {
        return 0
    }
    
    ///The increment of each segment after the y-axis is established with the base value
    ///
    /// - Parameter depthChart:
    /// - Returns:
    func incrementValueForYAxisInDepthChart(in depthChart: CHDepthChartView) -> Double {
        
        //
        //Calculate a friendly effect that shows 4 guides
        //        var step = self.maxAmount / 4
        //        var j = 0
        //        while step / 10 > 1 {
        //            j += 1
        //            step = step / 10
        //        }
        //
        //        //幂运算
        //        var pow: Int = 1
        //        if j > 0 {
        //            for _ in 1...j {
        //                pow = pow * 10
        //            }
        //        }
        //
        //        step = Float(lroundf(step) * pow)
        //
        //        return Double(step)
        let step = Double(self.maxAmount / 4)
        
//        print("setp == \(step)")
        return step
    }
    /// Ordinate value display spacing
    func widthForYAxisLabelInDepthChart(in depthChart: CHDepthChartView) -> CGFloat {
        return 30
    }
    ///
    //Vertical coordinate value
    func depthChart(chart: CHDepthChartView, labelOnYAxisForValue value: CGFloat) -> String {
        if value >= 1000{
            let newValue = value / 1000
            return newValue.ch_toString(maxF: 0) + "K"
        }else {
            return value.ch_toString(maxF: 1)
        }
    }
    
    /// Price decimal place
    func depthChartOfDecimal(chart: CHDepthChartView) -> Int {
        return 4
    }
    
    ///
    //Amount of decimal places
    func depthChartOfVolDecimal(chart: CHDepthChartView) -> Int {
        return 6
    }
    
}
//Depth chart required extensions

// MARK:- Extensible Stylesheet
extension CHKLineChartStyle {
    
    
    /// 深度图样式
    static var depthStyle: CHKLineChartStyle = {
        
        let style = CHKLineChartStyle()
        //字体大小
        style.labelFont = UIFont.systemFont(ofSize: 12)
        //分区框线颜色
//        style.lineColor = UIColor(white: 0.7, alpha: 1)
        style.lineColor = UIColor(white: 0.7, alpha: 1)
        //背景颜色
        style.backgroundColor = UIColor.clear
        //文字颜色
        style.textColor = UIColor.white
        //整个图表的内边距
        style.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //Y轴是否内嵌式
        style.isInnerYAxis = true
            //Y轴显示在右边
        style.showYAxisLabel = .left
        
        /// 买单居右
        style.bidChartOnDirection = .left
        
        //边界宽度
        style.borderWidth = (0, 0, 0, 0)
        
        //是否允许手势点击
        style.enableTap = true
//        style.enableTap = false
        
        //买方深度图层的颜色 UIColor(hex:0xAD6569) UIColor(hex:0x469777)
        style.bidColor = (UIColor(hex:0x469777), UIColor(hex:0x469777).withAlphaComponent(0.2), 1)//(UIColor(hex:0xAD6569), UIColor(hex:0xAD6569).withAlphaComponent(0.2), 1)
        //        style.askColor = (UIColor(hex:0xAD6569), UIColor(hex:0xAD6569), 1)
        //买方深度图层的颜色
        style.askColor = (UIColor(hex:0xAD6569), UIColor(hex:0xAD6569).withAlphaComponent(0.2), 1)//(UIColor(hex:0x469777), UIColor(hex:0x469777).withAlphaComponent(0.2), 1)
        //        style.bidColor = (UIColor(hex:0x469777), UIColor(hex:0x469777), 1)
        
        return style
        
    }()
}

public extension CGFloat {
    
    /**
     转化为字符串格式
     
     - parameter minF:
     - parameter maxF:
     - parameter minI:
     
     - returns:
     */
    func ch_toString(_ minF: Int = 2, maxF: Int = 6, minI: Int = 1) -> String {
        let valueDecimalNumber = NSDecimalNumber(value: Double(self) as Double)
        let twoDecimalPlacesFormatter = NumberFormatter()
        twoDecimalPlacesFormatter.maximumFractionDigits = maxF
        twoDecimalPlacesFormatter.minimumFractionDigits = minF
        twoDecimalPlacesFormatter.minimumIntegerDigits = minI
        return twoDecimalPlacesFormatter.string(from: valueDecimalNumber)!
    }
}


extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
