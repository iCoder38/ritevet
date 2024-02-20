//
//  MyOrders.swift
//  RiteVet
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyOrders: UIViewController {

    let cellReuseIdentifier = "myOrdersTableCell"
    
    var arrListOfMyOrders:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MY ORDERS"
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        self.sideBarMenu()
        
        
    }
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.arrListOfMyOrders.removeAllObjects()
        self.myOrders(page_number: 1)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tbleView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    self.myOrders(page_number: page)
                    
                }
            }
        }
    }
    
    @objc func myOrders(page_number:Int) {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            
            parameters = [
                "action"    :   "orderlist",
                "userId"    :   myString,
                "pageNo"    :   page_number
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
                        Utils.RiteVetIndicatorHide()
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        // self.arrListOfMyOrders = (ar as! Array<Any>)
                        self.arrListOfMyOrders.addObjects(from: ar as! [Any])
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        self.loadMore = 1
                        
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


extension MyOrders: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrListOfMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MyOrdersTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyOrdersTableCell
        
        cell.backgroundColor = .clear
        
        /*
         SKU = e4t64r222;
         ShippingCity = "Dishant Rajput Vendor";
         ShippingMobile = 123456789;
         ShippingState = "";
         TotalAmount = 8000;
         amount = 8000;
         created = "December 26th, 2019, 6:10 pm";
         id = 65;
         image = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/products/1575973651bb3ce36c-a3bc-4ab6-bd0e-1efcf105cc75_1.d403ef16688c4b782fc44a6e10e2058a.jpeg";
         orderID = 55;
         orderStatus = 1;
         paymentTrouugh = "";
         price = 4000;
         productId = 77;
         productName = "Pet Food";
         quantity = 2;
         shippingAddress = "";
         shippingAmount = 10;
         shippingName = "";
         shippingZipcode = "";
         transactionID = "";
         */
        
        
         let item = arrListOfMyOrders[indexPath.row] as? [String:Any]
        
         // image
        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
         // product name
        cell.lblTitle.text = (item!["productName"] as! String)
        
        // created at
        cell.lblDate.text = (item!["created"] as! String)
        
        // quantity
        let livingArea = item?["quantity"] as? Int ?? 0
        if livingArea == 0 {
            let stringValue = String(livingArea)
            cell.lblQuantity.text = " Quantity: "+(stringValue)+" |"
        }
        else
        {
            let stringValue = String(livingArea)
            cell.lblQuantity.text = " Quantity: "+(stringValue)+" |"
        }
        // price
        /*let livingArea2 = item?["price"] as? Int ?? 0
        if livingArea2 == 0 {
            let stringValue2 = String(livingArea2)
            cell.lblPrice.text = " Price: $"+(stringValue2)
        }
        else
        {
            let stringValue2 = String(livingArea2)
            cell.lblPrice.text = " Price: $"+(stringValue2)
        }*/
        
        let pass_special_price :String!
        
        if item?["price"] is String {
            print("Yes, it's a String")

            pass_special_price = (item?["price"] as! String)
            
        } else if item?["specialPrice"] is Int {
            print("It is Integer")
                        
            let x2 : Int = (item?["price"] as! Int)
            let myString2 = String(x2)
            pass_special_price = myString2
        } else {
            print("i am number")
                        
            let temp:NSNumber = item?["price"] as! NSNumber
            let tempString = temp.stringValue
            pass_special_price = tempString
        }
        
        cell.lblPrice.text = " Price: $"+pass_special_price
        
        cell.accessoryType = .disclosureIndicator
        
        if "\(item!["orderStatus"]!)" == "3" {
            cell.img_profile.isHidden = false
            cell.img_profile.image = UIImage(named: "delivered")
        } else {
            cell.img_profile.isHidden = true
        }
        //
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // getFreeStuffDict
         let item = arrListOfMyOrders[indexPath.row] as? [String:Any]
        
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyOrdersDetailsId") as? MyOrdersDetails
         push!.dictGetOrderDetails = item as NSDictionary?
         self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MyOrders: UITableViewDelegate
{
    
}
