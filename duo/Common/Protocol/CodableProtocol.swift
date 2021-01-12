//
//  CodableProtocol.swift
//  duo
//
//  Created by 김록원 on 2021/01/12.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RealmSwift

protocol CodableProtocol : Codable{
    func toRealm<T : CodableProtocol> (type : Codable) -> T?
}
