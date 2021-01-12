//
//  MemberDatabase.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

class UserDatabase : NSObject {
    
    let realm = RealmManager.shared
    
    // RealmUser를 MemberEntity로 바꾸어서 return
    func select() -> UserEntity? {
        return realm.select(RealmUser.self).first?.toEntity(type: UserEntity.self)
    }
    
    func update(user : UserEntity) {
        delete()
        
        
    }
    
    func delete() {
        if let user = realm.select(RealmUser.self).first {
            realm.delete(user)
            realm.save()
        }
    }
    
    
    
}
