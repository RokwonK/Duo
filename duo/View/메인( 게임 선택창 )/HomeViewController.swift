//
//  HomeViewController.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var lolView: UIView!
    @IBOutlet weak var lolButton: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgButton: UIButton!
    
    @IBOutlet weak var owView: UIView!
    @IBOutlet weak var owButton: UIButton!
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayer()
        setupUI()
    }
    
    func setupLayer() {
        lolView.layer.borderWidth = 1
        lolView.layer.borderColor = .init(srgbRed: 50/255, green: 110/255, blue: 249/255, alpha: 1)
        lolView.layer.cornerRadius = 2
        
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = .init(srgbRed: 50/255, green: 110/255, blue: 249/255, alpha: 1)
        bgView.layer.cornerRadius = 2
        
        owView.layer.borderWidth = 1
        owView.layer.borderColor = .init(srgbRed: 50/255, green: 110/255, blue: 249/255, alpha: 1)
        owView.layer.cornerRadius = 2
    }
    
    func setupUI() {
        lolButton.rx
            .tap
            .subscribe(onNext : {
                // 게시판으로
            })
            .disposed(by: viewModel.disposeBag)
        
        bgButton.rx
            .tap
            .subscribe(onNext : {
                print("준비 중입니다.")
            })
            .disposed(by: viewModel.disposeBag)
        
        owButton.rx
            .tap
            .subscribe(onNext : {
                print("준비 중입니다.")
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    

}
