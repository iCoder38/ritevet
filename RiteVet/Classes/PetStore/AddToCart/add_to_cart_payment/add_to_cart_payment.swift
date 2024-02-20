//
//  add_to_cart_payment.swift
//  RiteVet
//
//  Created by Dishant Rajput on 04/08/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import SwiftyJSON
import FirebaseAuth
import Firebase

// MARK:- LOCATION -
import CoreLocation

class add_to_cart_payment: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

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
    
    // var addInitialMutable:NSMutableArray = []
    var fullArrayProductDetails:NSArray! // NSMutableArray = []
    
    var cardTypeIs:String!
    
    var iAmDate:String!
    var iAmTime:String!
    
    var subscriptionForTotalNumberOfDaysGet:String!
    
    var strValidTill:String!
    
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
    
    @IBOutlet weak var lblCardNumberHeading:UILabel!
    @IBOutlet weak var lblEXPDate:UILabel!
    
    @IBOutlet weak var lblPayableAmount:UILabel!
    
    @IBOutlet weak var viewCard:UIView! {
        didSet {
            viewCard.backgroundColor = NAVIGATION_BACKGROUND_COLOR // UIColor.init(red: 34.0/255.0, green: 72.0/255.0, blue: 104.0/255.0, alpha: 1)
            viewCard.layer.cornerRadius = 6
            viewCard.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
        }
    }
    
    @IBOutlet weak var imgCardImage:UIImageView!
    
    @IBOutlet weak var btnmakePayment:UIButton! {
        didSet {
            btnmakePayment.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            btnmakePayment.setTitle("PAY NOW", for: .normal)
            btnmakePayment.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
            // btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    // var finalPrice:String!
    
    var get_final_total_price:String!
    var get_final_shipping_amount:String!
    var arr_get_orders_data:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
         print(self.arr_get_orders_data as Any)
        print(self.get_final_shipping_amount as Any)
        print(self.get_final_total_price as Any)
        
        // MARK:- DISMISS KEYBOARD WHEN CLICK OUTSIDE -
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CSelectPaymetScreen.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.btnBack.addTarget(self, action: #selector(sideBarMenuClick), for: .touchUpInside)
        
        self.btnmakePayment.addTarget(self, action: #selector(firstCheckValidation), for: .touchUpInside)
        
        self.lblPayableAmount.text = "You have to pay $"+String(self.get_final_total_price)
        
        print(self.memberShipPlan as Any)
        if self.memberShipPlan == "Membership : PREMIUM" {
            self.memberShipPlan = "2"
        } else {
            self.memberShipPlan = "3"
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.iAmHereForLocationPermission()
        
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
       
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func sideBarMenuClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func firstCheckValidation() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_to_cart_payment_table_cell
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
            
            self.fetchStripeToken()
            
            
        }
    }
    
    // MARK:- FETCH STRIPE TOKEN -
    @objc func fetchStripeToken() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_to_cart_payment_table_cell
        
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
            
            self.dummy_send_data_wb(stripe_token: tokenID)
            // self.update_payment_webservice(str_token_id: tokenID)
        }
        
    }
    
    @objc func dummy_send_data_wb(stripe_token:String) {
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
            
            // convert array into JSONSerialization
            let paramsArray = self.arr_get_orders_data
            let paramsJSON = JSON(paramsArray)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
            
            // print(self.lblTotalPrice.text as Any)
            
            parameters = [
                
                "action"            :   "order",
                "userId"            :   String(myString),
                "shippingAmount"    :   String(self.get_final_shipping_amount),
                "TotalAmount"       :   String(self.get_final_total_price),
                "shippingAddress"   :   (person["address"] as! String),
                "ShippingCity"      :   (person["city"] as! String),
                "ShippingState"     :   (person["stateName"] as! String),
                "shippingZipcode"   :   (person["zipCode"] as! String),
                "ShippingMobile"    :   (person["contactNumber"] as! String),
                "productList"       :   String(paramsString),
                "shippingName"      :  (person["fullName"] as! String)+" "+(person["lastName"] as! String),
                "transactionId"     : String(stripe_token)
                
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
                        ERProgressHud.sharedInstance.hide()
                        
                        let alert = UIAlertController(title: "Success", message: strSuccessAlert2,preferredStyle: .alert)

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
                        ERProgressHud.sharedInstance.hide()
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
    
}

//MARK:- TABLE VIEW -
extension add_to_cart_payment: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:add_to_cart_payment_table_cell = tableView.dequeueReusableCell(withIdentifier: "add_to_cart_payment_table_cell") as! add_to_cart_payment_table_cell
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_to_cart_payment_table_cell
            
         self.lblCardNumberHeading.text! = cell.txtCardNumber.text!
    }
    
    @objc func textFieldDidChange2(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_to_cart_payment_table_cell
            
         self.lblEXPDate.text! = cell.txtExpDate.text!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_to_cart_payment_table_cell
        
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

extension add_to_cart_payment: UITableViewDelegate {
    
}

 

class add_to_cart_payment_table_cell: UITableViewCell {

    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewBG.layer.shadowOpacity = 1.0
            viewBG.layer.shadowRadius = 15.0
            viewBG.layer.masksToBounds = false
            viewBG.layer.cornerRadius = 15
            viewBG.backgroundColor = .white
        }
    }
    @IBOutlet weak var txtCardNumber:UITextField! {
        didSet {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: txtCardNumber.frame.height - 1, width: txtCardNumber.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.systemGray2.cgColor
            txtCardNumber.borderStyle = UITextField.BorderStyle.none
            txtCardNumber.layer.addSublayer(bottomLine)
            txtCardNumber.textAlignment = .center
            txtCardNumber.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtExpDate:UITextField! {
        didSet {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: txtExpDate.frame.height - 1, width: txtExpDate.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.systemGray2.cgColor
            txtExpDate.borderStyle = UITextField.BorderStyle.none
            txtExpDate.layer.addSublayer(bottomLine)
            txtExpDate.textAlignment = .center
            txtExpDate.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtCVV:UITextField! {
        didSet {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: txtCVV.frame.height - 1, width: txtCVV.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.systemGray2.cgColor
            txtCVV.borderStyle = UITextField.BorderStyle.none
            txtCVV.layer.addSublayer(bottomLine)
            txtCVV.textAlignment = .center
            txtCVV.keyboardType = .numberPad
            txtCVV.isSecureTextEntry = true
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
