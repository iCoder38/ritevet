//
//  ConfirmAppointment.swift
//  RiteVet
//
//  Created by evs_SSD on 1/8/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class ConfirmAppointment: UIViewController {

    var strGetBookingDate:String!
    var strGetBookingTime:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CONFIRM APPOINTMENT"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.layer.cornerRadius = 4
            viewBG.clipsToBounds = true
            viewBG.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var viewLeftBG:UIView! {
        didSet {
            viewLeftBG.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            viewLeftBG.layer.borderColor = UIColor.white.cgColor
            viewLeftBG.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewRightBG:UIView! {
        didSet {
            viewRightBG.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            viewRightBG.layer.borderColor = UIColor.white.cgColor
            viewRightBG.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var lblUserName:UILabel! {
        didSet {
            lblUserName.textColor = .white
        }
    }
    
    @IBOutlet weak var lblBookedTime:UILabel!
    @IBOutlet weak var lblBookedDate:UILabel!
    
    @IBOutlet weak var imgView:UIImageView! {
        didSet {
            imgView.layer.cornerRadius = 32
            imgView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnHome:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnBack.isHidden = true
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnHome.addTarget(self, action: #selector(homeClick), for: .touchUpInside)
        
        lblBookedTime.text = String(strGetBookingTime)
        lblBookedDate.text = String(strGetBookingDate)
        
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "keySaveVendorImage") {
            imgView.sd_setImage(with: URL(string: myString), placeholderImage: UIImage(named: "plainBack"))
            
        }
        
        if let myString2 = defaults.string(forKey: "keySaveVendorBName") {
            lblUserName.text = String(myString2)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func homeClick() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
        self.navigationController?.pushViewController(push!, animated: true)
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "keySaveVendorBName")
        defaults.set(nil, forKey: "keySaveVendorBName")
        
        defaults.set("", forKey: "keySaveVendorImage")
        defaults.set(nil, forKey: "keySaveVendorImage")
    }
    
}
