//
//  AccountTab.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func goto_loginpage () {
     let storyBoard = self.storyboard!
     let loginpage = storyBoard.instantiateViewController(withIdentifier: "loginpage") as! ViewController
     present(loginpage, animated: true, completion: nil)
    }
    
     @IBAction func Logout(_sender : UIButton){
        ViewController().naverLogout()
        ViewController().kakaoLogout()
        ViewController().googleLogout()
        
        goto_loginpage()
    }
    @IBAction func DeleteAccount(_ sender: Any) {
        
    }
}
