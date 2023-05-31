//
//  BookAnAppointment.swift
//  RiteVet
//
//  Created by evs_SSD on 1/6/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BookAnAppointment: UIViewController {

    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "BOOK AN APPOINTMENT"
            lblNavigationTitle.textColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
