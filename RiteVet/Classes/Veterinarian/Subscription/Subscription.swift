//
//  Subscription.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView
import StoreKit

class Subscription: UIViewController,SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var in_app_auto_renew_one_month: String!
    
    let cellReuseIdentifier = "subscriptionTableCell"
    
    var arrSubscription = [
        "Free Trial",
        "Subscription",
        // "12 months $89.95 ( you save $29.45 )",
        // "1 month free ( enter coupon code )"
        ]
    
    var dictSaveAllDataVeterinarian:NSDictionary!
    
    var str_user_info_id:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SUBSCRIPTION"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
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

        // in-app purchase
        SKPaymentQueue.default().add(self)
        self.in_app_auto_renew_one_month = "one_month_sub"
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
         self.veterianrianRegistration()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func veterianrianRegistration() {
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        /*
         action:returnprofile
         userId;
         UTYPE:
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"         :   "returnprofile",
                "userId"         :   String(myString),
                "UTYPE"          :   "2"
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
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        //print(dict as Any)
                        self.dictSaveAllDataVeterinarian = dict as NSDictionary
                        
                        //
                        self.str_user_info_id = "\(dict["userInfoId"]!)"
                        
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        Utils.RiteVetIndicatorHide()
                    }
                    else
                    {
                        //self.indicator.stopAnimating()
                        //self.enableService()
                        Utils.RiteVetIndicatorHide()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                //self.indicator.stopAnimating()
                //self.enableService()
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
    
    @objc func init_in_app_purchase() {
        
        // print(str_selected_product_id)
        if (SKPaymentQueue.canMakePayments()) {
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
            let productID:NSSet = NSSet(object: self.in_app_auto_renew_one_month!);
            print(productID)
            
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self
            productsRequest.start()
            print("Fetching Products")

            
        } else {
            
            print("Can't make purchases")
            
        }
        
    }
    
    func buyProduct(product: SKProduct) {
        
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
        
    }
    
    // delegate method
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.in_app_auto_renew_one_month) {
                
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(product: validProduct)
                
            } else {
                
                print(validProduct.productIdentifier)
            }
        } else {
            
            ERProgressHud.sharedInstance.hide()
            print("nothing")
            print(response)
            print(request)
            
        }
    }
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error Fetching product information");
        
        ERProgressHud.sharedInstance.hide()
        
        let alertController = UIAlertController(title: "Error", message: "Error Fetching product information. Please try again after sometime", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        }
        
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction])
    
    {
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    
                    // if you successfully purchased an item
                    print("Product Purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    // Handle the purchase
                    UserDefaults.standard.set(true , forKey: "purchased")
                    
                    
                    // UPDATE PAYMENT IN OUR SERVER
                    // after success
                    self.update_payment_after_apple()
                    
                    
                    break;
                case .failed:
                    
                    ERProgressHud.sharedInstance.hide()
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    break;
                    
                case .restored:
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    print("Already Purchased");
                    SKPaymentQueue.default().restoreCompletedTransactions()
                                        
                    // Handle the purchase
                    UserDefaults.standard.set(true , forKey: "purchased")
                    //adView.hidden = true

                    break;
                    
                default:
                    break;
                }
            }
        }
        
    }
    
    func update_payment_after_apple() {
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let date = Date().today(format: "dd-MM-yyyy")
            
            parameters = [
                "action"            :   "updatepayment",
                "userId"            :   String(myString),
                "userInfoId"        :   String(self.str_user_info_id),
                "SubscriptionFrom"  :   date,
                "UTYPE"             :   "2"
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
                        
                        self.pushToVeterinarianRegistration()
                        Utils.RiteVetIndicatorHide()
                    }
                    else {
                        //self.indicator.stopAnimating()
                        //self.enableService()
                        Utils.RiteVetIndicatorHide()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                //self.indicator.stopAnimating()
                //self.enableService()
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

extension Subscription: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrSubscription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:SubscriptionTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SubscriptionTableCell
        
        cell.backgroundColor = .clear
        
        cell.btnSubscription.backgroundColor = .white//BUTTON_BACKGROUND_COLOR_BLUE
        cell.btnSubscription.layer.cornerRadius = 4
        cell.btnSubscription.clipsToBounds = true
        cell.btnSubscription.setTitleColor(.black, for: .normal)
        cell.btnSubscription.tag = indexPath.row
        
        /*if indexPath.row == 0 {
            cell.btnSubscription.setTitle("      Free Trial", for: .normal)
        }
        else */
        if indexPath.row == 1 {
            cell.btnSubscription.setTitle("      Subscription", for: .normal)
        }
        
        cell.btnSubscription.addTarget(self, action: #selector(subscriptionClickMethod), for: .touchUpInside)
        
        return cell
    }
    
    @objc func subscriptionClickMethod(_ sender:UIButton) {
        if sender.tag == 0 {
            self.freeTrialActionSheet()
            /*
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VeterinarianRegistrationId") as? VeterinarianRegistration
            self.navigationController?.pushViewController(push!, animated: true)
            */
        }
        else if sender.tag == 1 {
            self.subscriptionActionSheet()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
        }
        else if indexPath.row == 1 {
            self.subscriptionActionSheet()
        }
    }
    
    @objc func freeTrialActionSheet() {
        let alert = UIAlertController(title: "Free Trial", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "1 Month free", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.pushToVeterinarianRegistration()
        }))
        alert.addAction(UIAlertAction(title: "3 Months - Enter Coupon Code", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.openEnterCouponPopup()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func openEnterCouponPopup() {
        let alertController = UIAlertController(title: "Enter coupon code", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "enter coupon code"
        }
        let saveAction = UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            // let secondTextField = alertController.textFields![1] as UITextField
            print(firstTextField.text!)
            self.pushToVeterinarianRegistration()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func subscriptionActionSheet() {
        let alert = UIAlertController(title: "Subscription", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "1 month $9.99", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            
            DispatchQueue.main.async {
                self.init_in_app_purchase()
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func pushToVeterinarianRegistration() {
        let alert = UIAlertController(title: "Success", message: "Successfully Subscribed.",preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
            self.navigationController?.pushViewController(push, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension Subscription: UITableViewDelegate {
    
}


extension Date {
    func today(format : String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
