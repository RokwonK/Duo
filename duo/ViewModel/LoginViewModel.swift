import UIKit
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import CoreData
import NaverThirdPartyLogin

class LoginViewModel : UIViewController{
    

    //데이터 저장함수
    func saveAccountInfo( _ nickName: String, _ userID : Int, _ userToken : String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        // AppDelegate.swift 파일에서 참조얻기
        let context = appDelegate.persistentContainer.viewContext // context객체 참조
        let entity = NSEntityDescription.entity(forEntityName: "LoginInfo", in: context)! // entity 객체 생성
        let login = NSManagedObject(entity: entity, insertInto: context)//entity 설정
        
        //entity 속성값 설정
        login.setValue(nickName, forKey: "nickname")
        login.setValue(userID, forKey: "id")
        login.setValue(userToken, forKey: "userToken")
        
        do{
            try context.save()
            
        } catch let error as NSError{
            print("저장 오류 \(error), \(error.userInfo)")
        }
    }
    
    //코어데이터 저장된 엔티티 초기화
    func resetRecords()
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
    
    /*
     구글 로그인
     */
    let google = GIDSignIn.sharedInstance();
    // 로그아웃
    func googleLogout() {
        google?.signOut()
    }
    
    /*
     네이버 로그인
     */
    // 네이버 로그인 버튼 클릭 시
    let loginConn = NaverThirdPartyLoginConnection.getSharedInstance();
    
    func getNaverEmailFromURL() -> String {
        // 받은 데이터를 이용해서 사용자 정보 가져오기
        return (loginConn?.accessToken)!
    }

    // 로그아웃 => 저장된 토큰정보 삭제
    func naverLogout() {
        loginConn?.resetToken()
        // 연동해제 네아로 서버의 인증정보까지 삭제
        loginConn?.requestDeleteToken()
    }

    /*
     카카오 로그인
     */
    func kakaoLogout() {
        UserApi.shared.logout {err in
            if let error = err { print(error) }
            else { print("kakaoLogut success") }
        }
    }
    
    func kakaoLogin(_ auth : OAuthToken?, _ error : Error?) -> String {
        if let error = error {
            print(error)
        }
        
            print("kakaoLogin success")
            return auth!.accessToken
    }
}
