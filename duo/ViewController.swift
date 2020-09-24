////
////  ViewController.swift
////  duo
////
////  Created by 김록원 on 2020/08/19.
////  Copyright © 2020 김록원. All rights reserved.
////
//import UIKit
//import Alamofire
//import KakaoSDKAuth
//import KakaoSDKUser
//import GoogleSignIn
//import CoreData
//import NaverThirdPartyLogin
//
//
//class ViewController: UIViewController,  UITabBarControllerDelegate,GIDSignInDelegate ,NaverThirdPartyLoginConnectionDelegate {
//
//    //데이터 저장함수
//    func save( _ fromserver_nickname: String, _ fromserver_id : Int){
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
//        // AppDelegate.swift 파일에서 참조얻기
//        let context = appDelegate.persistentContainer.viewContext // context객체 참조
//        let entity = NSEntityDescription.entity(forEntityName: "LoginInfo", in: context)! // entity 객체 생성
//        let login = NSManagedObject(entity: entity, insertInto: context)//entity 설정
//
//        //entity 속성값 설정
//        login.setValue(fromserver_nickname, forKey: "nickname")
//        login.setValue(fromserver_id, forKey: "id")
//
//        do{
//            try context.save()
//            print(fromserver_nickname)
//            print(fromserver_id)
//
//        } catch let error as NSError{
//            print("저장 오류 \(error), \(error.userInfo)")
//        }
//    }
//
//    //코어데이터 저장된 엔티티 초기화
//    func resetAllRecords()
//    {
//        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
//        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//        do
//        {
//            try context.execute(deleteRequest)
//            try context.save()
//        }
//        catch
//        {
//            print ("There was an error")
//        }
//    }
//
//    func loginSuccess () {
//        let storyBoard = self.storyboard!
//        let tabbarcontroller = storyBoard.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
//        present(tabbarcontroller, animated: true, completion: nil)
//       }
//
//
//    // 우리 서버와 통신 고유 id값 닉네임 넘겨줌
//    func userLoginConfirm(_ acToken : String, _ acExpire : Date, _ rfToken : String, _ sns : String) {
//
//        let urlStr = "http://ec2-18-222-143-156.us-east-2.compute.amazonaws.com:3000/login/\(sns)"
//        let url = URL(string :urlStr)!
//        var fromserver_nickname = ""
//        var fromserver_id = 0
//        let ad = UIApplication.shared.delegate as? AppDelegate
//        ad?.sns_name = sns            //appdelegate에다 변수저장
//        ad?.access_token = acToken
//
//        //서버에서 받을 json데이터항목정의
//        struct getinfo : Codable {
//            var nickname : String
//            var id : Int
//        }
//
//        //(우리 서버로 인증 하는 부분)
//        let req = AF.request(url,
//                            method:.post,
//                            parameters: ["accesstoken" : acToken],
//                            encoding: JSONEncoding.default)
//
//        req.responseJSON { res in
//            print(res)
//
//            switch res.result {
//            case.success (let value):
//                do{
//                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                    let logininfo = try JSONDecoder().decode(getinfo.self, from: data)
//
//                    fromserver_nickname = logininfo.nickname
//                    fromserver_id = Int(logininfo.id)
//
//                    if fromserver_nickname == "needNickname"{
//                        let storyBoard = self.storyboard!
//                        let make_nickname = storyBoard.instantiateViewController(withIdentifier: "nickname") as! UIViewController
//                        self.present(make_nickname, animated: true, completion: nil)
//                    }
//
//                    else{
//                        //resetAllRecords()
//                        self.save(fromserver_nickname, Int(fromserver_id))
//                        self.loginSuccess()
//                    }
//                }
//                catch{
//                }
//
//            case.failure(let error):
//                print("error :\(error)")
//                break;
//            }
//        }
//
//
////        if fromserver_nickname == "needNickname"{
////            let storyBoard = self.storyboard!
////            let make_nickname = storyBoard.instantiateViewController(withIdentifier: "nickname") as! UIViewController
////            present(make_nickname, animated: true, completion: nil)
////
////        }
////
////        else{
////            //resetAllRecords()
////            save(fromserver_nickname, Int(fromserver_id))
////        }
////
//    }
//
//    /*
//        구글 로그인
//    */
//
//
//    let google = GIDSignIn.sharedInstance();
//
//    // 구글 로그아웃이 실행되고 난 후 호출
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        if (error != nil) {
//            print(error)
//        }
//    }
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
//
//        guard let idToken = user.authentication.idToken else {return}
//        guard let idTokenExpire = user.authentication.idTokenExpirationDate else {return}
//        guard let rfToken = user.authentication.refreshToken else {return}
//        print(idToken)
//        print(idTokenExpire)
//        print(rfToken)
//
//        userLoginConfirm(idToken, idTokenExpire, rfToken, "google")
//    }
//
//    // 로그아웃
//    func googleLogout() {
//        google?.signOut()
//        print("3")
//    }
//
//    @IBAction func Google_Login (_sender: AnyObject){
//        google?.delegate = self
//        google?.signIn()
//    }
//
//
//    /*
//        네이버 로그인
//    */
//
//    // 네이버 로그인 버튼 클릭 시
//    let loginConn = NaverThirdPartyLoginConnection.getSharedInstance();
//
//    func getNaverEmailFromURL() {
//        // 받은 데이터를 이용해서 사용자 정보 가져오기
//        guard let ACToken = loginConn?.accessToken else {return }
//        guard let ACExpireDate = loginConn?.accessTokenExpireDate else {return }
//        guard let RFToken = loginConn?.refreshToken else {return }
//        print("ACToken : \(ACToken) ")
//        print("ACEXpireDate : \(ACExpireDate) ")
//        print("ACToken : \(RFToken) ")
//
//        self.userLoginConfirm(ACToken,ACExpireDate,RFToken, "naver")
//    }
//
//    // 로그인 후 토큰들을 받아오면 실행되는 함수
//    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
//        self.getNaverEmailFromURL()
//    }
//
//    // 액세스토큰 갱신 시 호출되는 함수
//    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//        self.getNaverEmailFromURL()
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
//
//    // 로그아웃 => 저장된 토큰정보 삭제
//    func naverLogout() {
//        loginConn?.resetToken()
//        // 연동해제 네아로 서버의 인증정보까지 삭제
//        loginConn?.requestDeleteToken()
//        print("1")
//    }
//
//    @IBAction func naverSignIn(_sender: UIButton) {
//        // login 기능 수행을 이곳으로 위임
//        loginConn?.delegate = self
//        // 로그인 시작 네이버/사파리 연결
//        loginConn?.requestThirdPartyLogin()
//    }
//
//    /*
//     카카오 로그인
//    */
//
//    func kakaoLogout() {
//        UserApi.shared.logout {err in
//            if let error = err { print(error) }
//            else { print("kakaoLogut success") }
//        }
//        print("2")
//    }
//
//    func kakaoLogin(_ auth : OAuthToken?, _ error : Error?) {
//        if let error = error {
//            print(error)
//        }
//        else {
//
//            print("kakaoLogin success")
//            guard let ACToken = auth?.accessToken else {return}
//            guard let ACExpireDate = auth?.expiredAt else {return}
//            guard let RFToken = auth?.refreshToken else {return}
//            print("ACToken : \(ACToken)")
//
//            self.userLoginConfirm(ACToken, ACExpireDate, RFToken, "kakao")
//        }
//    }
//
//    @IBAction func Kakao_Login(_ sender: Any) {
//        if (AuthApi.isKakaoTalkLoginAvailable()) {
//            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in self.kakaoLogin(oauthToken, error) }
//        }
//        else {
//            AuthApi.shared.loginWithKakaoAccount { (oauthToken, error) in self.kakaoLogin(oauthToken, error)}
//        }
//    }
//
//    //------------------------앱 실행시 동작--------------------------------
//
//    override func viewDidLoad() {
//        super.viewDidLoad();
//        // restorePreviousSignIn 함수를 위해 필요
//        google?.delegate = self
//        google?.presentingViewController = self
//    }
//
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
//
//        //네이버 accesstoken 만료일 확인
//        guard let naverToken : Bool = loginConn?.isValidAccessTokenExpireTimeNow() else {return}
//
//        // 네이버로 로그인한 기록이 있을때 => 자동로그인
//        if (loginConn?.accessToken != nil) {
//            // 토큰 만료일자가 지남 => 갱신토큰으로 다시 받아옴
//            if (!naverToken) { loginConn?.requestAccessTokenWithRefreshToken() }
//            else { self.getNaverEmailFromURL() }
//
//            return
//        }
//
//        // 구글 자동 로그인 (refresh도 자동으로 됨, 성공하면 sign함수 호출함)
//        google?.restorePreviousSignIn();
//
//
//        // 카카오 캐시에 로그인 기록이 있을때 => 자동로그인
//        let kakaoManager = TokenManager.manager;
//
//        if (kakaoManager.getToken() != nil) {
//            UserApi.shared.accessTokenInfo { AccessTokenInfo, Error in
//                if let error = Error {
//                    print("Occur Eror \(error)")
//                    return;
//                }
//
//                if (AccessTokenInfo != nil) {
//                    // 토큰 갱신
//                    AuthApi.shared.refreshAccessToken { auth, Error in
//                        // 자동 로그인 실행
//                        self.kakaoLogin(auth, Error)
//                    }
//                }
//
//            }
//        }
//
//
//    }
//
//}
//
///*
//
//     //저장된 데이터 불러오는 함수
//     func fetch() {
//         let appDelegate = UIApplication.shared.delegate as! AppDelegate
//         let context = appDelegate.persistentContainer.viewContext
//         let fetch_request = NSFetchRequest<NSManagedObject>(entityName: "Login") //Login entity 불러오는 동작
//         fetch_request.returnsObjectsAsFaults = false //데이터참조 오류 방지
//
//         do {
//             loginlist = try context.fetch(fetch_request) //처음에 선언한 배열에 넣기
//         }
//         catch let error as NSError{ print("불러올수 없습니다. \(error), \(error.userInfo)")
//         }
//     }
//
// */
