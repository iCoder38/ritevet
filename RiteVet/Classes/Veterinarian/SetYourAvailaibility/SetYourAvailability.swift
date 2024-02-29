//
//  SetYourAvailability.swift
//  RiteVet
//
//  Created by evs_SSD on 1/2/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView
import CRNotifications

class SetYourAvailability: UIViewController,UITextFieldDelegate {

    // time picker
    // theme
    var theme: SambagTheme = .dark
    
    var strCheckWhichTextField:String!
    
    // multiple picker UI
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SET YOUR AVAILABILITY"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var txtWorkingTimeFrom:UITextField!
    @IBOutlet weak var txtWorkingTimeTo:UITextField!
    @IBOutlet weak var txtWeekOff:UITextField!
    @IBOutlet weak var txtLunchBreakFrom:UITextField!
    @IBOutlet weak var txtLunchBreakTo:UITextField!
    
    // multiple day selection button
    @IBOutlet weak var btnDayPicker: UIButton!
    
    // time picker button
    @IBOutlet weak var btnTimePickerWorkingFrom: UIButton!
    @IBOutlet weak var btnTimePickerWorkingTo: UIButton!
    @IBOutlet weak var btnTimePickerLunchFrom: UIButton!
    @IBOutlet weak var btnTimePickerLunchTo: UIButton!
    
