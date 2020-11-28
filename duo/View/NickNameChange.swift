//
//  NickNameChange.swift
//  duo
//
//  Created by 황윤재 on 2020/11/10.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class NickNameChange : UIViewController {
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.layer.cornerRadius = 7;
        
        // Do any additional setup after loading the view.
    }
    func save( _ nickName: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        // AppDelegate.swift 파일에서 참조얻기
        let context = appDelegate.persistentContainer.viewContext // context객체 참조
        let entity = NSEntityDescription.entity(forEntityName: "LoginInfo", in: context)! // entity 객체 생성
        let login = NSManagedObject(entity: entity, insertInto: context)//entity 설정
        
        //entity 속성값 설정
        login.setValue(nickName, forKey: "nickname")
        
        do{
            try context.save()
        } catch let error as NSError{
            print("저장 오류 \(error), \(error.userInfo)")
        }
    }
    
    func gobackToAccountView() {
        let storyBoard = self.storyboard!
        let AccountView = storyBoard.instantiateViewController(withIdentifier: "AccountView")
        present(AccountView, animated: true, completion: nil)
    }
    
    //닉네임생성완료 버튼누르면 실행
    @IBAction func changeNickName(sender: Any) {
        
//        let ad = UIApplication.shared.delegate as? AppDelegate // Appdelegate 참조후 캐스팅
//        var sns_name = ad!.sns_name!
//        var snsToken = ad!.access_token!
        //닉네임 서버로 송신하는코드
        let urlString = "http://ec2-18-222-143-156.us-east-2.compute.amazonaws.com:3000/auth"
        let url = URL(string :urlString)!
        
        var r_msg = ""
        var r_code = 0
        
        //서버에서 받을 json 구조체
        struct resultMessage : Codable {
            var msg : String
            var code : Int
        }
        
        //서버로 생성할 닉네임 보내고 nickname,id json데이터 받아오기
        let req = AF.request(url,
                             method:.put,
                             parameters: ["nickname" : inputText.text,
                                          "userId" : ad!.userID],
                             encoding: JSONEncoding.default,
                             headers: ["Authorization": ad!.access_token, "Content-Type": "application/json"])

        req.responseJSON { res in
            print(res)

            switch res.result{

            case.success (let value):
                do{
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let result = try JSONDecoder().decode(resultMessage.self, from: data)
//                    self.save(self.inputText.text!)
                    r_msg = result.msg
                    r_code = result.code
//                    self.dismiss(animated: true, completion: nil)
                    
                    let alert = UIAlertController(title: nil , message: "닉네임 변경 완료", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default, handler: {action in self.navigationController?.popToRootViewController(animated: true)})
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    
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
