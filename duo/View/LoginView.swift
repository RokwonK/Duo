//
//  ViewController.swift
//  duo
//
//  Created by 김록원 on 2020/08/19.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import CoreData
import NaverThirdPartyLogin
import RxSwift
import RxCocoa


class LoginView: UIViewController,  UITabBarControllerDelegate,GIDSignInDelegate ,NaverThirdPartyLoginConnectionDelegate {
    
    
    func loginProcess(_ snsToken : String, _ sns_name : String) {
        
        var nickName = ""
        var userID = 0
        var userToken = ""
        
        var msg = ""
        var code = 0
        
        let ad = UIApplication.shared.delegate as? AppDelegate
        ad?.sns_name = sns_name
        ad?.access_token = snsToken
        
        //서버에서 받을 json데이터항목정의
        struct getInfo : Codable {
            var userToken : String
            var nickname : String
            var userId : Int
        }
        
        struct errorMessage : Codable {
            var msg : String
            var code : Int
        }
        
        //(우리 서버로 인증 하는 부분)
        let req = AF.request(URL(string :"\(BaseFunc.baseurl)/auth/\(sns_name)")!,
                             method:.post,
                             encoding: JSONEncoding.default,
                             headers: ["Authorization" : snsToken, "Content-Type": "application/json"])
        
        req.responseJSON { res in
            switch res.result {
            case.success (let value):
                do{
                    print("success")
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    
                    guard let loginInfo = try? JSONDecoder().decode(getInfo.self, from: data) else{
                        let eM = try JSONDecoder().decode(errorMessage.self, from: data)
                        msg = eM.msg
                        code = Int(eM.code)
                        return
                    }

                        nickName = loginInfo.nickname
                        userID = Int(loginInfo.userId)
                        userToken = loginInfo.userToken
                        
                        ad?.access_token = userToken
                        LoginViewModel().saveAccountInfo(nickName, Int(userID), userToken)
                        if userToken != ""{
                            let storyBoard = self.storyboard
                            let tabBarController = storyBoard!.instantiateViewController(withIdentifier: "TabBar") as! TabBarControllerView
                            self.present(tabBarController, animated: true, completion: nil)
                        }
                    }
                catch{
                }
                
            case.failure(let error):
                print("error :\(error)")
                break;
            }
        }
    }
    // 구글 로그인 후 실행
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
        
