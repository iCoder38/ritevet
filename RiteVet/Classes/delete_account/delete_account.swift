//
//  delete_account.swift
//  RiteVet
//
//  Created by Dishant Rajput on 22/06/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire

class delete_account: UIViewController {

    var str_delete_account_message:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.setImage(UIImage(named: "menu"), for: .normal)
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Delete account"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_text:UILabel! {
        didSet {
            lbl_text.textColor = .black
        }
    }
    @IBOutlet weak var txt_otp:UITextField!
    
    @IBOutlet weak var btnSignIn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.lbl_text.text = String(self.str_delete_account_message)
        Utils.textFieldDR(text: txt_otp, placeHolder: "Enter OTP...", cornerRadius: 20, color: .white)
        
        /****** SIGN IN BUTTON *********/
        Utils.buttonDR(button: btnSignIn, text: "Submit", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        btnSignIn.addTarget(self, action: #selector(delete_account), for: .touchUpInside)
        
        self.sideBarMenu()
        self.view.backgroundColor = .white
        
    }
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    @objc func delete_account() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"       :   "userdelete",
                "userId"       :   myString,
                "OTP"           : String(self.txt_otp.text!)
               
            ]
        }
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "Success" || strSuccess == "success"  {
                        Utils.RiteVetIndicatorHide()
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue("", forKey: "keyLoginFullData")
                        defaults.setValue(nil, forKey: "keyLoginFullData")
                        
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginId") as! Login
                        // obj.strBookingOrAppointment = "bookingIs"
                        let navController = UINavigationController(rootViewController: obj)
                        navController.setViewControllers([obj], animated:true)
                        self.revealViewController().setFront(navController, animated: true)
                        self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                        
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                Utils.RiteVetIndicatorHide()
                
                let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                break
            }
        }
    }
    
}
