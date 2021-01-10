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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            
            self?.moveTabBarView()
            // Realm에 값이 있는지 없는지 찾아봄 있으면 바로 tabBar로 없으면 로그인뷰 띄우고 뒤에서 tab바로
//            self?.showLoginView()
//            
//            if let tabBar = self?.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? TabBarControllerView {
//                print("이건 찍혀야지")
//                
//                self?.navigationController?.pushViewController(tabBar, animated: true)
//            }
        })
    }
    
    func moveTabBarView() {
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
    
}
