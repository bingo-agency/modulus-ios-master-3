//
//  MDHomeTabBarControllerViewController.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 13/06/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class MDHomeTabBarControllerViewController: UITabBarController,UITabBarControllerDelegate , UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        print("navigation_item",self.navigationItem == nil)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        longPressRecognizer.minimumPressDuration = 3
        longPressRecognizer.delegate = self ///Temp added only for this build
        self.tabBar.addGestureRecognizer(longPressRecognizer)
        setupTabBar()
    }
    
    func setupTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Instantiate view controllers
        let homeNav = storyboard.instantiateViewController(withIdentifier: "MarketNav") as! UINavigationController
        
        let wallet = storyboard.instantiateViewController(withIdentifier: "WalletNav") as! UINavigationController
        
        let tradeNC = storyboard.instantiateViewController(withIdentifier: "TradeNC") as! UINavigationController
        
        let account = storyboard.instantiateViewController(withIdentifier: "AccountNav") as! UINavigationController
        let moreNav = storyboard.instantiateViewController(withIdentifier: "MoreNav") as! UINavigationController
        
        tradeNC.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        
        
        // Assign viewControllers to tabBarController
        let viewControllers = [homeNav,wallet,tradeNC, account,moreNav]
        self.setViewControllers(viewControllers, animated: false)
        
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapButton = { [unowned self] in
            self.routeToCreateNewAd()
        }
        // Ensure navigation bars are not hidden
        viewControllers.forEach { navController in
            (navController as? UINavigationController)?.navigationBar.isHidden = false
        }
        addFullScreenView()
        
        // Initially hide the full-screen view
        fullScreenView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.fullScreenView.isHidden = true
        }
        
    }
    
    func addFullScreenView() {
        // Add the full-screen view to the tab bar controller's view
        self.view.addSubview(fullScreenView)
        
        // Set constraints to cover the entire screen
        NSLayoutConstraint.activate([
            fullScreenView.topAnchor.constraint(equalTo: self.view.topAnchor),
            fullScreenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            fullScreenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            fullScreenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        // Add image view to the full-screen view
        fullScreenView.addSubview(centeredImageView)
        
        // Set constraints for the image view
        NSLayoutConstraint.activate([
            centeredImageView.centerXAnchor.constraint(equalTo: fullScreenView.centerXAnchor),
            centeredImageView.centerYAnchor.constraint(equalTo: fullScreenView.centerYAnchor),
            centeredImageView.widthAnchor.constraint(equalToConstant: 244),
            centeredImageView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    // Create a full-screen view
    let fullScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Create an image view
    let centeredImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // Set your image here
        imageView.image = UIImage(named: "pressLogo")
        return imageView
    }()
    
    func routeToCreateNewAd() {
        if MDHelper.shared.isUserLoggedIn() == false{
//            MDHelper.shared.showYouWantToLoginPopUp()
//            return
        }
        let createAdNavController = self.storyboard?.instantiateViewController(withIdentifier: "TradeNC") as! UINavigationController
        createAdNavController.modalPresentationCapturesStatusBarAppearance = true
        self.present(createAdNavController, animated: true, completion: nil)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if (sender.state == .ended) {
            print("Long Pressed")
            let tabIndex = self.tabBarIndex(xCo : sender.location(in: self.view).x)
            if tabIndex == 1{
                if  UserDefaults.standard.value(forKey: "isLT") as? Bool ?? false {
                    UserDefaults.standard.setValue(false, forKey: "isLT")
                }else{
                    UserDefaults.standard.setValue(true, forKey: "isLT")
                }
                if let rootVC = self.viewControllers?.first as? UINavigationController , tabBar.selectedItem == tabBar.items?[0]{
                    MDHelper.shared.showSucessAlert(message: "Theme changed please restart app", viewController: rootVC)
                }
            }
        }
    }
    
    private
    func tabBarIndex(xCo : CGFloat) -> Int{
        
        var window : UIWindow?
        for i in 0..<UIApplication.shared.windows.count{
            if UIApplication.shared.windows[i].isKeyWindow == true{
                window = UIApplication.shared.windows[i]
                break
            }
        }
        
        let screenWidth = window?.frame.width ?? 0
        let eachTabWidth = screenWidth/4  // 5 is number of tabs
        
        if xCo <= eachTabWidth{
            //Home tab
            print("Map tab")
            return 1
        }else if xCo > eachTabWidth && xCo <= (eachTabWidth * 2){
            //Chat Tab
            print("Feed tab")
            return 2
        }else if xCo > (eachTabWidth * 2) && xCo <= (eachTabWidth * 3){
            //Search Tab
            print("Chat tab")
            return 3
        }else if xCo > (eachTabWidth * 3) && xCo <= (eachTabWidth * 4){
            //Communities tab
            print("Settings tab")
            return 4
        }
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let items = tabBar.items else { return }
        
        items[0].title = localised("Market")
        items[1].title = localised("Wallet")
        items[2].title = localised("Trade")
        items[3].title = localised("Account")
        items[4].title = localised("More")
        print("title_view",self.navigationController?.isNavigationBarHidden)

    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Trade" {
//            routeToCreateNewAd()
            return
        }
//        print("did select tab bar")
        if MDHelper.shared.isUserLoggedIn() == false && tabBar.items?.last != item{
            if item.title != "Market"{
            MDHelper.shared.showYouWantToLoginPopUp()
            }
        }
//
//        if let rootVC = self.viewControllers?.first as? UINavigationController , tabBar.selectedItem == tabBar.items?[0]{
//            rootVC.popToRootViewController(animated: false)
//        }
//        if tabBar.selectedItem == tabBar.items?[0]{
//            let rootView = self.viewControllers![0] as! UINavigationController
//            rootView.popToRootViewController(animated: false)
//        }
//        if tabBar.selectedItem == tabBar.items?[1]{
//            let rootView = self.viewControllers![1] as! UINavigationController
//            rootView.popToRootViewController(animated: false)
//        }
//        if tabBar.selectedItem == tabBar.items?[2]{
//            let rootView = self.viewControllers![2] as! UINavigationController
//            rootView.popToRootViewController(animated: false)
//        }
//        if tabBar.selectedItem == tabBar.items?[3]{
//            let rootView = self.viewControllers![3] as! UINavigationController
//            rootView.popToRootViewController(animated: false)
//        }
    }

}

class CustomTabBar: UITabBar {
    
    // MARK: - Variables
    public var didTapButton: (() -> ())?
    
    public lazy var middleButton: UIButton! = {
        let middleButton = UIButton()
        
        middleButton.frame.size = CGSize(width: 48, height: 48)
        
        let image = UIImage(named: "withdraw")
        middleButton.setImage(image, for: .normal)
        middleButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        middleButton.backgroundColor = UIColor(named: "primaryColor")
        middleButton.tintColor = .black
        middleButton.layer.cornerRadius = 24
        
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        
        self.addSubview(middleButton)
        
        return middleButton
    }()
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        middleButton.center = CGPoint(x: frame.width / 2, y: -5)
    }
    
    // MARK: - Actions
    @objc func middleButtonAction(sender: UIButton) {
        didTapButton?()
    }
    
    // MARK: - HitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
}
