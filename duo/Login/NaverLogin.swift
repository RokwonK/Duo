//
//  NaverLogin.swift
//  duo
//
//  Created by 김록원 on 2020/08/27.
//  Copyright © 2020 김록원. All rights reserved.
//

import NaverThirdPartyLogin

class NaverLogin : UIButton ,NaverThirdPartyLoginConnectionDelegate {
    
    let loginConn = NaverThirdPartyLoginConnection.getSharedInstance();
        
    
    // 로그인 시작
    func startLogin() {
        // 네이버 앱/사파리 호출
        loginConn?.delegate = self
        loginConn?.requestThirdPartyLogin();
    }
    
    func getNaverEmailFromURL() {
        // 받은 데이터를 이용해서 사용자 정보 가져오기
        guard let ACToken = loginConn?.accessToken else {return }
        guard let ACExpireDate = loginConn?.accessTokenExpireDate else {return }
        guard let RFToken = loginConn?.refreshToken else {return }
        print("ACToken : \(ACToken) ")
        print("ACEXpireDate : \(ACExpireDate) ")
        print("ACToken : \(RFToken) ")
        //ViewController().userLoginConfirm(ACToken,ACExpireDate,RFToken, "naver")
    }
    
    // 로그인 후 토큰들을 받아오면 실행되는 함수
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        self.getNaverEmailFromURL()
    }
    
    // 액세스토큰 갱신 시 호출되는 함수
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        self.getNaverEmailFromURL()
    }
    
    // 연동해제시 호출되는 함수
    func oauth20ConnectionDidFinishDeleteToken() {
    }
    
    // 연동해제 실패(네아로서버와의 연결 실패 등)시 호출되는 함수
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("Error \(error.localizedDescription)")
    }
    
    // 로그아웃 => 저장된 토큰정보 삭제
    func logout() {
        loginConn?.resetToken();
        // 연동해제 네아로 서버의 인증정보까지 삭제
        loginConn?.requestDeleteToken()
    }
    
    
}
