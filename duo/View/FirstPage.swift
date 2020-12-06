//
//  File.swift
//  duo
//
//  Created by 황윤재 on 2020/12/06.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class FirstPage: UIViewController{
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 7;
        loginButton.layer.masksToBounds = true;
//        loginButton.backgroundColor = UIColor.white
        loginButton.tintColor = UIColor(displayP3Red: 71/255, green: 123/255, blue: 209/255, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    
    
}
