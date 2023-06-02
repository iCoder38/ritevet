//
//  RequestServiceDetails.swift
//  RiteVet
//
//  Created by evs_SSD on 1/6/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RequestServiceDetails: UIViewController {

    var str_business_type_is:String!
    
    var str_set_price_or_not:String!
    
    let cellReuseIdentifier = "requestServiceDetailsTableCell"
    
    var getDictRequestServiceHome:NSDictionary!
    
    var arrSetDetailsAndService:Array<Any>!
    
    var getUtypeInDetailsPage:String!
    
    
    
    var dict: Dictionary<AnyHashable, Any> = [:]
    
    
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DETAILS"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    @IBOutlet weak var btnAddress:UIButton!
    
    @IBOutlet weak var imgStarOne:UIImageView!
    @IBOutlet weak var imgStarTwo:UIImageView!
    @IBOutlet weak var imgStarThree:UIImageView!
    @IBOutlet weak var imgStarFour:UIImageView!
    @IBOutlet weak var imgStarFive:UIImageView!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 60
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderWidth = 5.0
            imgProfile.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var btnService:UIButton! // 0 205 108
    {
        didSet {
            btnService.layer.cornerRadius = 25
            btnService.clipsToBounds = true
            btnService.backgroundColor = UIColor.init(red: 0.0/255.0, green: 205.0/255.0, blue: 108.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnReview:UIButton! // 250 206 70
    {
        didSet {
            btnReview.layer.cornerRadius = 25
            btnReview.clipsToBounds = true
            btnReview.backgroundColor = UIColor.init(red: 250.0/255.0, green: 206.0/255.0, blue: 70.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnDetailsDown:UIButton! {
        didSet {
            btnDetailsDown.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnServiceDown:UIButton! {
        didSet {
            btnServiceDown.setTitle("Please wait...", for: .normal)
            btnServiceDown.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    var strDetailsDownSet:String!
    var strServiceDownSet:String!
    
    var strSaveFullValueOfSpecializationInOneString:String!
    var strSaveFullValueOfServiceInOneString:String!
    
    var arrListOfServices:Array<Any>!
    
    @IBOutlet weak var btnBookAnAppointment:UIButton! {
        didSet {
            btnBookAnAppointment.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnChatShow:UIButton! {
        didSet {
            btnChatShow.setImage(UIImage(systemName: "message.fill"), for: .normal)
            btnChatShow.tintColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnAudioShow:UIButton! {
        didSet {
            btnAudioShow.setImage(UIImage(systemName: "phone.fill"), for: .normal)
            btnAudioShow.tintColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnVideoShow:UIButton! {
        didSet {
            btnVideoShow.setImage(UIImage(systemName: "video.fill"), for: .normal)
            btnVideoShow.tintColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lbl_busy_status:UILabel! {
        didSet {
            lbl_busy_status.text = "please wait..."
            lbl_busy_status.textColor = .white
        }
    }
    
    @IBOutlet weak var view_busy:UIView! {
        didSet {
            view_busy.isHidden = true
            view_busy.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_busy.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_busy.layer.shadowOpacity = 1.0
            view_busy.layer.shadowRadius = 15.0
            view_busy.layer.masksToBounds = false
            view_busy.layer.cornerRadius = 15
            view_busy.backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        //self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.view.backgroundColor = .white
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btnServiceDown.isUserInteractionEnabled = false
        btnDetailsDown.addTarget(self, action: #selector(detailsDownClickMethod), for: .touchUpInside)
        btnServiceDown.addTarget(self, action: #selector(serviceDownbackClickMethod), for: .touchUpInside)
        
        self.btnBookAnAppointment.isUserInteractionEnabled = false
        // print(getUtypeInDetailsPage as Any)
        print(str_business_type_is as Any)
        /*
         Optional({
             VAstate = UP;
             VBSuite = "New way";
             VBusinessAddress = "Sector- 18, B- block";
             VBusinessName = "DOC Vet";
             VEmail = "purnima.pandey@evirtualservices.com";
             VFirstName = Vet;
             VLastName = New;
             VMiddleName = "";
             VPhone = 0931323334;
             VZipcode = 201011;
             Vcity = Noida;
             averagerating = 0;
             ownPicture = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/users/15771699764t.jpg";
             typeOfSpecilizationList =     (
                         {
                     id = 1;
                     name = Behavior;
                 },
                         {
                     id = 2;
                     name = Neurology;
                 },
                         {
                     id = 4;
                     name = Radiology;
                 }
             );
             userId = 95;
             userInformationId = 21;
         })
         (lldb)
         */
        
        
        strDetailsDownSet = "0"
        strSaveFullValueOfSpecializationInOneString = "0"
        strSaveFullValueOfServiceInOneString = "0"
        
        btnBookAnAppointment.addTarget(self, action: #selector(bookAnAppoitmentClickMethod), for: .touchUpInside)
        
        
        self.requestServiceData()
        
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
    
    @objc func detailsDownClickMethod() {
        strDetailsDownSet = "0"
        strServiceDownSet = "0"
        self.tbleView.reloadData()
    }
    @objc func serviceDownbackClickMethod() {
        strDetailsDownSet = "1"
        strServiceDownSet = "1"
        self.tbleView.reloadData()
    }
    
    
    
    
    //MARK:- REQUEST SERVICE DETAILS PAGE -
    @objc func requestServiceData() {
        imgProfile.sd_setImage(with: URL(string: (getDictRequestServiceHome!["ownPicture"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
        
        lblName.text = (getDictRequestServiceHome!["VBusinessName"] as! String)
        lblAddress.text = (getDictRequestServiceHome!["VBusinessAddress"] as! String)
        lblAddress.isHidden = true
        
        // VAstate = UP;VBusinessAddress = "Sector- 18, B- block";Vcity = Noida;
        btnAddress.setTitle((getDictRequestServiceHome!["Vcity"] as! String)+" "+(getDictRequestServiceHome!["VAstate"] as! String)+" "+(getDictRequestServiceHome!["VBusinessAddress"] as! String), for: .normal)
        btnAddress.setTitleColor(.white, for: .normal)
        
        self.requestServiceDetailsWB()
        
    }
    
    @objc func requestServiceDetailsWB() {
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //self.disableService()
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"                : "requestservicedetails",
            "userInformationId"     : (getDictRequestServiceHome!["userInformationId"] as! Int)
        ]
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
        { [self]
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    /*
                     {
                     data =     {
                     TotalReview = 3;
                     VAstate = UP;
                     VBSuite = "New way";
                     VBusinessAddress = "Sector- 18, B- block";
                     VBusinessName = "DOC Vet";
                     VEmail = "purnima.pandey@evirtualservices.com";
                     VFirstName = Vet;
                     VLastName = New;
                     VMiddleName = "";
                     VPhone = 0931323334;
                     VZipcode = 201011;
                     Vcity = Noida;
                     averagerating = 0;
                     dayendarray = "Sat,Sun";
                     ownPicture = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/users/15771699764t.jpg";
                     typeOfServiceList =         (
                     {
                     id = 1;
                     name = "General / Internal Medicine";
                     },
                     {
                     id = 2;
                     name = Wellness;
                     },
                     {
                     id = 3;
                     name = Dental;
                     },
                     {
                     id = 4;
                     name = Imaging;
                     },
                     {
                     id = 5;
                     name = Boarding;
                     },
                     {
                     id = 6;
                     name = "Diagnostic Lab";
                     }
                     );
                     typeOfSpecilizationList =         (
                     {
                     id = 1;
                     name = Behavior;
                     },
                     {
                     id = 2;
                     name = Neurology;
                     },
                     {
                     id = 4;
                     name = Radiology;
                     }
                     );
                     userId = 95;
                     userInformationId = 21;
                     };
                     status = success;
                     }
                     
                     */
                    
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "success" {
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        
                        
                        self.dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        print(dict as Any)
                        
                        self.view_busy.isHidden = false
                        
                        if (self.dict["currentAvailable"] as! String) == "No" {
                            
                            self.view_busy.backgroundColor = .systemRed
                            self.lbl_busy_status.text = "Unavailaible"
                            
                        } else {
                            
                            self.view_busy.backgroundColor = .systemGreen
                            self.lbl_busy_status.text = "Availaible"
                            
                        }
                        
                        
                        var ar : NSArray!
                        ar = (dict["typeOfSpecilizationList"] as! Array<Any>) as NSArray
                        
                        var itemCount:Int!
                        var newString1 = ""
                        var ss:String!
                        
                        //print(ar as Any)
                        //print(ar.count as Any)
                        
                        if ar.count == 0 {
                            
                        }
                        else {
                            
                            itemCount = ar.count-1
                            
                            for i in 0 ... itemCount {
                                
                                let item = ar[i] as? [String:Any]
                                ss = (item!["name"] as! String)
                                newString1 += "\(ss!)+"
                                
                            }
                            
                        }
                        
                        self.strSaveFullValueOfSpecializationInOneString = newString1
                        
                        //var strDetailsDownSet:String!
                        //var strServiceDownSet:String!
                        
                        //self.strSaveFullValueOfSpecializationInOneString = "1"
                        //self.arrSetDetailsAndService = (ar as! Array<Any>)
                        
                        
                        // services
                        
                        // save service for service button
                        var ar12 : NSArray!
                        ar12 = (dict["typeOfServiceList"] as! Array<Any>) as NSArray
                        self.arrListOfServices = (ar12 as! Array<Any>)
                        //print(self.arrListOfServices as Any)
                        
                        // details button
                        var arServices : NSArray!
                        arServices = (dict["typeOfServiceList"] as! Array<Any>) as NSArray
                        
                        var itemCountarServices:Int!
                        var newString1arServices = ""
                        var ssarServices:String!
                        
                        itemCountarServices = arServices.count-1
                        
                        for i in 0 ... itemCountarServices {
                            
                            let itemarServices = arServices[i] as? [String:Any]
                            ssarServices = (itemarServices!["name"] as! String)
                            newString1arServices += "\(ssarServices!)+"
                            
                        }
                        
                        self.strSaveFullValueOfServiceInOneString = newString1arServices
                        
                        //self.strDetailsDownSet = "1"
                        //self.strServiceDownSet = "1"
                        
                        self.btnServiceDown.isUserInteractionEnabled = true
                        self.btnServiceDown.setTitle("Services", for: .normal)
                        // typeOfServiceList
                        self.btnService.setTitle(String(arServices.count), for: .normal)
                        self.btnBookAnAppointment.isUserInteractionEnabled = true
                        
                        let livingArea2 = dict["TotalReview"] as? Int ?? 0
                        self.btnReview.setTitle(String(livingArea2), for: .normal)
                        
                        
                        /*
                         AudioChat = 1;
                         MessageChat = 2;
                         videoChat = 2;
                         */
                        
                        
                        if "\(dict["MessageChat"] as! Int)" == "1" {
                            // no chat
                            self.btnChatShow.tintColor = .lightGray
                            self.btnChatShow.isUserInteractionEnabled = false
                            
                        } else {
                            // yes chat
                            self.btnChatShow.tintColor = NAVIGATION_BACKGROUND_COLOR
                            self.btnChatShow.isUserInteractionEnabled = true
                        }
                        
                        
                        if "\(dict["AudioChat"] as! Int)" == "1" {
                            // no audio hat
                            self.btnAudioShow.tintColor = .lightGray
                            self.btnAudioShow.isUserInteractionEnabled = false
                            
                        } else {
                            // yes audio chat
                            self.btnAudioShow.tintColor = NAVIGATION_BACKGROUND_COLOR
                            self.btnAudioShow.isUserInteractionEnabled = true
                        }
                        
                        
                        if "\(dict["videoChat"] as! Int)" == "1" {
                            // no video chat
                            self.btnVideoShow.tintColor = .lightGray
                            self.btnVideoShow.isUserInteractionEnabled = false
                            
                        } else {
                            // yes video chat
                            self.btnVideoShow.tintColor = NAVIGATION_BACKGROUND_COLOR
                            self.btnVideoShow.isUserInteractionEnabled = true
                        }
                        
                        
                            
                            self.btnChatShow.addTarget(self, action: #selector(chatClickMethod), for: .touchUpInside)
                            self.btnVideoShow.addTarget(self, action: #selector(videoClickMethod), for: .touchUpInside)
                            self.btnAudioShow.addTarget(self, action: #selector(audioClickMethod), for: .touchUpInside)
                            
                         
                        
                        
                        Utils.RiteVetIndicatorHide()
                        self.tbleView.reloadData()
                        
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
    
    // MARK:- CHAT -
    @objc func chatClickMethod() {
        
        if (self.dict["currentAvailable"] as! String) == "No" {
            
            if "\(self.dict["UTYPE"]!)" == "2" {
                
                let alert = UIAlertController(title: "Ritevet", message: "Veterinarian is busy now. Please check and schedule appointment.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Ritevet", message: "Pet service provider is busy now. Please check and schedule appointment.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
            push!.receiverData = dict as NSDictionary?
            push!.fromDialog = "no"
            self.navigationController?.pushViewController(push!, animated: true)
        }
    }
    
    // MARK:- VIDEO -
    @objc func videoClickMethod() {
        
        
        if (self.dict["currentAvailable"] as! String) == "No" {
            
            if "\(self.dict["UTYPE"]!)" == "2" {
                
                let alert = UIAlertController(title: "Ritevet", message: "Veterinarian is busy now. Please check and schedule appointment.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Ritevet", message: "Pet service provider is busy now. Please check and schedule appointment.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                let x2 : Int = (dict["userId"] as! Int)
                let myString2 = String(x2)
                
                let channelNameIs = String(myString)+"+"+String(myString2)
                
                print(channelNameIs as Any)
                 
                self.sendNotificationForSingleUser(strChannelName: channelNameIs, strType: "videocall", strBody: "Incoming Video call")
                
            }
            
        }
    
       
        
    }
    
    // MARK:- AUDIO -
    @objc func audioClickMethod() {
        
        
        if (self.dict["currentAvailable"] as! String) == "No" {
            
            if "\(self.dict["UTYPE"]!)" == "2" {
                
                let alert = UIAlertController(title: "Ritevet", message: "Veterinarian is busy now. Please check and schedule appointment.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Ritevet", message: "Pet service provider is busy now. Please check and schedule appointment.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                let x2 : Int = (dict["userId"] as! Int)
                let myString2 = String(x2)
                
                let channelNameIs = String(myString)+"+"+String(myString2)
                
                self.sendNotificationForSingleUser(strChannelName: channelNameIs, strType: "audiocall", strBody: "Incoming Audio call")
                
                
            }
        }
        
        
        
        
    }
    
    @objc func sendNotificationForSingleUser(strChannelName:String,strType:String,strBody:String) {
        
        /*
         json.put("action", "sendnotification");
         json.put("message", message);
         json.put("type", type);
         json.put("userId", SessionManager.get_user_id(prefs));
         json.put("todevice", device);
         json.put("device", "IOS"); // android
         json.put("channel", channel);
         json.put("name", SessionManager.get_name(prefs));
         json.put("image", SessionManager.get_image(prefs));
         json.put("Token", token);
         json.put("deviceToken", SessionManager.get_device_token(prefs));
         json.put("mobileNumber", SessionManager.get_mobile(prefs));
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            parameters = [
                "action"        : "sendnotification",
                "message"       : String(strBody),
                "type"          : String(strType),
                "userId"        : String(myString),
                "todevice"      : "\(dict["device"] as! String)",
                "device"        : "iOS",
                "channel"       : String(strChannelName),
                "name"          : (person["fullName"] as! String),
                "image"         : "\(dict["ownPicture"] as! String)",
                "Token"         : "\(dict["deviceToken"] as! String)",
                "deviceToken"   : (person["deviceToken"] as! String),
                "mobileNumber"  : ""
                
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
                        
                        if strSuccess == "success" {
                            
                            /*var ar : NSArray!
                             ar = (JSON["data"] as! Array<Any>) as NSArray
                             //print(ar as Any)
                             
                             //var arServices : NSArray!
                             var itemCountarServices:Int!
                             var newString1arServices = ""
                             var ssarServices:String!
                             
                             itemCountarServices = ar.count-1
                             
                             for i in 0 ... itemCountarServices {
                             let itemarServices = ar[i] as? [String:Any]
                             ssarServices = (itemarServices!["name"] as! String)
                             newString1arServices += "\(ssarServices!)+"
                             }
                             
                             //print(newString1arServices as Any)
                             //self.strSaveFullValueOfServiceInOneString = newString1arServices
                             
                             let defaults = UserDefaults.standard
                             defaults.set((newString1arServices), forKey: "keyRequestServiceDropDown")
                             */
                            
                            Utils.RiteVetIndicatorHide()
                            
                            if strType == "audiocall" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"RoomViewControllerId") as? RoomViewController
                                push!.roomName = String(strChannelName)
                                push!.setSteps = "2"
                                push!.strIamCallingTo = "\(self.dict["VFirstName"] as! String)"
                                
                                push!.callerName = "\(self.dict["VFirstName"] as! String)"
                                push!.callerImage = "\(self.dict["ownPicture"] as! String)"
                                
                                let x22 : Int = (self.dict["userId"] as! Int)
                                let myString22 = String(x22)
                                
                                push!.receiver_id_for_missed_call = myString22
                                push!.receiver_name_for_missed_call = "\(self.dict["VFirstName"] as! String)"
                                push!.receiver_image_for_missed_call = "\(self.dict["ownPicture"] as! String)"
                                push!.receiver_token_for_missed_call = "\(self.dict["device"] as! String)"
                                
                                self.navigationController?.pushViewController(push!, animated:true)
                                
                            } else {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoChatViewControllerId") as? VideoChatViewController
                                push!.roomName = String(strChannelName)
                                push!.setSteps = "2"
                                push!.strIamCallingTo = "\(self.dict["VFirstName"] as! String)"
                                
                                push!.callerName = "\(self.dict["VFirstName"] as! String)"
                                push!.callerImage = "\(self.dict["ownPicture"] as! String)"
                                
                                self.navigationController?.pushViewController(push!, animated:true)
                                
                            }
                            
                            
                            
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
    
    
    
    
    
    @objc func sendNotification(strChannelName:String,strType:String,strBody:String) {
        
        // self.callOurLocalServer(strRandomIdIs: String(dictGetPostData["postRandomGenerateNumber"] as! String), strTimeStamp: String(myTimeStamp))*/
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let token = "\(dict["deviceToken"] as! String)"
            print(token as Any)
            
            let serverKey = "AAAAD2RCGuc:APA91bEef_TONrwvdJT6Rg027PmANBlwCHmAM8qPtQW7kRTtoTlOJwTDXnAxw3fYa-OcJGWxZoJJciaLSjN7xSiYvbQ7_QAeHXR96IcLLGo_mBT4mvA7qMLMmcYNBiXIgoxEtIbpkGU-"
            let partnerToken = token
            // let topic = "/topics/<Dishant Rajput>"  // replace it with partnerToken if you want to send a topic
            let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
            
            let postParams = [
                "to": partnerToken,
                "priority":"high",
                "content_available":true,
                "notification": [
                    "body": String(strBody),
                    "title": (person["fullName"] as! String),
                    "sound" : true,
                    // "click_action" : String(self.chatChannelName),
                    // "click_action2" : String(self.chatChannelName),
                ],
                "data":[
                    "message"       : String(strBody),
                    "type"          : String(strType),
                    "userId"        : String(myString),
                    "todevice"      : "iOS",
                    "channel"       : String(strChannelName),
                    "name"          : (person["fullName"] as! String),
                    "image"         : "\(dict["ownPicture"] as! String)",
                    "deviceToken"   : (person["deviceToken"] as! String)
                ]] as [String : Any]
            
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
                print("My paramaters: \(postParams)")
                
                
            } catch {
                print("Caught an error: \(error)")
            }
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                if let realResponse = response as? HTTPURLResponse {
                    if realResponse.statusCode != 200 {
                        print("Not a 200 response")
                    }
                }
                
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String? {
                    print("POST: \(postString)")
                }
            }
            
            task.resume()
            
        }
        
    }
    
    @objc func bookAnAppoitmentClickMethod() {
    
        // print(self.getDictRequestServiceHome)
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarId") as? Calendar
        
        push!.dictGetVendorDetails = self.getDictRequestServiceHome
        push!.strGetVendorIdForCalendar = (getDictRequestServiceHome!["userId"] as! Int)
        push!.arrGetDetailsAndService = arrListOfServices
        push!.getUtypeForCalendar = getUtypeInDetailsPage
        // print(getDictRequestServiceHome as Any)strCountryName
        push!.strCountryName = (self.getDictRequestServiceHome["Country"] as! String)
        push!.strAmericanBoardOption = (self.getDictRequestServiceHome["american_board_certified_option"] as! String)
        push!.str_set_payment = String(self.str_set_price_or_not)
        push!.str_get_business_type_for_calendar = String(self.str_business_type_is)
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
}

extension RequestServiceDetails: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if strDetailsDownSet == "0" {
            print("details count")
            return 4 // arrSetDetailsAndService.count
        }
        else if strServiceDownSet == "0" {
            print("service count")
            return 2
        }
        else if strServiceDownSet == "1" {
            print("service count")
            return arrListOfServices.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:RequestServiceDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RequestServiceDetailsTableCell
        
        cell.backgroundColor = .clear
                  
        print(self.getDictRequestServiceHome as Any)
        
        if strDetailsDownSet == "0" {
            print("details count cell for row")
            cell.lblStaticTitle.isHidden = false
            
            if indexPath.row == 0 {
                
                cell.lblStaticTitle.text = "EMAIL ADDRESS"
                cell.lblDynamicTitle.text = (getDictRequestServiceHome!["VEmail"] as! String)
                
            } else if indexPath.row == 1 {
                print(self.getDictRequestServiceHome as Any)
                
                cell.lblStaticTitle.text = "ADDRESS"
                cell.lblDynamicTitle.text = (getDictRequestServiceHome!["VBusinessAddress"] as! String)+",\n\nCity : "+(getDictRequestServiceHome!["Vcity"] as! String)+",\n\nState : "+(getDictRequestServiceHome!["stateName"] as! String)+",\n\nCountry : "+(getDictRequestServiceHome!["Country"] as! String)+",\n\nZipCode : "+(getDictRequestServiceHome!["VZipcode"] as! String)
                
            }  else if indexPath.row == 2 {
                //print(strSaveFullValueOfSpecializationInOneString as Any)
                if strSaveFullValueOfSpecializationInOneString == "0" {
                    cell.lblStaticTitle.text = "SPECIALIZATION"
                    cell.lblDynamicTitle.text = String("Please wait...")
                }
                else
                if strSaveFullValueOfSpecializationInOneString == nil {
                    cell.lblStaticTitle.text = "SPECIALIZATION"
                    cell.lblDynamicTitle.text = String("Please wait...")
                }
                else
                {
                    cell.lblStaticTitle.text = "SPECIALIZATION"
                    cell.lblDynamicTitle.text = String(strSaveFullValueOfSpecializationInOneString)
                }
                
            }
            else
            if indexPath.row == 3 {
                cell.lblStaticTitle.text = "TYPE OF SERVICES"
                
                if strSaveFullValueOfServiceInOneString == "0" {
                    cell.lblDynamicTitle.text = String("Please wait...")
                }
                else
                if strSaveFullValueOfServiceInOneString == nil {
                    cell.lblDynamicTitle.text = String("Please wait...")
                }
                else
                {
                    cell.lblDynamicTitle.text = String(strSaveFullValueOfServiceInOneString)
                }
            }
        
        }
        else if strServiceDownSet == "0" {
            //print("service count cell for row")
        
            //cell.lblStaticTitle.isHidden = true
            //cell.lblDynamicTitle.text = (arrListOfServices[indexPath.row] as! String)
        }
        else if strServiceDownSet == "1" {
            //print("service count cell for row")
        
            //print(arrListOfServices as Any)
            let item = arrListOfServices[indexPath.row] as? [String:Any]
            
            cell.lblStaticTitle.isHidden = true
            cell.lblDynamicTitle.text = (item!["name"] as! String)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        // vendor id
        //print(getDictRequestServiceHome as Any)userId
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if strDetailsDownSet == "0" {
            print("details count cell height")
            return UITableView.automaticDimension
        }
        else if strServiceDownSet == "0" {
            print("service count cell heigh")
            return 70
        }
        return 70
    }
}

extension RequestServiceDetails: UITableViewDelegate {
    
}

