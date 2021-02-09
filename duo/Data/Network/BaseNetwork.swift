//
//  ApiBase.swift
//  duo
//
//  Created by 김록원 on 2021/01/06.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift

class BaseNetwork : NSObject {
    
    func request<T : Codable>(
        method : HTTPMethod,
        addPath : String,
        param : Codable? = nil,
        responseType : T.Type
    ) -> Single<T> {
        
        let headers : HTTPHeaders? = ["Authorization": UserDefaults.standard.string(forKey: "userToken") ?? ""]
        
        return RxAlamofire
            .request(method, BaseValue.baseurl + addPath,
                            parameters: param?.toDictionary(),
                            encoding: URLEncoding.default,
                            headers: headers)
            .validate(statusCode: 200...300)
            .responseData()
            .mappingObject(type: responseType)
    }

}

extension Observable where Element == (HTTPURLResponse, Data){
    fileprivate func mappingObject<T : Codable>(type: T.Type) -> Single<T>{
        return self.map{ (_, data) -> T in
            if let object = try? JSONDecoder().decode(type, from: data) {
                return object
            }
            
            // code만 뽑기 위해서
            let error = try JSONDecoder().decode(ApiErrorMessage.self, from: data)
            let errorJson = try JSONEncoder().encode(error)
            return try JSONDecoder().decode(type, from: errorJson)
            
        }.asSingle()
    }
}


enum ApiResult<Value, Error>{
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }

}

struct ApiErrorMessage: Codable{
    var msg: String?
    var code: Int?
    
    init(msg : String?, code : Int?) {
        self.msg = msg
        self.code = code
    }
}
