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
    
    var arr_review_list:Array<Any>!
    
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
        
//        self.btnBack.addTarget(self, action: #selector(backClick_method), for: .touchUpInside)
        
        self.view.backgroundColor = UIColor.init(red: 7.0/255.0, green: 30.0/255.0, blue: 86.0/255.0, alpha: 1)
        
        self.sideBarMenu()
        
        self.booking()
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
    
    @objc func booking() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    :   "reviewlist",
                "userId"    :   myString,
                "pageNo"    :   "0",
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
                        Utils.RiteVetIndicatorHide()
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arr_review_list = (ar as! Array<Any>)
                        
                        self.tbleView.isHidden = false
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
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
        
        cell.lbl_to_name.text = (item!["To_userName"] as! String)
        cell.lbl_message.text = (item!["message"] as! String)
        
        cell.img_profile.sd_setImage(with: URL(string: (item!["To_profile_picture"] as! String)), placeholderImage: UIImage(named: "logo-500"))
        
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
