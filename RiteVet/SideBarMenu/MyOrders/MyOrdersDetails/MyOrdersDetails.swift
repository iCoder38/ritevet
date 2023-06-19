//
//  MyOrdersDetails.swift
//  RiteVet
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyOrdersDetails: UIViewController {

    let cellReuseIdentifier = "myOrdersDetailsTableCell"
    
    var arrListOfMyOrders:Array<Any>!
    
    var dictGetOrderDetails:NSDictionary!
    
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
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = UIColor.init(red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lblOrderId:UILabel! {
        didSet {
            lblOrderId.textColor = .systemYellow
            lblOrderId.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblInTransit:UILabel! {
        didSet {
            lblInTransit.text = "InTransit"
            lblInTransit.backgroundColor = .clear
            lblInTransit.textColor = .systemGreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        // btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        // self.sideBarMenu()
        
        self.view.backgroundColor = UIColor.init(red: 7.0/255.0, green: 30.0/255.0, blue: 86.0/255.0, alpha: 1)
        print(dictGetOrderDetails as Any)
        
        let livingArea = dictGetOrderDetails["orderID"] as? Int ?? 0
        if livingArea == 0 {
            self.lblOrderId.text = "ORDER ID : "+String("N.A.")
        } else {
            self.lblOrderId.text = "ORDER ID : "+String(livingArea)
        }
        // order id orderID
        
        /*
         SKU = 100XSDX;
         ShippingCity = "New Delhi";
         ShippingMobile = 9865326564;
         ShippingState = Delhi;
         TotalAmount = 221;
         amount = 199;
         created = "February 13th, 2021, 1:48 pm";
         id = 132;
         image = "http://demo2.evirtualservices.co/ritevet/site/img/uploads/products/15767601821-02-cat-256-whiskas-original-imafaf9zfudcajum.jpeg";
         orderID = 89;
         orderStatus = 1;
         paymentTrouugh = "";
         price = 199;
         productId = 86;
         productName = "Cat Food";
         quantity = 1;
         shippingAddress = dhdhdififj;
         shippingAmount = 1;
         shippingName = "";
         shippingZipcode = "";
         transactionID = "";
         */
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
     navigationController?.setNavigationBarHidden(true, animated: animated)
        // myOrders()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyOrdersDetails: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1 // arrListOfMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MyOrdersDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyOrdersDetailsTableCell
        
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
        
        
         // let item = arrListOfMyOrders[indexPath.row] as? [String:Any]
        
         // image
        cell.imgProductImage.sd_setImage(with: URL(string: (dictGetOrderDetails!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
         // product name
        cell.lblTitle.text = (dictGetOrderDetails!["productName"] as! String)
        
        // created at
        cell.lblDate.text = (dictGetOrderDetails!["created"] as! String)
        
        // quantity
        let livingArea = dictGetOrderDetails?["quantity"] as? Int ?? 0
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
        // let livingArea2 = dictGetOrderDetails?["price"] as? Int ?? 0
        cell.lblPrice.text = "$\(self.dictGetOrderDetails["price"]!)"
        
        // fullName = purnima;
        // shipping details
         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            cell.lblUsername.text = (self.dictGetOrderDetails["SellerCompanyName"] as! String)+"\n"+(dictGetOrderDetails["shippingAddress"] as! String)+"\n"+(dictGetOrderDetails["ShippingCity"] as! String)+"\n"+(dictGetOrderDetails["ShippingState"] as! String)+"\nPhone Number : "+(dictGetOrderDetails["ShippingMobile"] as! String)
            
         }
        
        cell.lbl_seller_info.text = "Name : "+(self.dictGetOrderDetails["sellerName"] as! String)+"\nEmail : "+(self.dictGetOrderDetails["sellerEmail"] as! String)+"\nPhone : "+(self.dictGetOrderDetails["sellerPhone"] as! String)+"\nCompany name : "+(self.dictGetOrderDetails["SellerCompanyName"] as! String)
        
        
        
        /*cell.lblAddress.text = "State : "+(dictGetOrderDetails["ShippingState"] as! String)
        cell.lblZipcode.text = "Address : "+(dictGetOrderDetails["shippingAddress"] as! String)+" - "+(dictGetOrderDetails["shippingZipcode"] as! String)
        cell.lblPhoneNumber.text = "Phone number : "+(dictGetOrderDetails["ShippingMobile"] as! String)*/
        /*}
        else {
            cell.lblUsername.text = "no name availaible"
            cell.lblAddress.text = "no address availaible"
            cell.lblPhoneNumber.text = "Phone number : "+"no phone number availaible"
        }*/
        
        
        
        // payment details
        /*
         @IBOutlet weak var lblPaymentDetails:UILabel!
         @IBOutlet weak var lblInvoiceDate:UILabel!
         @IBOutlet weak var lblRefId:UILabel!
         */ // created
        
        if "\(self.dictGetOrderDetails!["orderStatus"]!)" == "3" {
            self.lblInTransit.text = "Delivered"
        } else {
            self.lblInTransit.text = "In-Transit"
        }
        
        
        cell.lblPaymentDetails.text = "Payment Details" //(item!["productName"] as! String)
        cell.lblInvoiceDate.text = "Invoice Date : "+(self.dictGetOrderDetails!["created"] as! String)
        cell.lblRefId.text = "Ref ID : "+"e4t64r222" //(item!["productName"] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // getFreeStuffDict
        // let item = arrListOfMyPost[indexPath.row] as? [String:Any]
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyPostDetailsId") as? MyPostDetails
        // push!.getFreeStuffDict = item as NSDictionary?
        // self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 522
    }
}

extension MyOrdersDetails: UITableViewDelegate
{
    
}
