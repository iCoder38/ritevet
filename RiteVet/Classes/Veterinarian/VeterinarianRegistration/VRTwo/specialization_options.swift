//
//  specialization_options.swift
//  RiteVet
//
//  Created by Dishant Rajput on 25/05/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class specialization_options: UIViewController {

    var str_get_specialization_options:String!
    
    var arr_specialization : NSMutableArray! = []
    
    var arr_already_specialization_data:NSArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Specialization"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // self.tbleView.delegate = self
            // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
//        print(self.str_get_specialization_options)
        
        if (self.str_get_specialization_options == "") {
            
        } else {
            let fullNameArr = self.str_get_specialization_options.components(separatedBy: ",")
            // print(fullNameArr as Any)
            
            self.arr_already_specialization_data = fullNameArr as NSArray
        }
        
        // print(self.arr_already_specialization_data)
        
        self.american_board_WB()
    }
    
    @objc func backClickMethod() {
        
        var arr_save_ids : NSMutableArray! = []
        var arr_save_names : NSMutableArray! = []
        
        for i in 0..<self.arr_specialization.count {
            
            let item = self.arr_specialization[i] as! [String:Any]
            
            if (item["status"] as! String == "yes") {
                arr_save_ids.add(item["id"] as! String)
                arr_save_names.add(item["name"] as! String)
            }
            
        }
        
        // print(arr_save)
        
        // ids
        if let array = arr_save_ids as? [String] {
            print(array)
            
            let productIDString = array.joined(separator: ",")
            print(productIDString)
            
            UserDefaults.standard.set(productIDString, forKey: "key_saved_specialization_ids")
            
        }
        
        // name
        if let array_name = arr_save_names as? [String] {
            print(array_name)
            
            let productIDString_names = array_name.joined(separator: ",")
            print(productIDString_names)
            
            UserDefaults.standard.set(productIDString_names, forKey: "key_saved_specialization_names")
            
        }
        
        
        
//

        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    @objc func american_board_WB() {

        Utils.RiteVetIndicatorShow()
        let urlString = BASE_URL_KREASE
        var parameters:Dictionary<AnyHashable, Any>!
        
                       parameters = [
                                        "action"        :   "american_board_certified_option"
                                    ]
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
                                  
                                       var ar : NSArray!
                                       ar = (JSON["data"] as! Array<Any>) as NSArray
                                       
                                       if (self.arr_already_specialization_data.count == 0) {
                                           
                                           print("no data")
                                           
                                           for i in 0..<ar.count {
                                               
                                               let item = ar[i] as! [String:Any]
                                               
                                               let custom = [
                                                "id":"\(item["id"]!)",
                                                   "name":(item["name"] as! String),
                                                   "status":"no",
                                               ]
                                               
                                               self.arr_specialization.add(custom)
                                               
                                           }
                                           
                                       } else {
                                           
                                           for i in 0..<ar.count {
                                               
                                               let item = ar[i] as! [String:Any]
                                               
                                               let custom = [
                                                "id":"\(item["id"]!)",
                                                   "name":(item["name"] as! String),
                                                   "status":"no",
                                               ]
                                               
                                               self.arr_specialization.add(custom)
                                               
                                           }

                                           
                                           // print(self.arr_specialization)
                                           // print(self.arr_specialization.count)
                                           
                                           // print(self.arr_already_specialization_data)
                                           // print(self.arr_already_specialization_data.count)
                                           
                                           for b in 0..<self.arr_already_specialization_data.count {
                                               
                                               let item_3 = self.arr_already_specialization_data[b]
                                               
                                               
                                               for c in 0..<self.arr_specialization.count {
                                                   
                                                   let item_4 = self.arr_specialization[c] as! [String:Any]
                                                   
                                                   if "\(item_4["id"]!)" == item_3 as! String {
                                                       print("=====> DISHANT RAJPUT <=====")
                                                       
                                                      // print("\(item_4["id"]!)")
                                                       // print(item_3 as! String)
                                                       
                                                       let custom = [
                                                            "id":"\(item_4["id"]!)",
                                                            "name":(item_4["name"] as! String),
                                                            "status":"yes",
                                                       ]
                                                       
                                                       self.arr_specialization.removeObject(at: c)
                                                       
                                                       self.arr_specialization.insert(custom, at: c)
                                                       
                                                   }
                                                   
                                               }

                                           }
                                           
                                           // print(self.arr_specialization)
                                           
                                       }
                                       
                                       
//                                       self.arr_specialization.addObjects(from: ar as! [Any])
                                       
                                       self.tbleView.delegate = self
                                       self.tbleView.dataSource = self
                                       self.tbleView.reloadData()
                                       
                                       Utils.RiteVetIndicatorHide()
                                       
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

// MARK:- TABLE VIEW -
extension specialization_options: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_specialization.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:specialization_options_table_cell = tableView.dequeueReusableCell(withIdentifier: "specialization_options_table_cell") as! specialization_options_table_cell
          
        let item = self.arr_specialization[indexPath.row] as? [String:Any]
        cell.lbl_title.textColor = .black
        cell.lbl_title.text = (item!["name"] as! String)
        
        if (item!["status"] as! String) == "no" {
            
            cell.btn_tick.setImage(UIImage(named: "regUncheck"), for: .normal)
            
        } else {
            
            cell.btn_tick.setImage(UIImage(named: "regCheck"), for: .normal)
            
        }
 
        cell.backgroundColor = .clear
        
        
        return cell
        
    }

     
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_specialization[indexPath.row] as? [String:Any]
        
        if (item!["status"] as! String) == "no"  {
            
            let custom = [
                
                "id":"\(item!["id"]!)",
                "name":(item!["name"] as! String),
                "status":"yes",
                
            ]
            
            self.arr_specialization.removeObject(at: indexPath.row)
            self.arr_specialization.insert(custom, at: indexPath.row)
            
        } else {
            
            let custom = [
                
                "id":"\(item!["id"]!)",
                "name":(item!["name"] as! String),
                "status":"no",
                
            ]
            
            self.arr_specialization.removeObject(at: indexPath.row)
            self.arr_specialization.insert(custom, at: indexPath.row)
            
            //
            
            //
        }
        
        self.tbleView.reloadData()

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 60 // UITableView.automaticDimension
    }
    
     
    
}


class specialization_options_table_cell: UITableViewCell {
    
    @IBOutlet weak var btn_tick:UIButton! {
        didSet {
            btn_tick.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var lbl_title:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

 
