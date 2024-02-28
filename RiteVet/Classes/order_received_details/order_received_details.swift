//
//  order_received_details.swift
//  RiteVet
//
//  Created by Dishant Rajput on 02/06/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire

class order_received_details: UIViewController {
    
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
        
        self.tbleView.separatorColor = .clear
        
        self.btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
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
    
    
    @objc func update_status_click_method() {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you delivered this product ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes, delivered", style: .default, handler: { action in
            
            self.delivered_click_method()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func delivered_click_method() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            
            parameters = [
                "action"    :   "orderdelivered",
                "userId"    :   myString,
                "orderId"   :   "\(self.dictGetOrderDetails["id"]!)",
                
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
                        
                        let alert = UIAlertController(title: JSON["status"] as? String, message: JSON["msg"] as? String, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                            
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
}

extension order_received_details: UITableViewDataSource , UITableViewDelegate
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
        let cell:order_received_details_table_cell = tableView.dequeueReusableCell(withIdentifier: "order_received_details_table_cell") as! order_received_details_table_cell
        
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
        // cell.lblDate.text = (dictGetOrderDetails!["created"] as! String)
        
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
//        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            cell.lblUsername.text = (dictGetOrderDetails["userName"] as! String)+"\n"+(dictGetOrderDetails["shippingName"] as! String)+"\n"+(dictGetOrderDetails["shippingAddress"] as! String)+"\n"+(dictGetOrderDetails["ShippingCity"] as! String)+"\n"+(dictGetOrderDetails["ShippingState"] as! String)+"\nPhone Number : "+(dictGetOrderDetails["ShippingMobile"] as! String)
            
//        }
        
        cell.lbl_seller_info.text = "Name : "+(self.dictGetOrderDetails["sellerName"] as! String)+"\nEmail : "+(self.dictGetOrderDetails["sellerEmail"] as! String)+"\nPhone : "+(self.dictGetOrderDetails["sellerPhone"] as! String)+"\nCompany name : "+(self.dictGetOrderDetails["SellerCompanyName"] as! String)
        
        
        cell.lblPaymentDetails.text = "Payment Details" //(item!["productName"] as! String)
        
        cell.lblRefId.text = "Ref ID : "+"e4t64r222" //(item!["productName"] as! String)
        
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
            cell.lblInvoiceDate.text = "Invoice Date : "+String(str_get)
        } else {
            cell.lblInvoiceDate.text = "Invoice Date : "
        }
        
        
        
        if "\(self.dictGetOrderDetails["orderStatus"]!)" == "3" {
            
            self.lblInTransit.text = "Delivered"
            cell.btn_update_status.setTitleColor(.white, for: .normal)
            cell.btn_update_status.setTitle("Delivered", for: .normal)
            cell.btn_update_status.backgroundColor = .systemGreen
            
        } else  if "\(self.dictGetOrderDetails["orderStatus"]!)" == "1" {
            
            self.lblInTransit.text = "In-Transit"
            cell.btn_update_status.setTitleColor(.white, for: .normal)
            cell.btn_update_status.setTitle("Mark as Delivered", for: .normal)
            cell.btn_update_status.backgroundColor = .systemOrange
            cell.btn_update_status.addTarget(self, action: #selector(update_status_click_method), for: .touchUpInside)
        }
        
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
        return 680
    }
}
 

class order_received_details_table_cell: UITableViewCell {

    @IBOutlet weak var lblOrderId:UILabel!
    @IBOutlet weak var lblInTansit:UILabel!
    
    @IBOutlet weak var lbl_seller_info:UILabel!
    
    @IBOutlet weak var imgProductImage:UIImageView!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblQuantity:UILabel!
    @IBOutlet weak var lblPrice:UILabel! {
        didSet {
            lblPrice.textColor = .blue
        }
    }
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var lblShippingDetails:UILabel!
    @IBOutlet weak var lblUsername:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var lblPhoneNumber:UILabel!
    @IBOutlet weak var lblZipcode:UILabel!
    
    @IBOutlet weak var lblPaymentDetails:UILabel!
    @IBOutlet weak var lblInvoiceDate:UILabel!
    @IBOutlet weak var lblRefId:UILabel!
    
    @IBOutlet weak var lblDeliveryStatus:UILabel!
    @IBOutlet weak var lblInvoilblCurrentStatusceDate:UILabel!
    @IBOutlet weak var lblExpectedDelivery:UILabel!
    
    @IBOutlet weak var view_seller_info:UIView! {
        didSet {
            view_seller_info.layer.cornerRadius = 8
            view_seller_info.clipsToBounds = true
            view_seller_info.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var viewBGOne:UIView! {
        didSet {
            viewBGOne.layer.cornerRadius = 8
            viewBGOne.clipsToBounds = true
            viewBGOne.backgroundColor = .white
        }
    }
    @IBOutlet weak var viewBGTwo:UIView! {
        didSet {
            viewBGTwo.layer.cornerRadius = 8
            viewBGTwo.clipsToBounds = true
            viewBGTwo.backgroundColor = .white
        }
    }
    @IBOutlet weak var viewBGThree:UIView! {
        didSet {
            viewBGThree.layer.cornerRadius = 8
            viewBGThree.clipsToBounds = true
            viewBGThree.backgroundColor = .systemYellow
        }
    }
    
    @IBOutlet weak var btn_update_status:UIButton! {
        didSet {
            btn_update_status.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_update_status.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_update_status.layer.shadowOpacity = 1.0
            btn_update_status.layer.shadowRadius = 15.0
            btn_update_status.layer.masksToBounds = false
            btn_update_status.layer.cornerRadius = 15
            btn_update_status.backgroundColor = .white
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
