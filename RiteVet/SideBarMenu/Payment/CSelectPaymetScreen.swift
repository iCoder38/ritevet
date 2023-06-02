//
//  CSelectPaymetScreen.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit
 import Stripe
import Alamofire
import SwiftyJSON
import FirebaseAuth
import Firebase

// MARK:- LOCATION -
import CoreLocation

class CSelectPaymetScreen: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    // var str_shipping_amount:String!
    
    let cellReuseIdentifier = "cSelectPaymentScreenTableCell"
    
    let locationManager = CLLocationManager()
    
    var strTotalAmountToPay:String!
    
    var strWhatCardIam:String!
    
    var dict_get_selected_product_Details:NSDictionary!
    
    // MARK:- WEEKDAYS STRING -
    var weekdayName:String!
    
    // chat cap
    var memberShipPlan:String!
    var membershipPrice:String!
    
    var strGetName:String!
    var strGetPhoneNumber:String!
    var strGetAddress:String!
    var strGetZipcode:String!
    var strGetState:String!
    var strGetCountry:String!
    
    var addInitialMutable:NSMutableArray = []
    var fullArrayProductDetails:NSArray! // NSMutableArray = []
    
    var cardTypeIs:String!
    
    var iAmDate:String!
    var iAmTime:String!
    
    var subscriptionForTotalNumberOfDaysGet:String!
    
    var strValidTill:String!
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "PAYMENT"
            lblNavigationTitle.textColor = .white
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
            // btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
        }
    }
    
    @IBOutlet weak var lblCardNumberHeading:UILabel!
    @IBOutlet weak var lblEXPDate:UILabel!
    
    @IBOutlet weak var lblPayableAmount:UILabel!
    
    // set values and send to server
    var paymentProductName:String!
    var paymentProductAddress:String!
    var paymentProductState:String!
    var paymentProductCity:String!
    var paymentProductZipcode:String!
    var paymentProductPhoneNumber:String!
    
    var arrayAddDataOnMutArrayToSendToOurLocalServer:NSMutableArray = []
    
    // automatic detect location
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    @IBOutlet weak var btnmakePayment:UIButton! {
        didSet {
            btnmakePayment.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            btnmakePayment.setTitle("PAY NOW", for: .normal)
            btnmakePayment.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var viewCard:UIView! {
        didSet {
            viewCard.backgroundColor = NAVIGATION_BACKGROUND_COLOR // UIColor.init(red: 34.0/255.0, green: 72.0/255.0, blue: 104.0/255.0, alpha: 1)
            viewCard.layer.cornerRadius = 6
            viewCard.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgCardImage:UIImageView!
    
    var finalPrice:String!
    
    var finalDaysLeft:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // print(self.dict_get_selected_product_Details)
        
        // MARK:- DISMISS KEYBOARD WHEN CLICK OUTSIDE -
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CSelectPaymetScreen.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.btnBack.addTarget(self, action: #selector(sideBarMenuClick), for: .touchUpInside)
        
        self.btnmakePayment.addTarget(self, action: #selector(firstCheckValidation), for: .touchUpInside)
        
        self.lblPayableAmount.text = "You have to pay $"+String(self.finalPrice)
        
        print(self.memberShipPlan as Any)
        if self.memberShipPlan == "Membership : PREMIUM" {
            self.memberShipPlan = "2"
        } else {
            self.memberShipPlan = "3"
        }
        
        // print(self.memberShipPlan as Any)
        
        // print(self.subscriptionForTotalNumberOfDaysGet as Any)
        
        /*let b:Int? = Int(self.subscriptionForTotalNumberOfDaysGet)
        let calendar = Calendar.current
        let addOneWeekToCurrentDate = calendar.date(byAdding: .month, value: b!, to: Date())
        
        // print(addOneWeekToCurrentDate as Any)
        
        
        // let date = Date()
        let formate = addOneWeekToCurrentDate!.getFormattedDate(format: "dd-MM-yyyy") // HH:mm:ss Set output formate
        // print(formate as Any)
        
        // print("\(formate)")
        
        self.strValidTill = "\(formate)"
        
        // let calendar = Calendar.current
        /*let date = Date()
         
         // Calculate start and end of the current year (or month with `.month`):
         let interval = calendar.dateInterval(of: .year, for: date)! //change year it will no of days in a year , change it to month it will give no of days in a current month
         
         // Compute difference in days:
         let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
         print(days)*/
        
        
        
        
        if self.subscriptionForTotalNumberOfDaysGet == "1" {
            self.howMnayDaysLeft(strTotalNumberOfDays: 30)
        } else if self.subscriptionForTotalNumberOfDaysGet == "3" {
            self.howMnayDaysLeft(strTotalNumberOfDays: 90)
        } else {
            self.howMnayDaysLeft(strTotalNumberOfDays: 180)
        }*/
        
    }
    
    /*@objc func howMnayDaysLeft(strTotalNumberOfDays:Int) {
        
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        var dateComponent = DateComponents()
        dateComponent.day = strTotalNumberOfDays
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        let myStringafd = formatter.string(from: futureDate!)
        
        let startDate = Date()
        let endDateString = String(myStringafd)
        
        
        if let endDate = formatter.date(from: endDateString) {
            let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
            print("Number of days: \(components.day!)")
            self.finalDaysLeft = "\(components.day!)"
        } else {
            print("\(endDateString) can't be converted to a Date")
        }
        
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.iAmHereForLocationPermission()
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func sideBarMenuClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func iAmHereForLocationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
            @unknown default:
                break
            }
        }
    }
    
    // MARK:- GET CUSTOMER LOCATION -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! PDCompleteAddressDetailsTableCell
        
        
        
        
        
        /*let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        location.fetchCityAndCountry { city, country, zipcode,localAddress,localAddressMini,locality, error in
            guard let city = city, let country = country,let zipcode = zipcode,let localAddress = localAddress,let localAddressMini = localAddressMini,let locality = locality, error == nil else { return }
            
            self.strSaveCountryName     = country
            self.strSaveStateName       = city
            self.strSaveZipcodeName     = zipcode
            
            self.strSaveLocalAddress     = localAddress
            self.strSaveLocality         = locality
            self.strSaveLocalAddressMini = localAddressMini
            
            //print(self.strSaveLocality+" "+self.strSaveLocalAddress+" "+self.strSaveLocalAddressMini)
            
            let doubleLat = locValue.latitude
            let doubleStringLat = String(doubleLat)
            
            let doubleLong = locValue.longitude
            let doubleStringLong = String(doubleLong)
            
            self.strSaveLatitude = String(doubleStringLat)
            self.strSaveLongitude = String(doubleStringLong)
            
            print("local address ==> "+localAddress as Any) // south west delhi
            print("local address mini ==> "+localAddressMini as Any) // new delhi
            print("locality ==> "+locality as Any) // sector 10 dwarka
            
            print(self.strSaveCountryName as Any) // india
            print(self.strSaveStateName as Any) // new delhi
            print(self.strSaveZipcodeName as Any) // 110075
            
            //MARK:- STOP LOCATION -
            self.locationManager.stopUpdatingLocation()
            
            // cell.txtAddress.text = String(self.strSaveLocality+" "+self.strSaveLocalAddress+" "+self.strSaveLocalAddressMini)
            // cell.txtCountry.text = String(self.strSaveCountryName)
            // cell.txtState.text = String(self.strSaveStateName)
            // cell.txtZipcode.text = String(self.strSaveZipcodeName)
            // cell.txtCity.text = String(locality)
            
            // self.findMyStateTaxWB()
        }*/
    }
    
    @objc func firstCheckValidation() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if cell.txtCardNumber.text == "" {
            let alert = UIAlertController(title: "Card Number", message: "Card number should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else if cell.txtExpDate.text == "" {
            let alert = UIAlertController(title: "Exp Month", message: "Expiry Month should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else if cell.txtCVV.text == "" {
            let alert = UIAlertController(title: "Security Code", message: "Security Code should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            
            self.dummy_send_data_wb()
            /*let alert = UIAlertController(title: "Alert!", message: "Successfully purchase",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
                self.navigationController?.pushViewController(push!, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            */
            // self.fetchStripeToken()
        }
    }
    
    @objc func dummy_send_data_wb() {
        //self.pushFromLoginPage()
        
        // indicator.startAnimating()
        // self.disableService()
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             dict_get_selected_product_Details
             
             SKU = quw31462;
             categoryId = 15;
             categoryName = Cat;
             description = " ";
             image = "";
             price = 10;
             productId = 3;
             productName = Cucoo;
             productUserId = 4;
             quantity = 100;
             shippingAmount = 1;
             specialPrice = 8;
             subcategoryId = 26;
             subcategoryName = "Cat Food";
            */
            
            let pid : Int = (self.dict_get_selected_product_Details["productId"] as! Int)
            let pidValue = String(pid)
            
            // let qua : Int = (self.dict_get_selected_product_Details["quantity"] as! Int)
            // let quaValue = String(qua)
            let pass_quantity :String!
            
            if self.dict_get_selected_product_Details["quantity"] is String {
                print("Yes, it's a String")

                pass_quantity = (self.dict_get_selected_product_Details["quantity"] as! String)
                
            } else if self.dict_get_selected_product_Details["quantity"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (self.dict_get_selected_product_Details["quantity"] as! Int)
                let myString2 = String(x2)
                pass_quantity = myString2
            } else {
                print("i am number")
                            
                let temp:NSNumber = self.dict_get_selected_product_Details["quantity"] as! NSNumber
                let tempString = temp.stringValue
                pass_quantity = tempString
            }
            
            
            
            
            // price
            
            // let pri : Int = (item["price"] as! Int)
            // let priValue = String(pri)
            let pass_price :String!
            
            if self.dict_get_selected_product_Details["price"] is String {
                print("Yes, it's a String")

                pass_price = (self.dict_get_selected_product_Details["price"] as! String)
                
            } else if self.dict_get_selected_product_Details["price"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (self.dict_get_selected_product_Details["price"] as! Int)
                let myString2 = String(x2)
                pass_price = myString2
            } else {
                print("i am number")
                            
                let temp:NSNumber = self.dict_get_selected_product_Details["price"] as! NSNumber
                let tempString = temp.stringValue
                pass_price = tempString
            }
            
            
            
            
            // let spri : Int = (item["specialPrice"] as! Int)
            // let spriiValue = String(spri)
            
            let pass_special_price :String!
            
            if self.dict_get_selected_product_Details["specialPrice"] is String {
                print("Yes, it's a String")

                pass_special_price = (self.dict_get_selected_product_Details["specialPrice"] as! String)
                
            } else if self.dict_get_selected_product_Details["specialPrice"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (self.dict_get_selected_product_Details["specialPrice"] as! Int)
                let myString2 = String(x2)
                pass_special_price = myString2
            } else {
                print("i am number")
                            
                let temp:NSNumber = self.dict_get_selected_product_Details["specialPrice"] as! NSNumber
                let tempString = temp.stringValue
                pass_special_price = tempString
            }
            
            let myDictionary: [String:String] = [
                
                "productId"     : String(pidValue),
                "quantity"      : String(pass_quantity),
                "productUserId" : "",
                "SKU"           : (self.dict_get_selected_product_Details["SKU"] as! String),
                "productName"   : (self.dict_get_selected_product_Details["productName"] as! String),
                "price"         : String(pass_price),
                "amount"        : String(pass_special_price)
            ]
            
            var res = [[String: String]]()
            res.append(myDictionary)
            
            self.addInitialMutable.addObjects(from: res)
            
            
            
            // convert array into JSONSerialization
            let paramsArray = self.addInitialMutable
            let paramsJSON = JSON(paramsArray)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
            
            // print(self.lblTotalPrice.text as Any)
            
            parameters = [
                
                "action"            :   "order",
                "userId"            :   String(myString),
                "shippingAmount"    :   "\(self.dict_get_selected_product_Details["shippingAmount"]!)",
                "TotalAmount"       :   String(pass_special_price), // empty
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
                        
                        let alert = UIAlertController(title: "Alert!", message: "Successfully purchase",preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
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
    
    // MARK:- FETCH STRIPE TOKEN -
    @objc func fetchStripeToken() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
        
        let fullNameArr = cell.txtExpDate.text!.components(separatedBy: "/")
        
        let expMonth    = fullNameArr[0]
        let expYear = fullNameArr[1]
        
        let cardParams = STPCardParams()
        
        cardParams.number       = String(cell.txtCardNumber.text!)
        cardParams.expMonth     = UInt(expMonth)!
        cardParams.expYear      = UInt(expYear)!
        cardParams.cvc          = String(cell.txtCVV.text!)
        
        STPAPIClient.shared.createToken(withCard: cardParams) { token, error in
            guard let token = token else {
                // Handle the error
                // print(error as Any)
                // print(error?.localizedDescription as Any)
                ERProgressHud.sharedInstance.hide()
                
                let alert = UIAlertController(title: "Error", message: String(error!.localizedDescription), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            let tokenID = token.tokenId
            print(tokenID)
            
            self.update_payment_webservice(str_token_id: tokenID)
        }
        
    }
    
    @objc func update_payment_webservice(str_token_id:String) {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let urlString = "CHARGER_AMOUNT"
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            print(self.finalPrice as Any)
            
            // let strTotalAmount = Double(self.finalPrice)!*100
            let price_is:String!
            
            if self.finalPrice == "3.99" {
                price_is = "399"
            } else {
                price_is = "2999"
            }
            
            parameters = [
                "action"    : "chargeramount",
                "userId"    : String(myString),
                "amount"    : String(price_is),
                "tokenID"   : String(str_token_id)
            ]
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON as Any)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        // var strSuccessAlert : String!
                        // strSuccessAlert = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["transactionID"]as Any as? String
                            
                            // self.signUpViaFirebase(strEmail: strEmailFirebase)
                            self.update_membership_amount_in_local_db(str_subscription_id: strSuccess2)
                        }
                        else {
                            print("no")
                            
                        }
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    let alertController = UIAlertController(title: nil, message: "Server Issue", preferredStyle: .actionSheet)
                    
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
   
    @objc func update_membership_amount_in_local_db(str_subscription_id:String) {
        
        let urlString = "BASE_URL_CHAT_CAP"
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            parameters = [
                "action"            : "updatepayment",
                "userId"            : String(myString),
                "transactionID"     : String(str_subscription_id),
                "subscriptionId"    : String(self.memberShipPlan),
                "amount"            : String(self.finalPrice)
            ]
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON as Any)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                         var strSuccessAlert : String!
                         strSuccessAlert = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            
                            
                            ERProgressHud.sharedInstance.hide()
                            let alert = UIAlertController(title: "Success", message: String(strSuccessAlert), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                                print("User click Delete button")
                                
                                // self.getProfileLoginNewData()
                                
                                /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabbarControllerId") as? TabbarController
                                push!.selectedIndex = 3
                                self.navigationController?.pushViewController(push!, animated: true)*/
                                
                            }))
                            
                            self.present(alert, animated: true)
                            
                        }
                        else {
                            print("no")
                             ERProgressHud.sharedInstance.hide()
                            
                            // login via evs
                            // self.evsRegistrationWebservice(strEmail: strEmailFirebase, strName: strNameFirebase, strType: strSocialTypeFirebase, strPhoto: strSocialPicFirebase, strSocialId: strSocialIdFirebase, strFirebaseId: strSocialIdFirebase)
                            
                            // self.signUpViaFirebase(strEmail: strEmailFirebase)
                        }
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    let alertController = UIAlertController(title: nil, message: "Server Issue", preferredStyle: .actionSheet)
                    
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
    
    /*@objc func updatePaymentOnFirebaseXMPP(strSubscriptionId:String,strTransactionId:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let weekday = components.weekday
        
        let hourr = components.hour
        let minutee = components.minute
        
        let time_string = String(hourr!)+":"+String(minutee!)
        
        self.iAmTime = time_string
        
        let today_string = String(day!) + "-" + String(month!) + "-" + String(year!)
        
        self.iAmDate = today_string
        
        
        let wd = String(weekday!)
        
        // convert digits into weekday
        if String(wd) == "1" {
            self.weekdayName = "Sunday"
        }
        else if String(wd) == "2" {
            self.weekdayName = "Monday"
        }
        else if String(wd) == "3" {
            self.weekdayName = "Tuesday"
        }
        else if String(wd) == "4" {
            self.weekdayName = "Wednesday"
        }
        else if String(wd) == "5" {
            self.weekdayName = "Thursday"
        }
        else if String(wd) == "6" {
            self.weekdayName = "Friday"
        }
        else if String(wd) == "7" {
            self.weekdayName = "Saturday"
        }
        
        /*var iAmDate:String!
         var iAmTime:String!*/
        
        let someDate = Date()
        let myTimeStamp = someDate.timeIntervalSince1970
        // print(myTimeStamp as Any)
        // print(strLessonNumber as Any)
        
        let newPaymentId = String.randomNumberGenerate()
        // print(newRegistrationUniqueId as Any)
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let ref = Database.database().reference()
            ref.child("ChatCapUserSubscription")
                .child(Auth.auth().currentUser!.uid)
            // .child(String(newPaymentId))
            // ref.child("ChatCapUserSubscription")
            // .child("details")
                .childByAutoId()
            
                .updateChildValues(
                    ["PaymentIs" : String(self.finalPrice),
                     "PaymentLoginUserId"       : String(myString),
                     "PaymentLoginUserFBId"     : String(Auth.auth().currentUser!.uid),
                     "PaymentUniqueId"          : String(newPaymentId),
                     "PaymentSubscriptionId"    : String(strSubscriptionId),
                     "PaymentTransactionId"     : String(strTransactionId),
                     "PaymentCardNumber"        : String(cell.txtCardNumber.text!),
                     "PaymentCardCVV"           : String(cell.txtCVV.text!),
                     "PaymentCardEXPdate"       : (cell.txtExpDate.text!),
                     "PaymentDay"               : (self.weekdayName!),
                     "PaymentTime"              : (self.iAmTime!),
                     "PaymentTimeStamp"         : (myTimeStamp ),
                     "PaymentDate"              : (self.iAmDate!),
                     "PaymentValidTill"         : (self.strValidTill!),
                     "PaymentMessage"           : ("Pemium")
                    ]
                )
            
        }
        
        
        
        
        
        // ERProgressHud.sharedInstance.hide()
        
        // ERProgressHud.sharedInstance.hide()
        
        // self.navigationController?.view.makeToast(TOAST_SUCCESS_MESSAGE)
        
        
        
    }*/
    
    
    @objc func getProfileLoginNewData() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            parameters = [
                "action"                         : "profile",// "getseeting",
                "userId"                         : String(myString)
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
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    var strSuccessAlert : String!
                    strSuccessAlert = JSON["alertMessage"]as Any as? String
                    
                    if strSuccess == String("success") {
                        ERProgressHud.sharedInstance.hide()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabbarControllerId") as? TabbarController
                        push!.selectedIndex = 3
                        self.navigationController?.pushViewController(push!, animated: true)*/
                    }
                    else {
                        ERProgressHud.sharedInstance.hide()
                        
                        let alert = UIAlertController(title: "Alert", message: String(strSuccessAlert), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                ERProgressHud.sharedInstance.hide()
                break
            }
        }
        
    }
    
    @objc func rechargeMyMembershipAccount(strStripeTokenIs:String) {
        
        
        // ERProgressHud.sharedInstance.show(withTitle: "Please wait...")
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if self.memberShipPlan == "1" { // free
                
                parameters = [
                    "action"          : "updatepayment",
                    "userId"          : String(myString),
                    "transactionID"   : String(strStripeTokenIs),
                    "subscriptionId"  : String("1"),
                    "amount": String("0")
                    
                ]
                
            } else if self.memberShipPlan == "2" { // premium
                
                parameters = [
                    "action"            : "updatepayment",
                    "userId"            : String(myString),
                    "transactionID"     : String(strStripeTokenIs),
                    "subscriptionId"    : String("2"),
                    "amount"            : String(self.finalPrice),
                    
                ]
                
            } else if self.memberShipPlan == "3" { // exclusive
                
                parameters = [
                    "action"            : "updatepayment",
                    "userId"            : String(myString),
                    "transactionID"     : String(strStripeTokenIs),
                    "subscriptionId"    : String("3"),
                    "amount"            : String(self.finalPrice),
                    
                ]
                
            }
        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    var strSuccessAlert : String!
                    strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        /*if self.memberShipPlan == "1" {
                            
                            self.updatePaymentOnFirebaseXMPP(strSubscriptionId: String("1"), strTransactionId: String(strStripeTokenIs))
                            
                        } else if self.memberShipPlan == "2" {
                            
                            self.updatePaymentOnFirebaseXMPP(strSubscriptionId: String("2"), strTransactionId: String(strStripeTokenIs))
                            
                        } else {
                            
                            self.updatePaymentOnFirebaseXMPP(strSubscriptionId: String("3"), strTransactionId: String(strStripeTokenIs))
                            
                        }*/
                        
                    } else {
                        print("no")
                        
                        ERProgressHud.sharedInstance.hide()
                    }
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                
                ERProgressHud.sharedInstance.hide()
                
                let alertController = UIAlertController(title: nil, message: "Server Issue", preferredStyle: .actionSheet)
                
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
    
    // MARK:- PUSH -
    @objc func pushToDashbaord() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Driver" {
                
                // let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DDashbaordId") as? DDashbaord
                // self.navigationController?.pushViewController(settingsVCId!, animated: true)
            } else {
                
                // let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CDashboardId") as? CDashboard
                // self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
            
        }
    }
    
}


//MARK:- TABLE VIEW -
extension CSelectPaymetScreen: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CSelectPaymentScreenTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CSelectPaymentScreenTableCell
        //
        cell.backgroundColor = .white
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtCardNumber.delegate = self
        cell.txtExpDate.delegate = self
        cell.txtCVV.delegate = self
        
        cell.txtCardNumber.addTarget(self, action: #selector(CSelectPaymetScreen.textFieldDidChange(_:)), for: .editingChanged)
        cell.txtExpDate.addTarget(self, action: #selector(CSelectPaymetScreen.textFieldDidChange2(_:)), for: .editingChanged)
        
        
        
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
            
         self.lblCardNumberHeading.text! = cell.txtCardNumber.text!
    }
    
    @objc func textFieldDidChange2(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
            
         self.lblEXPDate.text! = cell.txtExpDate.text!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
        
        if textField == cell.txtCardNumber {
            
            let first2 = String(self.lblCardNumberHeading.text!.prefix(2))
            
            if first2.count == 2 {
                // print("yes")
                
                let first3 = String(self.lblCardNumberHeading.text!.prefix(2))
                // print(first3 as Any)
                
                if first3 == "34" { // amex
                    self.imgCardImage.image = UIImage(named: "amex")
                    self.strWhatCardIam = "amex"
                } else if first3 == "37" { // amex
                    self.imgCardImage.image = UIImage(named: "amex")
                    self.strWhatCardIam = "amex"
                } else if first3 == "51" { // master
                    self.imgCardImage.image = UIImage(named: "mastercard")
                    self.strWhatCardIam = "master"
                } else if first3 == "55" { // master
                    self.imgCardImage.image = UIImage(named: "mastercard")
                    self.strWhatCardIam = "master"
                }  else if first3 == "42" { // visa
                    self.imgCardImage.image = UIImage(named: "visa")
                    self.strWhatCardIam = "visa"
                } else if first3 == "65" { // discover
                    self.imgCardImage.image = UIImage(named: "discover")
                    self.strWhatCardIam = "discover"
                } else {
                    self.imgCardImage.image = UIImage(named: "ccCard")
                    self.strWhatCardIam = "none"
                }
                
            } else {
                // print("no")
                self.imgCardImage.image = UIImage(named: "ccCard")
            }
            
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                      return false
                  }
            
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            // print(self.strWhatCardIam as Any)
            if self.strWhatCardIam == "amex" {
                return count <= 15
            } else {
                return count <= 16
            }
            
            
        }
        
        if textField == cell.txtExpDate {
            if string == "" {
                return true
            }
            
            
            let currentText = textField.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            
            textField.text = updatedText
            let numberOfCharacters = updatedText.count
            
            if numberOfCharacters == 2 {
                textField.text?.append("/")
            }
            self.lblEXPDate.text! = cell.txtExpDate.text!
        }
        
        if textField == cell.txtCVV {
            
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                      return false
                  }
            
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            if self.strWhatCardIam == "amex" {
                
                return count <= 4
                
            } else {
                
                return count <= 3
                
            }
            
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
}

extension CSelectPaymetScreen: UITableViewDelegate {
    
}



extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
