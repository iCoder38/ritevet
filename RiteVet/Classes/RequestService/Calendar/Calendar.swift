//
//  Calendar.swift
//  RiteVet
//
//  Created by Apple  on 28/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import JKCalendar
import Alamofire
import SwiftyJSON
import CRNotifications
import BottomPopup

class Calendar: UIViewController {
    
    var str_doctor_time_zone_is:String!
    var str_doctor_time_zone_real_is:String!
    
    var str_get_business_type_for_calendar:String!
    var str_date_for_Added:String!
    
    var str_set_payment:String!
    
    var dictGetVendorDetails:NSDictionary!
    
    var strCountryName:String!
    var strAmericanBoardOption:String!
    
    var strGetVendorIdForCalendar:Int!
    
    var arrGetDetailsAndService:Array<Any>!
    
    var arrListOfServicesInCalendar:Array<Any>!
    
    var getUtypeForCalendar:String!
    
    var selectDay: JKDay = JKDay(date: Date())
    
    // set array to WB
    var arrSetArray:Array<Any>!
    var strSaveAll:String!
    var newString1 = ""
    var aaa : Array<Any>!
    
    // time array
    var arrListOfTime:Array<Any>!
    
    // bottom view popup
    var height : CGFloat = 600 // height
    var topCornerRadius : CGFloat = 35 // corner
    var presentDuration : Double = 0.8 // present view time
    var dismissDuration : Double = 0.5 // dismiss view time
    let kHeightMaxValue : CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue : CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    // multiple picker UI
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    @IBOutlet weak var viewNavigation:UIView! {
           didSet {
               viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
           }
       }
       @IBOutlet weak var btnBack:UIButton!
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "Select Date/Time And Service"
               lblNavigationTitle.textColor = .white
           }
       }
    
    @IBOutlet weak var calendar: JKCalendar!
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.text = ""
        }
    }
    
    @IBOutlet weak var lblSelectedServices: UILabel! {
        didSet {
            lblSelectedServices.text = "Please Select Services"
        }
    }
    
    @IBOutlet weak var btnConfirm:UIButton!{
        didSet {
            btnConfirm.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            btnConfirm.setTitle("Confirm", for: .normal)
            btnConfirm.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var btnTime:UIButton!{
        didSet {
            btnTime.setTitle("Select Time", for: .normal)
            btnTime.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            btnTime.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var lblSelectedTimeIs: UILabel!
    
   @IBOutlet weak var btnAddServices:UIButton!
    //
    let markColor = UIColor(red: 40/255, green: 178/255, blue: 253/255, alpha: 1)
    var selectDays: [JKDay]?{
        didSet {
            if let days = selectDays,
               days.count > 0 {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                
                let firstDay = days.first!
                let firstDate = JKCalendar.calendar.date(from: DateComponents(
                    
                year: firstDay.year,
                month: firstDay.month,
                day: firstDay.day))!
                

                let lastDay = days.last!
                _ = JKCalendar.calendar.date(from: DateComponents(year: lastDay.year,
                                                                                 month: lastDay.month,
                                                                                 day: lastDay.day))!
                dateLabel.text = formatter.string(from: firstDate)
                
                self.getTimeSlot()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // print(self.str_set_payment)
        
        /****** VIEW BG IMAGE *********/
//        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.view.backgroundColor = .white
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        //btnNext.addTarget(self, action: #selector(nextClickMethod), for: .touchUpInside)
        btnTime.addTarget(self, action: #selector(timeClickMethod), for: .touchUpInside)
        
        
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.textColor = UIColor(white: 0.25, alpha: 1)
        calendar.backgroundColor = UIColor.white
        
        calendar.isNearbyMonthNameDisplayed = false
        calendar.isScrollEnabled = false
        
        print(strGetVendorIdForCalendar as Any)
        print(str_get_business_type_for_calendar as Any)
        
        /*
         Optional(95)
         Optional([{
             id = 1;
             name = "General / Internal Medicine";
         },  {
             id = 6;
             name = "Diagnostic Lab";
         }])
         (lldb)
         */
        
        //var ar : NSArray!
        //ar = (dict["typeOfSpecilizationList"] as! Array<Any>) as NSArray
        
        var itemCount:Int!
        var newString1 = ""
        var ss:String!
        
        print(self.arrGetDetailsAndService as Any)
        
        itemCount = arrGetDetailsAndService.count-1
           
        for i in 0 ... itemCount {
            let item = arrGetDetailsAndService[i] as? [String:Any]
            ss = (item!["name"] as! String)
            newString1 += "\(ss!)+"
        }
        
        let fullNameArr = newString1.components(separatedBy: "+")
        arrListOfServicesInCalendar = fullNameArr
        
        btnAddServices.addTarget(self, action: #selector(openCountriesPickerAction(_:)), for: .touchUpInside)
        
        btnConfirm.addTarget(self, action: #selector(confirmClickMethod), for: .touchUpInside)
       
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
    
    @objc func confirmClickMethod() {
        
        if btnTime.titleLabel?.text == "Select Time" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please select Time Slot", dismissDelay: 1.5, completion:{})
        }
        else
        if lblSelectedServices.text == "Please Select Services" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please select Service", dismissDelay: 1.5, completion:{})
        }
        else
        {
            
            
            //
            if (self.str_set_payment == "no") {
                self.submit_request_without_payment()
            } else {
                self.submitRequestServiceToServer()
            }
            
        }
        
        
    }
    @objc func submit_request_without_payment() {
        Utils.RiteVetIndicatorShow()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.date(from: String(dateLabel.text!))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = dateFormatter.string(from: date!)
        print(resultString)
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            
            
            
            
            /*if (self.strTypeOfBusiness == "3") {
                
                if (self.strGetCountryName == "United States") {
                    strCountryNameAndPrice = "195"
                } else {
                    strCountryNameAndPrice = "25"
                }
                
            } else if (self.strTypeOfBusiness == "2") {
                
                
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
             
             push!.dictShowFullDetails = self.dictGetVendorDetails
             push!.strServiceList = String(productIDString)
             push!.strVendorId = String(strGetVendorIdForCalendar)
             push!.strBookingDate = String(dateLabel.text!);
             push!.strSlotTime = self.btnTime.titleLabel?.text;
             push!.strTypeOfBusiness = String(myString22);
             push!.strUType = String(getUtypeForCalendar)
             push!.strGetCountryName = String(self.strCountryName)
             push!.strGetAmericanBoardCertificate = String(self.strAmericanBoardOption)
            }*/
            
            var type_of_services:String!
            var myString222:String!
            
            let arrMut:NSMutableArray! = []
            for i in 0..<self.arrGetDetailsAndService.count {
                
                let item = self.arrGetDetailsAndService[i] as! [String:Any]
                
                arrMut.add("\(item["id"]!)")
                
            }
            
            // print(arrMut)
            
            let defaults = UserDefaults.standard
            if let myString22 = defaults.string(forKey: "selectedBusinessIdIs") {
                
                myString222 = myString22
                
                if let array = arrMut as? [String] {
                    print(array)
                    
                    let productIDString = array.joined(separator: ",")
                    print(productIDString)
                    type_of_services = String(productIDString)
                }
            }
                
                parameters = [
                    "action"        : "addbooking",
                    "userId"        : String(myString),
                    "vendorId"      : String(strGetVendorIdForCalendar),
                    "typeOfServices" : String(type_of_services),
                    "bookingDate"   : String(resultString),
                    "slotTime"      : String((self.btnTime.titleLabel?.text)!),
                    "typeofbusinessId" : String(myString222),
                    "UTYPE"         : String(getUtypeForCalendar),
                    "transactionId" : "123456",
                    "payment_mode"  : "Card",
                    "amount"        : "0",
                    
                    "added_time"       : Date.get24TimeWithDateForTimeZone(),
                    "current_time_zone" : "\(TimeZone.current.abbreviation()!)",
                ]
                //            }
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
                        Utils.RiteVetIndicatorHide()
                        
                        //var strGetBookingDate:String!
                        //var strGetBookingTime:String!
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfirmAppointmentId") as? ConfirmAppointment
                        push!.strGetBookingDate = String(self.dateLabel.text!)
                        push!.strGetBookingTime = String((self.btnTime.titleLabel?.text)!)
                        self.navigationController?.pushViewController(push!, animated: true)
                        
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
    
    
    
    
    
    func submitRequestServiceToServer() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "payment_before_booking_id") as? payment_before_booking
//        print(self.arrListOfServicesInCalendar);
        
        let arrMut:NSMutableArray! = []
        for i in 0..<self.arrGetDetailsAndService.count {
            
            let item = self.arrGetDetailsAndService[i] as! [String:Any]
            
            arrMut.add("\(item["id"]!)")
            
        }
        
        // print(arrMut)
        
        let defaults = UserDefaults.standard
        if let myString22 = defaults.string(forKey: "selectedBusinessIdIs") {
            
            if let array = arrMut as? [String] {
                print(array)
                
                let productIDString = array.joined(separator: ",")
                print(productIDString)
                
                push!.str_doctor_time_zone = String(self.str_doctor_time_zone_is)
                push!.str_doctor_time_zone_with_real = String(self.str_doctor_time_zone_real_is)
                push!.str_booking_time_for_added = String(self.str_date_for_Added)
                
                print(self.btnTime.titleLabel?.text)
//                push!.strGetPrice =
                push!.dictShowFullDetails = self.dictGetVendorDetails
                push!.strServiceList = String(productIDString)
                push!.strVendorId = String(strGetVendorIdForCalendar)
                push!.strBookingDate = String(dateLabel.text!);
                push!.strSlotTime = self.btnTime.titleLabel?.text;
                push!.strTypeOfBusiness = String(myString22);
                push!.strUType = String(getUtypeForCalendar)
                push!.strGetCountryName = String(self.strCountryName)
                push!.strGetAmericanBoardCertificate = String(self.strAmericanBoardOption)
                push!.str_get_business_type_for_payment = String(self.str_get_business_type_for_calendar)
            }
        }
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
   @IBAction func handleBackButtonClick(_ sender: Any) {
       let _ = navigationController?.popViewController(animated: true)
   }
    
    @IBAction func openCountriesPickerAction(_ sender: UIButton) {
        let blueColor = sender.backgroundColor
        
        let blueAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Service",
            titleFont           : boldFont,
            titleTextColor      : .black,
            titleBackground     : .clear,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Service",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : blueColor,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named:"blue_ic_checked"),
            itemUncheckedImage  : UIImage(),
            itemColor           : .black,
            itemFont            : regularFont
        )
        
        let fruits = arrListOfServicesInCalendar
        let picker = YBTextPicker.init(with: fruits as! [String], appearance: blueAppearance,
                                       onCompletion: { (selectedIndexes, selectedValues) in
            if selectedValues.count > 0 {
                                            
                var values = [String]()
                for index in selectedIndexes{
                    values.append(fruits![index] as! String)
                }
                     
    
                            
    // print(values.count)
    //var newString2 = ""
    // var addDict:NSDictionary!
    //var checkInt:Int = values.count
     
                var results: [Int] = []
                for multiplier in 1...10 {
                    let multiples = (multiplier * 6)
                    print(multiples)
                    results.append(multiples)
                }
                 
    //var res:[String] = []
     
                                          
                var res = [[String: String]]()
                for i in 0 ... values.count-1 {
      
                    let item = values[i]
        
                    let myDictionary: [String:String] = [
                        "serviceId":"1",
                        "serviceName":item,
                        "price":""
                    ]
                    print(myDictionary as Any)
        
                    res.append(myDictionary)
                    print(type(of: res))
                }
                                            
                let paramsArray = res
                let paramsJSON = JSON(paramsArray)
                let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
         
                self.strSaveAll = paramsString
                                               
                self.lblSelectedServices.text = values.joined(separator: ", ")
                      
            } else {
                                            //self.btnFruitsPicker.setTitle("Select Fruits", for: .normal)
    //self.txtWeekOff.text = "Select Day"
                self.lblSelectedServices.text = "Select Day"
            }
        },
                                       onCancel: {
            print("Cancelled")
        }
        )
        
        
        if let title = btnAddServices.title(for: .normal){
            if title.contains(","){
                picker.preSelectedValues = title.components(separatedBy: ", ")
            }
        }
         
        
        picker.allowMultipleSelection = true
        
        picker.show(withAnimation: .Fade)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertIntoJSONString(arrayObject: [Any]) -> String? {

        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    @objc func timeClickMethod() {
        
        if dateLabel.text == "" {
            
            CRNotifications.showNotification(type: CRNotifications.error, title: "Hurray!", message:"Please Select Date", dismissDelay: 1.5, completion:{})
            return
            
        } else {
        
            print(self.arrListOfTime as Any)
            
            let arrAvailaibleTime:NSMutableArray! = []
            
            for i in 0..<self.arrListOfTime.count {
                
                let item  = self.arrListOfTime[i] as! [String:Any]
                
                if (item["status"] as! String) == "Available" {
                    
                    let custom = [
                        "converted_slot":(item["converted_slot"] as! String),
                        "slot":(item["slot"] as! String),
                        "status":"Available"
                    ]
                    
                    arrAvailaibleTime.add(custom)
                    
                }
                
            }

            guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
            popupVC.height = self.height
            popupVC.topCornerRadius = self.topCornerRadius
            popupVC.presentDuration = self.presentDuration
            popupVC.dismissDuration = self.dismissDuration
            //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
            popupVC.popupDelegate = self
            popupVC.arrGetTime = arrAvailaibleTime
            popupVC.strGetDetails = "timeSlot"
            popupVC.dynamicString = "Time Slots"
            self.present(popupVC, animated: true, completion: nil)
    
        }
        
    }
    
}

extension Calendar: JKCalendarDelegate{
    
    func calendar(_ calendar: JKCalendar, didTouch day: JKDay) {
        selectDays = [day]
        calendar.reloadData()
    }
    
    func calendar(_ calendar: JKCalendar, didPan days: [JKDay]) {
        selectDays = days
        calendar.reloadData()
    }
}

extension Calendar: JKCalendarDataSource{
    
    func calendar(_ calendar: JKCalendar, marksWith month: JKMonth) -> [JKCalendarMark]? {
        
        let firstMarkDay: JKDay = JKDay(year: 2018, month: 1, day: 9)!
        let secondMarkDay: JKDay = JKDay(year: 2018, month: 1, day: 20)!
        
        var marks: [JKCalendarMark] = []
        if selectDay == month{
            marks.append(JKCalendarMark(type: .underline,
                                        day: selectDay,
                                        color: UIColor.red))
        }
        if firstMarkDay == month{
            marks.append(JKCalendarMark(type: .underline,
                                        day: firstMarkDay,
                                        color: markColor))
        }
        if secondMarkDay == month{
            marks.append(JKCalendarMark(type: .hollowCircle,
                                        day: secondMarkDay,
                                        color: markColor))
        }
        return marks
    }
    
    func calendar(_ calendar: JKCalendar, continuousMarksWith month: JKMonth) -> [JKCalendarContinuousMark]?{
        if let days = selectDays,
            let start = days.first,
            let end = days.last{
            return [JKCalendarContinuousMark(type: .circle, start: start, end: end, color: markColor)]
        } else {
            return nil
        }
    }
    
    @objc func getTimeSlot() {
       
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        // print(dateLabel.text!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.date(from: String(dateLabel.text!))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = dateFormatter.string(from: date!)
        print(resultString)
        
        self.str_date_for_Added = String(resultString)
        
        parameters = [
            "action"    : "vendorslot",
            "vendorId"  : String(strGetVendorIdForCalendar),
            "date"      : String(resultString),
            "added_time"     : Date.get24TimeWithDateForTimeZone(),
            // "current_time_zone":"\(TimeZone.current.abbreviation()!)",
            // booker current time offset
            "current_time_zone":"\(TimeZone.current.currentTimezoneOffset())",

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
                    
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                             
                    // var strSuccessAlert : String!
                    // strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == "Success" {
                               
                        self.str_doctor_time_zone_is = JSON["current_time_zone_doctor"]as Any as? String
                        self.str_doctor_time_zone_real_is = JSON["zone_doctor"]as Any as? String
                        
                        
                        
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfTime = (ar as! Array<Any>)
                        
                        Utils.RiteVetIndicatorHide()
                              
                        if self.arrListOfTime.count == 0 {
                           
                            let alert = UIAlertController(title: "Alert", message: "No Slots availaible for this Date. Please select another Date.",
                                                          preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
                                //Cancel Action
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                            self.btnConfirm.setTitle("Please select another Date", for: .normal)
                            self.btnConfirm.backgroundColor = .lightGray
                            self.btnConfirm.isUserInteractionEnabled = false
                        } else {
                            self.btnConfirm.setTitle("Confirm", for: .normal)
                            self.btnConfirm.backgroundColor = NAVIGATION_BACKGROUND_COLOR
                            self.btnConfirm.isUserInteractionEnabled = true
                        }
                        
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
                        
                        let alert = UIAlertController(title: "Alert", message: strSuccess2,
                                                      preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
                            //Cancel Action
                            self.navigationController?.popViewController(animated: true)
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
    //}
}



extension Calendar: BottomPopupDelegate {
    
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
        if let myString = defaults.string(forKey: "keySelectedTimeIs") {
            print(myString)
            btnTime.setTitle(myString, for: .normal)
            
            defaults.set("", forKey: "keySelectedTimeIs")
            defaults.set(nil, forKey: "keySelectedTimeIs")
        }
        else {
            print("never went to that page")
        }
        
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
