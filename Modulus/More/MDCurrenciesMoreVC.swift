//
//  MDCurrenciesMoreVC.swift
//  Modulus
//
//  Created by Abhijeet on 10/19/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit

enum CurrencySorter {
    case nameup
    case nameDown
    case priceUp
    case priceDown
    case percUp
    case percDown
}

class MDCurrenciesMoreVC: UIViewController {

    @IBOutlet weak var currencyTable: UITableView!
   // @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var nameUpImg: UIImageView!
    @IBOutlet weak var nameDownImg: UIImageView!
    
    @IBOutlet weak var priceUpImg: UIImageView!
    @IBOutlet weak var priceDownImg: UIImageView!
    
    @IBOutlet weak var percUpImg: UIImageView!
    @IBOutlet weak var percDownImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var changeLbl: UILabel!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchView: UIViewX!
    
    
    var currencyDataSource = [NSDictionary]()
    var temp_Arr = [NSDictionary]()
    
    var sortHelper : CurrencySorter = .nameup{
        didSet{
            self.sortList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.getCurrencies()
        self.setUpColors()
        
    }
    
    //MARK: - UI Helpers
    func setUpUI(){
        
        self.searchText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.searchText.placeholder = "Enter your search"
        
        let label = UILabel()
        label.textColor = Theme.current.titleTextColor
        label.font = MDAppearance.Fonts.smallNavigationTitleFont
        label.text = "Currencies"
        self.navigationItem.titleView = label
    }
    
    
    func sortList(){
        if self.currencyDataSource.count == 0{
            return
        }
        //Up - Descending
        //Down - Ascending
        switch self.sortHelper {
        case .nameup:
            self.currencyDataSource = self.currencyDataSource.sorted(by: { (dict1, dict2) -> Bool in
                return ((dict1["exchangeTicker"] as? String)!) > ((dict2["exchangeTicker"] as? String)!)
            })
            break
        case .nameDown:
            self.currencyDataSource = self.currencyDataSource.sorted(by: { (dict1, dict2) -> Bool in
                return ((dict1["exchangeTicker"] as? String)!) < ((dict2["exchangeTicker"] as? String)!)
            })
            break
        case .priceUp:
            self.currencyDataSource = self.currencyDataSource.sorted(by: { (dict1, dict2) -> Bool in
                return ((dict1["price"] as? String)!) > ((dict2["price"] as? String)!)
            })
            break
        case .priceDown:
            self.currencyDataSource = self.currencyDataSource.sorted(by: { (dict1, dict2) -> Bool in
                return ((dict1["price"] as? String)!) < ((dict2["price"] as? String)!)
            })
            break
        case .percUp:
            self.currencyDataSource = self.currencyDataSource.sorted(by: { (dict1, dict2) -> Bool in
                return (Float(dict1["priceChangePercent24hr"] as? String ?? "0") ?? 0) > (Float(dict2["priceChangePercent24hr"] as? String ?? "0") ?? 0)
            })
            break
        case .percDown:
            self.currencyDataSource = self.currencyDataSource.sorted(by: { (dict1, dict2) -> Bool in
                return (Float(dict1["priceChangePercent24hr"] as? String ?? "0") ?? 0) < (Float(dict2["priceChangePercent24hr"] as? String ?? "0") ?? 0)
            })
            break
        
        }
        DispatchQueue.main.async { [weak self] in
            self?.setUpImageColors()
            self?.currencyTable.reloadData()
       }
    }
    
    func setUpImageColors(){
        
        self.nameUpImg.tintColor = self.sortHelper == .nameup ? Theme.current.primaryColor : .gray
        self.nameDownImg.tintColor = self.sortHelper == .nameDown ? Theme.current.primaryColor : .gray
        
        self.priceUpImg.tintColor = self.sortHelper == .priceUp ? Theme.current.primaryColor : .gray
        self.priceDownImg.tintColor = self.sortHelper == .priceDown ? Theme.current.primaryColor : .gray
        
        self.percUpImg.tintColor = self.sortHelper == .percUp ? Theme.current.primaryColor : .gray
        self.percDownImg.tintColor = self.sortHelper == .percDown ? Theme.current.primaryColor : .gray
        
        
    }
    
    private
    func setUpColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        
        self.nameLbl.textColor = Theme.current.titleTextColor
        self.priceLbl.textColor = Theme.current.titleTextColor
        self.changeLbl.textColor = Theme.current.titleTextColor
        
        self.filterView.backgroundColor = Theme.current.navigationBarColor
        self.searchView.backgroundColor = Theme.current.mainTableCellsBgColor
        self.searchText.textColor = Theme.current.titleTextColor
        
        
    }
    
    //MARK: - API calls
    func getCurrencies(){
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(baseUrl:API.baseURL,
                                            methodType: .get,
                                            apiName: API.get_coin_stats,
                                            parameters: nil,
                                            headers: nil) { (response, error) in
                                                //Handle Response Here
                                                MDHelper.shared.hideHudOnWindow()
                                                if response != nil && error == nil{
                                                    if MDNetworkManager.shared.isResponseSucced(response: response!){
                                                        if let data = response?.value(forKey: "data") as? NSDictionary{
                                                            //if let aave = data.value(forKey: "aave") as? [NSDictionary]{
                                                                self.currencyDataSource = data.allValues as? [NSDictionary] ?? []
                                                                self.temp_Arr = data.allValues as? [NSDictionary] ?? []
                                                                DispatchQueue.main.async { [weak self] in
                                                                    self?.currencyTable.reloadData()
                                                                }
                                                            //}
                                                        }
                                                    }else{
                                                        let message = response?.valueForCaseInsensativeKey(forKey: "Message") as? String ?? "Error occured"
                                                          MDHelper.shared.showErrorAlert(message: message, viewController: self)
                                                    }
                                                }else{
                                                    if  error != nil{
                                                        MDHelper.shared.showErrorPopup(message:(error?.localizedDescription)!)
                                                    }
                                                }

        }
        
    }

    
    
