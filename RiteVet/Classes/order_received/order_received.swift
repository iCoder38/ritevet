//
//  order_received.swift
//  RiteVet
//
//  Created by Dishant Rajput on 02/06/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class order_received: UIViewController {

    var str_get:String! = ""
    
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
            lblNavigationTitle.text = "Order Received"
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
        
        if (page_number == 1) {
            Utils.RiteVetIndicatorShow()
        }
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "orderlist",
                "userId"    : myString,
                "type"      : "OWNER",
                "pageNo"    : page_number
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


extension order_received: UITableViewDataSource , UITableViewDelegate {
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
        let cell:order_received_table_cell = tableView.dequeueReusableCell(withIdentifier: "order_received_table_cell") as! order_received_table_cell
        
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
        print(item as Any)
        
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
            
            cell.btn_delivered_status.isHidden = false
            cell.btn_delivered_status.setTitle("Delivered", for: .normal)
            cell.btn_delivered_status.backgroundColor = .systemGreen
            
        } else {
            
            cell.btn_delivered_status.isHidden = false
            cell.btn_delivered_status.setTitle("In-Transit", for: .normal)
            cell.btn_delivered_status.backgroundColor = .systemOrange
            
        }
        
        print(TimeZone.current.abbreviation()!)
        
        if (item!["added_time"] as! String) != "" {
            // divide time
            let fullName    = (item!["added_time"] as! String)
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
            let commenter_time_zone = (item!["current_time_zone"] as! String)
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
            
            
            if let date = timeFormatterGet.date(from: "\(join_date_and_time_together)") {
                print(timeFormatterPrint.string(from: date))
                self.str_get = timeFormatterPrint.string(from: date)
            } else {
               print("There was an error decoding the string")
            }
            
            print(str_get as Any)
            cell.lblDate.text = String(self.str_get)
            
        } else {
            cell.lblDate.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // getFreeStuffDict
        
        let item = arrListOfMyOrders[indexPath.row] as? [String:Any]
        print(item as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "order_received_details_id") as? order_received_details
        push!.dictGetOrderDetails = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

class order_received_table_cell: UITableViewCell {

    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 4
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderColor = NAVIGATION_BACKGROUND_COLOR.cgColor
            imgProfile.layer.borderWidth = 3.0
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblQuantity:UILabel!
    @IBOutlet weak var lblPrice:UILabel! {
        didSet {
            lblPrice.textColor = .blue
        }
    }
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var btn_delivered_status:UIButton! {
        didSet {
            btn_delivered_status.isHidden = true
            btn_delivered_status.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_delivered_status.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_delivered_status.layer.shadowOpacity = 1.0
            btn_delivered_status.layer.shadowRadius = 14.0
            btn_delivered_status.layer.masksToBounds = false
            btn_delivered_status.layer.cornerRadius = 14
            btn_delivered_status.backgroundColor = .white
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
