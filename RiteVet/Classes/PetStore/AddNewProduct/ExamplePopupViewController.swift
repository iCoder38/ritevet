//
//  ExamplePopupViewController.swift
//  BottomPopup
//
//  Created by Emre on 16.09.2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit
import BottomPopup
import Alamofire
import SwiftyJSON

class ExamplePopupViewController: BottomPopupViewController {

    let cellReuseIdentifier = "exampleNewProductTableCel"
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var getArrListOfCategory:Array<Any>!
    var arrListOfCategory:Array<Any>!
    
    var strGetDetails:String!
    
    var arrGetTime:NSMutableArray! = []
    
    var ar : NSArray!
    
    var dynamicString:String!
    
    // country array
    var arrCountry : NSArray!
    var arrState : NSArray!
    
    @IBOutlet weak var lblTitle:UILabel!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(strGetDetails as Any)
        
        // print(arrGetTime as Any)
        
        //
        if strGetDetails == "categorySection" {
            //self.category()
            tbleView.delegate = self
            tbleView.dataSource = self
        }
        else if strGetDetails == "timeSlot" {
            lblTitle.text = dynamicString
            tbleView.delegate = self
            tbleView.dataSource = self
        }
            //
        else if strGetDetails == "countryListFromEdit" {
            lblTitle.text = "Country List"
            let defaults = UserDefaults.standard
            let array = defaults.array(forKey: "keyCountryListForEditProfile")
            arrCountry = array as NSArray?
            
            tbleView.delegate = self
            tbleView.dataSource = self
        }
        else if strGetDetails == "stateListFromEdit" {
            lblTitle.text = "State List"
            let defaults = UserDefaults.standard
            let array = defaults.array(forKey: "keyStateListForEditProfile")
            arrState = array as NSArray?
            
            tbleView.delegate = self
            tbleView.dataSource = self
        }
        else if strGetDetails == "requestService" {
            lblTitle.text = dynamicString
            
            let defaults = UserDefaults.standard
            if let myString = defaults.string(forKey: "keySelectedRequestServiceIs")
            {
                print(myString)    
            }
            else
            {
                print("never went to that page")
            }
        }
        else
        {
            tbleView.delegate = self
            tbleView.dataSource = self
            // sub category
            let data = UserDefaults.standard.object(forKey: "subCategory")!
            print(data)
            print(type(of: data))
            //print(ar as Any)
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        // Create UserDefaults
        let defaults = UserDefaults.standard
        defaults.set("Some string you want to save", forKey: "savedString")
    }
    
    // Bottom popup attribute methods
    // You can override the desired method to change appearance
    
