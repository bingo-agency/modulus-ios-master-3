//
//  MDSecurityVerifcationVC.swift
//  Modulus
//
//  Created by Pathik  on 25/10/18.
//  Copyright © 2018 Modulus Global Inc. All rights reserved.
//

import UIKit
import IdensicMobileSDK
import CryptoKit

class MDSecurityVerifcationVC: UIViewController {
    var appToken = "sbx:zlMWXi5BskLWyrfuwJJDWWZE.S6A83u7rTxDIqdavpnHQy5fJrWWrthFQ"
    let secretKey = "lVsc9457g4jfxV0Ov6ZUM3DTAilZdTds"
    
    //MARK: - StoryBoard outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    
    //MARK: - Constants
    let cellIdentifier = "securityVerficationCell"
    
    //MARK: - Variables
    var selectedData:NSDictionary? = nil
    var data : [[String:Any]] = []
    
    var kycDict : NSDictionary? = nil
    
    private var alreadySelectedKYC : Int = 0
    
    private var isTwoFAEnabled : Bool = false
    
    private var enable_WebSDK : Bool = false
    
    private var approveLevel : Int = 0
    
    var kycStatusText : String = ""
    
    var kycStatus : Bool = false
    
    var isPartiallyDone : Bool = false
    
    var kycStatusString : String = ""
    
    private var maxLevel : Int = 0
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialVC()
        checkGoogleTwoAuthStatus()
        setUpColors()
        self.fetchKYCForm()
        
       // self.navigateToKYCVC(enable_WebSDK: true) //TEMP
       // self.createAccessTokenForSumSub() ///TEMP
        // Do any additional setup after loading the view.
    }
    
    private
    func setInitialVC(){
        // Two FA Settings
        if let twoFactorEnabled = UserDefaults.standard.value(forKey: "is2FAEnabled") as? Bool {
            self.isTwoFAEnabled = twoFactorEnabled
        }
        
        // Enable_WebSDK
        if let settings = MDHelper.shared.getAppSetting() , let kyc_info = settings.value(forKey: "kyc") as? NSDictionary {
            if kyc_info.value(forKey: "enable_WebSDK") as? String == "True"{
                self.enable_WebSDK = true
            }else{
                self.enable_WebSDK = false
            }
        }
        
        if let profile = UserDefaults.standard.value(forKey: "profile") as? NSDictionary {
            ///get KYC settings
            if let kycStatusUpdate = profile.valueForCaseInsensativeKey(forKey: "kycStatus") as? String {
                kycStatusText = localised(kycStatusUpdate)
                self.kycStatusString = localised(kycStatusUpdate)
                if kycStatusUpdate == "Approved" {
                    if let approveLevel = profile.value(forKey: "kycApprovedLevel") as? String ,
                       let approveLevelInt = Int(approveLevel){
                        self.approveLevel = approveLevelInt
                    }
                    self.kycStatus = true
                }
            }
        }
        self.setTableViewData()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationbar()
        checkGoogleTwoAuthStatus()
        addObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeObserver()
    }
    func setUpColors(){
        self.bgView.backgroundColor = Theme.current.backgroundColor
        self.tableView.backgroundColor = Theme.current.backgroundColor
    }

    //MARK: - Notification observer helpers
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.kycSubmitted), name: NSNotification.Name.init("profileUpdated"), object: nil)
    }
    func removeObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: -  Data helpers
    @objc func setTableViewData() {
        data = [["image":"google",
                 "title":localised("Google Authenticator"),
                 "selected":self.isTwoFAEnabled],
                ["image":"user",
                 "title":localised("KYC Verification"),
                 "selected":kycStatus,
                 "status":kycStatusText ,
                 "isPartiallyDone":isPartiallyDone ,
                 "enable_WebSDK":enable_WebSDK]]
        
        tableView.delegate = self
        self.tableView.reloadData()
    }
    
    //MARK: -  Data helpers
    @objc func kycSubmitted() {
        self.setInitialVC()
        self.fetchKYCForm()
    }
    

    
    /// This will check if user has enabled google authentcator by making API call
    func checkGoogleTwoAuthStatus()  {
      
        let header = ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: "AccessToken") as! String)"]
        
        MDNetworkManager.shared.sendRequest(methodType: .get, apiName: API.checkGoogleAuth, parameters: nil, headers: header as NSDictionary) { (response, error) in
            if let isEnable = response?.valueForCaseInsensativeKey(forKey: "data") as? Bool{
                UserDefaults.standard.set(isEnable, forKey: "is2FAEnabled")
                self.isTwoFAEnabled = isEnable
                self.setTableViewData()
                
            }
        }
    }
    
    //MARK:- navigation bar helprs
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
        label.text = localised("Security Verification")
        self.navigationItem.titleView = label
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let google2FAVC = segue.destination as? MDGoogleAuthVC{
            google2FAVC.navigationTitle = selectedData?.valueForCaseInsensativeKey(forKey: "title") as! String
            google2FAVC.isGoogl2FAenabled = selectedData?.valueForCaseInsensativeKey(forKey: "selected") as! Bool
        }
        
        if let kycVC = segue.destination as? MDKYCVC{
            kycVC.approveLevel = self.approveLevel
            kycVC.maxLevel = self.maxLevel
            kycVC.dict = self.kycDict
        }
        
    }
    
    private
    func navigateToKYCVC(enable_WebSDK : Bool){
        if enable_WebSDK{
            if let settings = MDHelper.shared.getAppSetting() , let kyc_info = settings.value(forKey: "kyc") as? NSDictionary {
                if kyc_info.value(forKey: "webSDK_Provider_Name") as? String == "sumsub"{
                    self.fetchKYC_OnSite_AccessToken() {[weak self] (accessToken) in
                        guard accessToken != nil else {return}
                        self?.initialiseSDKParameter(accessToken: accessToken!)
                    }
                }else{
                    MDHelper.shared.showErrorPopup(message: "Service Provider Not found!!!!")
                }
            }
        }else{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: MDKYCVC.openKYC, sender: self)
            }
        }

    }
}

