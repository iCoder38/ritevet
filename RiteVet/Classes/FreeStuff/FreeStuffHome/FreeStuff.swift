//
//  FreeStuff.swift
//  RiteVet
//
//  Created by Apple  on 02/12/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class FreeStuff: UIViewController {

    let cellReuseIdentifier = "freeStuffTableCell"
    
    @IBOutlet weak var viewNavigation:UIView! {
          didSet {
              viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
          }
      }
      @IBOutlet weak var btnBack:UIButton!
      @IBOutlet weak var lblNavigationTitle:UILabel! {
          didSet {
              lblNavigationTitle.text = "FREE STUFF"
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
           
        self.tbleView.separatorColor = .clear
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
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

extension FreeStuff: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FreeStuffTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FreeStuffTableCell
        
        cell.backgroundColor = .clear
    
        cell.btnFreeStuffHome.tag = indexPath.row
        
        if indexPath.row == 0 {
            Utils.buttonDR(button: cell.btnFreeStuffHome, text: "BROWSE FREE STUFF", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
            cell.btnFreeStuffHome.addTarget(self, action: #selector(freeStuffHomeClickMethod), for: .touchUpInside)
        }
        else
        if indexPath.row == 1 {
            Utils.buttonDR(button: cell.btnFreeStuffHome, text: "POST FREE STUFF", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
            cell.btnFreeStuffHome.addTarget(self, action: #selector(freeStuffHomeClickMethod), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func freeStuffHomeClickMethod(_ sender:UIButton) {
        
        if sender.tag == 0 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FreeStuffPageId") as? FreeStuffPage
            self.navigationController?.pushViewController(push!, animated: true)
        } else if sender.tag == 1 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubmitPostId") as? SubmitPost
            self.navigationController?.pushViewController(push!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FreeStuffPageId") as? FreeStuffPage
        //self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension FreeStuff: UITableViewDelegate {
    
}
