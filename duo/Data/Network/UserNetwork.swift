//
//  UserNetwork.swift
//  duo
//
//  Created by 김록원 on 2021/01/26.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserNetwork : BaseNetwork {
    
    func getUser(social : String) -> Observable<ApiResult<UserEntity,ApiErrorMessage>>{
        return request(method: .post,
                       addPath: "/auth/\(social)",
                       responseType: UserEntity.self)
    }
    
    func patchUser() {
        
    }
    
    // 넷통신 ( 유저 탈퇴 )
    func deleteUser() {
        
    }
    
}
