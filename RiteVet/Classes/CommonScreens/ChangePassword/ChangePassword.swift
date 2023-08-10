//
//  ChangePassword.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire

class ChangePassword: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CHANGE PASSWORD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var txtNewPassword:UITextField!
    @IBOutlet weak var txtConfirmPassword:UITextField!
    @IBOutlet weak var txtReConfirmPassword:UITextField!
    
    @IBOutlet weak var btnSavePassword:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        
        // self.sideBarMenu()
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keyBackOrSlide") {
           if myLoadedString == "backOrMenu" {
               
               // menu
               btnBack.setImage(UIImage(named: "menu"), for: .normal)
               self.sideBarMenu()
               
           } else {
               
               // back
               btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
               btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
           }
           
        } else {
           
           // back
            btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
       }
        
        
        self.changePasswordUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
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
        
        self.view.endEditing(true)
    }
    
    @objc func changePasswordUI() {
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: txtNewPassword, placeHolder: "Current Password", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtConfirmPassword, placeHolder: "New Password", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtReConfirmPassword, placeHolder: "Confirm Password", cornerRadius: 20, color: .white)
        
        self.txtNewPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        self.txtReConfirmPassword.delegate = self
        
        /****** BUTTON *********/
        Utils.buttonDR(button: btnSavePassword, text: "CHANGE PASSWORD", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        self.btnSavePassword.addTarget(self, action: #selector(validationBeforeChangePassword), for: .touchUpInside)
    }
    
    /*
     action: "changePassword",
                                      userId: String(myString),
                                      oldPassword: String(txtCurrentPassword.text!),
                                      newPassword: String(txtNewPassword.text!))
     */
    
    @objc func validationBeforeChangePassword() {
        
        if self.txtNewPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Current Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txtConfirmPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("New Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txtReConfirmPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Confirm Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
             self.changePasswordWB()
        }
        
    }
    
    @objc func changePasswordWB() {
        
        // indicator.startAnimating()
        // self.disableService()
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            parameters = [
                "action"        :   "changePassword",
                "userId"        :   String(myString),
                "oldPassword"   :   String(txtNewPassword.text!),
                "newPassword"   :   String(txtConfirmPassword.text!)
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
                    
                     var strSuccess2 : String!
                     strSuccess2 = JSON["msg"]as Any as? String
                               
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                            
                            self.txtReConfirmPassword.text = ""
                            self.txtNewPassword.text = ""
                            self.txtConfirmPassword.text = ""
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                                   
                    }
                    else {
                        // self.indicator.stopAnimating()
                        // self.enableService()
                        Utils.RiteVetIndicatorHide()
                        
                        let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                            
                            
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }

            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                // self.indicator.stopAnimating()
                // self.enableService()
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
