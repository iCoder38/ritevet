//
//  RequestServiceHome.swift
//  RiteVet
//
//  Created by evs_SSD on 1/6/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import BottomPopup

class RequestServiceHome: UIViewController,UITextFieldDelegate {

    var str_took_payment:String!
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    let cellReuseIdentifier = "requestServiceHomeTableCell"
    
    var strGetRequestServiceHome:String!
    var strSubCategoryId:String!
    
    // var arrListOfRequestServiceHome:Array<Any>!
    
    // bottom view popup
    var height: CGFloat = 600 // height
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    var strUTYPEis:String!
    
    var selectServiceType:String!
    
    var str_type_of_business:String!
    
    var arr_mut_request_service_list:NSMutableArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "REQUEST SERVICE HOME"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var txtCategory:UITextField!
    @IBOutlet weak var btnCategoryOpenBottomSheet:UIButton!
    
    @IBOutlet weak var txtSearch:UITextField!
    
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

        // MAIN CATEGORY ID
        print(strGetRequestServiceHome as Any)
        
        // SUB CATEGORY ID
        print(strSubCategoryId as Any)
        print(self.str_type_of_business as Any)
        
        
        
        /****** VIEW BG IMAGE *********/
        //self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        let defaults = UserDefaults.standard
        defaults.set("1", forKey: "selectedUtypeIs")
        
