//
//  UIViewController+Extension.swift
//  duo
//
//  Created by 김록원 on 2021/01/02.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showLoginView() {        
        let loginView = LoginViewController()
        
        let navi = UINavigationController(rootViewController: loginView)
        navi.setNavigationBarHidden(true, animated: false)
        navi.modalPresentationStyle = .fullScreen
        
        self.present(navi, animated: true, completion: nil)
    }
    
}
