//
//  SceneDelegate.swift
//  duo
//
//  Created by 김록원 on 2020/08/19.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import KakaoSDKAuth


// SceneDelegate는 보고하는 코드임
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // 앱에 장면이 추가되었다고 delegate에게 알린다.
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let rootVC = NavigationViewController(rootViewController: SplashViewController())
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    // delegate에게 하나 이상의 URL을 열도록 요청함
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    // scene이 앱에서 영영 지워질거다
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    // scene이 활동할거고 user의 행동에 응당하고 있다
    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    // scene이 활동을 끝내고, user의 요구에대한 행동을 끝냄.
    func sceneWillResignActive(_ scene: UIScene) {
    }

    // 화면이 foreground로 들어 갈거고, 사용자에게 보여질것이다.
    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    
    // 화면이 Background로 들어갔다 즉, 사용되어지고 있지않다 => 보여지고 있지 않다.
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

