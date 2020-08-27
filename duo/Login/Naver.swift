//
//  Naver.swift
//  duo
//
//  Created by 황윤재 on 2020/08/27.
//  Copyright © 2020 김록원. All rights reserved.
//

import NaverThirdPartyLogin

class naver : UIResponder, NaverThirdPartyLoginConnectionDelegate{
    
    let loginconn = NaverThirdPartyLoginConnection.getSharedInstance()
    // 네이버 로그인 버튼 클릭 시
    func naverSignIn() {
        loginconn?.delegate = self;
        loginconn?.requestThirdPartyLogin()
    }
    
    // 로그인 했을 시 샐행됨
    func getNaverEmailFromURL() {
        // 받은 데이터를 이용해서 사용자 정보 가져오기
        guard let ACToken = loginconn?.accessToken else {return}
        guard let ACExpireDate = loginconn?.accessTokenExpireDate else {return}
        guard let RFToken = loginconn?.refreshToken else {return}
        
        ViewController().userLoginConfirm(ACToken, ACExpireDate, RFToken, "naver");
    }
    
    // 로그인 성공했을 시, 로그인 토큰을 건네 받고 이 함수 실행됨.
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
             getNaverEmailFromURL()
    }
    // 로그인 실패, 토큰이 없다.
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        getNaverEmailFromURL()// 틀렸다는 alert표시
    }
    // 접근 코드 갱신
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {}
    func oauth20ConnectionDidFinishDeleteToken() {}
    
    // Access 토큰 갱신
    func requestAccessTokenWithRefreshToken(){
        oauth20ConnectionDidFinishRequestACTokenWithRefreshToken()
    }
    
    
}
