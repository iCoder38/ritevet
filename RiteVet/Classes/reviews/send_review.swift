//
//  send_review.swift
//  RiteVet
//
//  Created by Dishant Rajput on 05/06/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class send_review: UIViewController {
    
    var dict_send_review_details:NSDictionary!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Review"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 45
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderColor = NAVIGATION_BACKGROUND_COLOR.cgColor
            imgProfile.layer.borderWidth = 3.0
        }
    }
    
    @IBOutlet weak var lbl_Name:UILabel!
    @IBOutlet weak var lbl_address:UILabel!
    @IBOutlet weak var lbl_email:UILabel!
    
    @IBOutlet weak var view_BG:UIView!{
        didSet {
            view_BG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_BG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_BG.layer.shadowOpacity = 1.0
            view_BG.layer.shadowRadius = 14.0
            view_BG.layer.masksToBounds = false
            view_BG.layer.cornerRadius = 14
            view_BG.backgroundColor = .white
        }
    }
    
    var str_number:String!
    
    @IBOutlet weak var btn_star_one:UIButton! {
        didSet {
            btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_star_two:UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var btn_star_three:UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var btn_star_four:UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var btn_star_five:UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.isHidden = false
            btn_submit.setTitle("Submit", for: .normal)
            btn_submit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_submit.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_submit.layer.shadowOpacity = 1.0
            btn_submit.layer.shadowRadius = 14.0
            btn_submit.layer.masksToBounds = false
            btn_submit.layer.cornerRadius = 14
            btn_submit.backgroundColor = .systemRed
            btn_submit.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var txt_view:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.tintColor = .white
        
        print(self.dict_send_review_details as Any)
        
        self.lbl_Name.text = (self.dict_send_review_details["vendorName"] as! String)
        self.lbl_email.text = (self.dict_send_review_details["vendorEmail"] as! String)
        self.lbl_address.text = (self.dict_send_review_details["vendorAddress"] as! String)
        self.imgProfile.sd_setImage(with: URL(string: (self.dict_send_review_details["vendorImage"] as! String)), placeholderImage: UIImage(named: "logo-500"))
        
        self.btn_star_one.addTarget(self, action: #selector(star_one_click_method), for: .touchUpInside)
        self.btn_star_two.addTarget(self, action: #selector(star_two_click_method), for: .touchUpInside)
        self.btn_star_three.addTarget(self, action: #selector(star_three_click_method), for: .touchUpInside)
        self.btn_star_four.addTarget(self, action: #selector(star_four_click_method), for: .touchUpInside)
        self.btn_star_five.addTarget(self, action: #selector(star_five_click_method), for: .touchUpInside)
        
        self.str_number = "1.0"
        
        self.btn_submit.addTarget(self, action: #selector(submit_review_click_method), for: .touchUpInside)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    @objc func star_one_click_method() {
        
        self.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_two.setImage(UIImage(systemName: "star"), for: .normal)
        self.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
        self.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
        self.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
        
        self.str_number = "1.0"
    }
    
    @objc func star_two_click_method() {
        
        self.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
        self.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
        self.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
        
        self.str_number = "2.0"
    }
    
    @objc func star_three_click_method() {
        
        self.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
        self.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
        
        self.str_number = "3.0"
    }
    
    @objc func star_four_click_method() {
        
        self.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_four.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
        
        self.str_number = "4.0"
    }
    
    @objc func star_five_click_method() {
        
        self.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_four.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btn_star_five.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        self.str_number = "5.0"
    }
    
    @objc func submit_review_click_method() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"        :  "submitreview",
                "reviewFrom"    :  myString,
                "reviewTo"      :  "\(self.dict_send_review_details["vendorID"]!)",
                "star"          :  String(self.str_number),
                "message"       :  String(self.txt_view.text!),
                "bookingId"     : "\(self.dict_send_review_details["bookingID"]!)",
                "added_time"    : Date.get24TimeForTimeZone(),
                "current_time_zone":"\(TimeZone.current.abbreviation()!)",
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
                    
                    if strSuccess == "Success" {
                        Utils.RiteVetIndicatorHide()
                        
                        let alert = UIAlertController(title: "Success", message: JSON["msg"] as? String, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                    }
                    else {
                        
                        Utils.RiteVetIndicatorHide()
                        let alert = UIAlertController(title: "Alert", message: JSON["msg"] as? String, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
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

