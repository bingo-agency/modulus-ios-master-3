//
//  MDDropDownView.swift
//  Modulus
//
//  Created by Abhijeet on 10/13/21.
//  Copyright © 2021 Bhavesh Sarwar. All rights reserved.
//

import UIKit
enum Options{
    case open
    case closed
}
class MDDropDownView: UIView {
    static let nibName :String = "MDDropDownView"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var arrow_imgView: UIImageView!
    var option_ : Options =  .closed
    private var initialHeight: CGFloat = 0
    private let rowHeight: CGFloat = 40
    var options: [String] = ["sadhas","dasd","dadsa"]
    var underline = UIView()
    var dropDownColor = UIColor.gray
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commoninit()
    }
    let animationView = UIView()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "MDOptionsViewCell", bundle: nil), forCellReuseIdentifier: "MDOptionsViewCell")
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets.zero
        return tableView
    }()
    private func addUnderline() {
        addSubview(underline)
        underline.backgroundColor = .black
        underline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: topAnchor, constant: initialHeight - 2),
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2)
            ])
    }
    func commoninit(){
        Bundle.main.loadNibNamed(MDDropDownView.nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.layer.cornerRadius = 14.0
        addUnderline()
        addTableView()
        addAnimationView()
        menuAnimate(up: false)
        
    }
    private func menuAnimate(up: Bool) {
        let downFrame = animationView.frame
        let upFrame = CGRect(x: 0, y: self.initialHeight, width: self.bounds.width, height: 0)
        animationView.frame = up ? downFrame : upFrame
        animationView.isHidden = false
        tableView.isHidden = true

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animationView.frame = up ? upFrame : downFrame
        }, completion: { (bool) in
//            self.isDroppedDown = !self.isDroppedDown
            self.animationView.isHidden = up
            self.animationView.frame = downFrame

            self.tableView.isHidden = up
//            self.delegate?.menuDidAnimate(up: up)
        })
    }
    @IBAction func btn_arrowClcikecAction(_ sender: Any) {
        if self.option_ == .closed {
            self.option_ = .open
            self.searchTextfield.isHidden = false
            self.searchTextfield.becomeFirstResponder()
            self.searchTextfield.placeholder = "select"
            self.selectView.isHidden = true
        }else{
            self.option_ = .closed
            self.searchTextfield.isHidden = true
            self.endEditing(true)
            self.selectView.isHidden = false
        }
    }
    private func calculateHeight() {
        self.initialHeight = self.bounds.height
        let rowCount = self.options.count + 1 //Add one so that you can include 'other'
        let newHeight = self.initialHeight + (CGFloat(rowCount) * rowHeight)
        self.frame.size = CGSize(width: self.frame.width, height: newHeight)
    }
    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        tableView.constraintsPinTo(leading: leadingAnchor, trailing: trailingAnchor, top: underline.bottomAnchor, bottom: bottomAnchor)
        tableView.isHidden = true
    }
    
    private func addAnimationView() {
        self.addSubview(animationView)
        animationView.frame = CGRect(x: 0.0, y: initialHeight, width: bounds.width, height: bounds.height - initialHeight)
        self.sendSubviewToBack(animationView)
        animationView.backgroundColor = dropDownColor
        animationView.isHidden = true
    }
    
}
extension MDDropDownView : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDOptionsViewCell") as! MDOptionsViewCell
//        let title = indexPath.row < options.count ? options[indexPath.row] : "Other"
        cell.configureCell(name: "", imageString: nil, image: nil)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
}
