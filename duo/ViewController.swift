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

class ViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate,GIDSignInDelegate, UITabBarControllerDelegate {
    
    // 각 SNS에서 받은 accestoken,refreshtoken으로 우리서버와 연결
    // accestoken,만료시간, sns
    func userLoginConfirm(_ acToken : String, _ acExpire : Date, _ rfToken : String, _ sns : String) {
                
        let urlStr = "http:localhost:80/login/\(sns)"
        let url = URL(string :urlStr)!
        //(우리 서버로 인증 하는 부분)
        let req = AF.request(url,
                            method:.post,
                            parameters: ["accesstoken" : acToken],
                            encoding: JSONEncoding.default)
        
        req.responseJSON { res in
            // 여기서도 분기 코드 작성해야함
            // 1. 처음 로그인 => nickname이 없다는 뜻 만들어야 하므로 만드는 곳으로 분기
            //          => 일단 api만들고 있음
            // 2. 원래 있는 아이디 => 우리서버에서 nickname을 넘겨줄 테니 그 닉테임을 가지고 tabbar로 이동하면 댐
            // 3. 오류 => 다시 로그인 요망 이라는 alert 표시
        }
        
        // 로그인이 잘되었으면 여기서 부터 다시 실행됨
        /*
            여기서 저 위의 매개변수들을 coredata에 저장해야함.
            즉, 이부분 코드 만들어 줘야함
         
        */
        
        
        
        // 로그인 성공시에 탭바뷰 컨트롤러의 storyboard id("tabbar")를 추적해 그 화면으로 전환
        let storyBoard = self.storyboard!
        let tabbarcontroller = storyBoard.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
        tabbarcontroller.delegate = self
        present(tabbarcontroller, animated: true, completion: nil)
    }
    
    
    // 0. 구글 로그인
    // -----------------------------------------------------------------------------------------------------------
    
    // 로그인 화면과 연결이 안될때의 에러
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
            print("Sign-in Error \(error!)")
            return;
        }
        
        // google idToken과 accessToken 둘 중에 어떤걸 써야 할 지 몰라서 그냥 놔둠
        print(user.authentication.refreshToken)
        print(user.authentication.idToken)
        print(user.authentication.accessToken)
        print(user.authentication.idTokenExpirationDate)
        print(user.authentication.accessTokenExpirationDate)
        
    
    }

    
    
    // 1. 네이버 로그인
    // -----------------------------------------------------------------------------------------------------------
    let loginConn = NaverThirdPartyLoginConnection.getSharedInstance();
    
    // 네이버 로그인 버튼 클릭 시
    @IBAction func naverSignIn(_ sender: UIButton) {
        loginConn?.delegate = self;
        loginConn?.requestThirdPartyLogin()
    }
    
    // 로그인 했을 시 샐행됨
    func getNaverEmailFromURL() {
        // 받은 데이터를 이용해서 사용자 정보 가져오기
        guard let ACToken = loginConn?.accessToken else {return}
        guard let ACExpireDate = loginConn?.accessTokenExpireDate else {return}
        guard let RFToken = loginConn?.refreshToken else {return}
        
        self.userLoginConfirm(ACToken, ACExpireDate, RFToken, "naver");
    }
    
    // 로그인 성공했을 시, 로그인 토큰을 건네 받고 이 함수 실행됨.
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        getNaverEmailFromURL()
    }
    // 로그인 실패, 토큰이 없다.
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 틀렸다는 alert표시
    }
    // 접근 코드 갱신
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {}
    func oauth20ConnectionDidFinishDeleteToken() {}
    
    
    
    
    
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
                    guard let ACToken = oauthToken?.accessToken else {return}
                    guard let ACExpireDate = oauthToken?.expiredAt else {return}
                    guard let RFToken = oauthToken?.refreshToken else {return}
                    self.userLoginConfirm(ACToken, ACExpireDate, RFToken, "kakao")
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
                    guard let ACToken = oauthToken?.accessToken else {return}
                    guard let ACExpireDate = oauthToken?.expiredAt else {return}
                    guard let RFToken = oauthToken?.refreshToken else {return}
                    self.userLoginConfirm(ACToken, ACExpireDate, RFToken, "kakao")
                }
            }
        }
    }
    
    
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad();
        GIDSignIn.sharedInstance().delegate = self
        
        /*
            만료일 검증 다하고 userLoginConfirm 함수 호출하면 댐.
            너가 코드 작성해야할 부분
        */
        
        // 자동 로그인 가능하게 만듬
        // 1. 액세스 토큰 만료 기간 검사
        // 2. 갱신 토큰으로 만료 기간 update
        // 3. 우리서버에 액세스 토큰 보내기
        //
        // coredata에 넣을 것
        // 1. accessToken
        // 2. 어떤 sns인지
        // 3. refreshToken
    }
    
}
