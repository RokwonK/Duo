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
import CoreData
import RxSwift
import RxCocoa


class LoginViewController: UIViewController {
    
    let viewModel = LoginViewModel()
    // let googleShared = GIDSignIn.sharedInstance();
    // let naverShared = NaverThirdPartyLoginConnection.getSharedInstance();
    
    @IBOutlet weak var kakaoButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var back: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 자동 로그인
        //naverAutomaticLogin()
        //self.googleShared?.restorePreviousSignIn();
        
        // 이게 Auto 이면 안됨. Realm에서 있는지 없는지 확인해야함
        kakaoAutomaticLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // UI직접관련 작업
        setupUI()
        // viewModel과 연동 작업
        setupBinding()
    }
    
    func setupUI() {
        
        #if DEBUG
        back.isHidden = false
        #else
        back.isHidden = true
        #endif
        
        if #available(iOS 13.0, *) {
            appleButton.isHidden = false
        }
        else {
            appleButton.isHidden = true
        }
        
        //googleShared?.delegate = self
        //googleShared?.presentingViewController = self
        //naverShared?.delegate = self
        
        // setShadow는 내가 만든 extension
        kakaoButton.layer.cornerRadius = 12
        kakaoButton.setShadow(color: UIColor.black.cgColor, width: 1, height: 2, opacity: 0.3, radius: 2.0)
        kakaoButton.backgroundColor = UIColor(displayP3Red: 254/255, green: 229/255, blue: 0/255, alpha: 1)
        
//        naverButton.layer.cornerRadius = 7
//        naverButton.setShadow(color: UIColor.black.cgColor, width: 3, height: 3, opacity: 0.2, radius: 2.0)
//
//        googleButton.layer.cornerRadius = 7
//        googleButton.setShadow(color: UIColor.black.cgColor, width: 3, height: 3, opacity: 0.2, radius: 2.0)
//        googleButton.layer.borderColor = UIColor.black.cgColor
//        googleButton.layer.borderWidth = 1.0
        
        appleButton.layer.cornerRadius = 12
        appleButton.setShadow(color: UIColor.black.cgColor, width: 1, height: 2, opacity: 0.5, radius: 2.0)
        
        // RX, kakao button 클릭 시 실행
        kakaoButton.rx.tap.subscribe(onNext : {
            if (AuthApi.isKakaoTalkLoginAvailable()) {
                AuthApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                    print("kakaoTalk login oauthToken : ", oauthToken ?? "없음")
                    self?.socialLogin(accessToken: oauthToken?.accessToken ?? "", sns: "kakao")
                }
            }
            else {
                AuthApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                    print("kakaoAccount login oauthToken : ", oauthToken ?? "없음")
                    self?.socialLogin(accessToken: oauthToken?.accessToken ?? "", sns: "kakao")
                }
            }
        }).disposed(by: viewModel.disposeBag)
        
        // RX, naver button 클릭 시 실행
//        naverButton.rx.tap.subscribe(onNext : {[weak self] in
//            self?.naverShared?.requestThirdPartyLogin()
//        }).disposed(by: viewModel.disposeBag)
//        
//        // RX, google button 클릭 시 실행
//        googleButton.rx.tap.subscribe(onNext : {[weak self] in
//            self?.googleShared?.signIn()
//        }).disposed(by: viewModel.disposeBag)
        
        // RX, apple button 클릭 시 실행
        appleButton.rx.tap.subscribe(onNext : {
            // 애플 버튼 클릭 시 처리
        }).disposed(by: viewModel.disposeBag)
        
        back.rx.tap.subscribe(onNext : { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: viewModel.disposeBag)
    
    }
    
    func setupBinding() {
        viewModel.loginComplete.subscribe(onNext : {[weak self] (result) in
            guard let `self` = self else { return }
            
            if result == "loginSuccess" {
                self.dismiss(animated: true)
                
            }
            else if result == "needNickname" {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nicknameviewcontroller = storyBoard.instantiateViewController(withIdentifier: "NickName")
                self.present(nicknameviewcontroller, animated: true, completion: nil)
            }
            
        }).disposed(by: viewModel.disposeBag)
    }
    
    private func socialLogin(accessToken : String, sns : String) {
        let entity = RequestUserEntity(token: accessToken, sns: sns)
        viewModel.loginExecute.onNext(entity)
    }

    
    func kakaoAutomaticLogin() {
        // 카카오 캐시에 로그인 기록이 있을때 => 자동로그인
        guard TokenManager.manager.getToken() != nil else { return }
        
        UserApi.shared.accessTokenInfo{ (AccessTokenInfo, error) in
            guard error == nil else { return }
            
            AuthApi.shared.refreshAccessToken { auth, Error in
                let snsToken = auth?.accessToken ?? ""
                self.socialLogin(accessToken: snsToken, sns: "kakao")
            }
        }
    }
    
//    func naverAutomaticLogin() {
//        // 네이버 accesstoken 만료일 확인
//        // 네이버로 로그인한 기록이 있을때 => 자동로그인
//        // 토큰 만료일자가 지남 => 갱신토큰으로 다시 받아옴
//        guard let naverToken : Bool = naverShared?.isValidAccessTokenExpireTimeNow() else {return}
//
//        if (self.naverShared?.accessToken != nil) {
//            if (!naverToken) {
//                self.naverShared?.requestAccessTokenWithRefreshToken()
//            }
//            else {
//                let snsToken = naverShared?.accessToken ?? ""
//                self.socialLogin(accessToken: snsToken, sns: "naver")
//            }
//        }
//    }
    
}

//
//
//// MARK: LoginViewController - Google Login
//extension LoginViewController : GIDSignInDelegate {
//
//    // 구글 로그인 후 실행
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
//
//        // optional을 벗겨내고 안에 nil이 아니라면
//        if let error = error {
//            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                print("The user has not signed in before or they have since signed out.")
//            }
//            else {
//                print("\(error.localizedDescription)")
//            }
//        }
//        // 애초에 nil이 아니라면
//        if (error != nil){
//            print("Sign-in Error \(error!)")
//            return;
//        }
//
//        guard let idToken = user.authentication.idToken else {return}
//        self.socialLogin(accessToken: idToken, sns: "google")
//    }
//
//}
//
//
//
//// MARK: LoginViewController - Naver Login
//extension LoginViewController : NaverThirdPartyLoginConnectionDelegate {
//
//    // 로그인 후 토큰들을 받아오면 실행되는 함수
//    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
//        naverAutomaticLogin()
//    }
//
//    // 액세스토큰 갱신 시 호출되는 함수
//    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//    }
//
//    // 연동해제시 호출되는 함수
//    func oauth20ConnectionDidFinishDeleteToken() {
//        print("Success Logout")
//    }
//
//    // 연동해제 실패(네아로서버와의 연결 실패 등)시 호출되는 함수
//    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
//        print("Error \(error.localizedDescription)")
//    }
//}
