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

    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableview.delegate = self
        tableview.dataSource = self
        var talkon = boardInfo?["talkon"] as! Int
        var startt = boardInfo?["startTier"] as! Int
        var endt = boardInfo?["endTier"] as! Int
//        var headcount = boardInfo?["headcount"] as! Int
        
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
        
        switch startt{
        case 1:
            start.text = "상관없음"
        default:
            return
        }
        
        switch endt{
        case 100:
            end.text = "상관없음"
        default:
            return
        }
        
//        switch headcount{
//        case 1:
//            peoplenum.text = "1명"
//        case 2:
//        default:
//            return
//        }
        
        nickname.text = boardInfo?["nickname"] as! String
        boardtitle.text = boardInfo?["title"] as! String
        gamemode.text = boardInfo?["gameMode"] as! String
        time.text = boardInfo?["createdAt"] as! String
        boardtext.text = boardInfo?["content"] as! String
        

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

class CommentTable: UITableViewCell{
    
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var gotochat: UIButton!
    
}
