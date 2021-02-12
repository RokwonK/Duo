//
//  AppDelegate.swift
//  duo
//
//  Created by 김록원 on 2020/08/19.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import CoreData
import KakaoSDKCommon
import KakaoSDKAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    // 어플리 케이션이 실행 되었을때, 호출됨
    // 시작 프로세스가 거의 완료되었고, 앱을 실행할 준비가 거의 완료되었음을 알림(true return)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        KakaoSDKCommon.initSDK(appKey: "ad22198785adb026ae8a5565ef48d7da")
        
        if #available(iOS 13, *) {
            // sceneDelegate에서 처리함
        }
        else {
            window = UIWindow()
            let rootVC = NavigationViewController(rootViewController: SplashViewController())
            window?.rootViewController = rootVC
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    
    // URL scheme 따라 이 앱의 URL에 도착, 이 함수가 잘 도착했다면 이 수로 오므로 true 뱉음
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // kakao인증코드 존재한다면(카톡에서 => 서비스앱으로 돌아올때, 카카오 로그인 처리를 적상적으로 완료하기 위해)
        if ( AuthApi.isKakaoTalkLoginUrl(url) ) {
            _ = AuthController.handleOpenUrl(url: url);
        }
        return true;
    }
    
    
    //----------------------------------------------------------------------
    // MARK: UISceneSession Lifecycle
    // 새로운 scene이 만들어 졌을때, 호출
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // 만들어져 있던 scene이 사라질 때, 호출
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    
    
    
    
    
    
    // MARK: - Core Data stack
    // Core Data의 Persistence 기능
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "duo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    

}

