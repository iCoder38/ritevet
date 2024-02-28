//
//  all_reviews.swift
//  RiteVet
//
//  Created by Dishant Rajput on 05/06/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class all_reviews: UIViewController {
    
    var str_get:String! = ""
    
    var str_back:String!
    var str_review_user_id:String!
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    var arr_review_list:NSMutableArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Reviews"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // tbleView.delegate = self
            // tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = UIColor.init(red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbleView.separatorColor = .black
        
        // str_review_user_id
        
        if (self.str_back == "back") {
          
            self.booking(page_number: 1,
                         str_user_id: String(self.str_review_user_id))
            
            self.btnBack.addTarget(self, action: #selector(backClick_method), for: .touchUpInside)
            
        } else {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                self.booking(page_number: 1,
                             str_user_id: String(myString))
                
            }
            
            self.sideBarMenu()
            
        }
        
        self.view.backgroundColor = UIColor.init(red: 7.0/255.0, green: 30.0/255.0, blue: 86.0/255.0, alpha: 1)

    }
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func backClick_method() {
        self.navigationController?.popViewController(animated: true)
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
                    
                    if (self.str_back == "back") {
                        
                        self.booking(page_number: page,
                                     str_user_id: String(self.str_review_user_id))
                        
                        self.btnBack.addTarget(self, action: #selector(backClick_method), for: .touchUpInside)
                        
                    } else {
                        
                        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                            let x : Int = (person["userId"] as! Int)
                            let myString = String(x)
                            
                            self.booking(page_number: page,
                                         str_user_id: String(myString))
                            
                        }
                        
                        self.sideBarMenu()
                        
                    }
                    
                }
            }
        }
    }
    
    @objc func booking(page_number:Int,
                       str_user_id:String) {
        
        if page_number == 1 {
            Utils.RiteVetIndicatorShow()
        }
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
         
            parameters = [
                "action"    :   "reviewlist",
                "userId"    :   String(str_user_id),
                "pageNo"    :   page_number,
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
                        Utils.RiteVetIndicatorHide()
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        // self.arr_review_list = (ar as! Array<Any>)
                        self.arr_review_list.addObjects(from: ar as! [Any])
                        
                        if self.arr_review_list.count == 0 {
                            
                            self.tbleView.isHidden = true
                            
                            var noDataLbl : UILabel!
                            noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 290, height: 70))
                            noDataLbl?.textAlignment = .center
                            noDataLbl?.font = UIFont(name: "Poppins-Semibold", size: 18.0)
                            noDataLbl?.numberOfLines = 0
                            noDataLbl?.text = "No data found."
                            noDataLbl?.lineBreakMode = .byTruncatingTail
                            noDataLbl?.center = self.view.center
                            self.view.addSubview(noDataLbl!)
                            
                        } else {
                            
                            self.tbleView.isHidden = false
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            self.loadMore = 1
                            
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

extension all_reviews: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_review_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:all_reviews_table_cell = tableView.dequeueReusableCell(withIdentifier: "all_reviews_table_cell") as! all_reviews_table_cell
        
        cell.backgroundColor = .clear
        
        let item = self.arr_review_list[indexPath.row] as? [String:Any]
        print(item as Any)
        
        cell.lbl_to_name.text = (item!["From_userName"] as! String)
        cell.lbl_message.text = (item!["message"] as! String)
        
        cell.img_profile.sd_setImage(with: URL(string: (item!["From_profile_picture"] as! String)), placeholderImage: UIImage(named: "logo-500"))
        
        if "\(item!["star"]!)" == "1" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if "\(item!["star"]!)" == "2" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if "\(item!["star"]!)" == "3" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if "\(item!["star"]!)" == "4" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
        }
        
        print(TimeZone.current.abbreviation()!)
        
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
            cell.lbl_date_time.text = String(self.str_get)
        } else {
            cell.lbl_date_time.text = String("")
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_review_list[indexPath.row] as? [String:Any]
        
        let alert = UIAlertController(title: (item!["To_userName"] as! String), message: (item!["message"] as! String), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
 

class all_reviews_table_cell: UITableViewCell {

    @IBOutlet weak var lbl_date_time:UILabel!
    @IBOutlet weak var lbl_to_name:UILabel!
    
    @IBOutlet weak var lbl_message:UILabel!
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.borderColor = UIColor.black.cgColor
            img_profile.layer.borderWidth = 2
        }
    }
    
    @IBOutlet weak var btn_star_one:UIButton! {
        didSet {
            btn_star_one.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var btn_star_two:UIButton! {
        didSet {
            btn_star_two.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var btn_star_three:UIButton! {
        didSet {
            btn_star_three.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var btn_star_four:UIButton! {
        didSet {
            btn_star_four.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var btn_star_five:UIButton! {
        didSet {
            btn_star_five.tintColor = .systemOrange
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
