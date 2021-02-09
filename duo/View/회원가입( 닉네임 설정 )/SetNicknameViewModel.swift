//
//  SetNicknameViewModel.swift
//  duo
//
//  Created by 김록원 on 2021/02/09.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SetNicknameViewModel : ViewModel {
    
    let userUseCase = UserUseCase()
    var socialName = "kakao"
    
    let userEntity = PublishRelay<UserEntity>()
    
    override init() {
        super.init()
        
        setupBinding()
    }
    
    func setupBinding() {
    }
    
    func requestSetNickname(nickname : String) {
        var request = UserRequestEntity()
        request.nickname = nickname
        
        userUseCase.signUp(social: self.socialName, request: request)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] entity in
                self?.userEntity.accept(entity)
            },onFailure: { _ in})
            .disposed(by: disposeBag)
    }
    
    func saveUser(entity : UserEntity?) {
        userUseCase.saveUser(entity: entity)
    }
    
    
}