    @IBOutlet weak var btnUpdateAvailability:UIButton! {
        didSet {
            btnUpdateAvailability.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btnUpdateAvailability.layer.cornerRadius = 4
            btnUpdateAvailability.clipsToBounds = true
            btnUpdateAvailability.setTitle("UPDATE AVAILABILITY", for: .normal)
            btnUpdateAvailability.setTitleColor(.white, for: .normal)
        }
    }
    // ok
    override func viewDidLoad() {
        super.viewDidLoad()
        strCheckWhichTextField = "0"
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        btnUpdateAvailability.addTarget(self, action: #selector(setAvailability), for: .touchUpInside)
        
        // working hours buttons
        btnTimePickerWorkingFrom.addTarget(self, action: #selector(workingHoursFromClickMethod), for: .touchUpInside)
        btnTimePickerWorkingTo.addTarget(self, action: #selector(workingHoursToClickMethod), for: .touchUpInside)
        
        // lunch buttons
        btnTimePickerLunchFrom.addTarget(self, action: #selector(lunchFromClickMethod), for: .touchUpInside)
        btnTimePickerLunchTo.addTarget(self, action: #selector(lunchToClickMethod), for: .touchUpInside)
        
        self.txtWorkingTimeFrom.isUserInteractionEnabled = false
        self.txtWorkingTimeTo.isUserInteractionEnabled = false
        self.txtWeekOff.isUserInteractionEnabled = false
        self.txtLunchBreakFrom.isUserInteractionEnabled = false
        self.txtLunchBreakTo.isUserInteractionEnabled = false
        
        self.welcome5()
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
    
    // working hours methods
    @objc func workingHoursFromClickMethod() {
        strCheckWhichTextField = "1"
        /*let vc = SambagTimePickerViewController()
        vc.theme = theme
        vc.delegate = self
        present(vc, animated: true, completion: nil)*/
        
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
            // TODO: Your implementation for date
            // self?.outputLabel.text = selectedDate.dateString("hh:mm a")
            self?.txtWorkingTimeFrom.text = selectedDate.dateString("hh:mm a")
        })
        
    }
    @objc func workingHoursToClickMethod() {
        strCheckWhichTextField = "2"
        /*let vc = SambagTimePickerViewController()
        vc.theme = theme
        vc.delegate = self
        present(vc, animated: true, completion: nil)*/
        
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
            // TODO: Your implementation for date
            // self?.outputLabel.text = selectedDate.dateString("hh:mm a")
            self?.txtWorkingTimeTo.text = selectedDate.dateString("hh:mm a")
        })
        
    }
    // lunch break methods
    @objc func lunchFromClickMethod() {
        strCheckWhichTextField = "3"
        /*let vc = SambagTimePickerViewController()
        vc.theme = theme
        vc.delegate = self
        present(vc, animated: true, completion: nil)*/
        
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
            // TODO: Your implementation for date
            // self?.outputLabel.text = selectedDate.dateString("hh:mm a")
            self?.txtLunchBreakFrom.text = selectedDate.dateString("hh:mm a")
        })
        
    }
    @objc func lunchToClickMethod() {
        strCheckWhichTextField = "4"
        /*let vc = SambagTimePickerViewController()
        vc.theme = theme
        vc.delegate = self
        present(vc, animated: true, completion: nil)*/
        
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
            // TODO: Your implementation for date
            // self?.outputLabel.text = selectedDate.dateString("hh:mm a")
            self?.txtLunchBreakTo.text = selectedDate.dateString("hh:mm a")
        })
        
    }
    
    @IBAction func openCountriesPickerAction(_ sender: UIButton) {
        let blueColor = sender.backgroundColor
        
        let blueAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Day",
            titleFont           : boldFont,
            titleTextColor      : .black,
            titleBackground     : .clear,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Day",
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
        
        let fruits = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        let picker = YBTextPicker.init(with: fruits, appearance: blueAppearance,
                                       onCompletion: { (selectedIndexes, selectedValues) in
                                        if selectedValues.count > 0{
                                            
                                            var values = [String]()
                                            for index in selectedIndexes{
                                                values.append(fruits[index])
                                            }
                                            
                                            //self.btnFruitsPicker.setTitle(values.joined(separator: ", "), for: .normal)
    self.txtWeekOff.text = values.joined(separator: ",")
                                        }else{
                                            //self.btnFruitsPicker.setTitle("Select Fruits", for: .normal)
    self.txtWeekOff.text = "Select Day"
                                        }
        },
                                       onCancel: {
                                        print("Cancelled")
        }
        )
        
        
        if let title = btnDayPicker.title(for: .normal){
            if title.contains(","){
                picker.preSelectedValues = title.components(separatedBy: ", ")
            }
        }
         
        
        picker.allowMultipleSelection = true
        
        picker.show(withAnimation: .Fade)
    }
    
    
    
    // MARK:- SET AVAILABILITY WEBSERVICE -
    @objc func setAvailability() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             Setting Availabity
             "action:setting
             vendorId:9
             startTime:10:30
             endTime:16:30
             brakeStartTime:13:00
             breakEndTime:13:30
             dayendarray:SAT,TUE"
             */
            
            parameters = [
                "action"         : "setting",
                "vendorId"       : String(myString),
                "startTime"      : String(txtWorkingTimeFrom.text!),
                "endTime"        : String(txtWorkingTimeTo.text!),
                "brakeStartTime" : String(txtLunchBreakFrom.text!),
                "breakEndTime"   : String(txtLunchBreakTo.text!),
                "dayendarray"    : String(txtWeekOff.text!),
                "userType"       : String("2"),
                
                "added_time"     : Date.get24TimeWithDateForTimeZone(),
                // "current_time_zone":"\(TimeZone.current.abbreviation()!)",
                "current_time_zone":"\(TimeZone.current.currentTimezoneOffset())",
                
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
                    
                    var strSuccessAlert : String!
                    strSuccessAlert = JSON["msg"]as Any as? String
                    
                    if strSuccess == "Success"{
                        Utils.RiteVetIndicatorHide()
                        
                        CRNotifications.showNotification(type: CRNotifications.success, title: "Hurray!", message:strSuccessAlert!, dismissDelay: 1.5, completion:{})
                        
                        let hideUnhide = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddVeterinarianBankInfoId")
                        self.navigationController?.pushViewController(hideUnhide, animated: true)
                        
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
                        CRNotifications.showNotification(type: CRNotifications.error, title: "OOPS!", message:strSuccessAlert!, dismissDelay: 1.5, completion:{})
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
    
    @objc func welcome5() {
        // indicator.startAnimating()
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "getsetting",
                "vendorId"    : String(myString),
                "userType"    : String("2"),
                "added_time"    : Date.get24TimeWithDateForTimeZone(),
                "current_time_zone":"\(TimeZone.current.abbreviation()!)",
            ]
        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON { [self]
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
                    
                    if strSuccess == "Success" {
                        Utils.RiteVetIndicatorHide()
                        
                        if strSuccess2 == "Please fill all the fields." {
                            
                        } else {
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            
                            self.txtWorkingTimeFrom.text = (dict["startTime"] as! String)
                            self.txtWorkingTimeTo.text = (dict["endTime"] as! String)
                            
                            self.txtWeekOff.text = (dict["dayendarray"] as! String)
                            
                            self.txtLunchBreakTo.text = (dict["brakeStartTime"] as! String)
                            self.txtLunchBreakFrom.text = (dict["breakEndTime"] as! String)
                        }
                        
                        
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
                        //  self.indicator.stopAnimating()
                        //  self.enableService()
                    }
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                Utils.RiteVetIndicatorHide()
                
                //                               self.indicator.stopAnimating()
                //                               self.enableService()
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

extension SetYourAvailability: SambagTimePickerViewControllerDelegate {
    
    func sambagTimePickerDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult) {
        //resultLabel.text = "\(result)"
        if strCheckWhichTextField == "0" {
            self.txtWorkingTimeFrom.text = ""
            self.txtWorkingTimeTo.text = ""
            self.txtLunchBreakFrom.text = ""
            self.txtLunchBreakTo.text = ""
        }
        else
        if strCheckWhichTextField == "1" {
            self.txtWorkingTimeFrom.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "2" {
            self.txtWorkingTimeTo.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "3" {
            self.txtLunchBreakFrom.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "4" {
            self.txtLunchBreakTo.text = "\(result)"
        }
        
        
        
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagTimePickerDidCancel(_ viewController: SambagTimePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension SetYourAvailability: SambagMonthYearPickerViewControllerDelegate {

    func sambagMonthYearPickerDidSet(_ viewController: SambagMonthYearPickerViewController, result: SambagMonthYearPickerResult) {
        
        if strCheckWhichTextField == "0" {
            self.txtWorkingTimeFrom.text = ""
            self.txtWorkingTimeTo.text = ""
        }
        else
        if strCheckWhichTextField == "1" {
            self.txtWorkingTimeFrom.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "2" {
            self.txtWorkingTimeTo.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "3" {
            self.txtLunchBreakFrom.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "4" {
            self.txtLunchBreakTo.text = "\(result)"
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagMonthYearPickerDidCancel(_ viewController: SambagMonthYearPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension SetYourAvailability: SambagDatePickerViewControllerDelegate {

    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        
        if strCheckWhichTextField == "0" {
            self.txtWorkingTimeFrom.text = ""
            self.txtWorkingTimeTo.text = ""
        }
        else
        if strCheckWhichTextField == "1" {
            self.txtWorkingTimeFrom.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "2" {
            self.txtWorkingTimeTo.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "3" {
            self.txtLunchBreakFrom.text = "\(result)"
        }
        else
        if strCheckWhichTextField == "4" {
            self.txtLunchBreakTo.text = "\(result)"
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    /*func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }*/
}