    //MARK: - IBActions
    @IBAction func changePriceAction(_ sender: Any) {
        self.sortHelper = self.sortHelper == .priceUp ? .priceDown : .priceUp
        
    }
    @IBAction func changeNameAction(_ sender: Any) {
        self.sortHelper = self.sortHelper == .nameup ? .nameDown : .nameup
        
    }
    @IBAction func changePricePercAction(_ sender: Any) {
        self.sortHelper = self.sortHelper == .percUp ? .percDown : .percUp
        
    }
    
    
}

//MARK: Search Delegate
extension MDCurrenciesMoreVC : UITextFieldDelegate{
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let queryText = self.searchText.text,queryText.count > 0 {
            self.currencyDataSource =  self.temp_Arr.filter({ (dict) -> Bool in
              let date :String = dict["coinName"] as? String ?? ""
                let browser :String = dict["marketName"] as? String ?? ""
               return date.prefix(queryText.count).lowercased().contains(queryText.lowercased()) ||
                browser.prefix(queryText.count).lowercased().contains(queryText.lowercased())
           })
        }else{
            self.currencyDataSource =  self.temp_Arr
        }
        DispatchQueue.main.async { [weak self] in
           self?.currencyTable.reloadData()
       }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//    }
}



//MARK: Table Delegate
extension MDCurrenciesMoreVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencyDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDCurrencyMoreCell", for: indexPath) as! MDCurrencyMoreCell
        cell.selectionStyle = .none
        cell.configureUI(data: self.currencyDataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}

class MDCurrencyMoreCell : UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var currencyImgView: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyPrice: UILabel!
    @IBOutlet weak var changePriceImgView: UIImageView!
    @IBOutlet weak var changeValueLbl: UILabel!
    @IBOutlet weak var marketCapLbl: UILabel!
    @IBOutlet weak var suppleLbl: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //@IBOutlet weak var graphView: LineChartView!
    var numbers : [CGFloat] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.backgroundColor = Theme.current.mainTableCellsBgColor
        ///Text Colors
        self.currencyName.textColor = Theme.current.titleTextColor
        self.currencyPrice.textColor = self.currencyName.textColor
        self.currencyPrice.textColor = self.currencyName.textColor
        self.marketCapLbl.textColor = self.currencyName.textColor
        self.suppleLbl.textColor = self.currencyName.textColor
    }
    
    override func prepareForReuse() {
        //self.lineChart = nil
    }
    
    func configureUI(data : NSDictionary){
        self.currencyImgView.image = MDHelper.shared.getImageByCurrencyCode(code: (data.value(forKey: "exchangeTicker") as? String ?? ""))
        self.currencyName.text =  (data.value(forKey: "exchangeTicker") as? String ?? "") + " - " + (data.value(forKey: "coinName") as? String ?? "")
        
        
        
        
        let price = MDHelper.shared.getCurrencyPageRates(amount:Double(data.value(forKey: "price") as? String ?? "") ?? 0.0 )
        self.currencyPrice.text = "\(price.1) " + String(format: "%.2f", Double(price.0) ?? 0.0)
        
        if let percen = data.valueForCaseInsensativeKey(forKey: "priceChangePercent24hr") as? String{
            self.changeValueLbl.text = "$\( String(format: "%.2f %%", Double(percen) ?? 0.0) )"
            
            self.changePriceImgView.image = (Double(percen) ?? 0.0) < 0 ?  UIImage(named: "redPriceDrop")?.imageWithColor(color1: Theme.current.primaryColor) : UIImage(named: "greenPriceUp")!.imageWithColor(color1: Theme.current.secondaryColor)
            self.changeValueLbl.textColor = (Double(percen) ?? 0.0) < 0 ? Theme.current.primaryColor : Theme.current.secondaryColor
        }
        
        self.marketCapLbl.text = "Market Cap \n\n$\(data.value(forKey: "marketCap") as? String ?? "")"
        self.suppleLbl.text = "Circulating Supply \n\n\(data.value(forKey: "circulatingSupply") as? String ?? "") " + (data.value(forKey: "exchangeTicker") as? String ?? "")
        
        self.numbers = data.value(forKey: "sparklineGraph") as? [CGFloat] ?? []
        //self.graphView.isHidden = true
        //self.updateGraph()
        
        
        
    }
    
//    func updateGraph(){
//        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
//        //here is the for loop
//        for i in 0..<numbers.count {
//            let value = ChartDataEntry(x: Double(i), y: Double(numbers[i])) // here we set the X and Y status in a data chart entry
//            lineChartEntry.append(value) // here we add it to the data set
//        }
//        let line1 = LineChartDataSet(entries: lineChartEntry, label: "") //Here we convert lineChartEntry to a LineChartDataSet
//        line1.colors = [NSUIColor.red] //Sets the colour to red
//        let data = LineChartData() //This is the object that will be added to the chart
//        data.addDataSet(line1) //Adds the line to the dataSet
//        graphView.data = data //finally - it adds the chart data to the chart and causes an update
//        graphView.chartDescription?.text = "" // Here we set the description for the graph
//        graphView.isUserInteractionEnabled = false
//
//    }
}
