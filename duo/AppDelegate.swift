//
//  AppDelegate.swift
//  duo
//
//  Created by 김록원 on 2020/08/19.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import CoreData
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    // 어플리 케이션이 실행 되었을때, 호출됨
    // 시작 프로세스가 거의 완료되었고, 앱을 실행할 준비가 거의 완료되었음을 알림(true return)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // 네이버 로그인 환경설정
        let loginconn = NaverThirdPartyLoginConnection.getSharedInstance();
        
        // 네이버앱 활성화 (네이버 앱이 설치x시, 사파리로 연결됨)
        loginconn?.isNaverAppOauthEnable = true;
        loginconn?.isInAppOauthEnable = true;
        
        
        // Pods 폴더의 Naver로그인 헤더에 입력해 놓은 값들을 가져와 네이버로그인instance에 할당
        loginconn?.serviceUrlScheme = kServiceAppUrlScheme
        
        //접금 토큰 요청에 사용하는 발급받은 id,secret 및 app이름
        loginconn?.consumerKey = kConsumerKey
        loginconn?.consumerSecret = kConsumerSecret
        loginconn?.appName = kServiceAppName
        // 화면 가로 회전 차단
        loginconn?.setOnlyPortraitSupportInIphone(true)
        
        KakaoSDKCommon.initSDK(appKey: "ad22198785adb026ae8a5565ef48d7da")
        
        GIDSignIn.sharedInstance().clientID = "670654932586-tjf445l443al4aklub6rnm2q2pk0j428.apps.googleusercontent.com"
        

        
        return true
    }
    
    // 프로세스 관련
    // delegate에게 URL로 지정된 리소스를 열도록 요청함(네이버 앱이 인증코드를 주고 요청하는 것)
    
    
    // URL scheme 따라 이 앱의 URL에 도착 이 함수가 잘 도착했다면 이 수로 오므로 true 뱉음
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // kakao인증코드 존재한다면(카톡에서 => 서비스앱으로 돌아올때, 카카오 로그인 처리를 적상적으로 완료하기 위해)
        if ( AuthApi.isKakaoTalkLoginUrl(url)) {
            AuthController.handleOpenUrl(url: url);
        }
        // 인증 코드를 받고 URL scheme이 맞는지 확인
        // 네이버 라이브러리에 넘겨줌 => 넘겨주자마자 바로 접근코드 얻는 메서드 실행(scene)
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
        GIDSignIn.sharedInstance().handle(url)


         return true;
    }
    
    
    
    
    //----------------------------------------------------------------------

    // MARK: UISceneSession Lifecycle
    // 새로운 scene이 만들어 졌을때, 호출
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // 만들어져 있던 scene이 사라질 때, 호출
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

