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
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var appNotification: UILabel!
    @IBOutlet weak var userSupport: UILabel!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    
    func addBottomBorder() {
        let thickness: CGFloat = 1.0
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.appNotification.frame.size.height - thickness, width: self.appNotification.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        appNotification.layer.addSublayer(bottomBorder)
        
    }
    
    func addBottomBorder2() {
        let thickness: CGFloat = 1.0
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.appNotification.frame.size.height - thickness, width: self.appNotification.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
       
        userSupport.layer.addSublayer(bottomBorder)
    }
    
    func addBottomBorder3() {
        let thickness: CGFloat = 1.0
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.appNotification.frame.size.height - thickness, width: self.appNotification.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
       
        account.layer.addSublayer(bottomBorder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //BaseFunc.fetch()
        userNickname.text = "\(ad!.nickname)님"
        addBottomBorder()
        addBottomBorder2()
        addBottomBorder3()
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
        
        let alert = UIAlertController(title: nil , message: "로그아웃 완료", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler : {(alert: UIAlertAction!) in
                                        self.returnToLogin()})
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    struct resultMessage : Codable {
        var msg : String
        var code : Int
    }
    
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