        // optional을 벗겨내고 안에 nil이 아니라면
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            }
            else {
                print("\(error.localizedDescription)")
            }
        }
        // 애초에 nil이 아니라면
        if (error != nil){
            print("Sign-in Error \(error!)")
            return;
        }
        
        guard let idToken = user.authentication.idToken else {return}
        self.loginProcess(idToken, "google")
        
        if BaseFunc.userNickname == "" {
            let storyBoard = self.storyboard!
            let nicknamePage = storyBoard.instantiateViewController(withIdentifier: "NickName") as! UIViewController
            self.present(nicknamePage, animated: true, completion: nil)

        }
    }
    
    // 구글 로그아웃이 실행되고 난 후 호출
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            print(error)
        }
    }
    
    
    // 로그인 후 토큰들을 받아오면 실행되는 함수
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        LoginViewModel().getNaverEmailFromURL()
    }
    
    // 액세스토큰 갱신 시 호출되는 함수
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        LoginViewModel().getNaverEmailFromURL()
    }
    
    // 연동해제시 호출되는 함수
    func oauth20ConnectionDidFinishDeleteToken() {
        print("Success Logout")
    }
    
    // 연동해제 실패(네아로서버와의 연결 실패 등)시 호출되는 함수
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("Error \(error.localizedDescription)")
    }
    
    //    struct getInfo : Codable {
    //        var userToken : String
    //        var nickname : String
    //        var userId : Int
    //    }
    
    //    func loginProcess(_ acToken : String, _ sns : String) -> Observable<getInfo>{
    //
    //        var nickName = ""
    //        var userID = 0
    //        var userToken = ""
    //
    //        var message = ""
    //        var code = 0
    //
    //        let ad = UIApplication.shared.delegate as? AppDelegate
    //        ad?.sns_name = sns
    //
    //        struct errorMessage : Codable {
    //            var msg : String
    //            var code : Int
    //        }
    //        let req = AF.request(URL(string :"\(BaseFunc.baseurl)/auth/\(sns)")!,
    //                             method:.post,
    //                             encoding: JSONEncoding.default,
    //                             headers: ["Authorization" : acToken, "Content-Type": "application/json"])
    //
    //        return Observable.create{ observer -> Disposable in req.validate().responseJSON{ res in
    //            switch res.result {
    //
    //            case.success(let value):
    //                print("here")
    //                do{
    //                    print("dodo")
    //                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
    //
    //                    let loginInfo = try JSONDecoder().decode(getInfo.self, from: data)
    //                    observer.onNext(loginInfo)
    //                    nickName = loginInfo.nickname
    //                    userID = Int(loginInfo.userId)
    //                    userToken = loginInfo.userToken
    //
    //                    ad?.access_token = userToken
    //                    print("dgfgf")
    //                    if loginInfo.userToken != "" {
    //                        self.saveAccountInfo(nickName, Int(userID), userToken)
    //                        print("gdagfgfgfdgfd")
    //                    }
    //                }catch{observer.onError(error)}
    //
    //            case.failure(let error):
    //                observer.onError(error)
    //
    //            }
    //            observer.onCompleted()
    //        }
    //        return Disposables.create(){
    //            req.cancel()
    //        }
    //        }
    //    }
    
    /*
     구글 로그인
     */
    
    let google = LoginViewModel().google
    let naver = LoginViewModel().loginConn
    
    @IBAction func Google_Login (_sender: AnyObject){
        google?.delegate = self
        google?.signIn()
    }
    
    // 네이버 로그인 버튼
    @IBAction func naverSignIn(_sender: UIButton) {
        // login 기능 수행을 이곳으로 위임
        naver?.delegate = self
        // 로그인 시작 네이버/사파리 연결
        naver?.requestThirdPartyLogin()
    }
    // 카카오 로그인 버튼
    @IBAction func Kakao_Login(_ sender: Any) {
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in LoginViewModel().kakaoLogin(oauthToken, error) }
        }
        else {
            AuthApi.shared.loginWithKakaoAccount { (oauthToken, error) in LoginViewModel().kakaoLogin(oauthToken, error)}
        }
    }
    
    //------------------------앱 실행시 동작--------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // restorePreviousSignIn 함수를 위해 필요
        BaseFunc.fetch()
        print(BaseFunc.userNickname)
        print("plz")
        google?.delegate = self
        google?.presentingViewController = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        //네이버 accesstoken 만료일 확인
        guard let naverToken : Bool = self.naver?.isValidAccessTokenExpireTimeNow() else {return}
        
        // 네이버로 로그인한 기록이 있을때 => 자동로그인
        if (self.naver?.accessToken != nil) {
            // 토큰 만료일자가 지남 => 갱신토큰으로 다시 받아옴
            if (!naverToken) { self.naver?.requestAccessTokenWithRefreshToken() }
            else { LoginViewModel().getNaverEmailFromURL() }
        }
        
        // 구글 자동 로그인 (refresh도 자동으로 됨, 성공하면 sign함수 호출함)
        self.google?.restorePreviousSignIn();
        
        
        // 카카오 캐시에 로그인 기록이 있을때 => 자동로그인
        let kakaoManager = TokenManager.manager;
        
        if (kakaoManager.getToken() != nil) {
            UserApi.shared.accessTokenInfo { AccessTokenInfo, Error in
                if let error = Error {
                    print("Occur Eror \(error)")
                    return;
                }
            
                if (AccessTokenInfo != nil) {
                    // 토큰 갱신
                    AuthApi.shared.refreshAccessToken { auth, Error in
                        // 자동 로그인 실행
                        LoginViewModel().kakaoLogin(auth, Error)
                    }
                }
            }
        }
    }
}
