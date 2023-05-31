//
//  AddToCart.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddToCart: UIViewController {
    var newString1 = 0.0
    var newShipMent = 0.0
    var totalPriceGetFresh = 0.0
    
    let cellReuseIdentifier = "addToCartTableCell"
    
    var saveTotalQuantity:String!
    
    var btnAddToCartList:UIButton!
    
    var arrListOfMyCartItems:Array<Any>!
    var arrListOfMyCartItems2:Array<Any>!
    
    // save add to cart food
    var addInitialMutable:NSMutableArray = []
    
    var mutableArrayAddShipping:NSMutableArray!
    
    var itemCount:Int!
    
    var sum = 0.0
    
    
    
    
    var strSumTotalIs:String!
    
    
    
    var intAddValueOne:Int!
    var intAddValueTwo:Int!
    var intAddValueThree:Int!
    
    
    var intAddValueOne1:NSNumber!
    var intAddValueTwo1:NSNumber!
    var intAddValueThree1:NSNumber!
    
    
    
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SHOPPING CART"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            //tbleView.delegate = self
            //tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btnCheckOut:UIButton!
    
    @IBOutlet weak var lblSubTotal:UILabel!
    @IBOutlet weak var lblShipingCharge:UILabel!
    @IBOutlet weak var lblTotalPrice:UILabel!
    
    @IBOutlet weak var lblSubTotalTitle:UILabel!
    @IBOutlet weak var lblShipingChargeTitle:UILabel!
    @IBOutlet weak var lblTotalPriceTitle:UILabel!
    
    var strFromSideBarCart:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        // print(dictGetAnimalFoodDetails as Any)
        
        //btnAddToCartList.addTarget(self, action: #selector(addToCartListClickMethod), for: .touchUpInside)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // 255 , 202 , 70
        btnCheckOut.backgroundColor = UIColor.init(red: 255.0/255.0, green: 202.0/255.0, blue: 70.0/255.0, alpha: 1)
        btnCheckOut.layer.cornerRadius = 4
        btnCheckOut.clipsToBounds = true
        btnCheckOut.setTitle("CHECKOUT", for: .normal)
        btnCheckOut.addTarget(self, action: #selector(checkOutClickMethod), for: .touchUpInside)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(AddToCart.longPress(longPressGestureRecognizer:)))
        self.tbleView.addGestureRecognizer(longPressRecognizer)
        
        if self.strFromSideBarCart == "sideBarMenuForMyProductCart" {
            self.btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
            
            self.sideBarMenu()
        } else {
            self.btnBack.setImage(UIImage(named: "previous"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
        
        self.savedCartList()
    }
    
    @objc func sideBarMenu() {
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
    @objc func addToCartListClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddToCartId") as? AddToCart
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func checkOutClickMethod() {
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
         self.navigationController?.pushViewController(push!, animated: true)*/
        
        for index in 0..<self.arrListOfMyCartItems.count {
            
            let item = self.arrListOfMyCartItems[index] as! [String:Any]
            print(item as Any)
            
            let pid : Int = (item["productId"] as! Int)
            let pidValue = String(pid)
            
            let qua : Int = (item["quantity"] as! Int)
            let quaValue = String(qua)
            
            
            // price
            
            // let pri : Int = (item["price"] as! Int)
            // let priValue = String(pri)
            let pass_price :String!
            
            if item["countryId"] is String {
                print("Yes, it's a String")

                pass_price = (item["specialPrice"] as! String)
                
            } else if item["specialPrice"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (item["specialPrice"] as! Int)
                let myString2 = String(x2)
                pass_price = myString2
            } else {
                print("i am number")
                            
                let temp:NSNumber = item["specialPrice"] as! NSNumber
                let tempString = temp.stringValue
                pass_price = tempString
            }
            
            
            
            
            // let spri : Int = (item["specialPrice"] as! Int)
            // let spriiValue = String(spri)
            
            let pass_special_price :String!
            
            if item["specialPrice"] is String {
                print("Yes, it's a String")

                pass_special_price = (item["specialPrice"] as! String)
                
            } else if item["specialPrice"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (item["specialPrice"] as! Int)
                let myString2 = String(x2)
                pass_special_price = myString2
            } else {
                print("i am number")
                            
                let temp:NSNumber = item["specialPrice"] as! NSNumber
                let tempString = temp.stringValue
                pass_special_price = tempString
            }
            
            
            let myDictionary: [String:String] = [
                
                "productId"     : String(pidValue),
                "quantity"      : String(quaValue),
                "productUserId" : "",
                "SKU"           : (item["SKU"] as! String),
                "productName"   : (item["productName"] as! String),
                "price"         : String(pass_price),
                "amount"        : String(pass_special_price)
            ]
            
            var res = [[String: String]]()
            res.append(myDictionary)
            
            self.addInitialMutable.addObjects(from: res)
            
        }
        
        
        self.orderPlaceWB()
    }
    
    @objc func orderPlaceWB() {
        //self.pushFromLoginPage()
        
        // indicator.startAnimating()
        // self.disableService()
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        // print(arrListOfMyCartItems as Any)
        
        /*
         [userId] => 173
         [shippingAmount] =>
         [TotalAmount] =>
         [shippingAddress] => dhdhdififj
         [ShippingCity] => New Delhi
         [ShippingState] => Delhi
         [shippingZipcode] =>
         [ShippingMobile] => 9865326564
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // convert array into JSONSerialization
            let paramsArray = self.addInitialMutable
            let paramsJSON = JSON(paramsArray)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
            
            // print(self.lblTotalPrice.text as Any)
            
            parameters = [
                
                "action"            :   "order",
                "userId"            :   String(myString),
                "shippingAmount"    :   String(""), // empty
                "TotalAmount"       :   String(self.lblTotalPrice.text!), // empty
                "shippingAddress"   :   (person["address"] as! String),
                "ShippingCity"      :   (person["city"] as! String),
                "ShippingState"     :   (person["stateName"] as! String),
                "shippingZipcode"   :   (person["zipCode"] as! String),
                "ShippingMobile"    :   (person["contactNumber"] as! String),
                "productList"       :   String(paramsString)
                
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
                    
                    var strSuccessAlert2 : String!
                    strSuccessAlert2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        
                        // self.enableService()
                        
                        // self.indicator.stopAnimating()
                        
                        /*var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                         
                         let defaults = UserDefaults.standard
                         defaults.setValue(dict, forKey: "keyLoginFullData")*/
                        
                        // self.pushFromLoginPage()
                        
                        let alert = UIAlertController(title: String(strSuccess), message: String(strSuccessAlert2),preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                            //Cancel Action
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                    }
                    else {
                        // self.indicator.stopAnimating()
                        // self.enableService()
                        Utils.RiteVetIndicatorHide()
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
    
    @objc func savedCartList() {
        
        self.intAddValueOne = 0
        self.intAddValueTwo = 0
        self.intAddValueThree = 0
        
        //print(saveTotalQuantity as Any)
        if saveTotalQuantity == "0" {
            let alert = UIAlertController(title: "Alert", message: "Quantity should be greater than 0",preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                parameters = [
                    "action"       :   "cartlist",
                    "userId"       :   myString// login id
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
                        
                        if strSuccess == "success"
                        {
                            Utils.RiteVetIndicatorHide()
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfMyCartItems = (ar as! Array<Any>)
                            
                            
                            // arrListOfMyCartItems2
                            var ar2 : NSArray!
                            ar2 = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfMyCartItems2 = (ar2 as! Array<Any>)
                            
                            if self.arrListOfMyCartItems.count == 0 {
                                self.yourCartIsEmpty() //self.navigationController?.popViewController(animated: true)
                            }
                            else {
                                
                                /*SKU = 23FD;
                                 TotalPrice = 0;
                                 TotalQuantity = 100;
                                 cartId = 10;
                                 categoryId = 23;
                                 created = "August 13th, 2021, 7:52 pm";
                                 image = "http://demo2.evirtualservices.co/ritevet/site/img/uploads/products/162878025132.jpg";
                                 price = 10;
                                 productId = 2;
                                 productName = Food;
                                 quantity = 1;
                                 shippingAmount = 1;
                                 specialPrice = "5.5";
                                 subCategoryId = "";*/
                                
                                
                                // let x : Int = JSON["data"] as! Int
                                // let myString = String(x)
                                
                                
                                /*if myString == "0" {
                                 self.lblTotalItemInCart.isHidden = true
                                 } else if myString == "" {
                                 self.lblTotalItemInCart.isHidden = true
                                 } else if myString == "1" {
                                 self.lblTotalItemInCart.isHidden = false
                                 self.lblTotalItemInCart.text = String(myString)+" Item"
                                 } else {
                                 self.lblTotalItemInCart.isHidden = false
                                 self.lblTotalItemInCart.text = String(myString)+" Items"
                                 }*/
                                
                                
                                for specialPriceIndex in 0..<ar.count {
                                    let item = ar[specialPriceIndex] as? [String:Any]
                                    
                                    if item!["specialPrice"] is String {
                                        
                                        print("Yes, it's a String")
                                        //                                     cell.lbl.text = "$ "+(item!["specialPrice"] as! String)
                                        
                                    } else if item!["specialPrice"] is Int {
                                        
                                        print("It is Integer")
                                        // let x : Int = item!["specialPrice"] as! Int
                                        // let myString = String(x)
                                        // cell.lblRealPrice.text = "$ "+String(myString)
                                        // print(String(myString))
                                        
                                        print(item!["specialPrice"] as! Int)
                                        
                                        self.intAddValueOne = ((item!["specialPrice"] as! Int)+self.intAddValueTwo)*(item!["quantity"] as! Int)
                                        
                                        self.intAddValueTwo = self.intAddValueOne
                                        
                                        print(self.intAddValueTwo as Any)
                                        print(self.intAddValueTwo as Any)
                                        
                                        let x : Int = self.intAddValueTwo!
                                        let myString = String(x)
                                        
                                        self.strSumTotalIs = String(myString)
                                        print(myString as Any)
                                        
                                    } else if item!["specialPrice"] is NSNumber {
                                        
                                        print("It is nsnimber")
                                        //some other check
                                        
                                        if item!["quantity"] is NSNumber {
                                            
                                            print("yes")
                                        }
                                        
                                        let num1 = item!["specialPrice"] as! Double
                                        let num2 = item!["quantity"] as! Int
                                        
                                        let a = Double(num2)
                                        let b = num1
                                        let c = a * b
                                        
                                        let d = String(format: "%.2f", c)
                                        
                                        self.strSumTotalIs = "$ "+d
                                        print(d as Any)
                                        
                                    }
                                    
                                }
                                
                                
                                
                                print(self.strSumTotalIs as Any)
                                
                                
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                                // self.loadMore = 1
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                // total shipping amount
                                /*var newString1 = 0.0
                                 var ss:String!
                                 self.itemCount = self.arrListOfMyCartItems.count-1
                                 
                                 // print(self.itemCount as Any)
                                 print(self.arrListOfMyCartItems as Any)
                                 
                                 for i in 0 ... self.itemCount {
                                 
                                 let item = self.arrListOfMyCartItems[i] as? [String:Any]
                                 
                                 ss = (item!["shippingAmount"] as! String)
                                 
                                 // ss =
                                 
                                 // newString1 += Double(ss)!
                                 }
                                 //print("Total Shipping Cost: "+newString1)
                                 //self.lblShipingCharge.text = newString1
                                 
                                 print(newString1 as Any)*/
                                /*let y: Int? = newString1
                                 let c = String(y!)
                                 self.lblShipingCharge.text = "$"+c
                                 
                                 // total price
                                 
                                 var newString2 = 0
                                 
                                 var ss2:Int!
                                 var getQuantity:Int!
                                 
                                 
                                 
                                 self.itemCount = self.arrListOfMyCartItems.count-1
                                 
                                 for i in 0 ... self.itemCount {
                                 
                                 let item = self.arrListOfMyCartItems[i] as? [String:Any]
                                 //print(item as Any)
                                 getQuantity = (item!["quantity"] as! Int)
                                 print(getQuantity as Any)
                                 ss2 = (item!["specialPrice"] as! Int)
                                 
                                 
                                 
                                 newString2 += ss2*getQuantity
                                 //print(newString2 as Any)
                                 }
                                 
                                 let y2: Int? = newString2
                                 let c2 = String(y2!)
                                 self.lblSubTotal.text = "$"+c2
                                 
                                 
                                 
                                 
                                 
                                 let getFinalPrice : Int!
                                 getFinalPrice = newString1+newString2
                                 
                                 let y3: Int? = getFinalPrice
                                 let c3 = String(y3!)
                                 self.lblTotalPrice.text = "$"+c3*/
                            }
                            
                            
                            
                            
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
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
    func btn(_ sender: UIButton) {
        //l
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tbleView)
            if let indexPath = self.tbleView.indexPathForRow(at: touchPoint) {
                //print(indexPath.row)
                
                
                let item = arrListOfMyCartItems[indexPath.row] as? [String:Any]
                //print(item as Any)
                
                
                let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?"+"\n"+" '"+(item!["productName"] as! String)+"' ",preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                    self.deleteProduct(cartIdInIntForDelete: (item?["cartId"] as? Int)!)
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
                // add your code here
                // you can use 'indexPath' to find out which row is selected
            }
        }
    }
    
    func deleteProduct(cartIdInIntForDelete:Int) {
        
        self.newString1 = 0.0
        self.newShipMent = 0.0
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             deletecart
             userId
             cartId
             */
            parameters = [
                "action"       :   "deletecart",
                "userId"       :   myString,// login id
                "cartId"       :   cartIdInIntForDelete,// cart id
            ]
        }
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
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
                        Utils.RiteVetIndicatorHide()
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfMyCartItems = (ar as! Array<Any>)
                        
                        // arrListOfMyCartItems2
                        var ar2 : NSArray!
                        ar2 = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfMyCartItems2 = (ar2 as! Array<Any>)
                        
                        
                        if self.arrListOfMyCartItems.count == 0 {
                            //                                   self.yourCartIsEmpty() self.navigationController?.popViewController(animated: true)
                        }
                        else
                        {
                            
                            // total shipping amount
                            for specialPriceIndex in 0..<ar.count {
                                let item = ar[specialPriceIndex] as? [String:Any]
                                
                                if item!["specialPrice"] is String {
                                    
                                    print("Yes, it's a String")
                                    //                                     cell.lbl.text = "$ "+(item!["specialPrice"] as! String)
                                    
                                } else if item!["specialPrice"] is Int {
                                    
                                    print("It is Integer")
                                    // let x : Int = item!["specialPrice"] as! Int
                                    // let myString = String(x)
                                    // cell.lblRealPrice.text = "$ "+String(myString)
                                    // print(String(myString))
                                    
                                    print(item!["specialPrice"] as! Int)
                                    
                                    self.intAddValueOne = ((item!["specialPrice"] as! Int)+self.intAddValueTwo)*(item!["quantity"] as! Int)
                                    
                                    self.intAddValueTwo = self.intAddValueOne
                                    
                                    print(self.intAddValueTwo as Any)
                                    print(self.intAddValueTwo as Any)
                                    
                                    let x : Int = self.intAddValueTwo!
                                    let myString = String(x)
                                    
                                    self.strSumTotalIs = String(myString)
                                    print(myString as Any)
                                    
                                } else if item!["specialPrice"] is NSNumber {
                                    
                                    print("It is nsnimber")
                                    //some other check
                                    
                                    if item!["quantity"] is NSNumber {
                                        
                                        print("yes")
                                    }
                                    
                                    let num1 = item!["specialPrice"] as! Double
                                    let num2 = item!["quantity"] as! Int
                                    
                                    let a = Double(num2)
                                    let b = num1
                                    let c = a * b
                                    
                                    let d = String(format: "%.2f", c)
                                    
                                    self.strSumTotalIs = "$ "+d
                                    print(d as Any)
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
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
    
    func yourCartIsEmpty() {
        
        self.lblSubTotalTitle.isHidden = true
        self.lblShipingChargeTitle.isHidden = true
        self.lblTotalPriceTitle.isHidden = true
        
        let alert = UIAlertController(title: "Your Cart is Empty", message: nil,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            // self.navigationController?.popViewController(animated: true)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
            self.navigationController?.pushViewController(push!, animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

 

extension AddToCart: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrListOfMyCartItems2.count
        //arrListOfMyCartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:AddToCartTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AddToCartTableCell
        
        cell.backgroundColor = .clear
        
        /*
        SKU = 2000;
        TotalPrice = "";
        TotalQuantity = 300;
        cartId = 102;
        categoryId = 8;
        created = "December 24th, 2019, 6:59 pm";
        image = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/products/1574152722images7.jpeg";
        price = 200;
        productId = 34;
        productName = "food fish ";
        quantity = 6;
        shippingAmount = 20;
        specialPrice = 150;
        subCategoryId = "";
        */
        
        /*let item = arrListOfMyCartItems2[indexPath.row] as? [String:Any]
        // print(item as Any)
        // image
        cell.imgDogProduct.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
        // title
        cell.lblDetails.text = (item!["productName"] as! String)
        
        
        // stepper
        cell.stepper.tag = indexPath.row
        cell.stepper.minimumValue = 0//item?["quantity"] as! Double
        cell.stepper.maximumValue = item?["TotalQuantity"] as! Double
        cell.stepper.value = item?["quantity"] as! Double//0
        cell.stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        cell.lblPrice.textAlignment = .right
        
        // stepper label
        cell.lblStepperText.tag = indexPath.row
        cell.lblStepperText.textColor = .black
        let livingArea2 = item?["quantity"] as? Int ?? 0
        if livingArea2 == 0 {
            let stringValue = String(livingArea2)
            cell.lblStepperText.text = stringValue
        }
        else
        {
            let stringValue = String(livingArea2)
            cell.lblStepperText.text = stringValue
        }
        
        
        /*// price
        let livingArea = (item!["specialPrice"] as! Int)*(item!["quantity"] as! Int)
        //print(livingArea*(item!["quantity"] as! Int))
        
        if livingArea == 0 {
            let stringValue = String(livingArea)
            cell.lblPrice.text = "$"+stringValue
        }
        else
        {
            let stringValue = String(livingArea)
            cell.lblPrice.text = "$"+stringValue
        }*/
       
        cell.lblPrice.text = (item!["specialPrice"] as! String)*/
        
        
        
        
        let item = arrListOfMyCartItems[indexPath.row] as? [String:Any]
         
        cell.imgDogProduct.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
        
        
        
        
        
        
        
        let x : Int = (item!["quantity"] as! Int)
        let myString = String(x)
        
        cell.lblStepperText.text = String(myString)
        
        
        
        
        
        
         cell.lblDetails.text = (item!["productName"] as! String)

         /*if item!["foodTag"] as! String == "Veg" {
             cell.imgVegNonveg.image = UIImage(named: "veg")
         } else if item!["foodTag"] as! String == "" {
             cell.imgVegNonveg.image = UIImage(named: "veg")
         } else {
             cell.imgVegNonveg.image = UIImage(named: "nonVeg")
         }*/
         
         // cell.lblRealPrice.text = "PRICE : "+(item!["specialPrice"] as! String)
         
         
         
         
         if item!["specialPrice"] is String {
             
             print("Yes, it's a String")
            
             cell.lblPrice.text = "$ "+(item!["specialPrice"] as! String)
             
         } else if item!["specialPrice"] is Int {
             
             print("It is Integer")
             // let x : Int = item!["specialPrice"] as! Int
             // let myString = String(x)
             
             let num1 = item!["specialPrice"] as! Double
             let num2 = item!["quantity"] as! Int

             let a = Double(num2)
             let b = num1
             let c = a * b
            
            let d = String(format: "%.2f", c)
             
            self.strSumTotalIs = d
            
            cell.lblPrice.text = "$ "+String(self.strSumTotalIs)
             // cell.lblRealPrice.text = "$ "+String(myString)
             
         } else if item!["specialPrice"] is NSNumber {
             
           print("It is nsnimber")
           //some other check
             
             if item!["quantity"] is NSNumber {
                  
                  print("yes")
             }
             
              let num1 = item!["specialPrice"] as! Double
              let num2 = item!["quantity"] as! Int

              let a = Double(num2)
              let b = num1
              let c = a * b
             
             let d = String(format: "%.2f", c)
              
             self.strSumTotalIs = d
             
             cell.lblPrice.text = "$ "+String(self.strSumTotalIs)
             
         }
         
        
        
        newString1 += Double(strSumTotalIs)!
         
        
        // let x2 : Int = (item!["shippingAmount"] as! Int)
        let myString2 = "\(item!["shippingAmount"]!)"// String(x2)
        
        newShipMent += Double(myString2)!
        
        // print(newString1)
         
        
        
        let add = Double(newString1)+Double(newShipMent)
        
        
        self.lblSubTotal.text = "$"+String(newString1)
        self.lblShipingCharge.text = "$"+String(newShipMent)
        
        self.lblTotalPrice.text = "$"+String(add)
        
        
         // food id
         /*let x4 : Int = item!["foodId"] as! Int
         let myString4 = String(x4)*/
         
         // array quantity
         let x5 : Int = item!["quantity"] as! Int
         let myString5 = String(x5)
         
         // array res id
         /*let x6 : Int = item!["resturentId"] as! Int
         let myString6 = String(x6)*/
         
         // specialPrice
         // let xSpecialPrice : Int = item!["specialPrice"] as! Int
         // let myStringSpecialPrice = String(xSpecialPrice)
         
         
         let myStringSpecialPrice:String!
         
         
         if item!["specialPrice"] is String {
                             
             print("Yes, it's a String")
             myStringSpecialPrice = (item!["specialPrice"] as! String)
             
         } else if item!["specialPrice"] is Int {
             
             print("It is Integer")
             let x2 : Int = (item!["specialPrice"] as! Int)
             let myString2 = String(x2)
             myStringSpecialPrice = String(myString2)
             
         } else {
             
             print("i am ")
             let temp:NSNumber = item!["specialPrice"] as! NSNumber
             let tempString = temp.stringValue
             myStringSpecialPrice = String(tempString)
             
         }
         
         
         
         
         
         /*let myDictionary: [String:String] = [
             "id":String(myString4),
             "name":(item!["foodName"] as! String),
             "price":String(myStringSpecialPrice),
             "quantity":String(myString5),
             "resturentId":String(myString6),
         ]
         
         var res = [[String: String]]()
         res.append(myDictionary)
         
         self.addInitialMutable.addObjects(from: res)*/
         
         
         
         // quantity
         let x3 : Int = item!["quantity"] as! Int
         let myString3 = String(x3)
         if myString3 == "0" {
             cell.stepper.isHidden = true
         } else {
             cell.stepper.isHidden = false
             
             let morePrecisePI = Double(myString3)
             cell.stepper.value = morePrecisePI!
         }
         
        
        
        cell.stepper.tag = indexPath.row
        cell.stepper.minimumValue = 0//item?["quantity"] as! Double
        cell.stepper.maximumValue = item?["TotalQuantity"] as! Double
        cell.stepper.value = item?["quantity"] as! Double//0
        
        cell.stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
         
         
         
         // cell.imgProfilee.sd_setImage(with: URL(string: (item!["foodImage"] as! String)), placeholderImage: UIImage(named: "avatar"))
         
         /*cell.imgProfilee.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
         
         if let url = (item!["foodImage"] as! String).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
             
          // cell.imgFoodProfile.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "food1"), options: [.continueInBackground, .progressiveDownload])
              cell.imgProfilee.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "food1"))
             
         }*/
         
        
        
        return cell
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        let cell = self.tbleView.cellForRow(at: indexPath!) as! AddToCartTableCell

        cell.lblStepperText.text = Int(sender.value).description
        
        saveTotalQuantity = Int(sender.value).description
        //print(saveTotalQuantity as Any)
        //print(type(of: saveTotalQuantity))
        
        
        let item = arrListOfMyCartItems[sender.tag] as? [String:Any]
        //print(item as Any)
        
        /*
         Optional(["specialPrice": 200,
         "TotalQuantity": 120,
         "categoryId": 15,
         "shippingAmount": 20,
         "created": December 26th, 2019, 11:53 am,
         "quantity": 1,
         "productName": collier and band,
         "price": 250,
         "subCategoryId": ,
         "TotalPrice": ,
         "SKU": 45erdfx,
         "image": http://demo2.evirtualservices.com/ritevet/site/img/uploads/products/1574252483images13.jpeg,
         "cartId": 109,
         "productId": 44])
         */
        
        //let strGetTotalShippingAmount:String!
        
        self.editCart(cartIdInInt: (item?["cartId"] as? Int)!, strQuantity: saveTotalQuantity)
        
    }
    
    @objc func editCart(cartIdInInt:Int,strQuantity:String) {
        
        self.newString1 = 0.0
        self.newShipMent = 0.0
        
        //print(saveTotalQuantity as Any)
        if saveTotalQuantity == "0" {
            self.deleteProduct(cartIdInIntForDelete: cartIdInInt)
        }
        else
        {
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                /*
                 action: editcart
                 userId:
                 cartId:
                 */
                
                parameters = [
                    "action"       :   "editcart",
                    "userId"       :   myString,// login id
                    "cartId"       :   cartIdInInt,// cart id
                    "quantity"          : String(strQuantity)
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
                        
                        if strSuccess == "success" //true
                        {
                            Utils.RiteVetIndicatorHide()
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfMyCartItems = (ar as! Array<Any>)
                            
                            // arrListOfMyCartItems2
                            var ar2 : NSArray!
                            ar2 = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfMyCartItems2 = (ar2 as! Array<Any>)
                            
                            if self.arrListOfMyCartItems.count == 0 {
                                self.yourCartIsEmpty()
                                
                            }
                            else
                            {
                                
                                // total shipping amount
                                
                                for specialPriceIndex in 0..<ar.count {
                                    let item = ar[specialPriceIndex] as? [String:Any]
                                    
                                    if item!["specialPrice"] is String {
                                        
                                        print("Yes, it's a String")
                                        // cell.lblRealPrice.text = "$ "+(item!["specialPrice"] as! String)
                                        
                                    } else if item!["specialPrice"] is Int {
                                        
                                        print("It is Integer")
                                        // let x : Int = item!["specialPrice"] as! Int
                                        // let myString = String(x)
                                        // cell.lblRealPrice.text = "$ "+String(myString)
                                        // print(String(myString))
                                        
                                        print(item!["specialPrice"] as! Int)
                                        
                                        self.intAddValueOne = ((item!["specialPrice"] as! Int)+self.intAddValueTwo)*(item!["quantity"] as! Int)
                                        
                                        self.intAddValueTwo = self.intAddValueOne
                                        
                                        print(self.intAddValueTwo as Any)
                                        print(self.intAddValueTwo as Any)
                                        
                                        let x : Int = self.intAddValueTwo!
                                        let myString = String(x)
                                        
                                        // self.strSumTotalIs = String(myString)
                                        print(myString as Any)
                                        
                                    } else if item!["specialPrice"] is NSNumber {
                                        
                                        print("It is nsnimber")
                                        //some other check
                                        
                                        if item!["quantity"] is NSNumber {
                                            
                                            print("yes")
                                        }
                                        
                                        let num1 = item!["specialPrice"] as! Double
                                        let num2 = item!["quantity"] as! Int
                                        
                                        let a = Double(num2)
                                        let b = num1
                                        let c = a * b
                                        
                                        let d = String(format: "%.2f", c)
                                        
                                        // self.strSumTotalIs = "$ "+d
                                        print(d as Any)
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
}

extension AddToCart: UITableViewDelegate
{
    
}
