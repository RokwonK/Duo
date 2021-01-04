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
    @objc dynamic var userToken : String?
    @objc dynamic var nickname : String?
    dynamic var userId : Int?
}
