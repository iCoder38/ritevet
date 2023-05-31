//
//  CheckAvailaibility.swift
//  RiteVet
//
//  Created by Apple  on 28/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class CheckAvailaibility: UIViewController {

    let cellReuseIdentifier = "checkAvailibilityTableCell"
    
    var arrTimeText = [
                        "10:00 am - 12:00 am",
                        "12:00 am - 02:00 pm",
                        "02:00 am - 04:00 pm",
                        "04:00 am - 06:00 pm",
                        "06:00 am - 07:00 pm",
                        "08:00 am - 10:00 pm",
                        "10:00 am - 12:00 pm"
                        ]
    
    var totalCellInTableView = [
                            "1",
                            "2",
                            "3",
                            "4",
                            "5",
                            "6",
                            "7"
                            ]
    
    var strSelectedDate:String!
    
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            
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
//        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.view.backgroundColor = .white
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        lblNavigationTitle.text = String(strSelectedDate)
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
    
}

extension CheckAvailaibility: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return totalCellInTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CheckAvailibilityTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CheckAvailibilityTableCell
        
        cell.backgroundColor = .clear
        
        
        /****** FINISH BUTTON *********/
        cell.btnCheck.backgroundColor = .systemRed
        cell.btnCheck.layer.cornerRadius = 4
        cell.btnCheck.clipsToBounds = true
        cell.btnCheck.setTitleColor(.white, for: .normal)
        cell.btnCheck.addTarget(self, action: #selector(DoneClickMethod), for: .touchUpInside)
        
        cell.lblTime.text = arrTimeText[indexPath.row]
        cell.lblTime.textColor = .black
        cell.btnCheck.setTitle(" Availaible ", for: .normal)
        
        return cell
    }
    
    @objc func DoneClickMethod() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CheckAvailaibility: UITableViewDelegate
{
    
}