extension MDSecurityVerifcationVC:UITableViewDataSource,UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SecurityVerficationCells = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SecurityVerficationCells
        
        let cellData = data[indexPath.row]
        cell.configure(data: cellData as NSDictionary)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = data[indexPath.row]
        selectedData = cellData as NSDictionary
        if let title = (cellData as NSDictionary).valueForCaseInsensativeKey(forKey: "title") as? String{
            if title.contains(localised("Google Authenticator")){
                self.performSegue(withIdentifier: MDGoogleAuthVC.segueId, sender: self)
            }else if title.contains(localised("KYC Verification")){
                let enable_WebSDK = (cellData as NSDictionary).value(forKey: "enable_WebSDK") as! Bool
                if let status = selectedData?.valueForCaseInsensativeKey(forKey: "status") as? String{
                    if status.lowercased().contains("pending") ||
                        status.lowercased().contains("approved") {
                        if status.lowercased().contains("approved") , let isPartDone = (cellData as NSDictionary).value(forKey: "isPartiallyDone") as? Bool , isPartDone{
                            self.navigateToKYCVC(enable_WebSDK: enable_WebSDK)
                        }
                    }else{
                        self.navigateToKYCVC(enable_WebSDK: enable_WebSDK)
                    }
                }else{
                    self.navigateToKYCVC(enable_WebSDK: enable_WebSDK)
                }
            }
        }
    }
    
}



class SecurityVerficationCells:UITableViewCell{
    
    //MARK: - StoryBoard outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickIcon: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Variables
    var cellData:NSDictionary = NSDictionary()
    
    override func draw(_ rect: CGRect) {
        cardView.backgroundColor = Theme.current.mainTableCellsBgColor
    }
    
