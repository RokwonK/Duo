//
//  SelectBoard.swift
//  duo
//
//  Created by 김록원 on 2020/09/02.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class SelectBoard : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    let eachTier : Array<String> = ["i", "b", "s", "g", "p", "d", "m", "gm", "c"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableview.delegate = self
        tableview.dataSource = self
        
        postID = boardInfo?["id"] as! Int
        print(postID)
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
        time.text = "시작시간: \(boardInfo?["startTime"] as! String)"
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTable
        cell.comment.text = "댓글"
        return cell
        
    }
}

//댓글
class CommentTable: UITableViewCell{
    
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var gotochat: UIButton!
    
    
}
