//
//  Help.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class Help: UIViewController {

    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "HELP"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var allRightsReserved:UILabel!
    
    @IBOutlet weak var btnCall:UIButton!
    @IBOutlet weak var btnMail:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        
        self.sideBarMenu()
        
        self.designUIhelpScreen()
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
           @objc func sideBarMenu() {
               if revealViewController() != nil {
               btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
               
                   revealViewController().rearViewRevealWidth = 300
                   view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                 }
       }
    
    @objc func designUIhelpScreen() {
        /*
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year], from: date)
        let year = components.year
        let currentYear = String(year!)
        allRightsReserved.text = "© "+currentYear+" RiteVet. All Rights Reserved."
        */
        
        // call
        btnCall.backgroundColor = .clear
        btnCall.setTitle("1800-1234-5678", for: .normal)
        
        // mail
        btnMail.backgroundColor = .clear
        btnMail.setTitle("support@ritevet.com", for: .normal)
    }
}
