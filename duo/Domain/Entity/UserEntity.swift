//
//  MemberEntity.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

struct UserEntity : CodableProtocol {
    var userToken : String?
    var userId : Int?
    var nickname : String?
    var conLOL : String?
    var conBG : String?
    var conOW : String?
}

struct UserRequestEntity : Codable {
}
