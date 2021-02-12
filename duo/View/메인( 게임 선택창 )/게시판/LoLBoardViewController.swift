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
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var dummyView: UIView!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var writeNewPostButton: UIButton!
    
    let viewModel = LoLboardViewModel()
    let mainColor : CGColor = .init(srgbRed: 50/255, green: 110/255, blue: 249/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUILayer()
        setupCollectionBinding()
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
        
        writeButton.layer.cornerRadius = 30
        writeButton.setShadow(color: .init(srgbRed: 0, green: 0, blue: 0, alpha: 1), width: 1, height: 1, opacity: 0.5, radius: 3)
        writeNewPostButton.layer.cornerRadius = 20
    }
    
    
    
    func setupCollectionBinding() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: UIScreen.main.bounds.width, height: LoLBoardCell.getHeight())
        
        collectionView.register(UINib(nibName: "LoLBoardCell", bundle: nil), forCellWithReuseIdentifier: "LoLBoardCell")
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
                self?.showFilterView()
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
        
        // 글쓰기 버튼 탭
        writeButton.rx
            .tap
            .subscribe(onNext : { [weak self] in
                self?.switchWriteButtonState()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    
    
    func switchButtonState(btn : UIButton?) {
        let state = btn?.isSelected ?? false
        
        btn?.isSelected = !state
        btn?.tintColor = !state ? .white : .init(cgColor: mainColor)
        btn?.backgroundColor = !state ? .init(cgColor: mainColor) : .white
    }
    
    
    
    func switchWriteButtonState() {
        writeButton.isSelected = !writeButton.isSelected
        dummyView.isHidden = !dummyView.isHidden
        
        if writeButton.isSelected {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.3,
                           options: [],
                           animations: { [weak self] in
                            self?.writeNewPostButton.transform = CGAffineTransform(translationX: 0, y: -100)
                            self?.dummyView.alpha = 0.4
                           },
                           completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.3,
                           animations: { [weak self] in
                            self?.writeNewPostButton.transform = CGAffineTransform(translationX: 0, y: 0)
                            self?.dummyView.alpha = 0.0
                           })
        }
    }
    
    
    
    func showFilterView() {
        let filterView = FilterViewController()
        filterView.modalPresentationStyle = .fullScreen
        self.present(filterView, animated: true)
    }
    
}

extension LoLBoardViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoLBoardCell", for: indexPath) as! LoLBoardCell
        
        return cell
    }
}
