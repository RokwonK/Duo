//
//  Nickname.swift
//  duo
//
//  Created by 황윤재 on 2020/08/28.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit
import CoreData
import Alamofire

class Nickname : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loginSuccess () {
        let storyBoard = self.storyboard!
        let tabbarcontroller = storyBoard.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
        present(tabbarcontroller, animated: true, completion: nil)
       }

    //데이터 저장함수
    func first_save( _ save_nickname: String, _ save_id: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        // AppDelegate.swift 파일에서 참조얻기
        let context = appDelegate.persistentContainer.viewContext // context객체 참조
        let entity = NSEntityDescription.entity(forEntityName: "LoginInfo", in: context)! // entity 객체 생성
        let login = NSManagedObject(entity: entity, insertInto: context)//entity 설정
        
        //entity 속성값 설정
        login.setValue(save_nickname, forKey: "nickname")
        login.setValue(save_id, forKey: "id")

        do{
            try context.save()
            moveto_tabbar()
        } catch let error as NSError{
            print("저장 오류 \(error), \(error.userInfo)")
        }
    }
    
    // 로그인 성공시에 탭바뷰 컨트롤러의 storyboard id("tabbar")를 추적해 그 화면으로 전환
    func moveto_tabbar() {
        let storyBoard = self.storyboard!
        let tabbarcontroller = storyBoard.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
        present(tabbarcontroller, animated: true, completion: nil)
    }

    @IBOutlet weak var inputtext: UITextField!
    
    //닉네임생성완료 버튼누르면 실행
    @IBAction func make_nickname(sender: UIButton) {
        
        let getfromappdelegate = UIApplication.shared.delegate as? AppDelegate // Appdelegate 참조후 캐스팅
        var sns = getfromappdelegate?.sns_name
        var acToken = getfromappdelegate?.access_token
        //닉네임 서버로 송신하는코드
        let urlStr = "http://ec2-18-222-143-156.us-east-2.compute.amazonaws.com:3000/login/set_nickname"
        let url = URL(string :urlStr)!
        var confirmed_nickname = ""
        var confirmed_id = 0
        print(sns)
        print(acToken)
        
        //서버에서 받을 json 구조체
        struct getinfo : Codable {
                   var nickname : String
                   var id : Int
               }
        
        //서버로 생성할 닉네임 보내고 nickname,id json데이터 받아오기
        let req = AF.request(url,
                             method:.post,
                             parameters: ["nickname" : inputtext.text, "sns" : sns, "accesstoken" : acToken],
                             encoding: JSONEncoding.default)

        req.responseJSON { res in
            print(res)

            switch res.result{

            case.success (let value):
                do{
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let logininfo = try JSONDecoder().decode(getinfo.self, from: data)

                    confirmed_nickname = logininfo.nickname
                    confirmed_id = Int(logininfo.id)
                }
                catch{
                }

            case .failure(let error):
                print("error :\(error)")
                break;
            }

        }
        first_save(confirmed_nickname, Int(confirmed_id))
    }
}
