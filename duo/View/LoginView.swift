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
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var kakaoBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    func loginProcess(_ snsToken : String, _ sns_name : String) {
        
        var nickName = ""
        var userID = 0
        var userToken = ""
        
        var msg = ""
        var code = 0
        
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
                    
                    if let loginInfo = try? JSONDecoder().decode(getInfo.self, from: data){
                        nickName = loginInfo.nickname
                        userID = Int(loginInfo.userId)
                        userToken = loginInfo.userToken
                        self.ad?.access_token = userToken
                        self.ad?.userID = loginInfo.userId
                        self.ad?.nickname = loginInfo.nickname
                        
                        if userToken != "" {
                            let storyBoard = self.storyboard
                            let tabBarController = storyBoard!.instantiateViewController(withIdentifier: "TabBar") as! TabBarControllerView
                            self.present(tabBarController, animated: true, completion: nil)
                        }
                        break
                    }
                    else{
                        let eM = try? JSONDecoder().decode(errorMessage.self, from: data)
                        msg = eM!.msg
                        code = Int(eM!.code)
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let nicknameviewcontroller = storyBoard.instantiateViewController(withIdentifier: "NickName")
                        self.present(nicknameviewcontroller, animated: true, completion: nil)
                        //LoginViewModel().saveAccountInfo(nickName, Int(userID), userToken)
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
        print("googlegooglegooglegooglegooglegooglegooglegooglegooglegooglegooglegooglegooglegoogle")
        self.loginProcess(idToken, "google")
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
    
    //------------------------앱 실행시 동작--------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // restorePreviousSignIn 함수를 위해 필요
//        BaseFunc.fetch()
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(kakaoBtnTapped))
//        kakaoBtn.addGestureRecognizer(tapGestureRecognizer)
        
        kakaoBtn.layer.cornerRadius = 7
        kakaoBtn.layer.shadowColor = UIColor.black.cgColor
        kakaoBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
        kakaoBtn.layer.shadowOpacity = 0.2
        kakaoBtn.layer.shadowRadius = 2.0
        
        naverButton.layer.cornerRadius = 7
        naverButton.layer.shadowColor = UIColor.black.cgColor
        naverButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        naverButton.layer.shadowOpacity = 0.2
        naverButton.layer.shadowRadius = 2.0

        googleButton.layer.borderWidth = 1.0
        googleButton.layer.borderColor = UIColor.black.cgColor
        
        googleButton.layer.cornerRadius = 7
        googleButton.layer.shadowColor = UIColor.black.cgColor
        googleButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        googleButton.layer.shadowOpacity = 0.2
        googleButton.layer.shadowRadius = 2.0

        appleBtn.layer.cornerRadius = 7
        appleBtn.layer.shadowColor = UIColor.black.cgColor
        appleBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
        appleBtn.layer.shadowOpacity = 0.2
        appleBtn.layer.shadowRadius = 2.0
        
        google?.delegate = self
        google?.presentingViewController = self
    }
    
//    @objc func kakaoBtnTapped(sender: UITapGestureRecognizer) { // 원하는 대로 코드 구성 }
//        if (AuthApi.isKakaoTalkLoginAvailable()) {
//            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in LoginViewModel().kakaoLogin(oauthToken, error) }
//        }
//        else {
//            AuthApi.shared.loginWithKakaoAccount
//            { (oauthToken, error) in LoginViewModel().kakaoLogin(oauthToken, error)}
//        }
//    }
    @IBAction func kakaoBtnTapped() {
        
        if (AuthApi.isKakaoTalkLoginAvailable()) {
                  AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in LoginViewModel().kakaoLogin(oauthToken, error) }
              }
              else {
                  AuthApi.shared.loginWithKakaoAccount
                  { (oauthToken, error) in LoginViewModel().kakaoLogin(oauthToken, error)}
              }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        //네이버 accesstoken 만료일 확인
        guard let naverToken : Bool = self.naver?.isValidAccessTokenExpireTimeNow() else {return}
        // 네이버로 로그인한 기록이 있을때 => 자동로그인
        if (self.naver?.accessToken != nil) {
            // 토큰 만료일자가 지남 => 갱신토큰으로 다시 받아옴
            if (!naverToken) { self.naver?.requestAccessTokenWithRefreshToken() }
            else {
                let snsToken = LoginViewModel().getNaverEmailFromURL()
                print(snsToken)
                print("navernavernavernavernavernavernavernavernavernavernavernavernavernavernavernavernavernavernavernavernavernavernavernaver")
                self.loginProcess(snsToken, "naver")
            }
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
                        let snsToken = LoginViewModel().kakaoLogin(auth, Error)
                        print(snsToken)
                        print("kakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakaokakao")
                        self.loginProcess(snsToken, "kakao")
                    }
                }
            }
        }
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
    
}
