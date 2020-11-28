//
//  AccountTab.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//
import Alamofire
import UIKit

class AccountView: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
//        BaseFunc.fetch()
        
        view1.layer.cornerRadius = 12
        
        view1.layer.borderWidth = 1.0
        view1.layer.borderColor = UIColor.white.cgColor

        // shadow
        view1.layer.shadowColor = UIColor.lightGray.cgColor
        view1.layer.shadowOffset = CGSize(width: 0, height: 0)
        view1.layer.shadowOpacity = 0.7
        view1.layer.shadowRadius = 4.0
        // Do any additional setup after loading the view.
    }
    
    func returnToLogin () {
        let storyBoard = self.storyboard!
        let loginpage = storyBoard.instantiateViewController(withIdentifier: "LoginView") as! LoginView
        present(loginpage, animated: true, completion: nil)
        
    }
    
    @IBAction func Logout(_sender : UIButton){
        LoginViewModel().naverLogout()
        LoginViewModel().kakaoLogout()
        LoginViewModel().googleLogout()
        
        returnToLogin()
    }
    
    struct resultMessage : Codable {
        var msg : String
        var code : Int
    }
    
//    @IBAction func changeNickname (_sender : UIButton){
//        
//        let storyBoard = self.storyboard
//        let NickNameChange = storyBoard!.instantiateViewController(withIdentifier: "NickNameChange")
//        self.present(NickNameChange, animated: true, completion: nil)
//    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        
        struct resultMessage : Codable {
            var msg : String
            var code : Int
        }
        
        let url = URL(string : BaseFunc.baseurl + "/auth")!

        let req = AF.request(url,
                             method:.delete,
                             parameters: ["userId": ad!.userID],
                             encoding: JSONEncoding.default,
                             headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"])
        
        req.responseJSON { res in
            print(res)
            switch res.result {
            case.success (let value):
                do{
                    let deletedata = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let alert = UIAlertController(title: nil , message: "회원탈퇴 완료", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "회원탈퇴완료, 재로그인 필요", style: .default, handler : {(alert: UIAlertAction!) in
                        LoginViewModel().naverLogout()
                        LoginViewModel().kakaoLogout()
                        LoginViewModel().googleLogout()
                        self.returnToLogin()})
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                catch{
                }
            case.failure(let error):
                print("error :\(error)")
                break;
            }
        }
    }
}

