//
//  AccountTab.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//
import Alamofire
import UIKit

class AccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseFunc.fetch()
        // Do any additional setup after loading the view.
    }
    
    func goto_loginpage () {
        let storyBoard = self.storyboard!
        let loginpage = storyBoard.instantiateViewController(withIdentifier: "loginpage") as! ViewController
        present(loginpage, animated: true, completion: nil)
    }
    
    @IBAction func Logout(_sender : UIButton){
        ViewController().naverLogout()
        ViewController().kakaoLogout()
        ViewController().googleLogout()
        
        goto_loginpage()
    }
    
    @IBAction func DeleteAccount(_ sender: Any) {
        
        let ad = UIApplication.shared.delegate as? AppDelegate
        let url = URL(string : BaseFunc.baseurl + "/login/delete_account")!
        var acToken = ad?.access_token
        var sns = ad?.sns_name
        print(acToken)
        print(sns)
        let req = AF.request(url,
                             method:.post,
                             parameters: ["accesstoken" : acToken, "sns" : sns ,"userId": BaseFunc.userId ],
                             encoding: JSONEncoding.default)
        req.responseJSON { res in
            print(res)
            switch res.result {
            case.success (let value):
                do{
                    let deletedata = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let alert = UIAlertController(title: nil , message: "회원탈퇴 완료", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "꺼져", style: .default, handler : {(alert: UIAlertAction!) in ViewController().naverLogout();ViewController().kakaoLogout();ViewController().googleLogout();self.goto_loginpage()})
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

