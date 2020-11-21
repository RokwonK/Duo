//
//  SelectBoard.swift
//  duo
//
//  Created by 김록원 on 2020/09/02.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire

class SelectBoard : UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    let ad = UIApplication.shared.delegate as? AppDelegate
    var commentsData : Array<Dictionary<String, Any>>?;
    
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var postComment: UIButton!
    @IBAction func postComment(_ sender: Any) {
        let url = URL(string : BaseFunc.baseurl + "/comment/lol")!
        let req = AF.request(url,
                             method:.post,
                             parameters: ["content": "댓글추가",
                                          "userId": ad!.userID,
                                          "postId": postID,
                                          "nickname" : ad!.nickname],
                             encoding: JSONEncoding.default,
                             headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"])
        // db에서 값 가져오기
        req.responseJSON {res in
            print(res)
            switch res.result {
            case.success(let value): break
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var boardInfo : Dictionary<String,Any>?;
    var postID : Int = 0
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var boardtitle: UILabel!
    @IBOutlet weak var gamemode: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var mic: UILabel!
    @IBOutlet weak var peoplenum: UILabel!
    @IBOutlet weak var boardtext: UILabel!
    @IBOutlet weak var end: UILabel!
    
    @IBOutlet weak var toplabel: UILabel!
    @IBOutlet weak var junglelabel: UILabel!
    @IBOutlet weak var midlabel: UILabel!
    @IBOutlet weak var bottomlabel: UILabel!
    @IBOutlet weak var supportlabel: UILabel!
    
    @IBAction func temp(_ sender: Any) {
        let url = URL(string : BaseFunc.baseurl + "/comment/lol")!
        let req = AF.request(url,
                             method:.post,
                             parameters: ["content": "임시테스트",
                                          "userId": ad!.userID,
                                          "postId": postID,
                                          "nickname" : ad!.nickname],
                             encoding: JSONEncoding.default,
                             headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"])
        // db에서 값 가져오기
        req.responseJSON {res in
            print(res)
            switch res.result {
            case.success(let value): break
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    let eachTier : Array<String> = ["i", "b", "s", "g", "p", "d", "m", "gm", "c"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableview.delegate = self
        tableview.dataSource = self
//        ScrollView.delegate = self
        
        DispatchQueue.main.async {
            self.tableviewheight.constant = self.tableview.contentSize.height
           }
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
      
        
        postID = boardInfo?["id"] as! Int
        print(postID)
        let url = URL(string : BaseFunc.baseurl + "/comment/lol")!
        let req = AF.request(url,
                             method:.get,
                             parameters: ["postId": postID],
                             encoding: URLEncoding.queryString,
                             headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"])
        // db에서 값 가져오기
        req.responseJSON {res in
            print(res)
            switch res.result {
            case.success(let value):
                if let datas = value as? Array<Dictionary<String,Any>> {
                    self.commentsData = datas;
                    DispatchQueue.main.async {
                        self.tableview.reloadData();
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        var talkon = boardInfo?["talkon"] as! Int
        var startt = boardInfo?["startTier"] as! Int
        var endt = boardInfo?["endTier"] as! Int
        var headcount = boardInfo?["headCount"] as! Int
        var Top = boardInfo?["top"] as! Int
        var Jungle = boardInfo?["jungle"] as! Int
        var Mid = boardInfo?["mid"] as! Int
        var Bottom = boardInfo?["bottom"] as! Int
        var Support = boardInfo?["support"] as! Int
        
        switch talkon{
        case 1:
            mic.text = "토크온: 가능"
        case 2:
            mic.text = "토크온: 불가능"
        case 3:
            mic.text = "토크온: 상관없음"
        default:
            return
        }
        
        
        let stShared = startt/10;
        let stRemaind = startt % 10;
        let edShared = endt/10;
        let edRemaind = endt % 10;
        
        if (startt == 1 && endt == 100) {
            start.text = "모든티어"
            end.text = "모든 티어"
        }
        else if (startt == 1) {
            end.text = "\(eachTier[edShared] + "\(10-edRemaind)" )"
        }
        else if (endt == 100) {
            start.text = "\(eachTier[stShared] + "\(10-stRemaind)" )";
        }
        else {
            start.text = "\(eachTier[stShared] + "\(10-stRemaind)" )"
            end.text = "\(eachTier[edShared] + "\(10-edRemaind)" )"
        }
        
        
        nickname.text = "닉네임: \(boardInfo?["nickname"] as! String)"
        boardtitle.text = boardInfo?["title"] as! String
        gamemode.text = boardInfo?["gameMode"] as! String
        time.text = "마감시간: \(boardInfo?["endTime"] as! String)"
        boardtext.text = boardInfo?["content"] as! String
        peoplenum.text = "인원:\(headcount)명모집"
        
        if (Top == 1 || Top == 3) {
            toplabel.backgroundColor = UIColor.green
        }
        if (Jungle == 1 || Jungle == 3) {
            junglelabel.backgroundColor = UIColor.green
        }
        if (Mid == 1 || Mid == 3) {
            midlabel.backgroundColor = UIColor.green
        }
        if (Bottom == 1 || Bottom == 3) {
            bottomlabel.backgroundColor = UIColor.green
        }
        if (Support == 1 || Support == 3) {
            supportlabel.backgroundColor = UIColor.green
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async {
            self.tableview.reloadData();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let comments = commentsData {
//            return comments.count;
//        }
//        return 0;
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentCell
        
        if let comments = commentsData {
            let v = comments[indexPath.row];
            if let cm = v["content"] as? String {
                cell.CommentTable.text = cm
                cell.CommentTable.font = UIFont.boldSystemFont(ofSize: 18)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let popover = UIStoryboard(name: "GameTab", bundle: nil).instantiateViewController(withIdentifier: "popup")
            
            
            popover.modalPresentationStyle = UIModalPresentationStyle.popover
            
            //        popover.popoverPresentationController?.delegate = self
            //        popover.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
            //        popover.popoverPresentationController?.sourceRect = devicesTableView.bounds
            //        popover.popoverPresentationController?.permittedArrowDirections = .any
            self.present(popover, animated: true, completion: nil)
        }
        
    }
    
}
