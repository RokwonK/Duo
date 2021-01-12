//
//  Object+Extension.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RealmSwift

extension Object {
    
    func toEntity<T : Codable>(type : T.Type) ->T? {
        
        // Codable을 상속하고 있는지
        if let `self` = self as? Codable, let jsondata = self.toJSON(){
            let entity = try! JSONDecoder().decode(T.self, from: jsondata)
            return entity
        }
        
        return nil
    }
    
}
