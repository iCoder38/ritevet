//
//  DogFood.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DogFood: UIViewController,UITextFieldDelegate {
    
    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var getCategoryIdInDogFood:String!
    var getSubCategoryIdInDogFood:String!
    
    var arrDogFoodList:Array<Any>!
    
    var strFromSideBar:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DOG FOOD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var clView: UICollectionView! {
        didSet
        {
            //collection
            //clView.delegate = self
            //clView.dataSource = self
            
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
            screenHeight = screenSize.height
            
            // Do any additional setup after loading the view, typically from a nib
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            
            
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            clView!.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var txtSearch:UITextField! {
        didSet {
            txtSearch.layer.cornerRadius = 4
            txtSearch.clipsToBounds = true
            txtSearch.backgroundColor = .white
            txtSearch.placeholder = "search product here..."
        }
    }
    
    @IBOutlet weak var btnSearch:UIButton!
    
    @IBOutlet weak var btnAdd:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnAdd.addTarget(self, action: #selector(addClickMethod), for: .touchUpInside)
        //print(getCategoryIdInDogFood as Any)
        //print(getSubCategoryIdInDogFood as Any)
        
        if self.strFromSideBar == "sideBarMenuForMyProduct" {
            lblNavigationTitle.text = "MY PRODUCTS"
            self.btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
            
            self.sideBarMenu()
        } else {
            lblNavigationTitle.text = "DOG FOOD"
            self.btnBack.setImage(UIImage(named: "previous"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        txtSearch.delegate = self
        
        btnSearch.addTarget(self, action: #selector(searchProductListWB), for: .touchUpInside)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    @objc func addClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewProductId") as? AddNewProduct
        self.navigationController?.pushViewController(push!, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.productListWB()
    }
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    /*
     action: productlist
     userId:   //optional
     pageNo:
     category:  //optional
     subcategory:  //optional
     keyword:    //optional
     */
    
    @objc func searchProductListWB() {
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        /*
         print(getCategoryIdInDogFood as Any)
         print(getSubCategoryIdInDogFood as Any)
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            if self.strFromSideBar == "sideBarMenuForMyProduct" {
                parameters = [
                    "action"        :   "productlist",
                    "userId"        :   String(myString),
                    "pageNo"        :   "1",
                    "category"      :   String(""),
                    "subcategory"    :  String(""),
                    "keyword"       :   String(txtSearch.text!)
                ]
            } else {
                parameters = [
                    "action"        :   "productlist",
                    "userId"        :   "",
                    "pageNo"        :   "1",
                    "category"      :   String(getCategoryIdInDogFood),
                    "subcategory"    :  String(getSubCategoryIdInDogFood),
                    "keyword"       :   String(txtSearch.text!)
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
                        // arrBrowsePetStore
                        
                        self.clView!.dataSource = self
                        self.clView!.delegate = self
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrDogFoodList = (ar as! Array<Any>)
                        
                        self.clView!.reloadData()
                        
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
    
    func productListWB() {
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        /*
         print(getCategoryIdInDogFood as Any)
         print(getSubCategoryIdInDogFood as Any)
         
         [action] => productlist
         [userId] => 173
         [pageNo] => 1
         [category] =>
         [subcategory] =>
         [keyword] =>
         
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            if self.strFromSideBar == "sideBarMenuForMyProduct" {
                parameters = [
                    "action"        :   "productlist",
                    "userId"        :   String(myString),
                    "pageNo"        :   "1",
                    "category"      :   "",
                    "subcategory"    :  "",
                    "keyword"       :   ""
                ]
            } else {
                parameters = [
                    "action"        :   "productlist",
                    "userId"        :   "",
                    "pageNo"        :   "1",
                    "category"      :   String(getCategoryIdInDogFood),
                    "subcategory"    :  String(getSubCategoryIdInDogFood),
                    "keyword"       :   ""
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
                    
                    if strSuccess == "success" //true
                    {
                        // arrBrowsePetStore
                        
                        self.clView!.dataSource = self
                        self.clView!.delegate = self
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrDogFoodList = (ar as! Array<Any>)
                        
                        self.clView!.reloadData()
                        
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


extension DogFood: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogFoodCollectionCell", for: indexPath as IndexPath) as! DogFoodCollectionCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0.8
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        /*
         SKU = 2000;
         categoryId = 8;
         categoryName = Fish;
         description = "food for fish";
         image = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/products/1574152722images7.jpeg";
         price = 200;
         productId = 34;
         productName = "food fish ";
         productUserId = 46;
         quantity = 300;
         shippingAmount = 20;
         specialPrice = 150;
         subcategoryId = 30;
         subcategoryName = "Fish Food";
         */
        
        
        let item = arrDogFoodList[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        // title
        cell.lblTitle.text = (item!["productName"] as! String)
        
        // old price
        
        let livingArea = item?["price"] as? Int ?? 0
        if livingArea == 0 {
            let stringValue = String(livingArea)
            cell.lbloldPrice.text = "$"+stringValue
        }
        else {
            let stringValue = String(livingArea)
            cell.lbloldPrice.text = "$"+stringValue
        }
        
        /*// new price
         let livingArea2 = item?["specialPrice"] as? Int ?? 0
         if livingArea2 == 0 {
         let stringValue = String(livingArea2)
         cell.lblPrice.text = "$"+stringValue
         }
         else {
         let stringValue = String(livingArea2)
         cell.lblPrice.text = "$"+stringValue
         }*/
        
        cell.lbloldPrice.text = "$"+(item!["price"] as! String)
        cell.lblPrice.text = "$"+(item!["specialPrice"] as! String)
        
        // image
        cell.imgDogProduct.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
        return cell
        
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDogFoodList.count
    }
}

extension DogFood: UICollectionViewDataSource {
    //Write DataSource Code Here
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let item = arrDogFoodList[indexPath.row] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DogFoodDetailsId") as? DogFoodDetails
        push!.dictGetAnimalFoodDetails = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
    }
}

extension DogFood: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
        
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height);
        if result.height == 480 {
            sizes = CGSize(width: 190, height: 220)
        }
        else if result.height == 568 {
            sizes = CGSize(width: 80, height: 170)
        }
        else if result.height == 667.000000 // 8
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 736.000000 // 8 plus
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 812.000000 // 11 pro
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 896.000000 // 11 , 11 pro max
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else
        {
            sizes = CGSize(width: 120, height: 190)
        }
        
        return sizes
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        let result = UIScreen.main.bounds.size
        if result.height == 667.000000 { // 8
            return 4
        } else if result.height == 812.000000 { // 11 pro
            return 4
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        if collectionView.numberOfItems(inSection: section) == 1 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: collectionView.frame.width - flowLayout.itemSize.width)
        } else {
            let result = UIScreen.main.bounds.size
            if result.height == 667.000000 { // 8
                return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            } else if result.height == 736.000000 { // 8 plus
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            } else if result.height == 896.000000 { // 11 plus
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            } else if result.height == 812.000000 { // 11 pro
                return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
            } else {
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        }
        
        
    }
    
}

