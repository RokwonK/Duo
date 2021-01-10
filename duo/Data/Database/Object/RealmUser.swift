//
//  RealmUser.swift
//  duo
//
//  Created by 김록원 on 2021/01/03.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RealmSwift

class RealmUser : Object, Codable {
    @objc dynamic var user_token : String?
    @objc dynamic var user_id : String?
    @objc dynamic var nickname : String?
    @objc dynamic var con_lol : String?
    @objc dynamic var con_er : String?
    @objc dynamic var con_bg : String?
    @objc dynamic var con_ow : String?
}
