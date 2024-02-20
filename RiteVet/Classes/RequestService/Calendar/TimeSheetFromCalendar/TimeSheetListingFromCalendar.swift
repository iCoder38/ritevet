//
//  TimeSheetListingFromCalendar.swift
//  RiteVet
//
//  Created by evs_SSD on 1/6/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import BottomPopup

class TimeSheetListingFromCalendar: BottomPopupViewController {

    let cellReuseIdentifier = "timeSheetForCalendarTableCell"
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var arrGetTime:Array<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(arrGetTime as Any)
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        // Create UserDefaults
        
    }
    
    // Bottom popup attribute methods
    // You can override the desired method to change appearance
    
      func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(300)
    }
    
      func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
     func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
      func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
      func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
}

extension TimeSheetListingFromCalendar: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGetTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:TimeSheetForCalendarTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TimeSheetForCalendarTableCell
        
        cell.backgroundColor = .clear
         
        let item = arrGetTime[indexPath.row] as? [String:Any]
        cell.lblTime.text = (item!["slot"] as! String)
           
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = arrGetTime[indexPath.row] as? [String:Any]
        
        let defaults = UserDefaults.standard
        defaults.set((item!["slot"] as! String), forKey: "keySelectedTimeIs")
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
}

extension TimeSheetListingFromCalendar: UITableViewDelegate
{
    
}

