//
//  MemberUseCase.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserUseCase : NSObject {
    let userDatabase = UserDatabase()
    let userNetwork = UserNetwork()
    
    // 넷통신 ( 유저 정보 가져오기 )
    func getUser(social : String) -> Observable<ApiResult<UserEntity,ApiErrorMessage>> {
        return userNetwork.getUser(social: social)
    }
    
    // 넷통신 ( 유저 정보 수정 )
    func patchUser() {
        
    }
    
    // 넷통신 ( 유저 탈퇴 )
    func deleteUser() {
        
    }
    
    // DB ( 유저 정보 저장 )
    func saveUser() {
        
    }
    
    // DB ( 유저 정보 가져오기 )
    func loadUser() {
    }
    
    // DB ( 유저 로그아웃 )
    func logoutUser() {
        
    }
}
