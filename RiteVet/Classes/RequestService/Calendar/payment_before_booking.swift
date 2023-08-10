//
//  payment_before_booking.swift
//  RiteVet
//
//  Created by Dishant Rajput on 26/05/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class payment_before_booking: UIViewController ,UITextFieldDelegate {

    var str_instant_payment:String!
    
//    "action"    : "addbooking",
//    "userId"    : String(myString),
//    "vendorId"   : String(strGetVendorIdForCalendar),
//    "servicelist" : String(self.strSaveAll),
//    "bookingDate" : String(dateLabel.text!),
//    "slotTime" : String((btnTime.titleLabel?.text!)!),
//    "typeofbusinessId" : String(myString22),
//    "UTYPE" : String(getUtypeForCalendar)
    
    var str_get_business_type_for_payment:String!
    
    var dictShowFullDetails:NSDictionary!
    
    var strGetPrice:String!
    var strGetCountryName:String!
    var strServiceList:String!
    var strVendorId:String!
    var strBookingDate:String!
    var strSlotTime:String!
    var strTypeOfBusiness:String!
    var strUType:String!
    var strGetAmericanBoardCertificate:String!
    
    @IBOutlet weak var txtCardNumber:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtCardNumber, placeHolder: "Card Number", cornerRadius: 20, color: .white)
            txtCardNumber.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtExpDate:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtExpDate, placeHolder: "12/2025", cornerRadius: 20, color: .white)
            txtExpDate.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtExpYear:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtExpYear, placeHolder: "Exp Year", cornerRadius: 20, color: .white)
            txtExpYear.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtCVV:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtCVV, placeHolder: "CVV", cornerRadius: 20, color: .white)
            txtCVV.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var tct_card_name:UITextField! {
        didSet {
            Utils.textFieldDR(text: tct_card_name, placeHolder: "Card holder name", cornerRadius: 20, color: .white)
        }
    }
    
    @IBOutlet weak var viewNavigation:UIView! {
           didSet {
               viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
           }
       }
       @IBOutlet weak var btnBack:UIButton!
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "PAYMENT"
               lblNavigationTitle.textColor = .white
           }
       }
    
    var strWhatCardIam:String!
    
    @IBOutlet weak var btn_done:UIButton! {
        didSet {
            btn_done.setTitle("Pay", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        print(str_get_business_type_for_payment as Any)
        
        // print(strUType)
        
        self.txtCVV.delegate = self
//        self.txtExpYear.delegate = self
        self.txtExpDate.delegate = self
        self.txtCardNumber.delegate = self
        // self.tct_card_name.delegate = self
        
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btn_done.addTarget(self, action: #selector(generate_stripe_token), for: .touchUpInside)
        
        
        self.manage_price()
    }

    
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func manage_price() {
        
        var strCountryNameAndPrice:String!
        
        if (self.str_get_business_type_for_payment == "2") {
        
            if (self.strGetCountryName == "United States") {
                strCountryNameAndPrice = "195"
            } else {
                strCountryNameAndPrice = "25"
            }
            
        } else if (self.str_get_business_type_for_payment == "3") {

            if (self.strGetAmericanBoardCertificate) == "" {
                
                if (self.strGetCountryName == "United States") {
                    strCountryNameAndPrice = "55"
                } else {
                    strCountryNameAndPrice = "20"
                }
                
            } else if (self.strGetAmericanBoardCertificate) == "0" {
                
                if (self.strGetCountryName == "United States") {
                    strCountryNameAndPrice = "55"
                } else {
                    strCountryNameAndPrice = "20"
                }
                
            } else {
                
                strCountryNameAndPrice = "75"
            }
            
        } else {
            strCountryNameAndPrice = "0"
        }
        
        self.btn_done.setTitle("Pay ( $"+strCountryNameAndPrice+" )", for: .normal)
        self.show_alert(price:strCountryNameAndPrice)
    }
    
    @objc func show_alert(price:String) {
        
        // print(self.dictShowFullDetails as Any)
        
        let name = String(self.dictShowFullDetails["VBusinessName"] as! String)
        let address = String(self.dictShowFullDetails["VBusinessAddress"] as! String)
        let country = String(self.dictShowFullDetails["Country"] as! String)
        
        let defaults = UserDefaults.standard
        if let myString22 = defaults.string(forKey: "selectedBusinessIdIs") {
            print(myString22)
            
            if (myString22 == "2") {
                
                let alert = UIAlertController(title: "Details", message: "You have selected veterinarian ' \(name) ' from  ' \(address) ' '\(country) ' and you will be charge ' $\(price) ', and you will get full refund if you canceled in 48 hours or less from the time of their appointment", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Details", message: "You have selected veterinarian ' \(name) ' from  ' \(address) ' '\(country) ' and you will be charge ' $\(price) ', and you will get full refund if you canceled in 2 hours or less from the time of their appointment", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtCardNumber {
           
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
        
        if textField == self.txtExpDate {
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
//            self.lblEXPDate.text! = self.txtExpDate.text!
        }
        
        if textField == self.txtCVV {
            
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            /*if self.strWhatCardIam == "amex" {
                
                return count <= 4
                
            } else {
               */
            return count <= 3
                
//            }
            
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    @objc func generate_stripe_token() {
        
         
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
        let fullNameArr = self.txtExpDate.text!.components(separatedBy: "/")
            
        let expMonth    = fullNameArr[0]
        let expYear = fullNameArr[1]
            
            // print(expMonth as Any)
            // print(expYear as Any)
            
        let cardParams = STPCardParams()
            
        cardParams.number       = String(self.txtCardNumber.text!)
        cardParams.expMonth     = UInt(expMonth)!
        cardParams.expYear      = UInt(expYear)!
        cardParams.cvc          = String(self.txtCVV.text!)
            
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
                
                self.add_booking_wb(stripe_token: tokenID)
                
            }
  
    }
    
    @objc func add_booking_wb(stripe_token:String) {
        
        //        var strServiceList:String!
        //        var :String!
        //        var :String!
        //        var :String!
        //        var :String!
        //        var :String!
        
        //        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // print(self.strBookingDate)
            
            var strDate :String!
            
            if (self.str_instant_payment == "yes_audio") {
                strDate = "yyyy-MM-dd"
            } else if (self.str_instant_payment == "yes_video") {
                strDate = "yyyy-MM-dd"
            } else {
                strDate = "dd-MMM-yyyy"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = String(strDate)
            let date = dateFormatter.date(from: String(self.strBookingDate))
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let resultString = dateFormatter.string(from: date!)
            print(resultString)
            
            var strCountryNameAndPrice:String!
            
            if (self.str_get_business_type_for_payment == "2") {
                
                if (self.strGetCountryName == "United States") {
                    strCountryNameAndPrice = "195"
                } else {
                    strCountryNameAndPrice = "25"
                }
                
            } else if (self.str_get_business_type_for_payment == "3") {
                
                
                if (self.strGetAmericanBoardCertificate) == "" {
                    
                    if (self.strGetCountryName == "United States") {
                        strCountryNameAndPrice = "55"
                    } else {
                        strCountryNameAndPrice = "20"
                    }
                    
                } else if (self.strGetAmericanBoardCertificate) == "0" {
                    
                    if (self.strGetCountryName == "United States") {
                        strCountryNameAndPrice = "55"
                    } else {
                        strCountryNameAndPrice = "20"
                    }
                    
                } else {
                    
                    strCountryNameAndPrice = "75"
                }
                
            } else {
                strCountryNameAndPrice = "0"
            }
            
            
            parameters = [
                "action"    : "addbooking",
                "userId"    : String(myString),
                "vendorId"   : String(self.strVendorId),
                "typeOfServices" : String(self.strServiceList),
                "bookingDate" : String(resultString),
                "slotTime" : String(self.strSlotTime),
                "typeofbusinessId" : String(self.strTypeOfBusiness),
                "UTYPE" : String(self.strUType),
                "transactionId" : String(stripe_token),
                "payment_mode"  : "Card",
                "amount"    : String(strCountryNameAndPrice),
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
                    
                    if strSuccess == "Success" {
                        ERProgressHud.sharedInstance.hide()
                        
                        //var strGetBookingDate:String!
                        //var strGetBookingTime:String!
                        
                        if (self.str_instant_payment == "yes_audio") {
                            
                            self.navigationController?.popViewController(animated: true)
                            UserDefaults.standard.set("yes_audio", forKey: "key_instant_calling")
                            
                        } else if (self.str_instant_payment == "yes_video") {
                            
                            self.navigationController?.popViewController(animated: true)
                            UserDefaults.standard.set("yes_video", forKey: "key_instant_calling")
                            
                        } else {
                        
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfirmAppointmentId") as? ConfirmAppointment
                            push!.strGetBookingDate = String(self.strBookingDate)
                            push!.strGetBookingTime = String(self.strSlotTime)
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        }
                        
                        
                    }
                    else {
                        ERProgressHud.sharedInstance.hide()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                ERProgressHud.sharedInstance.hide()
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
