//
//  BaseApi.swift
//  duo
//
//  Created by 김록원 on 2021/01/26.
//  Copyright © 2021 김록원. All rights reserved.
//
import UIKit
import Alamofire

class BaseApi : NSObject {
    
    static let host = "\(BaseValue.baseurl)/"
    
    var url = ""
    var method : HTTPMethod = HTTPMethod.get
    var pathValues : [String : String]?
    
    func getURL() -> URL {
        if let pathValues = pathValues {
            pathValues.forEach { [weak self] item in
                
                // url을 읽을 수 있는 것으로 변형(한국어 같은것을 바꾸어주는것)
                if let value = item.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                    url = url.replacingOccurrences(of: "{\(item.key)}", with: value)
                }
            }
        }
        
        return URL(string: url) ?? URL(string: BaseValue.baseurl)!
    }

}
