//
//  SetNicknameViewController.swift
//  duo
//
//  Created by 김록원 on 2021/02/09.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SetNicknameViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    let viewModel = SetNicknameViewModel()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    
    
    func setData(socialName : String) {
        viewModel.socialName = socialName
    }
    
    
    
    func setupUI() {
        nicknameTextField.rx
            .text
            .subscribe(onNext : { [weak self] text in
                var changedText = text
                if (text?.count ?? 0) > 10 {
                    changedText?.removeLast()
                    self?.nicknameTextField.text = changedText
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        startButton.rx
            .tap
            .subscribe(onNext : { [weak self] in
                self?.viewModel.requestSetNickname(nickname: self?.nicknameTextField.text ?? "")
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    
    
    func setupBinding() {
        viewModel.userEntity
            .subscribe(onNext : { [weak self] entity in
                self?.viewModel.saveUser(entity: entity)
                self?.dismiss(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
    }
    

}
