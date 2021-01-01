//
//  TabBarController.swift
//  duo
//
//  Created by 황윤재 on 2020/08/23.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class TabBarControllerView: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        self.tabBar.barTintColor = UIColor.white;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
