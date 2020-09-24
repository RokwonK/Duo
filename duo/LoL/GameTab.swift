//
//  GameTab.swift
//  duo
//
//  Created by 황윤재 on 2020/08/25.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class GameViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ad = UIApplication.shared.delegate as? AppDelegate
        ad!.record = 0
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func Lol(_ sender: Any) {
        
    }
    
    @IBAction func Battleground(_ sender: Any) {
        
    }
    
    @IBAction func Overwatch(_ sender: Any) {
        
    }
    
    
}
