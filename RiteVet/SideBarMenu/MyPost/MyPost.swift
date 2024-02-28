//
//  MyPost.swift
//  RiteVet
//
//  Created by evs_SSD on 1/9/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyPost: UIViewController {
    var str_get:String! = ""
    let cellReuseIdentifier = "myPostTableCell"
    
    var arrListOfMyPost:Array<Any>!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MY POST"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
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
        // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        self.sideBarMenu()
        
        
    }
    @objc func sideBarMenu() {
            if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
                revealViewController().rearViewRevealWidth = 300
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     navigationController?.setNavigationBarHidden(true, animated: animated)
        myPost()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func myPost() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            
            parameters = [
                "action"       :   "stufflist",
                "userId"       :   myString,// login id
                "pageNo"       :   "",
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
                    
                    if strSuccess == "success" //true
                    {
                        Utils.RiteVetIndicatorHide()
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfMyPost = (ar as! Array<Any>)
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        
                    }
                    else
                    {
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

extension MyPost: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrListOfMyPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MyPostTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyPostTableCell
        
        cell.backgroundColor = .clear
        
        /*
         categoryId = 18;
         categoryName = Bird;
         created = "2020-01-02 18:21:00";
         description = does;
         "image_1" = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/freestaff/1577969474riteVetImage.jpg";
         "image_2" = "";
         "image_3" = "";
         "image_4" = "";
         "image_5" = "";
         postTitle = title;
         staffId = 92;
         totalComment = 0;
         userImage = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/users/1578568990riteVetImage.jpg";
         userName = "Dishant Rajput";
         video = "";
         */
        
        let item = arrListOfMyPost[indexPath.row] as? [String:Any]
        print(item as Any)
         // image
        cell.imgProfile.sd_setImage(with: URL(string: (item!["userImage"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
         // title
        cell.lblTitle.text = (item!["postTitle"] as! String)
        
        
        
        // message
        cell.lblMessage.text = (item!["description"] as! String)
        
        if (item!["added_time"] as! String) != "" {
            // divide time
            let fullName    = (item!["added_time"] as! String)
            let fullNameArr = fullName.components(separatedBy: " ")

            let normal_date    = fullNameArr[0]
            let surname = fullNameArr[1]
            
            // print(normal_date as Any)
            // print(surname as Any)
            
            // divide sub time
            let divide_time = surname.components(separatedBy: ":")
            let time_hour    = divide_time[0]
            let time_minute = divide_time[1]
            
            // print(time_hour as Any)
            // print(time_minute as Any)
            
            let joiin_and_create_new_time = time_hour+":"+time_minute
            // print(joiin_and_create_new_time as Any)
            
            let dateAsString = String(joiin_and_create_new_time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            // print(Date12)
            
            // print(date24 as Any)
            let commenter_time_zone = (item!["current_time_zone"] as! String)
            let commenter_watcher_time_zone = "\(TimeZone.current.abbreviation()!)"
            // print(commenter_time_zone)
            // print(commenter_watcher_time_zone)
            
            let timeFormatterGet = DateFormatter()
            timeFormatterGet.dateFormat = "yyyy-MM-dd h:mm a"
            // timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
            timeFormatterGet.timeZone = TimeZone(abbreviation: "\(commenter_time_zone)")
            
            let timeFormatterPrint = DateFormatter()
            timeFormatterPrint.dateFormat = "yyyy-MM-dd h:mm a"
            timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(commenter_watcher_time_zone)")
            
            // timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(TimeZone.current.abbreviation()!)\(TimeZone.current.currentTimezoneOffset())") // if you want to specify timezone for output, otherwise leave this line blank and it will default to devices timezone

            let join_date_and_time_together = String(normal_date)+" "+String(Date12)
            // print(join_date_and_time_together)
            
            
            if let date = timeFormatterGet.date(from: "\(join_date_and_time_together)") {
                print(timeFormatterPrint.string(from: date))
                self.str_get = timeFormatterPrint.string(from: date)
            } else {
               print("There was an error decoding the string")
            }
            
            print(str_get as Any)
            cell.lblDate.text = String(self.str_get)
        } else {
            cell.lblDate.text = ""
        }
        // date
        
        cell.lblDate.textColor = NAVIGATION_BACKGROUND_COLOR
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // getFreeStuffDict
        let item = arrListOfMyPost[indexPath.row] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyPostDetailsId") as? MyPostDetails
        push!.getFreeStuffDict = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
}

extension MyPost: UITableViewDelegate
{
    
}
