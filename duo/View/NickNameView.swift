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
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    static let sharedInstance = NickNameView()
    
    @IBOutlet weak var inputText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //데이터 저장함수
    func data_save( _ nickName: String, _ userId: Int, _ userToken : String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        // AppDelegate.swift 파일에서 참조얻기
        let context = appDelegate.persistentContainer.viewContext // context객체 참조
        let entity = NSEntityDescription.entity(forEntityName: "LoginInfo", in: context)! // entity 객체 생성
        let login = NSManagedObject(entity: entity, insertInto: context)//entity 설정
        
        //entity 속성값 설정
        login.setValue(nickName, forKey: "nickname")
        login.setValue(userId, forKey: "id")
        login.setValue(userToken, forKey: "userToken")
        
        do{
            print("여기")
            try context.save()
            self.dismiss(animated: true, completion: nil)
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
        if (inputText.text!.count > 8) || (inputText.text!.count < 2){
            let alert = UIAlertController(title: nil , message: "닉네임길이 2자~8자. 현재 \(inputText.text!.count)자", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let ad = UIApplication.shared.delegate as? AppDelegate // Appdelegate 참조후 캐스팅
            var sns_name = ad!.sns_name!
            var snsToken = ad!.access_token
            //닉네임 서버로 송신하는코드
            let url = URL(string :"http://ec2-18-222-143-156.us-east-2.compute.amazonaws.com:3000/auth/\(sns_name)")!
            
            var nickName = ""
            var userId = 0
            var userToken = ""
            
            //서버에서 받을 json 구조체
            struct getInfo : Codable {
                var userToken : String
                var nickname : String
                var userId : Int
            }
            
            //서버로 생성할 닉네임 보내고 nickname,id json데이터 받아오기
            let req = AF.request(url,
                                 method:.post,
                                 parameters: ["nickname" : inputText.text],
                                 encoding: JSONEncoding.default,
                                 headers: ["Authorization": snsToken, "Content-Type": "application/json"])
            
            req.responseJSON { res in
                print(res)
                
                switch res.result{
                
                case.success (let value):
                    do{
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let logininfo = try JSONDecoder().decode(getInfo.self, from: data)
                        
                        ad!.access_token = logininfo.userToken
                        ad!.nickname = logininfo.nickname
                        ad!.userID = Int(logininfo.userId)
                       
                        self.gotoTabBar()
                    }
                    catch{
                    }
                    
                case .failure(let error):
                    print("error :\(error)")
                    break;
                }
                
            }
        }
    }
}