    func configure(data:NSDictionary){
        
        cardView.backgroundColor = Theme.current.mainTableCellsBgColor
        
        
        
        cellData = data
        
        if let title = cellData.valueForCaseInsensativeKey(forKey: "title") as? String{
            titleLabel.text = title
        }
        if let status = cellData.valueForCaseInsensativeKey(forKey: "status") as? String{
            statusLabel.isHidden = false
//            if status.lowercased().contains("pending"){
//                 statusLabel.text = "Under Review"
//            }else{
                statusLabel.text = status
//            }
            
        }else{
            statusLabel.text = ""
        }
        
        if let selected = cellData.valueForCaseInsensativeKey(forKey: "selected") as? Bool{
            if selected == true{
                let activeColor = Theme.current.titleTextColor
                tickIcon.image = UIImage.init(named: "tick")?.imageWithColor(color1: Theme.current.secondaryColor)
//                tickIcon.tintColor = activeColor
                titleLabel.textColor = activeColor
                statusLabel.textColor = activeColor
                if let image = cellData.valueForCaseInsensativeKey(forKey: "image") as? String{
                    iconImage?.image = UIImage.init(named: image)?.imageWithColor(color1: activeColor)
                }
            }else{
                let inactiveColor = Theme.current.subTitleColor
                tickIcon.image = UIImage.init(named: "cross")?.imageWithColor(color1: Theme.current.primaryColor)
//                tickIcon.tintColor = UIColor.red
                titleLabel.textColor = inactiveColor
                statusLabel.textColor = inactiveColor
                if let image = cellData.valueForCaseInsensativeKey(forKey: "image") as? String{
                    iconImage?.image = UIImage.init(named: image)?.imageWithColor(color1: inactiveColor)
                }
            }
            
        }
        
    }
}

extension MDSecurityVerifcationVC{
    private
    func initialSetUpOfKYCSDKVC(){
        if let settings = MDHelper.shared.getAppSetting() , let kyc_info = settings.value(forKey: "kyc") as? NSDictionary {
            let webSDK_Provider_Url = kyc_info.value(forKey: "webSDK_Provider_Url") as? String
            let webSDK_Provider_Name = kyc_info.value(forKey: "webSDK_Provider_Name") as? String
        
        }
    }
    
    private
    func fetchKYC_OnSite_AccessToken(completion: (@escaping (String?) -> Void)){
        let headers = ["Authorization":MDNetworkManager.shared.authToken,
                       "hmac":MDNetworkManager.shared.generateHmacForParams(params: [:] as NSDictionary)] as NSDictionary
        MDHelper.shared.showHudOnWindow()
        MDNetworkManager.shared.sendRequest(methodType: .post, apiName: API.KYC_OnSite_AccessToken, parameters: [:], headers: headers) { (response, error) in
            MDHelper.shared.hideHudOnWindow()
            if error != nil{
                MDHelper.shared.showErrorAlert(message: error!.localizedDescription, viewController: self)
            }
            guard let response = response else {return}
            if MDNetworkManager.shared.isResponseSucced(response: response){
                if let onSiteTokenData = response.value(forKey: "data") as? NSDictionary{
                    if let accessToken = onSiteTokenData.value(forKey: "accessToken") as? String{ ///"_act-sbx-c80b0f55-4b5b-4130-81f9-c16d8818b139";
//                        let applicantID = onSiteTokenData.value(forKey: "applicantID")  ///NA;
//                        let flowName = onSiteTokenData.value(forKey: "flowName")   ///"basic-kyc-level";
//                        let scriptUrl = onSiteTokenData.value(forKey: "scriptUrl")   ///"https://api.sumsub.com";
                        completion(accessToken)
                        return
                    }
                }
            }else{
                let message = response.valueForCaseInsensativeKey(forKey: "Message") as? String ?? "Error occured"
                  MDHelper.shared.showErrorAlert(message: message, viewController: self)
            }
        }
    }
    
    private
    func initialiseSDKParameter(accessToken : String){
        let sdk = SNSMobileSDK(accessToken: accessToken , environment: .production)
        
        guard sdk.isReady else {
            print("Initialization failed: " + sdk.verboseStatus)
            return
        }
        
        
        self.listenToTokenExpiration(sdk: sdk)
        self.listenStatusChange(sdk: sdk)
        self.listenToTheEvent(sdk: sdk)
        sdk.present()
    }
    
