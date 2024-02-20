//
//  AddCreditCardPayment.swift
//  RiteVet
//
//  Created by Apple  on 26/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import CRNotifications

class AddCreditCardPayment: UIViewController,UITextFieldDelegate {

    var getDictValueOfPetAndParents:Dictionary<AnyHashable, Any>!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ADD CREDIT CARD INFO"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var txtCreditCardNumber:UITextField!
    @IBOutlet weak var txtExpiryDate:UITextField!
    @IBOutlet weak var txtCVV:UITextField!
    @IBOutlet weak var txtNameOnCard:UITextField!
    @IBOutlet weak var txtAddress:UITextField!
    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtZipCode:UITextField!
    
    @IBOutlet weak var btnFinish:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.textFieldUI()
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        //print(getDictValueOfPetAndParents as Any)
        
        txtCreditCardNumber.delegate = self
        txtExpiryDate.delegate = self
        
        self.txtCreditCardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        //self.txtExpiryDate.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
       }
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
       @objc func backClickMethod() {
           self.navigationController?.popViewController(animated: true)
       }
    
    @objc func didChangeText(textField:UITextField) {
        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()

        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""

        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCreditCardNumber {
            let newLength = (textField.text ?? "").count + string.count - range.length
            if(textField == txtCreditCardNumber) {
                return newLength <= 19
            }
        }
        else if textField == txtExpiryDate {
            if range.length > 0 {
              return true
            }
            if string == "" {
              return false
            }
            if range.location > 4 {
              return false
            }
            var originalText = textField.text
            let replacementText = string.replacingOccurrences(of: " ", with: "")

            //Verify entered text is a numeric value
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
              return false
            }

            //Put / after 2 digit
            if range.location == 2 {
              originalText?.append("/")
              textField.text = originalText
            }
        }
        
         
         return true
    }
    
    //MARK:- TEXT FIELD UI
    @objc func textFieldUI() {
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: txtCreditCardNumber, placeHolder: "Credit Card Number", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtExpiryDate, placeHolder: "Expiry MM / YY", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtCVV, placeHolder: "CVV", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtNameOnCard, placeHolder: "Name on Card", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtAddress, placeHolder: "Address", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtCity, placeHolder: "City", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtState, placeHolder: "State", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtZipCode, placeHolder: "Zipcode", cornerRadius: 20, color: .white)
        
        /****** SIGN IN BUTTON *********/
        Utils.buttonDR(button: btnFinish, text: "FINISH", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        btnFinish.addTarget(self, action: #selector(pushToAddBankInfo), for: .touchUpInside)
    }
    
    @objc func pushToAddBankInfo() {
        
        if txtCreditCardNumber.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "Credit Card Number")
        }
        else if txtCreditCardNumber.text!.count < 19 {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please enter Valid Credit Card Number", dismissDelay: 1.5, completion:{})
        }
        else
        if txtExpiryDate.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "Expiry Date")
        }
        else
        if txtCVV.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "CVV")
        }
        else
        if txtNameOnCard.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "Name on Card")
        }
        else
        if txtAddress.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "Address")
        }
        else
        if txtCity.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "City")
        }
        else
        if txtState.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "State")
        }
        else
        if txtZipCode.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "Zipcode")
        }
        else
        {
        let creditCardDict:[String:String] = [
                                    "creditcardnumber":String(txtCreditCardNumber.text!),
                                        "expirydate":String(txtExpiryDate.text!),
                                        "cvv":String(txtCVV.text!),
                                        "nameoncard":String(txtNameOnCard.text!),
                                        "address":String(txtAddress.text!),
                                        "city":String(txtCity.text!),
                                        "state":String(txtState.text!),
                                        "zipcode":String(txtZipCode.text!)
        ]
        
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddBankInfoId") as? AddBankInfo
        push!.getDictValueOfFirstPage       = getDictValueOfPetAndParents
        // push!.getDictValueOfCreditCardInfo  = creditCardDict
         self.navigationController?.pushViewController(push!, animated: true)
    }
    }
    
    @objc func fieldShouldNotBeEmpty(textFieldName:String) {
        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:textFieldName+" Should not be empty", dismissDelay: 1.5, completion:{})
    }
    
}
