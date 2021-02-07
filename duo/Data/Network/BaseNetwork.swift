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
    ) -> Observable<ApiResult<T,ApiErrorMessage>> {
        
        let headers : HTTPHeaders? = ["Authorization": UserDefaults.standard.string(forKey: "userToken") ?? ""]
        
        return RxAlamofire
            .request(method, BaseValue.baseurl + addPath,
                            parameters: param?.toDictionary(),
                            encoding: URLEncoding.default,
                            headers: headers)
            .responseData()
            .mappingObject(type: responseType)
    }

}

extension Observable where Element == (HTTPURLResponse, Data){
    fileprivate func mappingObject<T : Codable>(type: T.Type) -> Observable<ApiResult<T, ApiErrorMessage>>{
        return self.map{ (httpURLResponse, data) -> ApiResult<T, ApiErrorMessage> in
            
            
            if let object = try? JSONDecoder().decode(type, from: data){
                return .success(object)
            }
            if let object = try? JSONDecoder().decode(ApiErrorMessage.self, from: data) {
                return .failure(object)
            }
            return .failure(ApiErrorMessage(msg : "server error", code: -501))
        }
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
