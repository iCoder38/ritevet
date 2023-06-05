//
//  Login.swift
//  RiteVet
//
//  Created by Apple  on 26/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import IHProgressHUD
import RSLoadingView

// import RxSwift
// import RxCocoa

class Login: UIViewController,UITextFieldDelegate {

    let indicator = UIActivityIndicatorView()
    
    var myDeviceTokenIs:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SIGN IN"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var imgLogo:UIImageView!
    
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtPassword, placeHolder: "Password", cornerRadius: 20, color: .white)
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton!
    @IBOutlet weak var btnSignUp:UIButton! {
        didSet {
            btnSignUp.setTitle("Don’t have an account? Sign up", for: .normal)
            btnSignUp.titleLabel?.textAlignment = .center
        }
    }
    @IBOutlet weak var btnFB:UIButton!
    @IBOutlet weak var btnGooglePlus:UIButton!
    
    @IBOutlet weak var btn_forgot_password:UIButton!
    
    // MARK: - Variable -
    // let rxbag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.style = .large
        indicator.color = .orange
        indicator.center = self.view.center
        //self.view.addSubview(indicator)
        
        self.UIdesignOfLoginScreen()
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btn_forgot_password.addTarget(self, action: #selector(forgot_pasword_click_method), for: .touchUpInside)
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        /*
        // google call
        googleLogin()
        
        // facebook call
        facebookLogin()
        
        
        // social buttons
        btnFB.rx.tap.bind{ [weak self] _ in
            guard let strongSelf = self else {return}
            RRFBLogin.shared.fbLogin(viewController: strongSelf)
        }.disposed(by: rxbag)
        
        btnGooglePlus.rx.tap.bind{ [weak self] _ in
            guard let strongSelf = self else {return}
            RRGoogleLogin.shared.googleSignIn(viewController: strongSelf)
        }.disposed(by: rxbag)
        */
        
        
        //self.submitRequestServiceToServer()
        //self.login()
        
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        self.rememberMe()
        
    }
    
    @objc func forgot_pasword_click_method() {
        
        showInputDialog(title: "Forgot Password",
                        subtitle: "Please enter your registered E-Mail address.",
                        actionTitle: "Submit",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "registered email address",
                        inputKeyboardType: .default, actionHandler:
                            { (input:String?) in
            print("The new number is \(input ?? "")")
            
            self.forgot_password_wb(str_email_address: "\(input ?? "")")
        })
        
    }
    
    @objc func forgot_password_wb(str_email_address:String) {
        
        Utils.RiteVetIndicatorShow()
        let urlString = BASE_URL_KREASE
        var parameters:Dictionary<AnyHashable, Any>!
        
        
        
        parameters = [
            "action"    : "forgotpassword",
            "email"     : str_email_address
        ]
        
        
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
                    
                    if strSuccess == "success" {
                        // let ar : NSArray!
                        // ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        Utils.RiteVetIndicatorHide()
                        
                        var strSuccess : String!
                        strSuccess = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: "Success", message: strSuccess, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        Utils.RiteVetIndicatorHide()
                        
                        var strSuccess : String!
                        strSuccess = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: "Alert!", message: strSuccess, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
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
    
    @objc func rememberMe() {
        // MARK:- PUSH -
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            /*
             "role": Member,
             "longitude": ,
             "image": ,
             "deviceToken": ,
             "userId": 27,
             "device": iOS,
             "address": ,
             "contactNumber": 9876543456,
             "middleName": ,
             "lastName": ,
             "fullName": qwerty,
             "latitude": ,
             "email": qwerty@gmail.com,
             "country": ,
             "gender": Male,
             "firebaseId": ,
             "state": ,
             "zipCode": 110075,
             "dob": 27/01/2021
             */
            
            
            // if person["role"] as! String == "Member" {
                
                // self.performSegue(withIdentifier: "afterLogin", sender: self)
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
                self.navigationController?.pushViewController(push!, animated: false)
                
            // } else {
                
            // }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func submitRequestServiceToServer() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
    
    //MARK:-
    @objc func UIdesignOfLoginScreen() {
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: txtEmail, placeHolder: "Username", cornerRadius: 20, color: .white)
        
        
        /****** SIGN IN BUTTON *********/
        Utils.buttonDR(button: btnSignIn, text: "SIGN IN", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        btnSignIn.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        /****** SIGN UP BUTTON *********/
        btnSignUp.addTarget(self, action: #selector(pushToRegistration), for: .touchUpInside)
        
        /****** FACEBOOK *********/
            btnFB.backgroundColor = UIColor.init(red: 46.0/255.0, green: 79.0/255.0, blue: 183.0/255.0, alpha: 1)
            btnFB.layer.cornerRadius = 20
            btnFB.clipsToBounds = true
            // btnFB.setTitle("f", for: .normal)
            btnFB.setTitleColor(.white, for: .normal)
            
        /****** G+ *********/
            btnGooglePlus.backgroundColor = UIColor.init(red: 193.0/255.0, green: 47.0/255.0, blue: 38.0/255.0, alpha: 1)
            btnGooglePlus.layer.cornerRadius = 20
            btnGooglePlus.clipsToBounds = true
            // btnGooglePlus.setTitle("g+", for: .normal)
            btnGooglePlus.setTitleColor(.white, for: .normal)
           
    }
    
    @objc func pushToRegistration() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationId") as? Registration
        self.navigationController?.pushViewController(push!, animated: true)
    }
    @objc func pushToWelcome() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func login() {
        //self.pushFromLoginPage()
        
        indicator.startAnimating()
        self.disableService()
        Utils.RiteVetIndicatorShow()
        
            let urlString = BASE_URL_KREASE
            
        var parameters:Dictionary<AnyHashable, Any>!
        
        // Create UserDefaults
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "key_my_device_token") {
            self.myDeviceTokenIs = myString

        }
        else {
            self.myDeviceTokenIs = "111111111111111111111"
        }
        
        parameters = [
            "action"        :   "login",
            "email"         :   String(txtEmail.text!),
            "password"      :   String(txtPassword.text!),
            "device"      :   String("iOS"),
            "deviceToken"   :   String(self.myDeviceTokenIs),
        ]
           
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
                            
                            //var strSuccessAlert : String!
                            //strSuccessAlert = JSON["msg"]as Any as? String
                            
                    if strSuccess == "success" {
                        self.enableService()
                                
                        self.indicator.stopAnimating()
                                
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                                
                        self.pushFromLoginPage()
                                
                    }
                    else {
                        self.indicator.stopAnimating()
                        self.enableService()
                        Utils.RiteVetIndicatorHide()
                    }
                }
                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
                    self.indicator.stopAnimating()
                    self.enableService()
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
    
    @objc func pushFromLoginPage() {
        
        Utils.RiteVetIndicatorHide()
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    @objc func enableService() {
        self.txtEmail.isUserInteractionEnabled      = true
        self.txtPassword.isUserInteractionEnabled   = true
        self.btnFB.isUserInteractionEnabled         = true
        self.btnGooglePlus.isUserInteractionEnabled = true
        self.btnSignIn.isUserInteractionEnabled     = true
        self.btnSignUp.isUserInteractionEnabled     = true
    }
    
    @objc func disableService() {
        self.txtEmail.isUserInteractionEnabled      = false
        self.txtPassword.isUserInteractionEnabled   = false
        self.btnFB.isUserInteractionEnabled         = false
        self.btnGooglePlus.isUserInteractionEnabled = false
        self.btnSignIn.isUserInteractionEnabled     = false
        self.btnSignUp.isUserInteractionEnabled     = false
    }
    
    @objc func loginViaFB(strEmail:String,strType:String,strName:String,strSocialId:String,strProfileImage:String) {
          
        indicator.startAnimating()
        self.disableService()
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "key_my_device_token") {
            self.myDeviceTokenIs = myString

        }
        else {
            self.myDeviceTokenIs = "111111111111111111111"
        }
        
        parameters = [
            "action"        :   "socialLoginAction",
            "email"         :   String(strEmail),
            "socialId"      :   String(strSocialId),
            "fullName"      :   String(strName),
            "socialType"    :   String(strType),
            "device"        :   String("iOS"),
            "deviceToken"   :   String(self.myDeviceTokenIs),
            "image"         :   String(strProfileImage)
        ]
              
                
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
                               
                               //var strSuccessAlert : String!
                               //strSuccessAlert = JSON["msg"]as Any as? String
                               
                    if strSuccess == "success" {
                        self.enableService()
                                   
                        self.indicator.stopAnimating()
                                   
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                                   
                        self.pushFromLoginPage()
                                   
                    }
                    else {
                        self.indicator.stopAnimating()
                        self.enableService()
                        Utils.RiteVetIndicatorHide()
                    }
                }

            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                self.indicator.stopAnimating()
                self.enableService()
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

/*
// MARK: - Social Login -
extension Login {
    
    private func googleLogin() {
        RRGoogleLogin.shared.googleUserDetails.asObservable()
        .subscribe(onNext: { [weak self] (userDetails) in
            guard let strongSelf = self else {return}
            strongSelf.socialLogin(user: userDetails)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.showAlert(title: nil, message: error.localizedDescription)
        }).disposed(by: rxbag)
    }
    
    private func facebookLogin() {
        RRFBLogin.shared.fbUserDetails.asObservable()
        .subscribe(onNext: { [weak self] (userDetails) in
            guard let strongSelf = self else {return}
            strongSelf.socialLogin(user: userDetails)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.showAlert(title: nil, message: error.localizedDescription)
        }).disposed(by: rxbag)
    }
    
    fileprivate func socialLogin(user :SocialUserDetails) {
        // lblType.text = user.type.rawValue
        // lblEmail.text = user.email
        // lblName.text = user.name
        
        print(user.name as Any)
        print(user.type as Any)
        print(user.email as Any)
        print(user.userId as Any)
        print(user.profilePic as Any)
        print(type(of: user.profilePic))
        
        let url = URL(string: user.profilePic)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            // imgProfile.image = image
        }
        
        self.loginViaFB(strEmail: user.email, strType: user.type.rawValue, strName: user.name, strSocialId: user.userId, strProfileImage: user.profilePic)
    }
    
    func showAlert(title : String?, message : String?, handler: ((UIAlertController) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            handler?(alertController)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}*/