      func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(500)
    }
    
      func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
      func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
      func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
      func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    func category() {
           Utils.RiteVetIndicatorShow()
           
               let urlString = BASE_URL_KREASE
               
               var parameters:Dictionary<AnyHashable, Any>!
           
                   parameters = [
                       "action"        :   "category"
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
                                // arrBrowsePetStore
                                
                                self.tbleView!.dataSource = self
                                self.tbleView!.delegate = self
                                
                                var ar : NSArray!
                                ar = (JSON["response"] as! Array<Any>) as NSArray
                                self.arrListOfCategory = (ar as! Array<Any>)
                                
                                self.tbleView!.reloadData()
                                
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

extension ExamplePopupViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if strGetDetails == "categorySection" {
            //self.category()
            return getArrListOfCategory.count
        }
        else if strGetDetails == "timeSlot" {
            return arrGetTime.count
        }
        else if strGetDetails == "countryListFromEdit" {
            return arrCountry.count
        }
        else if strGetDetails == "stateListFromEdit" {
            return arrState.count
        }
        else if strGetDetails == "requestService" {
            return arrGetTime.count
        }
        else
        {
            // sub category
            let data = UserDefaults.standard.object(forKey: "subCategory")!
            print(data)
            print(type(of: data))
            return (data as AnyObject).count
        }
        // return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ExampleNewProductTableCel = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ExampleNewProductTableCel
        
        cell.backgroundColor = .clear
        
        if strGetDetails == "categorySection" {
            //self.category()
            let item = getArrListOfCategory[indexPath.row] as? [String:Any]
            cell.lblTitle.text = (item!["name"] as! String)
            //return getArrListOfCategory.count
        }
        else if strGetDetails == "timeSlot" {
            let item = arrGetTime[indexPath.row] as? [String:Any]
            cell.lblTitle.text = (item!["slot"] as! String)
        }
        else if strGetDetails == "requestService" {
            let item = arrGetTime[indexPath.row] as? [String:Any]
            cell.lblTitle.text = (item!["slot"] as! String)
        }
        else if strGetDetails == "countryListFromEdit" {
            let item = arrCountry[indexPath.row] as? [String:Any]
            cell.lblTitle.text = (item!["name"] as! String)
        }
        else if strGetDetails == "stateListFromEdit" {
            let item = arrState[indexPath.row] as? [String:Any]
            cell.lblTitle.text = (item!["name"] as! String)
        }
        else
        {
            // sub category
            let data = UserDefaults.standard.object(forKey: "subCategory")!
            if let rawArray = data as? NSArray,
            let castArray = rawArray as? Array< Dictionary< String, AnyObject > >
            {
                let item = castArray[indexPath.row]
                cell.lblTitle.text = (item["name"] as! String)
            }
            
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if strGetDetails == "categorySection" {
        let item = getArrListOfCategory[indexPath.row] as? [String:Any]
        print(item as Any)
        dismiss(animated: true, completion: nil)
    
            
            
        ar = (item!["SubCat"] as! Array<Any>) as NSArray
            
        let defaults = UserDefaults.standard
        defaults.set(ar, forKey: "subCategory")
        
        defaults.set(item?["name"] as? String, forKey: "getCategoryNameForFreeStuff")
        defaults.set(item?["id"] as? Int, forKey: "getCategoryIdForFreeStuff")
            
        var strCatIdIs:String!
        let livingArea = item?["id"] as? Int ?? 0
        if livingArea == 0 {
            let stringValue = String(livingArea)
            strCatIdIs = stringValue
        }
        else
        {
            let stringValue = String(livingArea)
            strCatIdIs = stringValue
        }
        
        defaults.set(strCatIdIs, forKey: "selectCategoryId") // id
        defaults.set((item!["name"] as! String), forKey: "selectCategoryName") // name
        }
        else if strGetDetails == "timeSlot" {
            let item = arrGetTime[indexPath.row] as? [String:Any]
            
            let defaults = UserDefaults.standard
            defaults.set((item!["slot"] as! String), forKey: "keySelectedTimeIs")
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "countryListFromEdit" {
            let item = arrCountry[indexPath.row] as? [String:Any]
            
            let defaults = UserDefaults.standard
            defaults.set((item!["name"] as! String), forKey: "keyDoneSelectingCountryName")
            UserDefaults.standard.set(item!["id"], forKey: "keyDoneSelectingCountryId")
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "stateListFromEdit" {
            let item = arrState[indexPath.row] as? [String:Any]
            let defaults = UserDefaults.standard
            defaults.set((item!["name"] as! String), forKey: "keyDoneSelectingStateName")
            UserDefaults.standard.set(item!["id"], forKey: "keyDoneSelectingStateId") // state id
            
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "requestService" {
            // keyRequestServiceDropDown
            // let item = arrGetTime[indexPath.row] as? [String:Any]
            let defaults = UserDefaults.standard
            defaults.set((""), forKey: "keySelectedRequestServiceIs")
            dismiss(animated: true, completion: nil)
        }
        else
        {
            
            // sub category
            
            var strSubCatIdIs:String!
            
            let data = UserDefaults.standard.object(forKey: "subCategory")!
            if let rawArray = data as? NSArray,
            let castArray = rawArray as? Array< Dictionary< String, AnyObject > >
            {
                let item = castArray[indexPath.row]
                let livingArea = item["id"] as? Int ?? 0
                if livingArea == 0 {
                    let stringValue = String(livingArea)
                    strSubCatIdIs = stringValue
                }
                else
                {
                    let stringValue = String(livingArea)
                    strSubCatIdIs = stringValue
                }
                
                let defaults = UserDefaults.standard
                defaults.set(strSubCatIdIs, forKey: "selectSubCategoryId") // id
                defaults.set((item["name"] as! String), forKey: "selectSubCategoryName") // name
            }
            
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
}

extension ExamplePopupViewController: UITableViewDelegate
{
    
}
