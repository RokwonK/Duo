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
    
    @IBOutlet var MyPostTable: UITableView!
    let ad = UIApplication.shared.delegate as? AppDelegate
    let eachTier : Array<String> = ["i", "b", "s", "g", "p", "d","q", "m", "gm", "c"];
    var postsData : Array<Dictionary<String, Any>>?;
    
    func getPosts() {
        //        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/me")!
        let req = AF.request(url,
                             method:.get,
                             parameters: ["userId" : ad!.userID],
                             encoding: URLEncoding.queryString,
                             headers: ["Authorization": ad!.access_token, "Content-Type": "application/json"])
        // db에서 값 가져오기
        req.responseJSON {res in
            print(res)
            switch res.result {
            case.success(let value):
                
                if let datas = value as? Array<Dictionary<String,Any>> {
                    self.postsData = datas;
                    DispatchQueue.main.async {
                        // 테이블 뷰에 그리기
                        self.MyPostTable.reloadData();
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    struct Message : Codable {
        var msg : String
    }
    
    @IBAction func delete (){
        //        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/lol")!
        let req = AF.request(url,
                             method:.get,
                             parameters: ["userId" : BaseFunc.userId],
                             encoding: JSONEncoding.default,
                             headers: ["Authorization": BaseFunc.userToken, "Content-Type": "application/json"])
        
        req.responseJSON { res in
            print(res)
            switch res.result {
            case.success (let value):
                if let datas = value as? Array<Dictionary<String,Any>> {
                    self.postsData = datas;
                    DispatchQueue.main.async {
                        /*
                         didset {
                         }
                         */
                        self.MyPostTable.reloadData();
                    }
                }

            case.failure(let error):
                print("error :\(error)")
                break;
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
        
        let cell = MyPostTable.dequeueReusableCell(withIdentifier: "MyPostCell", for: indexPath) as! MyPostCell
        extension_cellSetting(cell);
        
        print(indexPath)
        let index = indexPath.row;
        if let posts = self.postsData {
            let v = posts[indexPath.row]
            
            if let top = v["top"] as? Int, top == 2 {
                cell.topBtn.isHidden = true;
            }
            if let bottom = v["bottom"] as? Int, bottom == 2 {
                cell.bottomBtn.isHidden = true;
            }
            if let mid = v["mid"] as? Int, mid == 2 {
                cell.midBtn.isHidden = true;
            }
            if let sup = v["support"] as? Int, sup == 2 {
                cell.supportBtn.isHidden = true;
            }
            if let jung = v["jungle"] as? Int, jung == 2 {
                cell.jungleBtn.isHidden = true;
            }
            
            if let talk = v["talkon"] as? Int, talk == 2 {
                cell.micFillBtn.isHidden = true;
            }
            else {
                cell.micNotBtn.isHidden = true;
            }
            
            
            if let gm = v["gameMode"] as? String{
                cell.gameMode.setTitle("\(gm)", for: .normal);
            }
            if let hc = v["headCount"] as? Int {
                cell.headCount.setTitle("인원 \(hc)명", for: .normal);
            }
            if let tit = v["title"] as? String {
                cell.title.text = tit;
                cell.title.font = UIFont.boldSystemFont(ofSize: 18)
            }
            if let st = v["startTime"] as? String {
                //cell.startTime.text = "시작시간 : \(st)";
                
                // 각각 뽑기 위해서 Date객체로의 변환이 필요
                // MM-dd를 뽑고 같으면 오늘 다르면 내일
                // HH:mm을 뽑아서 사용자에게 보여줌
                
                // String => Date로 바꿈;
                let thisDateFormatter = DateFormatter();
                thisDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let thisDate = thisDateFormatter.date(from: st)!;
                thisDateFormatter.dateFormat = "MM-dd";
                let thisDateMMdd = thisDateFormatter.string(from : thisDate);
                
                //let nowDateFormatter = DateFormatter();
                let nowDate = Date()
                let nowDateMMdd = thisDateFormatter.string(from : nowDate);
                
                thisDateFormatter.dateFormat = "HH:mm";
                let thisStartTime = thisDateFormatter.string(from : thisDate)
                if (nowDateMMdd == thisDateMMdd) {
                    cell.startTime.text = "오늘 \(thisStartTime)"
                }
                else {
                    cell.startTime.text = "내일 \(thisStartTime)"
                }
            }
            
            if let stTier = v["startTier"] as? Int {
                if let edTier = v["endTier"] as? Int {
                    let stShared = stTier/10;
                    var stRemaind = stTier % 10;
                    let edShared = edTier/10;
                    var edRemaind = edTier%10;
                    if (stRemaind == 0) {stRemaind = 10}
                    if (edRemaind == 0) {edRemaind = 10}
                    
                    if (stTier == 1 && edTier == 100) {
                        cell.tier.setTitle("상관x", for: .normal);
                    }
                    else if (stTier == 1) {
                        cell.tier.setTitle("~\(eachTier[edShared] + "\(10-edRemaind)" )", for: .normal);
                    }
                    else if (edTier == 100) {
                        cell.tier.setTitle("\(eachTier[stShared] + "\(10-stRemaind)" )~", for: .normal);
                    }
                    else {
                        cell.tier.setTitle("\(eachTier[stShared] + "\(10-stRemaind)" )~\(eachTier[edShared] + "\(10-edRemaind)" )", for: .normal);
                    }
                }
            }
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyPostTable.delegate = self
        MyPostTable.dataSource = self
        self.getPosts()
        print("오냐?")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async {
            self.MyPostTable.reloadData();
        }
    }
}
