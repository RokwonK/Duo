//
//  MemberEntity.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

struct UserEntity : CodableProtocol {
    var user_token : String?
    var user_id : String?
    var nickname : String?
    var con_lol : String?
    var con_er : String?
    var con_bg : String?
    var con_ow : String?
    
    func toJSON() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
