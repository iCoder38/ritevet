//
//  order_received_details.swift
//  RiteVet
//
//  Created by Dishant Rajput on 02/06/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit

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
        // print(dictGetOrderDetails as Any)
        
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
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
            
            cell.lblUsername.text = (person["fullName"] as! String)+"\n"+(dictGetOrderDetails["shippingAddress"] as! String)+"\n"+(dictGetOrderDetails["ShippingCity"] as! String)+"\n"+(dictGetOrderDetails["ShippingState"] as! String)+"\nPhone Number : "+(dictGetOrderDetails["ShippingMobile"] as! String)
            
        }
        
        cell.lbl_seller_info.text = "Name : "+(self.dictGetOrderDetails["sellerName"] as! String)+"\nEmail : "+(self.dictGetOrderDetails["sellerEmail"] as! String)+"\nPhone : "+(self.dictGetOrderDetails["sellerPhone"] as! String)+"\nCompany name : "+(self.dictGetOrderDetails["SellerCompanyName"] as! String)
        
        
        cell.lblPaymentDetails.text = "Payment Details" //(item!["productName"] as! String)
        cell.lblInvoiceDate.text = "Invoice Date : "+"02-11-2019"
        cell.lblRefId.text = "Ref ID : "+"e4t64r222" //(item!["productName"] as! String)
        
        if "\(self.dictGetOrderDetails["orderStatus"]!)" == "3" {
            
            self.lblInTransit.text = "Delivered"
            cell.btn_update_status.setTitleColor(.white, for: .normal)
            cell.btn_update_status.setTitle("Delivered", for: .normal)
            cell.btn_update_status.backgroundColor = .systemGreen
            
        } else  if "\(self.dictGetOrderDetails["orderStatus"]!)" == "1" {
            
            self.lblInTransit.text = "In-Transit"
            cell.btn_update_status.setTitleColor(.white, for: .normal)
            cell.btn_update_status.setTitle("In-Transit", for: .normal)
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
        return 720
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
