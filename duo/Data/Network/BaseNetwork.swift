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
    
    func requestGet<T : Codable>(api : BaseApi, responseType : T.Type, param : [String:Any] ,  success : ( (T.Type?) -> Void)?, failure : ( () -> Void )?) {
        
        let header = UserDefaults.standard.string(forKey: "user_token") ?? ""
        let headers : HTTPHeaders = ["Authorization" : header]
        let request = AF.request(api.getURL(),
                                 method: api.method,
                                 parameters: param,
                                 encoding: JSONEncoding.default,
                                 headers: headers,
                                 interceptor: nil).validate(statusCode: 200..<300)
        
        
        request.responseData { response in
            switch response.result {
            case .success(let data):
                let entity = try? JSONDecoder().decode(responseType, from: data) as? T.Type
                success?(entity)
            case .failure(let error):
                print("Error Code", error)
            }
        }
    }
}
