//
//  MyPost.swift
//  duo
//
//  Created by 황윤재 on 2020/09/05.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire

class MyPostView :  UITableViewController{
    
    @IBOutlet var TableViewController: UITableView!
    var postsData : Array<Dictionary<String, Any>>?;
    let eachTier : Array<String> = ["i", "b", "s", "g", "p", "d", "m", "gm", "c"];

    func getPosts() {
        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/mypost")!
        print("id : \(BaseFunc.userId)")
        print("id : \(BaseFunc.userNickname)")
        let req = AF.request(url,
                            method:.post,
                            parameters: ["userId" : BaseFunc.userId, "userNickname" : BaseFunc.userNickname],
                            encoding: JSONEncoding.default)
        // db에서 값 가져오기
        req.responseJSON {res in
            switch res.result {
            case.success(let value):
                
                if let datas = value as? Array<Dictionary<String,Any>> {
                    self.postsData = datas;
                    
                    DispatchQueue.main.async {
                        // 테이블 뷰에 그리기
                        self.TableViewController.reloadData();
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func send(){
//        BaseFunc.fetch();
//        let url = URL(string : BaseFunc.baseurl + "/post/lol/uploadpost")!
//        let req = AF.request(url,
//                             method:.post,
//                             parameters: ["userId" : BaseFunc.userId, "userNickname" : BaseFunc.userNickname, "gameMode" : "soloRank", "title" : "졸려...","startTier":1,"endTier":100,"startTime":"17:00"
//                                ,"content":"ㅎㅇ", "headCount":3, "top" : 3,
//                                 "bottom" : 3, "mid" : 3, "jungle" : 3, "support" : 3, "talkon" : 3],
//                             encoding: JSONEncoding.default)
//
//        req.responseJSON { res in
//            print(res)
//
//            switch res.result{
//            case.success (let value):
//                do{
//                    let data1 = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                    print(data1)
//                }
//                catch{
//                }
//            case .failure(let error):
//                print("error :\(error)")
//                break;
//            }
//        }
//    }

    // 테이블의 갯수 정의
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = postsData {
            return posts.count;
        }
        return 0
    }
    
    // 테이블 cell 하나하나의 값에 무엇이 들어가는지 정의
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = TableViewController.dequeueReusableCell(withIdentifier: "MyPostCell", for: indexPath) as! Mypostcell
        print(indexPath)
        let index = indexPath.row;
        if let posts = postsData {
            let v = posts[index];
            print(v)
            
            if let top = v["top"] as? Int {
                if (top == 1) {
                    cell.top.backgroundColor = UIColor.green
                }
            }
            if let bottom = v["bottom"] as? Int {
                if (bottom == 1){
                    cell.bottom.backgroundColor = UIColor.green
                    //cell.bottom.layer.backgroundColor = UIColor.green.cgColor;
                }
            }
            if let mid = v["mid"] as? Int {
                if (mid == 1) {
                    cell.mid.backgroundColor = UIColor.green;
                }
            }
            if let sup = v["support"] as? Int {
                if (sup == 1) {
                    cell.support.backgroundColor = UIColor.green;
                }
            }
            if let jung = v["jungle"] as? Int {
                if (jung == 1) {
                    cell.jungle.backgroundColor = UIColor.green;
                }
            }
            
            if let gm = v["gameMode"] as? String{
                cell.gameMode.text = gm;
            }
            if let hc = v["headCount"] as? Int {
                cell.headCount.text = "인원 \(hc)"
            }
            if let tit = v["title"] as? String {
                cell.title.text = tit;
                cell.title.font = UIFont.boldSystemFont(ofSize: 20)
            }
            if let st = v["startTime"] as? String {
                cell.startTime.text = "시작시간 : \(st)";
            }
            
            if let stTier = v["startTier"] as? Int {
                if let edTier = v["endTier"] as? Int {
                    let stShared = stTier/10;
                    let stRemaind = stTier % 10;
                    let edShared = edTier/10;
                    let edRemaind = edTier%10;
                    
                    if (stTier == 1 && edTier == 100) {
                        cell.tier.text = "상관x";
                    }
                    else if (stTier == 1) {
                        cell.tier.text = "~\(eachTier[edShared] + "\(10-edRemaind)" )";
                    }
                    else if (edTier == 100) {
                        cell.tier.text = "\(eachTier[stShared] + "\(10-stRemaind)" )~";
                    }
                    else {
                        cell.tier.text = "\(eachTier[stShared] + "\(10-stRemaind)" )~\(eachTier[edShared] + "\(10-edRemaind)" )";
                    }
                    
                }
            }
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.send()
        self.getPosts()
        
    }
}
