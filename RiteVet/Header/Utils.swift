//
//  Utils.swift
//  KREASE
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import RSLoadingView

// 25,32,143
let BASE_URL_KREASE = "http://ritevet.com/services/index/"

let audio_call_collection_path = "mode/test/audio_call"
let video_call_collection_path = "mode/test/video_call"
let missed_call_collection_path = "mode/test/missed_call"

let merchant_id = "merchant.com.pay.ritevet"
let apple_pay_price = "9.99"

let NAVIGATION_BACKGROUND_COLOR = UIColor.init(red: 7.0/255.0, green: 33.0/255.0, blue: 98.0/255.0, alpha: 1)

let BUTTON_BACKGROUND_COLOR = UIColor.init(red: 242.0/255.0, green: 208.0/255.0, blue: 11.0/255.0, alpha: 1)

let BUTTON_BACKGROUND_COLOR_BLUE = UIColor.init(red: 7.0/255.0, green: 33.0/255.0, blue: 98.0/255.0, alpha: 1)

let BUTTON_TEXT_COLOR = UIColor.init(red: 220.0/255.0, green: 255.0/255.0, blue: 9.0/255.0, alpha: 1)

let PLACEHOLDER_EMAIL       = "Email address"
let PLACEHOLDER_PASSWORD    = "Password"
let PLACEHOLDER_NAME        = "Name"
let PLACEHOLDER_PHONE       = "Phone"
let PLACEHOLDER_ADDRESS     = "Address"

// SERVER ISSUE
let SERVER_ISSUE_TITLE          = "Server Issue."
let SERVER_ISSUE_MESSAGE_ONE    = "Server Not Responding."
let SERVER_ISSUE_MESSAGE_TWO    = "Please contact your Server Admin."

let AGORA_KEY_ID = "bbe938fe04a746fd9019971106fa51ff"


//let FONT_NAME_12 = UIFont.

class Utils: NSObject {

    // text field
    class func textFieldDR(text:UITextField,placeHolder:String,cornerRadius:Int,color:UIColor) {
        text.placeholder = placeHolder
        text.layer.cornerRadius = CGFloat(cornerRadius)
        text.clipsToBounds = true
        text.backgroundColor = color
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15 , height: text.frame.height))
        text.leftView = paddingView
        text.leftViewMode = UITextField.ViewMode.always
    }
    
    // button
    class func buttonDR(button:UIButton,text:String,backgroundColor:UIColor,textColor:UIColor,cornerRadius:Int) {
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.layer.cornerRadius = CGFloat(cornerRadius)
        button.clipsToBounds = true
        button.backgroundColor = backgroundColor
    }
    
    class func indicator(indicator:UIActivityIndicatorView) {
        indicator.style = .large
        indicator.color = .orange
        
    }
    
    class func RiteVetIndicatorShow() {
        let loadingView = RSLoadingView()
        loadingView.shouldTapToDismiss = false
        loadingView.variantKey = "inAndOut"
        loadingView.speedFactor = 2.0
        loadingView.lifeSpanFactor = 2.0
        loadingView.mainColor = UIColor.yellow
        loadingView.showOnKeyWindow()
    }
    
    class func RiteVetIndicatorHide() {
        let loadingView = RSLoadingView()
        loadingView.mainColor = UIColor.clear
        loadingView.showOnKeyWindow()
        loadingView.hide()
    }
    
    class func convert_server_date_time_from_UTC(string : String,tz:String) -> String {
        let separate_date = string
        // let off_set_value = (item!["timeZone"])
        
        
        print(string as Any)
        print(tz as Any)
        
        let gmt_date = string+" "+String(tz)
        print(gmt_date as Any)
        
        let separate_time = String(gmt_date).components(separatedBy: " ")
        print(separate_time as Any)
        
        let join_1 = String(separate_time[0])
        let join_2 = String(separate_time[1])
        let join_3 = String(separate_time[2])
        
        let join_2_sub = String(join_2.prefix(5))
        
        let join_all_string = String(join_1)+" "+String(join_2_sub)+" "+String(join_3)
        let timeFormatterGet = DateFormatter()
        timeFormatterGet.dateFormat = "yyyy-MM-dd HH:mm ZZZZZ"
        timeFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        
        let timeFormatterPrint = DateFormatter()
        timeFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm"
        print(TimeZone.current.abbreviation()!)
        timeFormatterPrint.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
        
        var return_value:String!
        
        if let date = timeFormatterGet.date(from: String(join_all_string)) {
            print(timeFormatterPrint.string(from: date))
            return_value = "\(timeFormatterPrint.string(from: date))"
        } else {
            print("There was an error decoding the string")
            return_value = ""
        }
        return return_value
    }
}



extension String {

    static func createChatUniqueId(length: Int = 12) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }

}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension UIViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
}

@objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
    }

}
}
