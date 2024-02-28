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

extension MyOrdersDetails: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // arrListOfMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyOrdersDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyOrdersDetailsTableCell
        
        cell.backgroundColor = .clear
        
        // image
        cell.imgProductImage.sd_setImage(with: URL(string: (dictGetOrderDetails!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
         // product name
        cell.lblTitle.text = (dictGetOrderDetails!["productName"] as! String)
        
        // created at
        
        
        print(TimeZone.current.abbreviation()!)
        
        if (dictGetOrderDetails!["added_time"] as! String) != "" {
            // divide time
            let fullName    = (dictGetOrderDetails!["added_time"] as! String)
            let fullNameArr = fullName.components(separatedBy: " ")

            let normal_date    = fullNameArr[0]
            let surname = fullNameArr[1]
            
            // print(normal_date as Any)
            // print(surname as Any)
            
            // divide sub time
            let divide_time = surname.components(separatedBy: ":")
            let time_hour    = divide_time[0]
            let time_minute = divide_time[1]
            
            // print(time_hour as Any)
            // print(time_minute as Any)
            
            let joiin_and_create_new_time = time_hour+":"+time_minute
            // print(joiin_and_create_new_time as Any)
            
            let dateAsString = String(joiin_and_create_new_time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            // print(Date12)
            
            // print(date24 as Any)
            let commenter_time_zone = (dictGetOrderDetails!["current_time_zone"] as! String)
            let commenter_watcher_time_zone = "\(TimeZone.current.abbreviation()!)"
            // print(commenter_time_zone)
            // print(commenter_watcher_time_zone)
            
            let timeFormatterGet = DateFormatter()
            timeFormatterGet.dateFormat = "yyyy-MM-dd h:mm a"
            // timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
            timeFormatterGet.timeZone = TimeZone(abbreviation: "\(commenter_time_zone)")
            
            let timeFormatterPrint = DateFormatter()
            timeFormatterPrint.dateFormat = "yyyy-MM-dd h:mm a"
            timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(commenter_watcher_time_zone)")
            
            // timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(TimeZone.current.abbreviation()!)\(TimeZone.current.currentTimezoneOffset())") // if you want to specify timezone for output, otherwise leave this line blank and it will default to devices timezone

            let join_date_and_time_together = String(normal_date)+" "+String(Date12)
            // print(join_date_and_time_together)
            
            var str_get:String! = ""
            if let date = timeFormatterGet.date(from: "\(join_date_and_time_together)") {
                print(timeFormatterPrint.string(from: date))
                str_get = timeFormatterPrint.string(from: date)
            } else {
               print("There was an error decoding the string")
            }
            
             print(str_get as Any)
            
            // created at
            cell.lblDate.text = String(str_get)
        } else {
            cell.lblDate.text = String("")
        }
        
        // quantity
        let livingArea = dictGetOrderDetails?["quantity"] as? Int ?? 0
        if livingArea == 0 {
            
            let stringValue = String(livingArea)
            cell.lblQuantity.text = " Quantity: "+(stringValue)+" |"
            
        } else {
            
            let stringValue = String(livingArea)
            cell.lblQuantity.text = " Quantity: "+(stringValue)+" |"
        }
        
        // price
        // let livingArea2 = dictGetOrderDetails?["price"] as? Int ?? 0
        cell.lblPrice.text = "$\(self.dictGetOrderDetails["price"]!)"
        
        // fullName = purnima;
        // shipping details
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            cell.lblUsername.text = (person["fullName"] as! String)+" "+(person["lastName"] as! String)+"\n"+(dictGetOrderDetails["shippingAddress"] as! String)+"\n"+(dictGetOrderDetails["ShippingCity"] as! String)+"\n"+(dictGetOrderDetails["ShippingState"] as! String)+"\nPhone Number : "+(dictGetOrderDetails["ShippingMobile"] as! String)
            
        }
        
        cell.lbl_seller_info.text = "Name : "+(self.dictGetOrderDetails["sellerName"] as! String)+"\nEmail : "+(self.dictGetOrderDetails["sellerEmail"] as! String)+"\nPhone : "+(self.dictGetOrderDetails["sellerPhone"] as! String)+"\nCompany name : "+(self.dictGetOrderDetails["SellerCompanyName"] as! String)
        
        if "\(self.dictGetOrderDetails!["orderStatus"]!)" == "3" {
            self.lblInTransit.text = "Delivered"
        } else {
            self.lblInTransit.text = "In-Transit"
        }
        
        cell.lblPaymentDetails.text = "Payment Details" //(item!["productName"] as! String)
        // cell.lblInvoiceDate.text = "Invoice Date : "+(self.dictGetOrderDetails!["created"] as! String)
        
        if (dictGetOrderDetails!["created"] as! String) != "" {
            // divide time
            let fullName    = (dictGetOrderDetails!["created"] as! String)
            let fullNameArr = fullName.components(separatedBy: " ")

            let normal_date    = fullNameArr[0]
            let surname = fullNameArr[1]
            
            // print(normal_date as Any)
            // print(surname as Any)
            
            // divide sub time
            let divide_time = surname.components(separatedBy: ":")
            let time_hour    = divide_time[0]
            let time_minute = divide_time[1]
            
            // print(time_hour as Any)
            // print(time_minute as Any)
            
            let joiin_and_create_new_time = time_hour+":"+time_minute
            // print(joiin_and_create_new_time as Any)
            
            let dateAsString = String(joiin_and_create_new_time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            // print(Date12)
            
            // print(date24 as Any)
            let commenter_time_zone = (dictGetOrderDetails!["current_time_zone"] as! String)
            let commenter_watcher_time_zone = "\(TimeZone.current.abbreviation()!)"
            // print(commenter_time_zone)
            // print(commenter_watcher_time_zone)
            
            let timeFormatterGet = DateFormatter()
            timeFormatterGet.dateFormat = "yyyy-MM-dd h:mm a"
            // timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
            timeFormatterGet.timeZone = TimeZone(abbreviation: "\(commenter_time_zone)")
            
            let timeFormatterPrint = DateFormatter()
            timeFormatterPrint.dateFormat = "yyyy-MM-dd h:mm a"
            timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(commenter_watcher_time_zone)")
            
            // timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(TimeZone.current.abbreviation()!)\(TimeZone.current.currentTimezoneOffset())") // if you want to specify timezone for output, otherwise leave this line blank and it will default to devices timezone

            let join_date_and_time_together = String(normal_date)+" "+String(Date12)
            // print(join_date_and_time_together)
            
            var str_get:String! = ""
            if let date = timeFormatterGet.date(from: "\(join_date_and_time_together)") {
                print(timeFormatterPrint.string(from: date))
                str_get = timeFormatterPrint.string(from: date)
            } else {
               print("There was an error decoding the string")
            }
            
             print(str_get as Any)
            
            // created at
            cell.lblInvoiceDate.text = "Invoice date : "+String(str_get)
        } else {
            cell.lblInvoiceDate.text = "Invoice date :"+String("")
        }
        
        
        
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

extension MyOrdersDetails: UITableViewDelegate {
    
}
