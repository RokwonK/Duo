//
//  FilterPageModel.swift
//  duo
//
//  Created by 황윤재 on 2020/09/22.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit

class FilterModel {
    
    static let sharedInstance = FilterModel()
    
    var talkOn = 3 //기본설정 상관없음
    var headCount : Int = 1
    var Position = ["top":3,"mid":3, "jungle":3,"dealer":3, "support":3]
    var Time : String = ""
    var Mytiernumber : Int?
    var gameModeName : String =  ""
    
    let tierData : [String] = ["Iron 4","Iron 3","Iron 2","Iron 1","Bronze 4","Bronze 3","Bronze 2","Bronze 1","Silver 4","Silver 3","Silver 2","Silver 1","Gold 4","Gold 3","Gold 2","Gold 1","Platinum 4","Platinum 3","Platinum 2","Platinum 1","Diamond 4","Diamond 3","Diamond 2","Diamond 1","Master", "Grand Master", "Challenger"]
    let tierDataToInt : [Int] = [6,7,8,9,16,17,18,19,26,27,28,29,36,37,38,39,46,47,48,49,56,57,58,59,70,80,90]
    
    let AD = UIApplication.shared.delegate as? AppDelegate // appdelegate파일 참조
}