    private
    func listenToTokenExpiration(sdk : SNSMobileSDK){
        sdk.tokenExpirationHandler { (onComplete) in
            self.fetchKYC_OnSite_AccessToken { (accessToken) in
                onComplete(accessToken)
            }
        }
    }
    
    private
    func listenStatusChange(sdk : SNSMobileSDK){

        switch sdk.status {
        case .ready:
            print("Ready This SDK FOR DISPLAY")
        case .pending:
            print("Its Pendingggg!!!!")
        
        default:
            break
        }
        
        
        sdk.onDidDismiss { (sdk) in

            switch sdk.status {

            case .failed:
                print("failReason: [\(sdk.description(for: sdk.failReason))] - \(sdk.verboseStatus)")

            case .actionCompleted:
                // the action was performed or cancelled

                if let result = sdk.actionResult {
                    print("Last action result: actionId=\(result.actionId) answer=\(result.answer ?? "<none>")")
                } else {
                    print("The action was cancelled")
                }

            default:
                // in case of an action level, the other statuses are not used for now,
                // but you could see them if the user closes the sdk before the level is loaded
                break
            }
        }
        
        
        
        
        
        sdk.onStatusDidChange { (sdk, prevStatus) in
            print("onStatusDidChange: [\(sdk.description(for: prevStatus))] -> [\(sdk.description(for: sdk.status))]")
            switch sdk.status {
            case .ready:
                // Technically .ready couldn't ever be passed here, since the callback has been set after `status` became .ready
                break
            case .failed:
                print("failReason: [\(sdk.description(for: sdk.failReason))] - \(sdk.verboseStatus)")
                
            case .initial:
                print("No verification steps are passed yet")
                
            case .incomplete:
                print("Some but not all of the verification steps have been passed over")
                
            case .pending:
                print("Verification is pending")
                ///Reload Now
                let updatedData : [String:Any] = ["title":localised("KYC Verification"),
                                                  "selected":false,
                                                  "status":"Pending" , "enable_WebSDK":true]
            
                self.data.removeLast()
                self.data.append(updatedData)
                
                self.tableView.reloadData()
                
                
            case .temporarilyDeclined:
                print("Applicant has been temporarily declined")
                
            case .finallyRejected:
                print("Applicant has been finally rejected")
                
            case .approved:
                print("Applicant has been approved")
                
            case .actionCompleted:
                print("Applicant action has been completed")
            }
        }
    }
    
    private
    func listenToTheEvent(sdk:SNSMobileSDK){
        sdk.onEvent { (sdk, event) in
            switch event.eventType{
            case .stepInitiated:
                print("Step Initialize")
                print(event.payload)
            case .stepCompleted:
                print("Step Complete")
                print(event.payload)
               // ["isCancelled" : 0 , "idDocSetType" : "IDENTITY"]
            
            @unknown default:
                print("onEvent: eventType=[\(event.description(for: event.eventType))] payload=\(event.payload)")
            }
        }
        
    
    
        
        sdk.actionResultHandler { (sdk, result, onComplete) in
            print("actionResultHandler: actionId=\(result.actionId) answer=\(result.answer ?? "<none>")")
            // you are allowed to process the result asynchronously, just don't forget to call `onComplete` when you finish,
            // you could pass `.cancel` to force the user interface to close, or `.continue` to proceed as usual
            print(result)

            onComplete(.continue)
        }
    }
//    on('idCheck.onApplicantSubmitted', (payload) => {
//                if (payload.applicantId) {
//                  //this.saveApplicantId(payload.applicantId)
//                  this.savedApplicantId = payload.applicantId;
//                }
//                this.saveApplicantId(this.savedApplicantId);
//            })
//            .on('idCheck.onApplicantResubmitted', (payload) => {
//              if (payload.applicantId) {
//                //this.saveApplicantId(payload.applicantId)
//                this.savedApplicantId = payload.applicantId;
//              }
//              this.saveApplicantId(this.savedApplicantId);
//          })
    
    
}

