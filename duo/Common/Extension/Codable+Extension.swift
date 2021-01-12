//
//  Codable+Extension.swift
//  duo
//
//  Created by 김록원 on 2021/01/12.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

extension Encodable {
    func toJSON() -> Data?{
        return try? JSONEncoder().encode(self)
    }
}

extension Decodable {
    
}
