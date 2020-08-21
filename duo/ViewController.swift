//
//  ViewController.swift
//  duo
//
//  Created by 김록원 on 2020/08/19.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit
import Alamofire
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

class ViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate,GIDSignInDelegate {
    
    // 0. 구글 로그인
    // -----------------------------------------------------------------------------------------------------------
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print(error);
      // Perform any operations when the user disconnects from app here.
      // ...
    }
    
    @IBAction func Google_Login (_sender: AnyObject){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }

    @IBAction func Google_Logout (_sender: AnyObject){
        GIDSignIn.sharedInstance().signOut()
        print("구글 로그아웃 완료")
    }

    //구글 로그인 요청후
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            }
            else {
                print("\(error.localizedDescription)")
            }
        }
        
        if (error != nil){
            print("Sign-in Error \(error)")
            return;
        }
        print(user)
        
        if let user = user.userID {print(user)}
        if let id = user.authentication.idToken {print(id)}
        if let full = user.profile.name {print(full)}
        if let em = user.profile.email {print(em)}
    }

    
    
    // 1. 네이버 로그인
    // -----------------------------------------------------------------------------------------------------------
    let loginConn = NaverThirdPartyLoginConnection.getSharedInstance();
    
    @IBOutlet weak var naver_button: UIButton!
    @IBOutlet weak var logout_button: UIButton!
    // 네이버 로그인
    @IBAction func naverSignIn(_ sender: UIButton) {
        loginConn?.delegate = self;
        loginConn?.requestThirdPartyLogin()
    }
    
    // 로그아웃
    @IBAction func logOut(_ sender: Any) {
        // 로그아웃(접근 토큰만 삭제) => loginConn?.resetToken();
        // 연동해제 (접근토큰, 인증코드 전체 삭제)
        do {
            try loginConn?.requestDeleteToken()
            logout_button.isHidden = true;
            print("로그아웃 성공");
        }
        catch {
            print("로그아웃 오류")
        }
    }
    
    // 로그인 했을 시 샐행됨
    func getNaverEmailFromURL() {
        // 받은 접근 토큰들
        guard let tokenType = loginConn?.tokenType else {return}
        guard let accessToken = loginConn?.accessToken else {return}
        logout_button.isHidden = false;
        
        // 받은 토큰을 이용해서 사용자 정보 가져오기
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string :urlStr)!
        let auth = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url,method:.get,encoding: JSONEncoding.default,headers: ["Authorization":auth])
        
        req.responseJSON { res in
            print( "\(res.result)")
            
            switch res.result {
            case .success(let value):
                if let data = value as? Dictionary<String, Any> {
                    if let response = data["response"] as? Dictionary<String, Any> {
                        print("\(response["id"]!)")
                        print("\(response["name"]!)")
                        print("\(response["email"]!)")
                    }
                }
            case .failure(let err):
                print("\(err)")
            }
        }
    }
    
    // 로그인 성공했을 시, 로그인 토큰을 건네 받고 이 함수 실행됨.
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        getNaverEmailFromURL()
    }
    // 로그인 실패, 토큰이 없다.
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        getNaverEmailFromURL()
    }
    // 접근 코드 갱신 등 지금 필요하지 않는 기능
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {}
    func oauth20ConnectionDidFinishDeleteToken() {}
    
    // -----------------------------------------------------------------------------------------------------------
    
    
    
    // 2. 카카오 로그인
    // -----------------------------------------------------------------------------------------------------------
    @IBAction func Kakao_Login(_ sender: Any) {
        
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카톡 로그인 성공")
                    let talktoken = oauthToken
                    
                    
                    
                }
            }
        }
        else {
            AuthApi.shared.loginWithKakaoAccount { (oauthToken, err) in
                if let error = err {
                    print(error)
                }
                else {
                    print ("login succes");
                    let accounttoken = oauthToken;

                }
            }
        }
        
    }
    
    @IBAction func Kakao_Logout(_ sender: Any) {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print (error)
            }
            else {
                print("kakao 로그아웃 성공")
            }
            
        }
    }
    
    
    // -----------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var naverButtonUi: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // 토큰을 가지고 있다 => 이미 로그인 중이다 로그아웃버튼 활성화
        if let havetoken = loginConn?.tokenType { logout_button.isHidden = false; }
        else { logout_button.isHidden = true; }
        
        GIDSignIn.sharedInstance().delegate = self
        // 자동 로그인
        // GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    

    
    // Naver login 정리
    /*
        1. 앱 프로세스가 실행될때, 네이버라이브러리 실행을 위해 (어디서[네이버앱,사파리], 가로모드로, apikey,secret)등을 설정 => AppDelegate/application(didFinishLaunchingWithOptions)
        2. 네이버 로그인하기 버튼 생성하고 누르면 requestThirdPartyLogin() 즉, 로그인 실행
        3-1. 웹뷰가 나오고 정보제공 후 인증코드를 획득
        3-2. URL scheme을 통해 AppDelegate/application(app,open,options) 에 넘겨줌
        3-3. 저 친구들은 받은 인증코드를 네이버 라이브러리로 넘겨줌
        3-4. 넘겨받은 인증코드를 자동으로 SceneDelegate/scene(openURLContext) 바로 실행(접근 토큰 얻기 위함)
        3-5. 네이버 서버에 접근해 인증 코드 보여주고 접근 토큰 얻어옴
        3-6-1. 토큰이 얻이지면 ViewController/oauth20ConnectionDidFinishRequestACTokenWithAuthCode() 실행
        3-6-2. 토큰을 얻지 못하면 ViewController/oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() 실행
        3.7 토큰이 얻어졌따면 네이버 라이브러리 안에 '토큰타입/접근 토큰'을 가지고 있을 거임.
        3.8 그 접근 토큰(해당 유저의 정보에 접근할 수 있는 것)을 이용해 오픈 API(해당 아이디 정보)를 사용가능
     
        
        로그 아웃 => 저장된 토큰 정보를 삭제
        연동 해제 => 네이버 서버에 저장된 인증 코드(인증 정보)까지 삭제
    */
    
    
}

