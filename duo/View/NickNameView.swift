//
//  NicknameView.swift
//  duo
//
//  Created by 황윤재 on 2020/09/25.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import RxSwift
import RxCocoa

class NickNameView : UIViewController {
    
    static let sharedInstance = NickNameView()
    
    @IBOutlet weak var inputText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //데이터 저장함수
    func first_save( _ nickName: String, _ userId: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        // AppDelegate.swift 파일에서 참조얻기
        let context = appDelegate.persistentContainer.viewContext // context객체 참조
        let entity = NSEntityDescription.entity(forEntityName: "LoginInfo", in: context)! // entity 객체 생성
        let login = NSManagedObject(entity: entity, insertInto: context)//entity 설정
        
        //entity 속성값 설정
        login.setValue(nickName, forKey: "nickname")
        login.setValue(userId, forKey: "id")
        
        do{
            try context.save()
            gotoTabBar()
        } catch let error as NSError{
            print("저장 오류 \(error), \(error.userInfo)")
        }
    }
    
    // 로그인 성공시에 탭바뷰 컨트롤러의 storyboard id("tabbar")를 추적해 그 화면으로 전환
    func gotoTabBar() {
        let storyBoard = self.storyboard!
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! TabBarControllerView
        present(tabBarController, animated: true, completion: nil)
    }

    //닉네임생성완료 버튼누르면 실행
    @IBAction func makeNickName(sender: UIButton) {
        
        let ad = UIApplication.shared.delegate as? AppDelegate // Appdelegate 참조후 캐스팅
        var sns = ad!.sns_name!
        var acToken = ad!.access_token!
        //닉네임 서버로 송신하는코드
        let urlString = "http://ec2-18-222-143-156.us-east-2.compute.amazonaws.com:3000/auth/\(sns)"
        let url = URL(string :urlString)!
        
        var nickName = ""
        var userId = 0
        var userToken = ""
        
        //서버에서 받을 json 구조체
        struct getInfo : Codable {
            var userToken : String
            var nickname : String
            var id : Int
        }
        
        //서버로 생성할 닉네임 보내고 nickname,id json데이터 받아오기
        let req = AF.request(url,
                             method:.post,
                             parameters: ["nickname" : inputText.text],
                             encoding: JSONEncoding.default,
                             headers: ["Authorization": acToken, "Content-Type": "application/json"])

        req.responseJSON { res in
            print(res)

            switch res.result{

            case.success (let value):
                do{
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let logininfo = try JSONDecoder().decode(getInfo.self, from: data)

                    userToken = logininfo.userToken
                    nickName = logininfo.nickname
                    userId = Int(logininfo.id)
                    
                    print(userToken)
                    print(nickName)
                    print(userId)
                }
                catch{
                }

            case .failure(let error):
                print("error :\(error)")
                break;
            }

        }
        first_save(nickName, Int(userId))
}
    
}

