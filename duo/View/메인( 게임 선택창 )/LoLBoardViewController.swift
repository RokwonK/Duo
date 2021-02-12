//
//  LoLBoardViewController.swift
//  duo
//
//  Created by 김록원 on 2021/02/11.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoLBoardViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var recruitButton: UIButton!
    @IBOutlet weak var mikeButton: UIButton!
    
    let viewModel = LoLboardViewModel()
    let mainColor : CGColor = .init(srgbRed: 50/255, green: 110/255, blue: 249/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUILayer()
        setupUIBinding()
    }
    
    
    
    func setupUILayer() {
        filterButton.layer.cornerRadius = 2
        recruitButton.layer.cornerRadius = 2
        mikeButton.layer.cornerRadius = 2
        
        recruitButton.layer.borderWidth = 1
        mikeButton.layer.borderWidth = 1
        
        recruitButton.setTitleColor(.init(cgColor: mainColor), for: .normal)
        recruitButton.setTitleColor(.white, for: .selected)
        mikeButton.setTitleColor(.init(cgColor: mainColor), for: .normal)
        mikeButton.setTitleColor(.white, for: .selected)
        
        recruitButton.layer.borderColor = mainColor
        recruitButton.tintColor = .init(cgColor: mainColor)
        recruitButton.backgroundColor = .white
        
        mikeButton.layer.borderColor = mainColor
        mikeButton.tintColor = .init(cgColor: mainColor)
        mikeButton.backgroundColor = .white
    }
    
    
    
    func setupUIBinding() {
        
        // 뒤로가기버튼 탭
        backButton.rx
            .tap
            .subscribe(onNext : { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
        
        // 필터버튼 탭
        filterButton.rx
            .tap
            .subscribe(onNext : { [weak self] in
                
            })
            .disposed(by: viewModel.disposeBag)
        
        // 모집중 버튼 탭
        recruitButton.rx
            .tap
            .subscribe(onNext : { [weak self] in
                self?.switchButtonState(btn: self?.recruitButton)
            })
            .disposed(by: viewModel.disposeBag)
        
        // 마이크 버튼 탭
        mikeButton.rx
            .tap
            .subscribe(onNext : { [weak self] in
                self?.switchButtonState(btn: self?.mikeButton)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    
    
    func switchButtonState(btn : UIButton?) {
        let state = btn?.isSelected ?? false
        
        btn?.isSelected = !state
        btn?.tintColor = !state ? .white : .init(cgColor: mainColor)
        btn?.backgroundColor = !state ? .init(cgColor: mainColor) : .white
    }
    
}

//extension LoLBoardViewController : UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
