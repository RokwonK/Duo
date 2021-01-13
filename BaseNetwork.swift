//
//  ApiBase.swift
//  duo
//
//  Created by 김록원 on 2021/01/06.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import Alamofire

class BaseNetwork : NSObject {
    
    func requestGet<T : Codable>(type : T.Type, param : T.Type? = nil, success : ( () -> Void)?, failure : ( () -> Void )?) {
        
        let header = UserDefaults.standard.string(forKey: "user_token")
        print("헤더 : ", header ?? "")
        
        
    }
    
}
