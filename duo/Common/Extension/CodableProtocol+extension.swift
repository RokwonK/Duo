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
    func toRealm<T : CodableProtocol> (type : T.Type) -> T?
}

extension CodableProtocol {
    func toRealm<T : CodableProtocol> (type : T.Type) -> T? {
        let jsonData = try! JSONEncoder().encode(self)
        let realmEntity = try! JSONDecoder().decode(T.self, from: jsonData)
        
        return realmEntity
    }
}
