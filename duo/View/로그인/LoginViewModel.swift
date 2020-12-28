import UIKit
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import CoreData
import NaverThirdPartyLogin

class LoginViewModel : ViewModel{
    
    let googleShared = GIDSignIn.sharedInstance();
    let naverShared = NaverThirdPartyLoginConnection.getSharedInstance();
    
    
    
    init() {
        super.init()
    }
    
    
    
    
    /*######################
     네이버 로그인
     #####################*/
    // 네이버 로그인 버튼 클릭 시
    func getNaverEmailFromURL() -> String {
        // 받은 데이터를 이용해서 사용자 정보 가져오기
        return (naverShared?.accessToken)!
    }



    /*#######################
     카카오 로그인
     ########################*/
    func kakaoLogin(_ auth : OAuthToken?, _ error : Error?) -> String {
        if let error = error {
            print(error)
            return "failed"
        }
        print("kakaoLogin success")
        return auth!.accessToken
    }
    
    
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

    
    
    
    /* Model 만들기 */
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
}
