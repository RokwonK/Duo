//
//  SplashViewController.swift
//  duo
//
//  Created by 김록원 on 2021/01/02.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

class SplashViewController : UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    let tabBar = TabBarViewController()
    let viewModel = TabBarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        mainImage.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.mainImage.alpha = 1
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5,
                                      execute: { [weak self] in
                                        if UserDefaults.standard.string(forKey: "userToken") == nil {
                                            self?.showLoginView()
                                        }
                                        self?.showTabBarView()
                                      })
    }
    
    func showTabBarView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,
                                      execute: { [weak self] in
                                        guard let `self` = self else {return}
                                        self.navigationController?.pushViewController(self.tabBar, animated: true)
                                      })
    }
    
}
