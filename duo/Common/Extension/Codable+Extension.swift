//
//  Codable+Extension.swift
//  duo
//
//  Created by 김록원 on 2021/01/12.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

extension Encodable {
    // JSON Data로
    func toJSON() -> Data?{
        return try? JSONEncoder().encode(self)
    }
    
    // Dictionary로
    func toDictionary() -> [String: Any] {
        if let data = try? JSONEncoder().encode(self),
           let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        {
            return dict
        }
         
        return [:]
    }
}

extension Decodable {
    
}