        self.view.backgroundColor = .white
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnCategoryOpenBottomSheet.addTarget(self, action: #selector(categoryClickMethod), for: .touchUpInside)
        
        /*
         let defaults = UserDefaults.standard
         if let myString = defaults.string(forKey: "keySelectedTimeIs") {
             print(myString)
             btnTime.setTitle(myString, for: .normal)
             
             defaults.set("", forKey: "keySelectedTimeIs")
             defaults.set(nil, forKey: "keySelectedTimeIs")
         }
         else {
             print("never went to that page")
         }
         */
        
        //strUTYPEis = strGetRequestServiceHome
        
        txtSearch.delegate = self
        txtCategory.delegate = self
        
        // self.requestServiceHomeWB()
        
        self.filterViaClickWB(strAction: "requestservice",
                              strUtpe: String(self.strGetRequestServiceHome),
                              strTypeOfBusiness: String(self.str_type_of_business),
                              page_number: 1)
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func categoryClickMethod() {
        /*
         let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
         
         let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                 UIAlertAction in
                 NSLog("OK Pressed")
             }
         
         alertController.addAction(okAction)
         
         self.present(alertController, animated: true, completion: nil)
         */
        
        if self.strGetRequestServiceHome == "2" {
            self.arr_mut_request_service_list.removeAllObjects()
            
            let alert = UIAlertController(title: "Request Veterinary Services", message: "Please Select Service", preferredStyle : .actionSheet)
            
            
            alert.addAction(UIAlertAction(title: "Veterinary clinic/Hospital near me", style: .default, handler: { _ in
                
                self.txtCategory.text = "Veterinary clinic/Hospital near me"
                self.filterViaClickWB(strAction: "requestservice", strUtpe: "2", strTypeOfBusiness: "1", page_number: 1)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Mobile Clinic /veterinarian come to my home", style: .default, handler: { _ in
                
                self.txtCategory.text = "Mobile Clinic /veterinarian come to my home"
                self.filterViaClickWB(strAction: "requestservice", strUtpe: "2", strTypeOfBusiness: "2", page_number: 1)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Video chat with a veterinarian", style: .default, handler: { _ in
                
                self.txtCategory.text = "Video chat with a veterinarian"
                self.filterViaClickWB(strAction: "requestservice", strUtpe: "2", strTypeOfBusiness: "3", page_number: 1)
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
                //Cancel Action
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.arr_mut_request_service_list.removeAllObjects()
            
            let alert = UIAlertController(title: "Request Other PetServices", message: "Please Select Service", preferredStyle : .actionSheet)
            
            
            alert.addAction(UIAlertAction(title: "Fixed location", style: .default, handler: { _ in
                
                self.txtCategory.text = "Fixed location"
                self.filterViaClickWB(strAction: "requestservice", strUtpe: "3", strTypeOfBusiness: "4", page_number: 1)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Mobile Business", style: .default, handler: { _ in
                
                self.txtCategory.text = "Mobile Business"
                self.filterViaClickWB(strAction: "requestservice", strUtpe: "3", strTypeOfBusiness: "5", page_number: 1)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Mobile Service Provider", style: .default, handler: { _ in
                
                self.txtCategory.text = "Mobile Service Provider"
                self.filterViaClickWB(strAction: "requestservice", strUtpe: "3", strTypeOfBusiness: "6", page_number: 1)
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
                //Cancel Action
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        /*let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "keyRequestServiceDropDown") {
            print(myString)
            
            var fullNameArr = myString.components(separatedBy: "+")
            fullNameArr = fullNameArr.filter({ $0 != ""})// remove empty array element from array list
            
            let alert = UIAlertController(title: "Request Services", message: "Please Select Service", preferredStyle : .actionSheet)
            
            for i in fullNameArr {
                alert.addAction(UIAlertAction(title: i, style: .default, handler: doSomething))
            }
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
                //Cancel Action
            }))
            
            self.present(alert, animated: true, completion: nil)
        }*/
        
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
                    
   
                    self.filterViaClickWB(strAction: "requestservice",
                                          strUtpe: String(self.strGetRequestServiceHome),
                                          strTypeOfBusiness: String(self.str_type_of_business),
                                          page_number: page)
                     
                    
                }
            }
        }
    }
    
    @objc func filterViaClickWB(strAction:String,strUtpe:String,strTypeOfBusiness:String,page_number:Int) {
       
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"            : strAction,
            "UTYPE"             : strUtpe,
            // "keyword"       : "",
            "typeofbusiness"    : strTypeOfBusiness,
            "pageNo"        :   page_number
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
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        // self.arrListOfRequestServiceHome = (ar as! Array<Any>)
                        self.arr_mut_request_service_list.addObjects(from: ar as! [Any])
                        
                        Utils.RiteVetIndicatorHide()
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
    
    func doSomething(action: UIAlertAction) {
        //Use action.title
        //print(action.title as Any)
        
        if action.title == " Clinic Hospital (Fixed Location)" {
            let defaults = UserDefaults.standard
            defaults.set("1", forKey: "selectedBusinessIdIs")
        }
        else
        if action.title == "Mobile Clinic / Mobile Veterinarian" {
            let defaults = UserDefaults.standard
            defaults.set("2", forKey: "selectedBusinessIdIs")
        }
        else
        if action.title == "Virtual Veterinarian (Video Chat)" {
            let defaults = UserDefaults.standard
            defaults.set("3", forKey: "selectedBusinessIdIs")
        }
        
        self.requestServiceHomeFromNavigationWB(strNameIdIs: action.title!)
    }
    
    @objc func requestServiceHomeFromNavigationWB(strNameIdIs:String) {
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //self.disableService()
        
        // "userId":""
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            print(strNameIdIs as Any)
            
            if strNameIdIs == " Clinic Hospital (Fixed Location)" {
                parameters = [
                    "action"            : "requestservice",
                    "UTYPE"             : String(strGetRequestServiceHome),
                    "keyword"           : "",
                    "typeofbusiness"    : "1",
                    "userId"            : String(myString)
                    //"UTYPE"        :   "4"
                ]
            }
            else
            if strNameIdIs == "Mobile Clinic / Mobile Veterinarian" {
                parameters = [
                    "action"            : "requestservice",
                    "UTYPE"             : String(strGetRequestServiceHome),
                    "keyword"           : "",
                    "typeofbusiness"    : "2",
                    "userId"            : String(myString)
                    //"UTYPE"        :   "4"
                ]
            }
            else
            if strNameIdIs == "Virtual Veterinarian (Video Chat)" {
                parameters = [
                    "action"            : "requestservice",
                    "UTYPE"             : String(strGetRequestServiceHome),
                    "keyword"           : "",
                    "typeofbusiness"    : "3",
                    "userId"            : String(myString)
                ]
            }
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        //print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        if strSuccess == "success" {
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            // self.arrListOfRequestServiceHome = (ar as! Array<Any>)
                            self.arr_mut_request_service_list.addObjects(from: ar as! [Any])
                            
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
    }
    
    /*@objc func requestServiceHomeWB() {
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //self.disableService()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            if self.strSubCategoryId == "3.1" {
                
                parameters = [
                    "action"        :   "requestservice",
                    "UTYPE"         : String("3"),
                    "typeofbusiness"    :   "4",
                    "userId"            : String(myString)
                ]
                
            } else if self.strSubCategoryId == "3.2" {
                
                parameters = [
                    "action"            :   "requestservice",
                    "UTYPE"             : String("3"),
                    "typeofbusiness"    :   "5",
                    "userId"            : String(myString)
                ]
                
            } else if self.strSubCategoryId == "3.3" {
                
                parameters = [
                    "action"            :   "requestservice",
                    "UTYPE"             : String("3"),
                    "typeofbusiness"    :   "6",
                    "userId"            : String(myString)
                ]
                
            } else if self.selectServiceType == "2" { // video chat
                
                parameters = [
                    "action"            :   "requestservice",
                    "UTYPE"             : String("2"),
                    "typeofbusiness"    :   "3",
                    "userId"            : String(myString)
                ]
                
            } else {
                
                parameters = [
                    "action"        :   "requestservice",
                    "UTYPE"         : String(strGetRequestServiceHome),
                    "userId"        : String(myString)
                    //"UTYPE"        :   "4"
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
                            
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfRequestServiceHome = (ar as! Array<Any>)
                            
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
    }*/
}

extension RequestServiceHome: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // return arrListOfRequestServiceHome.count
        return self.arr_mut_request_service_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:RequestServiceHomeTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RequestServiceHomeTableCell
        
        cell.backgroundColor = .clear
        
        let item = self.arr_mut_request_service_list[indexPath.row] as? [String:Any]
        
        cell.lblName.text = (item!["VBusinessName"] as! String)
        cell.lblAddress.text = (item!["VBusinessAddress"] as! String)+", "+(item!["Vcity"] as! String)+", "+(item!["VAstate"] as! String)
        
        cell.imgProfile.sd_setImage(with: URL(string: (item!["ownPicture"] as! String)), placeholderImage: UIImage(named: "logo-500"))
        
        cell.imgStarOne.image = UIImage(named:"unselectStar")
        cell.imgStarTwo.image = UIImage(named:"unselectStar")
        cell.imgStarThree.image = UIImage(named:"unselectStar")
        cell.imgStarFour.image = UIImage(named:"unselectStar")
        cell.imgStarFive.image = UIImage(named:"unselectStar")
        
        /*
         let livingArea = dictServerValue?["totalView"] as? Int ?? 0
         
         if livingArea == 0 {
             let stringValue = String(livingArea)
             self.lblTotalViews.text = (stringValue)+" View"
         }
         else
         {
             let stringValue = String(livingArea)
             self.lblTotalViews.text = (stringValue)+" Views"
         }
         */
        
        /*
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
         typeOfSpecilizationList =             (
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
         */
        
        /*
        let totalRating = item!["totalView"] as? Int ?? 0
        if totalRating == 0 {
            let stringValue = String(totalRating)
            //self.lblTotalViews.text = (stringValue)+" View"
            //cell.lblrat .text = stringValue
        }
        else
        {
            let stringValue = String(totalRating)
            //cell.lblAddress.text = stringValue
        }
        */
            
        cell.lblDoctorType.isHidden = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        //print(strUTYPEis as Any)
        
        let item = arr_mut_request_service_list[indexPath.row] as? [String:Any]
        
        /*
         if let myString = defaults.string(forKey: "keySelectedTimeIs")
         {
         */
        let defaults = UserDefaults.standard
        defaults.set((item!["ownPicture"] as! String), forKey: "keySaveVendorImage")
        defaults.set((item!["VBusinessName"] as! String), forKey: "keySaveVendorBName")
        
        //print(item as Any)
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestServiceDetailsId") as? RequestServiceDetails
        
        push!.getDictRequestServiceHome = item as NSDictionary?
        push!.getUtypeInDetailsPage = strGetRequestServiceHome
        push!.str_set_price_or_not = String(self.str_took_payment)
        push!.str_business_type_is = String(self.str_type_of_business)
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
}

extension RequestServiceHome: UITableViewDelegate {
    
}


extension RequestServiceHome: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
        // one
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
        
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "keySelectedRequestServiceIs")
        {
            print(myString)
            //btnTime.setTitle(myString, for: .normal)
            self.txtCategory.text = myString
            
            defaults.set("", forKey: "keySelectedRequestServiceIs")
            defaults.set(nil, forKey: "keySelectedRequestServiceIs")
        }
        else
        {
            print("never went to that page")
        }
        
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
