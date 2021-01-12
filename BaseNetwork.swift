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
    
    func requestGet<T : Codable>(type : T.Type, success : ( () -> Void)?, failure : ( () -> Void )?) {
//        AF.request(<#T##convertible: URLConvertible##URLConvertible#>,
//                   method: <#T##HTTPMethod#>,
//                   parameters: <#T##Encodable?#>,
//                   encoder: <#T##ParameterEncoder#>,
//                   headers: <#T##HTTPHeaders?#>,
//                   interceptor: <#T##RequestInterceptor?#>,
//                   requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>)           
        
    }
    
}
