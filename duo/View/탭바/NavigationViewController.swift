//
//  NavigationViewController.swift
//  duo
//
//  Created by 김록원 on 2021/02/12.
//  Copyright © 2021 김록원. All rights reserved.
//
import UIKit

class NavigationViewController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 2
    }
}
