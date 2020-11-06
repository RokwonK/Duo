//
//  BaseFunc.swift
//  duo
//
//  Created by 김록원 on 2020/09/04.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import CoreData

class BaseFunc : NSObject{
    static let baseurl = "http://ec2-18-222-143-156.us-east-2.compute.amazonaws.com:3000";
    static var userId : Int = 0;
    static var userNickname : String = ""
    static var userToken : String = ""
    
    override init() {
        super.init();
    }
    
    static func fetch() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        //Login entity 불러오는 동작
        let fetch_request = NSFetchRequest<NSManagedObject>(entityName: "LoginInfo")
        fetch_request.returnsObjectsAsFaults = false //데이터참조 오류 방지
        
        do {
            let userData : [NSManagedObject];
            let user : NSManagedObject?;
            try userData = context.fetch(fetch_request) //처음에 선언한 배열에 넣기
            user = userData[userData.count-1];
            if let us = user {
                if let usid = us.value(forKey: "id") as? Int{
                    userId = usid;
                    
                }
                if let usnick = us.value(forKey: "nickname") as? String {
                    userNickname = usnick;
                    
                }
                if let ustoken = us.value(forKey: "userToken") as? String{
                    userToken = ustoken
                }
            }
            //print(user["data"])
        }
        catch let error as NSError {
            print("불러올수 없습니다. \(error), \(error.userInfo)")
        }
    }
}
