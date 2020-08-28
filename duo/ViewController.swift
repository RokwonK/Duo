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
import CoreData

class ViewController: UIViewController,  UITabBarControllerDelegate,GIDSignInDelegate ,NaverThirdPartyLoginConnectionDelegate {
    
    // 로그인 성공시에 탭바뷰 컨트롤러의 storyboard id("tabbar")를 추적해 그 화면으로 전환
    func loginSuccess () {
        let storyBoard = self.storyboard!
        let tabbarcontroller = storyBoard.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
        tabbarcontroller.delegate = self
        present(tabbarcontroller, animated: true, completion: nil)
    }
    
    // 우리 서버와 통신 고유 id값 닉네임 넘겨줌
    func userLoginConfirm(_ acToken : String, _ acExpire : Date, _ rfToken : String, _ sns : String) {
                
//        print(acExpire)
//        let urlStr = "http:localhost:80/login/\(sns)"
//        let url = URL(string :urlStr)!
//        //(우리 서버로 인증 하는 부분)
//        let req = AF.request(url,
//                            method:.post,
//                            parameters: ["accesstoken" : acToken],
//                            encoding: JSONEncoding.default)
//
//        req.responseJSON { res in
//            print(res)
//            // 여기서도 분기 코드 작성해야함
//            // 1. 처음 로그인 => nickname이 없다는 뜻 만들어야 하므로 만드는 곳으로 분기
//            //          => 일단 api만들고 있음
//            // 2. 원래 있는 아이디 => 우리서버에서 nickname을 넘겨줄 테니 그 닉테임을 가지고 tabbar로 이동하면 댐
//            // 3. 오류 => 다시 로그인 요망 이라는 alert 표시
//        }
//
        // 로그인이 잘되었으면 여기서 부터 다시 실행됨
        /*
            여기서 저 위의 매개변수들을 coredata에 저장해야함.
            즉, 이부분 코드 만들어 줘야함
            sns 가 google 일 경우는 따로 분리해서 sns랑  idtoken에 acToken만 넣으면 됨
        */
        self.loginSuccess();
    }

    
    
    
    
    /*
        구글 로그인
    */
    
    
    let google = GIDSignIn.sharedInstance();
    
    // 구글 로그아웃이 실행되고 난 후 호출
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            print(error)
        }
    }

    // 구글 로그인 후 실행
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
        print("dfdfd")
        
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
        guard let idTokenExpire = user.authentication.idTokenExpirationDate else {return}
        guard let rfToken = user.authentication.refreshToken else {return}
        
        userLoginConfirm(idToken, idTokenExpire, rfToken, "google")
    }
    
    
    // 로그아웃
    func googleLogout() {
        google?.signOut()
    }
    
    @IBAction func Google_Login (_sender: AnyObject){
        google?.delegate = self
        google?.signIn()
    }
    
    
    
    
    
    
    
    /*
        네이버 로그인
    */
    
    // 네이버 로그인 버튼 클릭 시
    let loginConn = NaverThirdPartyLoginConnection.getSharedInstance();
    
    func getNaverEmailFromURL() {
        // 받은 데이터를 이용해서 사용자 정보 가져오기
        guard let ACToken = loginConn?.accessToken else {return }
        guard let ACExpireDate = loginConn?.accessTokenExpireDate else {return }
        guard let RFToken = loginConn?.refreshToken else {return }
        print("ACToken : \(ACToken) ")
        print("ACEXpireDate : \(ACExpireDate) ")
        print("ACToken : \(RFToken) ")
        
        self.userLoginConfirm(ACToken,ACExpireDate,RFToken, "naver")
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
    func naverLogout() {
        loginConn?.resetToken();
        // 연동해제 네아로 서버의 인증정보까지 삭제
        loginConn?.requestDeleteToken()
    }
    
    
    @IBAction func naverSignIn(_ sender: UIButton) {
        // login 기능 수행을 이곳으로 위임
        loginConn?.delegate = self
        // 로그인 시작 네이버/사파리 연결
        loginConn?.requestThirdPartyLogin();
    }
    
    
    
    
    
    
   
    /*
        카카오 로그인
    */
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
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad();
        //google?.delegate = self
        google?.presentingViewController = self
        // 이전 로그인 정보를 복구
        google?.restorePreviousSignIn()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // 네이버 로그인
        naverLogout();
        guard let naverToken : Bool = loginConn?.isValidAccessTokenExpireTimeNow() else {return}

        
        // 네이버로 로그인한 기록이 있음
        if (loginConn?.accessToken != nil) {
            // 토큰 만료일자가 지남 => 갱신토큰으로 다시 받아옴
            if (!naverToken) { loginConn?.requestAccessTokenWithRefreshToken() }
            else { self.getNaverEmailFromURL() }
        }
        // 구글 로그인 기록 이 있음
        
        if (google?.currentUser != nil) {
            print("1")
            print(google?.currentUser.authentication.accessTokenExpirationDate)
            google?.currentUser.authentication.refreshTokens{ GIDAuthentication, Error in
                guard Error == nil else { return }
                print("2")
                print(GIDAuthentication)
            }
            
            print("3")
            print(google?.currentUser.authentication.accessTokenExpirationDate)
        }
        
        
    }
    
    
}




// Coredata에 저장, 값 꺼내오기 코드
/*
     var loginlist : [NSManagedObject] = [] // 코어데이터에 로그인 정보 저장할 객체 배열 생성
     
     //데이터 저장함수
     func save(_ acToken : String, _ acExpire : Date, _ rfToken : String, _ sns : String){
         
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
         // AppDelegate.swift 파일에서 참조얻기
         let context = appDelegate.persistentContainer.viewContext // context객체 참조
         let entity = NSEntityDescription.entity(forEntityName: "Login", in: context)! // entity 객체 생성
         
         let login = NSManagedObject(entity: entity, insertInto: context)//entity 설정
         
         //entity 속성값 설정
         login.setValue(acToken, forKey: "access_token")
         login.setValue(acExpire, forKey: "access_expire")
         login.setValue(rfToken, forKey: "refresh_token")
         login.setValue(sns, forKey: "sns_name")
         
         do{
             try context.save() //저장
         } catch let error as NSError{
             print("저장 오류 \(error), \(error.userInfo)")
         }
     }
     
     //저장된 데이터 불러오는 함수
     func fetch() {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         let fetch_request = NSFetchRequest<NSManagedObject>(entityName: "Login") //Login entity 불러오는 동작
         fetch_request.returnsObjectsAsFaults = false //데이터참조 오류 방지
         
         do {
             loginlist = try context.fetch(fetch_request) //처음에 선언한 배열에 넣기
         }
         catch let error as NSError{ print("불러올수 없습니다. \(error), \(error.userInfo)")
         }
     }
     
 //    //코어데이터에 저장된 로그인정보가 있는지(그전에 로그인한 이력확인) 확인
 //    var isEmpty: Bool {
 //        do {
 //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
 //            let context = appDelegate.persistentContainer.viewContext
 //            let check_request = NSFetchRequest<NSManagedObject>(entityName: "Login")
 //            let count  = try context.count(for: check_request)
 //            return count == 0
 //        } catch {
 //            return true
 //        }
 //    }
 
 func resetAllRecords() //코어데이터 엔티티 데이터 초기화
 {
     let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
     let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
     let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
     do
     {
         try context.execute(deleteRequest)
         try context.save()
     }
     catch
     {
         print ("There was an error")
     }
 }
 */
