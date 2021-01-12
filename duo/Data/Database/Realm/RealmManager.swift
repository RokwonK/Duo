//
//  RealmManager.swift
//  duo
//
//  Created by 김록원 on 2021/01/03.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager : NSObject {
    
    var currentVersion : UInt64 = 1
    
    static let shared = RealmManager()
    var realm : Realm!
    
    override init() {
        super.init()
        
        let fileName = "Realm_v1"
        let documentPath = "\(NSHomeDirectory())/Documents/"
        let fileURL = URL.init(fileURLWithPath: "\(documentPath)\(fileName)")
        
        
        // Realm 환경설정
        // Realm 설정위치, 버전, 마이그레이션(버전 바꿀 시 수행), Realm 객체
        var config = Realm.Configuration()
        config.fileURL = fileURL
        config.schemaVersion = 1
        config.migrationBlock = { (oldVersion, newVersion) in
            
        }
        config.objectTypes = [RealmUser.self]
        
        
        Realm.Configuration.defaultConfiguration = config
        if let realm = try? Realm() {
            self.realm = realm
        }
    }
    
    
    // CRUD 작업 - update는 사실상 delete 후 insert
    func insert(_ object : Object) {
        try? realm.write {
            realm.add(object)
        }
    }
    
    func select<T : Object>(_ type : T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func delete(_ object : Object) {
        try? realm.write {
            realm.delete(object)
        }
    }
    
    func save() {
        try? realm.commitWrite()
    }
    
}
