//
//  Help.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
 import MessageUI

class Help: UIViewController,
            MFMailComposeViewControllerDelegate
{

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
        btnCall.setTitle("321-682-9800", for: .normal)
        
        // mail
        btnMail.backgroundColor = .clear
        btnMail.setTitle("ritevethelp@gmail.com", for: .normal)
        
        btnMail.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
    }
    //
    
    @objc func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ritevethelp@gmail.com"])
            mail.setMessageBody("<p>Type your message here</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            
             
            
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
