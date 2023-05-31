//
//  PetStoreTermsAndConditions.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PetStoreTermsAndConditions: UIViewController,UITextViewDelegate {

    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DISCLAIMER & TERMS & CONDITIONS"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var textView:UITextView! {
        didSet {
            textView.layer.cornerRadius = 4
            textView.clipsToBounds = true
            textView.isEditable = false
        }
    }
    
    @IBOutlet weak var btnAcceptOrNot:UIButton!
    
    @IBOutlet weak var btnAgree:UIButton! {
        didSet {
            btnAgree.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnAgree.layer.cornerRadius = 4
            btnAgree.clipsToBounds = true
            btnAgree.setTitle("AGREE & CONTINUE", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnAgree.setTitleColor(.white, for: .normal)
        btnAgree.backgroundColor = .lightGray
        btnAgree.isUserInteractionEnabled = false
        
        btnAcceptOrNot.tag = 0
        btnAcceptOrNot.addTarget(self, action: #selector(acceptOrNotClickMethod), for: .touchUpInside)
        
        // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenuPetStore") {
            print(name)
            if name == "PetStoreMenuBar" {
             // menu
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                self.sideBarMenu()
            }
            else
            {
                btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
            }
        }
        else
        {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
        
                
        self.termsAndCondtions()
            
        
        
        
    }
    @objc func sideBarMenu() {
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "keySideBarMenuPetStore")
        defaults.set(nil, forKey: "keySideBarMenuPetStore")
        
            if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
                revealViewController().rearViewRevealWidth = 300
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func acceptOrNotClickMethod() {
        if btnAcceptOrNot.tag == 0 {
            btnAcceptOrNot.setImage(UIImage(named: "regCheck"), for: .normal)
            
            btnAgree.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnAgree.isUserInteractionEnabled = true
            btnAgree.addTarget(self, action: #selector(agreeClickMethod), for: .touchUpInside)
            
            btnAcceptOrNot.tag = 1
        }
        else if btnAcceptOrNot.tag == 1 {
            btnAcceptOrNot.setImage(UIImage(named: "regUncheck"), for: .normal)
            
            btnAgree.backgroundColor = .lightGray
            btnAgree.isUserInteractionEnabled = false
            
            btnAcceptOrNot.tag = 0
        }
    }
    
    @objc func agreeClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetStoreHomeId") as? PetStoreHome
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func termsAndCondtions() {
           Utils.RiteVetIndicatorShow()
           
               let urlString = BASE_URL_KREASE
               
               var parameters:Dictionary<AnyHashable, Any>!
           
                   parameters = [
                       "action"        :   "termAndConditions"
                   ]
              
                
                   print("parameters-------\(String(describing: parameters))")
                   
                   AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
                       {
                           response in
               
                           switch(response.result) {
                           case .success(_):
                              if let data = response.value {

                               
                               let JSON = data as! NSDictionary
                               //print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               
                               
                               if strSuccess == "success" //true
                               {
                                
                                
                                let defaults = UserDefaults.standard
                                defaults.set("Yes", forKey: "keyReadTermsAndCondition")
                                
                                var strMessage : String!
                                strMessage = JSON["msg"]as Any as? String
                                
                                self.textView.text = String(strMessage)
                                
                                Utils.RiteVetIndicatorHide()
                               }
                               else
                               {
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
