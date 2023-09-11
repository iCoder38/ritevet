//
//  RequestVeterianaryService.swift
//  RiteVet
//
//  Created by Apple  on 02/12/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class RequestVeterianaryService: UIViewController {

    let cellReuseIdentifier = "requestVeterinaryServiceTableCell"
    
    var arrSubscription = [
    "1","2"
    ]
    
    var getBusinessType :String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "REQUEST VETERINARY SERVICE"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        if (self.getBusinessType == "2") {
            self.lblNavigationTitle.text = "REQUEST VETERINARY SERVICES"
        } else {
            self.lblNavigationTitle.text = "REQUEST OTHER PET SERVICES"
        }
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
    
    
    
}

extension RequestVeterianaryService: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RequestVeterinaryServiceTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RequestVeterinaryServiceTableCell
        
        cell.backgroundColor = .clear
        
        if self.getBusinessType == "2" {
            
            if indexPath.row == 0 {
                cell.imgRequestVeterinaryService.image = UIImage(named: "rvs1")
            }
            else
            if indexPath.row == 1 {
                cell.imgRequestVeterinaryService.image = UIImage(named: "rvs2")
            }
            else
            if indexPath.row == 2 {
                cell.imgRequestVeterinaryService.image = UIImage(named: "rvs3")
            }
            
        } else {
            
            if indexPath.row == 0 {
                cell.imgRequestVeterinaryService.image = UIImage(named: "rvs4")
            }
            else
            if indexPath.row == 1 {
                cell.imgRequestVeterinaryService.image = UIImage(named: "rvs5")
            }
            else
            if indexPath.row == 2 {
                cell.imgRequestVeterinaryService.image = UIImage(named: "rvs6")
            }
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        
         
        
        if self.getBusinessType == "2" {
        
            // print(indexPath.row as Any)
            
            let x : Int = indexPath.row+1
            let myString = String(x)
            
            let defaults = UserDefaults.standard
            defaults.set(myString, forKey: "selectedBusinessIdIs")
            
            print(myString)
            print(self.getBusinessType as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestServiceHomeId") as? RequestServiceHome
            
            push!.strGetRequestServiceHome = String(self.getBusinessType)
            push!.selectServiceType = String(myString)
            
            if indexPath.row == 0 {
                push!.str_type_of_business = "1"
                push!.str_took_payment = "no"
                
            } else if indexPath.row == 1 {
                push!.str_type_of_business = "2"
                push!.str_took_payment = "yes"
                
            } else {
                push!.str_type_of_business = "3"
                push!.str_took_payment = "yes"
                
            }
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            
            if indexPath.row == 0 {
                
                let defaults = UserDefaults.standard
                defaults.set("4", forKey: "selectedBusinessIdIs")
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestServiceHomeId") as? RequestServiceHome
                push!.strGetRequestServiceHome = getBusinessType
                push!.strSubCategoryId = "3.1"
                
                push!.str_type_of_business = "4"
                push!.str_took_payment = "no"
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else if indexPath.row == 1 {
                
                let defaults = UserDefaults.standard
                defaults.set("5", forKey: "selectedBusinessIdIs")
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestServiceHomeId") as? RequestServiceHome
                push!.strGetRequestServiceHome = getBusinessType
                push!.strSubCategoryId = "3.2"
                
                push!.str_type_of_business = "5"
                push!.str_took_payment = "no"
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                
                let defaults = UserDefaults.standard
                defaults.set("6", forKey: "selectedBusinessIdIs")
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestServiceHomeId") as? RequestServiceHome
                push!.strGetRequestServiceHome = getBusinessType
                push!.strSubCategoryId = "3.3"
                
                push!.str_type_of_business = "6"
                push!.str_took_payment = "no"
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
                        
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250
    }
}

extension RequestVeterianaryService: UITableViewDelegate
{
    
}
