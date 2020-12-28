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


class LoginViewController: UIViewController,  UITabBarControllerDelegate,GIDSignInDelegate ,NaverThirdPartyLoginConnectionDelegate {
    
    /* @@@@@@@@@@ Realm으로 @@@@@@@@@@ */
    let ad = UIApplication.shared.delegate as? AppDelegate
    let viewModel = LoginViewModel()
    let google = LoginViewModel().googleShared
    let naver = LoginViewModel().naverShared
    
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var kakaoBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 자동 로그인
        naverAutomaticLogin()
        self.google?.restorePreviousSignIn();
        kakaoAutomaticLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupUI()
        setupBinding()
    }
    
    func setupUI() {
        kakaoBtn.layer.cornerRadius = 7
        kakaoBtn.setShadow(color: UIColor.black.cgColor, width: 3, height: 3, opacity: 0.2, radius: 2.0)
        
        naverButton.layer.cornerRadius = 7
        naverButton.setShadow(color: UIColor.black.cgColor, width: 3, height: 3, opacity: 0.2, radius: 2.0)
        
        googleButton.layer.cornerRadius = 7
        googleButton.setShadow(color: UIColor.black.cgColor, width: 3, height: 3, opacity: 0.2, radius: 2.0)
        googleButton.layer.borderColor = UIColor.black.cgColor
        googleButton.layer.borderWidth = 1.0
        
        appleBtn.layer.cornerRadius = 7
        appleBtn.setShadow(color: UIColor.black.cgColor, width: 3, height: 3, opacity: 0.2, radius: 2.0)
    }
    
    func setupBinding() {
        google?.delegate = self
        google?.presentingViewController = self
        naver?.delegate = self
    }
    
    
    func naverAutomaticLogin() {
        // 네이버 accesstoken 만료일 확인
        // 네이버로 로그인한 기록이 있을때 => 자동로그인
        // 토큰 만료일자가 지남 => 갱신토큰으로 다시 받아옴
        guard let naverToken : Bool = self.naver?.isValidAccessTokenExpireTimeNow() else {return}
        if (self.naver?.accessToken != nil) {
            if (!naverToken) {
                self.naver?.requestAccessTokenWithRefreshToken()
            }
            else {
                let snsToken = LoginViewModel().getNaverEmailFromURL()
                viewModel.loginProcess(snsToken, "naver")
            }
        }
    }
    
    func kakaoAutomaticLogin() {
        // 카카오 캐시에 로그인 기록이 있을때 => 자동로그인
        let kakaoManager = TokenManager.manager;
        if (kakaoManager.getToken() != nil) {
            UserApi.shared.accessTokenInfo { AccessTokenInfo, Error in
                if let error = Error {
                    print("Occur Eror \(error)")
                    return;
                }
                if (AccessTokenInfo != nil) {
                    AuthApi.shared.refreshAccessToken { auth, Error in
                        let snsToken = LoginViewModel().kakaoLogin(auth, Error)
                        self.viewModel.loginProcess(snsToken, "kakao")
                    }
                }
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
        viewModel.loginProcess(idToken, "google")
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
    
    
    @IBAction func Google_Login (_sender: AnyObject){
        
        google?.signIn()
    }
    // 네이버 로그인 버튼
    @IBAction func naverSignIn(_sender: UIButton) {
        // login 기능 수행을 이곳으로 위임
        
        // 로그인 시작 네이버/사파리 연결
        naver?.requestThirdPartyLogin()
    }
    
    @IBAction func kakaoBtnTapped() {
        
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in LoginViewModel().kakaoLogin(oauthToken, error) }
        }
        else {
            AuthApi.shared.loginWithKakaoAccount
            { (oauthToken, error) in LoginViewModel().kakaoLogin(oauthToken, error)}
        }
    }
    
    
    
        
}
