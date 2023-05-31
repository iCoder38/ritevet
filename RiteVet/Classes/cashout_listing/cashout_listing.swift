//
//  cashout_listing.swift
//  RiteVet
//
//  Created by Dishant Rajput on 31/05/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView

class cashout_listing: UIViewController {

    var str_product_wallet:String!
    var str_veterian_wallet:String!
    
    var str_type:String!
    
    var arr_cashout_listing:Array<Any>!
//    var arr_cashout_listing:NSMutableArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Cashout Requests"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_cashout:UIButton! {
        didSet {
            btn_cashout.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btn_cashout.layer.cornerRadius = 20
            btn_cashout.clipsToBounds = true
            btn_cashout.setTitle("Cashout", for: .normal)
            btn_cashout.setTitleColor(.white, for: .normal)
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
        
        // print(self.str_product_wallet)
        // print(self.str_veterian_wallet)
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btn_cashout.addTarget(self, action: #selector(cashout_click_method), for: .touchUpInside)
    }
    
    @objc func cashout_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cashout_pay_id") as? cashout_pay
       
        push!.str_type_2 = String(self.str_type)
        push!.str_product_wallet = String(self.str_product_wallet)
        push!.str_veterian_wallet = String(self.str_veterian_wallet)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.veterianrianRegistration()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
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
                "action"    : "cashoutlist",
                "userId"    : String(myString),
                "type"      : String(self.str_type),
                "pageNo"    : "",
                
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
                               
                    if strSuccess == "success" {
                                   
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        if ar.count == 0 {
                            let alert = UIAlertController(title: "Alert", message: "No data found.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            
                            self.arr_cashout_listing = (ar as! Array<Any>)
                                       
                            // print(self.arr_cashout_listing.count)
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                        }
                        
                        Utils.RiteVetIndicatorHide()
                        
                    }
                    else {
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


extension cashout_listing: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_cashout_listing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:cashout_listing_table_cell = tableView.dequeueReusableCell(withIdentifier: "cashout_listing_table_cell") as! cashout_listing_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_cashout_listing[indexPath.row] as? [String:Any]
        
        cell.lbl_date.text = (item!["created"] as! String)
        cell.lbl_amount.text = "Amount : $\(item!["Request_Amount"]!)"
        
        if "\(item!["Approve_Amount"]!)" == "0" {
            
            cell.lbl_status.text = "Pending"
            cell.lbl_status.textColor = .white
            cell.view_status.backgroundColor = .systemRed
            
        } else {
            
            cell.lbl_status.text = "Paid"
            cell.lbl_status.textColor = .black
            cell.view_status.backgroundColor = .systemGreen
            
        }
        
//        cell.btn_withdraw_product_wallet.addTarget(self, action: #selector(withdraw_click_method), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
//        let item = self.arr_cashout_listing[indexPath.row] as? [String:Any]
//
//        if "\(item!["Approve_Amount"]!)" == "0" {
//
//
//
//        }
        
        
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
 
class cashout_listing_table_cell: UITableViewCell {

    @IBOutlet weak var view_status:UIView! {
        didSet {
            view_status.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_status.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_status.layer.shadowOpacity = 1.0
            view_status.layer.shadowRadius = 15.0
            view_status.layer.masksToBounds = false
            view_status.layer.cornerRadius = 15
            view_status.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_date:UILabel!
    @IBOutlet weak var lbl_amount:UILabel!
    @IBOutlet weak var lbl_status:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
