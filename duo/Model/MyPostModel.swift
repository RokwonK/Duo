//
//  MyPostModel.swift
//  duo
//
//  Created by 황윤재 on 2020/09/25.
//  Copyright © 2020 김록원. All rights reserved.
//

import Foundation

class MyPostModel {
    
    static let sharedInstance = MyPostModel()
    
    var postsData : Array<Dictionary<String, Any>>?;
    let eachTier : Array<String> = ["i", "b", "s", "g", "p", "d", "m", "gm", "c"];
}
