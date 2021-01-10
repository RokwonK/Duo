//
//  TabBarViewController.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import SnapKit

class TabBarViewController : UITabBarController {
    
    var tabBarView : TabBarView?
    
    let homeView = HomeViewController()
    let ChatView = ChatViewController()
    let profileView = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // layout 배치
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let view = tabBarView {
            view.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(50+self.view.safeAreaInsets.bottom)
            }
        }
    }
    
    // tabBar 불러옴
    func setupUI() {
        self.viewControllers = [homeView, ChatView, profileView]
        if let tabBar = Bundle.main.loadNibNamed("TabBarView", owner: self, options: nil)?.first as? TabBarView {
            self.view.addSubview(tabBar)
            self.tabBarView = tabBar
            tabBar.touchTab = { [weak self] (idx) in
                self?.selectedIndex = idx
            }
        }
    }
    
}
