//
//  DogFoodDetails.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DogFoodDetails: UIViewController {

    let cellReuseIdentifier = "dogFoodDetailsTableCell"
    
    var dictGetAnimalFoodDetails:NSDictionary!
    
    var saveTotalQuantity:String!
    
    var setMyQuantityCount:Double!
    
    var arrListOfMyCartItems:Array<Any>!
    var arrListOfMyCartItems2:Array<Any>!
    
    @IBOutlet weak var lblCartCount:UILabel! {
        didSet {
            lblCartCount.layer.cornerRadius = 10
            lblCartCount.clipsToBounds = true
            lblCartCount.backgroundColor = .black
            lblCartCount.textColor = .white
        }
    }
    
    @IBOutlet weak var btnGear:UIButton!
    
    @IBOutlet weak var btnAddToCartList:UIButton!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Details"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        setMyQuantityCount = 0
        
        
        
        /*
         The iTunes information is;
         Triple R Services, LLC
         mailto:3rcustomdetail@gmail.com
         3Rcustoms$
         */
        
        /*
         SKU = 4ty;
         categoryId = 8;
         categoryName = Fish;
         description = "test please ";
         image = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/products/1583219469riteVetImage.jpg";
         price = 20;
         productId = 116;
         productName = test;
         productUserId = 105;
         quantity = 5;
         shippingAmount = 2;
         specialPrice = 19;
         subcategoryId = 30;
         subcategoryName = "Fish Food";
         */
        
        // print(dictGetAnimalFoodDetails!["productUserId"] as Any)
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let y : Int = (dictGetAnimalFoodDetails["productUserId"] as! Int)
            let myString2 = String(y)
            
            if myString == myString2 {
                print("yes my product")
                self.btnGear.isHidden = false
                
                
                
                print(dictGetAnimalFoodDetails as Any)
               
//                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
//                    let x : Int = (person["userId"] as! Int)
//                    let myString = String(x)
//                    print(myString)
//
//                }
                
                
                if "\(self.dictGetAnimalFoodDetails["status"]!)" == "0" {
                    self.btnGear.addTarget(self, action: #selector(publish_gearClickMethod), for: .touchUpInside)
                } else {
                    self.btnGear.addTarget(self, action: #selector(gearClickMethod), for: .touchUpInside)
                }
                
            }
            else {
                print("no my product")
                btnGear.isHidden = true
            }
        }
                
        saveTotalQuantity = "0"

        self.btnAddToCartList.addTarget(self, action: #selector(addToCartListClickMethod), for: .touchUpInside)
        
    }
    
    @objc func publish_gearClickMethod() {
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            print("User click edit button")
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewProductId") as? AddNewProduct
            push!.editStringOrNot = "1"
            push!.dictGetForEdit = self.dictGetAnimalFoodDetails
            self.navigationController?.pushViewController(push!, animated: true)
            
        }))

        alert.addAction(UIAlertAction(title: "Publish", style: .default , handler:{ (UIAlertAction)in
            print("User click unpublished button")
            
             self.publish_this_product_again()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel , handler:{ (UIAlertAction)in
            print("User click dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func gearClickMethod() {
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            print("User click edit button")
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewProductId") as? AddNewProduct
            push!.editStringOrNot = "1"
            push!.dictGetForEdit = self.dictGetAnimalFoodDetails
            self.navigationController?.pushViewController(push!, animated: true)
            
        }))

        alert.addAction(UIAlertAction(title: "Unpublished", style: .default , handler:{ (UIAlertAction)in
            print("User click unpublished button")
            self.unpublishThisProduct()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel , handler:{ (UIAlertAction)in
            print("User click dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let defaults = UserDefaults.standard
        if let myString2 = defaults.string(forKey: "keyEditProductDone") {
            print("editProduct: \(myString2)")
            if myString2 == "" {
                self.cartList()
            } else {
                self.showDetailPageAfterEdit()
            }
        } else {
            self.cartList()
        }
    }
    
    @objc func publish_this_product_again() {
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        let defaults = UserDefaults.standard
        if let myString2 = defaults.string(forKey: "keyEditedProductIdIs") {
            print("editProduct: \(myString2)")
            
            parameters = [
                "action"       :   "productstatus",
                "status"       :   "1",
                "productId"    :   "\(self.dictGetAnimalFoodDetails!["productId"]!)"
            ]
            // }
        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
//                    The iTunes information is;
//                    Triple R Services, LLC
//                    mailto:3rcustomdetail@gmail.com
//                    3Rcustoms$
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        let alert = UIAlertController(title: "Alert", message: "This product is published again.",preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
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
    
    @objc func unpublishThisProduct() {
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        let defaults = UserDefaults.standard
        if let myString2 = defaults.string(forKey: "keyEditedProductIdIs") {
            print("editProduct: \(myString2)")
            
            parameters = [
                "action"       :   "productstatus",
                "status"       :   "0",
                "productId"    :   "\(self.dictGetAnimalFoodDetails!["productId"]!)"
            ]
            // }
        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
//                    The iTunes information is;
//                    Triple R Services, LLC
//                    mailto:3rcustomdetail@gmail.com
//                    3Rcustoms$
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        
                        let alert = UIAlertController(title: "Alert", message: "This product is unpublished now. No one will able to see your product.",preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
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
    
    @objc func showDetailPageAfterEdit() {
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        let defaults = UserDefaults.standard
        if let myString2 = defaults.string(forKey: "keyEditedProductIdIs") {
            print("editProduct: \(myString2)")
            
            
           if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
                  {
                      let x : Int = (person["userId"] as! Int)
                      let myString = String(x)
                      
                   parameters = [
                       "action"       :   "productdetails",
                       "userId"       :   myString,// login id
                        "productId"       :   myString2,// product id
                       
                   ]
        }
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
                                defaults.set(nil, forKey: "keyEditProductDone")
                                defaults.set("", forKey: "keyEditProductDone")
                                
                                defaults.set(nil, forKey: "keyEditedProductIdIs")
                                defaults.set("", forKey: "keyEditedProductIdIs")
                                
                                
                                
                                let indexPath = IndexPath.init(row: 0, section: 0)
                                let cell = self.tbleView.cellForRow(at: indexPath) as! DogFoodDetailsTableCell
                                
                                
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                
                                
                                
                                // image
                                cell.imgDogProduct.sd_setImage(with: URL(string: (dict["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
                                
                                // title
                                cell.lblDetails.text = (dict["productName"] as! String)
                                
                                // old price
                                
                                let livingArea = dict["price"] as? Int ?? 0
                                if livingArea == 0 {
                                    let stringValue = String(livingArea)
                                    //cell.lblOldPrice.text = "Price: $"+stringValue
                                    
                                    let attrString = NSAttributedString(string: "Price: $"+stringValue, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                                    cell.lblOldPrice.attributedText = attrString
                                }
                                else
                                {
                                    let stringValue = String(livingArea)
                                    //cell.lblOldPrice.text = "Price: $"+stringValue
                                    
                                    let attrString = NSAttributedString(string: "Price: $"+stringValue, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                                    cell.lblOldPrice.attributedText = attrString
                                }
                                
                                
                                
                                // new price
                                let livingArea2 = dict["specialPrice"] as? Int ?? 0
                                if livingArea2 == 0 {
                                    let stringValue = String(livingArea2)
                                    cell.lblPrice.text = "Special Price: $"+stringValue
                                }
                                else
                                {
                                    let stringValue = String(livingArea2)
                                    cell.lblPrice.text = "Special Price: $"+stringValue
                                }
                                
                                
                                // stepper
                                cell.stepper.minimumValue = 0
                                cell.stepper.maximumValue = dict["quantity"] as! Double
                                cell.stepper.value = 0
                                // cell.stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
                                
                                // sku
                                cell.lblSKU.text = "SKU: "+(dict["SKU"] as! String)
                                
                                
                                // shipping
                                let livingAreaShipping = dict["shippingAmount"] as? Int ?? 0
                                if livingAreaShipping == 0 {
                                    let stringValue = String(livingAreaShipping)
                                    cell.lblShipping.text = "SHIPPING: $"+stringValue
                                }
                                else {
                                    let stringValue = String(livingAreaShipping)
                                    cell.lblShipping.text = "SHIPPING: $"+stringValue
                                }
                                
                                // category
                                cell.lblCategory.text = "CATEGORY: "+(dict["categoryName"] as! String)
                                
                                // description
                                cell.txtViewMessage.text = (dict["description"] as! String)
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                // Utils.RiteVetIndicatorHide()
                                self.cartList()
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
    @objc func addToCartListClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddToCartId") as? AddToCart
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
    @objc func buyNowClickMethod() {
        // print(saveTotalQuantity as Any)
        if saveTotalQuantity == "0" {
            let alert = UIAlertController(title: "Alert", message: "Quantity should be greater than 0",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyNowId") as? BuyNow
            push!.buyNowItemFullQuery = dictGetAnimalFoodDetails
            push!.quantityCount = setMyQuantityCount
            self.navigationController?.pushViewController(push!, animated: true)
        }
    }
    
    @objc func addToCart() {
        
        //print(saveTotalQuantity as Any)
        if saveTotalQuantity == "0" {
            let alert = UIAlertController(title: "Alert", message: "Quantity should be greater than 0",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
        
        /*
        action: addtocart
        userId:
        categoryId:
        productId:
        quantity:
        price:
        */
            Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
        
        let stringValue:String!
        
        let livingArea2 = dictGetAnimalFoodDetails?["specialPrice"] as? Int ?? 0
        if livingArea2 == 0 {
            stringValue = String(livingArea2)
        }
        else
        {
            stringValue = String(livingArea2)
        }
        
        
        // category id
        var stringValueCid:String!
        let livingAreaCid = dictGetAnimalFoodDetails?["categoryId"] as? Int ?? 0
        if livingAreaCid == 0 {
            stringValueCid = String(livingAreaCid)
        }
        else
        {
            stringValueCid = String(livingAreaCid)
        }
        
        
        // product id
        var stringValuePid:String!
        let livingAreaPid = dictGetAnimalFoodDetails?["productId"] as? Int ?? 0
        if livingAreaPid == 0 {
            stringValuePid = String(livingAreaPid)
        }
        else
        {
            stringValuePid = String(livingAreaPid)
        }
        
        
        var parameters:Dictionary<AnyHashable, Any>!
           if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
                  {
                      let x : Int = (person["userId"] as! Int)
                      let myString = String(x)
                      
                   parameters = [
                       "action"       :   "addtocart",
                       "userId"       :   myString,// login id
                       "categoryId"   :   String(stringValueCid),
                       "productId"     :  String(stringValuePid),
                       "quantity"     :  String(saveTotalQuantity),
                       "price"       :   String(stringValue)
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
                               //print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               if strSuccess == "success" {
                                // Utils.RiteVetIndicatorHide()
                                self.cartList()
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
    
    @objc func cartList() {
       
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
                                Utils.RiteVetIndicatorHide()
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfMyCartItems = (ar as! Array<Any>)
                                
                                if self.arrListOfMyCartItems.count == 0 {
                                    self.lblCartCount.isHidden = true
                                }
                                else {
                                    
                                    self.lblCartCount.text = String(self.arrListOfMyCartItems.count)
                                }
                                
                                
                                
                                
                                
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                // self.tbleView.reloadData()
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


extension DogFoodDetails: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:DogFoodDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DogFoodDetailsTableCell
        
        cell.backgroundColor = .clear
        
        // (self.dictGetAnimalFoodDetails as Any)
        
        // image
        cell.imgDogProduct.sd_setImage(with: URL(string: (dictGetAnimalFoodDetails!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
        // title
        cell.lblDetails.text = (dictGetAnimalFoodDetails!["productName"] as! String)
        
        cell.lbl_seller_email.text = (dictGetAnimalFoodDetails!["sellerEmail"] as! String)
        cell.lbl_seller_name.text = (dictGetAnimalFoodDetails!["sellerName"] as! String)
        cell.lbl_seller_company_name.text = (dictGetAnimalFoodDetails!["SellerCompanyName"] as! String)
        cell.lbl_seller_phone.text = (dictGetAnimalFoodDetails!["sellerPhone"] as! String)
        
        // old price
        
        /*let livingArea = dictGetAnimalFoodDetails?["price"] as? Int ?? 0
        if livingArea == 0 {
            let stringValue = String(livingArea)
            //cell.lblOldPrice.text = "Price: $"+stringValue
            
            let attrString = NSAttributedString(string: "Price: $"+stringValue, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.lblOldPrice.attributedText = attrString
        }
        else
        {
            let stringValue = String(livingArea)
            //cell.lblOldPrice.text = "Price: $"+stringValue
            
            let attrString = NSAttributedString(string: "Price: $"+stringValue, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.lblOldPrice.attributedText = attrString
        }
        
        
        
        // new price
        let livingArea2 = dictGetAnimalFoodDetails?["specialPrice"] as? Int ?? 0
        if livingArea2 == 0 {
            let stringValue = String(livingArea2)
            cell.lblPrice.text = "Special Price: $"+stringValue
        }
        else
        {
            let stringValue = String(livingArea2)
            cell.lblPrice.text = "Special Price: $"+stringValue
        }*/
        
        let attrString = NSAttributedString(string: "Price: $"+(dictGetAnimalFoodDetails!["price"] as! String), attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        cell.lblOldPrice.attributedText = attrString
        // cell.lblOldPrice.text = "Price: $"+(dictGetAnimalFoodDetails!["price"] as! String)
        cell.lblPrice.text = "Special Price: $"+(dictGetAnimalFoodDetails!["specialPrice"] as! String)
        
        
        
        // stepper
        cell.stepper.minimumValue = 0
        cell.stepper.maximumValue = Double(dictGetAnimalFoodDetails!["quantity"] as! String)!// dictGetAnimalFoodDetails?["quantity"] as! Double
        cell.stepper.value = 0
        cell.stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        // sku
        cell.lblSKU.text = "SKU: "+(dictGetAnimalFoodDetails!["SKU"] as! String)
        
        
        // shipping
//        let livingAreaShipping = dictGetAnimalFoodDetails?["shippingAmount"] as? Int ?? 0
//        if livingAreaShipping == 0 {
//            let stringValue = String(livingAreaShipping)
//            cell.lblShipping.text = "SHIPPING: $"+stringValue
//        }
//        else {
//            let stringValue = String(livingAreaShipping)
        cell.lblShipping.text = "SHIPPING : $\(self.dictGetAnimalFoodDetails["shippingAmount"]!)"
//        }
        
        // category
        cell.lblCategory.text = "CATEGORY: "+(dictGetAnimalFoodDetails!["categoryName"] as! String)
        
        // description
        cell.txtViewMessage.text = (dictGetAnimalFoodDetails!["description"] as! String)
        
        cell.btnAddToCart.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        cell.btnBuyNow.addTarget(self, action: #selector(buyNowClickMethod), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        //valueLabel.text = Int(sender.value).description
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        let cell = self.tbleView.cellForRow(at: indexPath!) as! DogFoodDetailsTableCell

        cell.lblStepperText.text = Int(sender.value).description
        
        saveTotalQuantity = Int(sender.value).description
        
        setMyQuantityCount = Double(sender.value)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        //let cell = tableView.cellForRow(at: indexPath) as? DogFoodDetailsTableCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 940
    }
}

extension DogFoodDetails: UITableViewDelegate {
    
}