extension MDSecurityVerifcationVC {
    private
    func createAccessTokenForSumSub(){
        let usrID : String = "userId1"
        let levelName : String = "basic-kyc-level"
        
        let epochTime : String = self.getEpochTime()
        let url : String = "https://api.sumsub.com/resources/accessTokens?userId=\(usrID)&levelName=\(levelName)&ttlInSecs=600"
        let hmacString = "\(epochTime)POST/resources/accessTokens?userId=\(usrID)&levelName=\(levelName)&ttlInSecs=600"
        
        let header : [String:Any] = [
            "X-App-Token": self.appToken,
            "X-App-Access-Sig": self.createSignature(string: hmacString),
            "X-App-Access-Ts": epochTime ,
            "Accept": "application/json"
        ]
        print(header)
        print("")
        MDNetworkManager.shared.sendRequest(baseUrl: url , methodType: .post, apiName: "", parameters: nil, headers: header as NSDictionary) { (dict, error) in
            if let token = dict?.value(forKey: "token") as? String{
                print(token)
                self.initialiseSDKParameter(accessToken: token)
            }
        }
        
        
    }
    
    func getEpochTime()->String{
        
        let timeInterval = Date().timeIntervalSince1970
        return String(timeInterval.description.split(separator: ".")[0])
    }
    
    func createSignature(string : String)->String{
        if #available(iOS 13.0, *){
            let secretString = self.secretKey
            let key = SymmetricKey(data: secretString.data(using: .utf8)!)
            let signature = HMAC<SHA256>.authenticationCode(for: Data(string.utf8), using: key)
            let kuchTo = Data(signature).map { String(format: "%02hhx", $0) }.joined()
            print("Original String \(string)")
            print("key \(secretKey)")
            print("Signature \(kuchTo)") // 1c161b971ab68e7acdb0b45cca7ae92d574613b77fca4bc7d5c4effab89dab67
            return kuchTo
        }else{
            return ""
        }
    }
}

extension MDSecurityVerifcationVC{
    //MARK: - Data Helpers
    @objc
    func fetchKYCForm(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isConnectedToInternet() == true{
            MDHelper.shared.showHudOnWindow()
            let headers = ["Authorization":MDNetworkManager.shared.authToken,
                           "Content-Type":"application/json"] as NSDictionary
            
            MDNetworkManager.shared.sendRequest(methodType: .post,
                                                apiName: API.getKycForm,
                                                parameters: nil,
                                                headers: headers as NSDictionary) { (response, error) in
                MDHelper.shared.hideHudOnWindow()
                self.handleKYCFormResponse(response: response, error: error)
            }
        }else{
            MDSnackBarHelper.shared.showErroMessage(message: "The internet appears to be offline")
        }
    }
    
    private
    func handleKYCFormResponse(response:NSDictionary?,error:Error?){
        if response != nil , error == nil{
            if MDNetworkManager.shared.isResponseSucced(response: response!){
                if let data = response?.valueForCaseInsensativeKey(forKey: "data") as? [String:Any]{
                    var maxLevel : Int = 0
                    if let fieldsList = data["fieldsList"] as? [[String:Any]]{
                        for field in fieldsList{
                            if let level = field["level"] as? Int{
                                maxLevel = max(maxLevel , level)
                            }
                            
                        }
                    }
                    self.isPartiallyDone = self.approveLevel < maxLevel
                    
                    if self.isPartiallyDone{
                        if kycStatusString == "Approved"{
                            self.kycStatusText = localised("Approved") + " (" + localised("Level") + "-" + String(self.approveLevel) + ")"
                        }
                    }else{
                        //self.kycStatusText = localised("Approved") + " (" + localised("Level") + "-" + String(self.approveLevel) + ")"
                    }
                    
                    self.maxLevel =  maxLevel
                    self.setTableViewData()
                    self.kycDict = response
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
    
}
