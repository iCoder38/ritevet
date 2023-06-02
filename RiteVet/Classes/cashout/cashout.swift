//
//  cashout.swift
//  RiteVet
//
//  Created by Dishant Rajput on 31/05/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView

class cashout: UIViewController {

    var str_vaterian_wallet:String!
    var str_product_wallet:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Wallet"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
//            tbleView.delegate = self
//            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.sideBarMenu()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.veterianrianRegistration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func veterianrianRegistration() {
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        /*
         action:returnprofile
         userId;
         UTYPE:
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
           
            parameters = [
                "action"         :   "getwallet",
                "userId"         :   String(myString),
                        
            ]
        }
                
        print("parameters-------\(String(describing: parameters))")
                   
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
        {
            response in
               
            switch(response.result) {
            case .success(_):
                if let data = response.value {

                               
                               let JSON = data as! NSDictionary
                               print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               if strSuccess == "success" {
                                   
                                   // var str_vaterian_wallet:String!
                                   // var str_product_wallet:String!
                                   
                                   self.str_vaterian_wallet = "\(JSON["VeterianWallet"]!)"
                                   self.str_product_wallet = "\(JSON["productWallet"]!)"
                                   
                                   self.tbleView.delegate = self
                                   self.tbleView.dataSource = self
                                   self.tbleView.reloadData()
                                   
                                   Utils.RiteVetIndicatorHide()
                               }
                               else
                               {
                                   //self.indicator.stopAnimating()
                                   //self.enableService()
                                   Utils.RiteVetIndicatorHide()
                               }
                               
                           }

                           case .failure(_):
                               print("Error message:\(String(describing: response.error))")
                               //self.indicator.stopAnimating()
                               //self.enableService()
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

extension cashout: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:cashout_table_cell = tableView.dequeueReusableCell(withIdentifier: "cashout_table_cell") as! cashout_table_cell
        
        cell.backgroundColor = .clear
        
        cell.lbl_current_product_price.text = "Current in wallet : $"+String(self.str_product_wallet)
        cell.lbl_current_veterinary_price.text = "Current in wallet : $"+String(self.str_vaterian_wallet)
        
        cell.btn_withdraw_product_wallet.addTarget(self, action: #selector(withdraw_click_method), for: .touchUpInside)
        
        cell.btn_withdraw_veterian_wallet.addTarget(self, action: #selector(withdraw_click_method_2), for: .touchUpInside)
        
        //
        
        return cell
    }
    
    @objc func withdraw_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cashout_listing_id") as? cashout_listing
       
        push!.str_type = "1"
        push!.str_product_wallet = String(self.str_product_wallet)
        push!.str_veterian_wallet = String(self.str_vaterian_wallet)
       
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func withdraw_click_method_2() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cashout_listing_id") as? cashout_listing
       
        push!.str_type = "2"
        push!.str_product_wallet = String(self.str_product_wallet)
        push!.str_veterian_wallet = String(self.str_vaterian_wallet)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
           
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 466
    }
    
}
 
class cashout_table_cell: UITableViewCell {

    @IBOutlet weak var btnSubscription:UIButton!
    
    @IBOutlet weak var lbl_current_product_price:UILabel! {
        didSet {
            lbl_current_product_price.textColor = .systemGreen
        }
    }
    
    @IBOutlet weak var lbl_current_veterinary_price:UILabel! {
        didSet {
            lbl_current_veterinary_price.textColor = .systemGreen
        }
    }
    
    @IBOutlet weak var btn_withdraw_product_wallet:UIButton! {
        didSet {
            btn_withdraw_product_wallet.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_withdraw_product_wallet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_withdraw_product_wallet.layer.shadowOpacity = 1.0
            btn_withdraw_product_wallet.layer.shadowRadius = 15.0
            btn_withdraw_product_wallet.layer.masksToBounds = false
            btn_withdraw_product_wallet.layer.cornerRadius = 15
            btn_withdraw_product_wallet.backgroundColor = .white
            btn_withdraw_product_wallet.backgroundColor = UIColor.init(red: 26.0/255.0, green: 65.0/255.0, blue: 155.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btn_withdraw_veterian_wallet:UIButton!  {
        didSet {
            btn_withdraw_veterian_wallet.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_withdraw_veterian_wallet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_withdraw_veterian_wallet.layer.shadowOpacity = 1.0
            btn_withdraw_veterian_wallet.layer.shadowRadius = 15.0
            btn_withdraw_veterian_wallet.layer.masksToBounds = false
            btn_withdraw_veterian_wallet.layer.cornerRadius = 15
            btn_withdraw_veterian_wallet.backgroundColor = .white
            btn_withdraw_veterian_wallet.backgroundColor = UIColor.init(red: 26.0/255.0, green: 65.0/255.0, blue: 155.0/255.0, alpha: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
