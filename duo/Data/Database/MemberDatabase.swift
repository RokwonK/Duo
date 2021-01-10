//
//  MemberDatabase.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

class MemberDatabase : NSObject {
    
    let realm = RealmManager.shared
    
    func select() -> MemberEntity? {
        //realm.select(RealmUser.self).first
        return nil
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
    
    
    
}
