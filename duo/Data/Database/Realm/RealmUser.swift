//
//  RealmUser.swift
//  duo
//
//  Created by 김록원 on 2021/01/03.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RealmSwift

class RealmUser : Object, CodableProtocol {
    @objc dynamic var userToken : String?
    let userId = RealmOptional<Int>()
    @objc dynamic var nickname : String?
    @objc dynamic var conLOL : String?
    @objc dynamic var conBG : String?
    @objc dynamic var conOW : String?
}
