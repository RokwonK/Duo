//
//  SelectBoard.swift
//  duo
//
//  Created by 김록원 on 2020/09/02.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit
import Alamofire

class SelectBoard : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var uploadComment: UIButton!
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    var commentsData : Array<Dictionary<String, Any>>?;
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!

    @IBAction func postComment(_ sender: Any) {
        let url = URL(string : BaseFunc.baseurl + "/comment/lol")!
        let req = AF.request(url,
                             method:.post,
                             parameters: ["content": commentTextfield.text!,
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
        self.view.endEditing(true);
        commentTextfield.text = ""
        postID = boardInfo?["id"] as! Int
        print(postID)
        let url2 = URL(string : BaseFunc.baseurl + "/comment/lol")!
        let req2 = AF.request(url2,
                             method:.get,
                             parameters: ["postId": postID],
                             encoding: URLEncoding.queryString,
                             headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"])
        // db에서 값 가져오기
        req2.responseJSON {res in
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
        
    }
    func addBottomBorder() {
        let thickness: CGFloat = 1.0
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.topView.frame.size.height - thickness, width: self.topView.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        topView.layer.addSublayer(bottomBorder)
        
    }
    var boardInfo : Dictionary<String,Any>?;
    var postID : Int = 0
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var boardtitle: UILabel!
    @IBOutlet weak var gamemode: UILabel!
    @IBOutlet weak var time: UILabel!
//    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var mic: UILabel!
    @IBOutlet weak var peoplenum: UILabel!
    @IBOutlet weak var boardtext: UILabel!
//    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var tierRangeField: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var gameMode: UILabel!
    @IBOutlet weak var people: UILabel!
    @IBOutlet weak var tierRange: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var micBool: UILabel!
    
    @IBOutlet var superview: UIView!
    @IBOutlet weak var stack: UIStackView!
    
    let eachTier : Array<String> = ["Iron", "Bronze", "Silver", "Gold", "Platinum", "Diamond", "Master", "GrandMaster", "Challenger"];
    
    @objc func textViewMoveUp(_ notification: NSNotification){ if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue { UIView.animate(withDuration: 0.3, animations: { self.superview.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height+83) }) } }
    
    @objc func textViewMoveDown(_ notification: NSNotification){ self.superview.transform = .identity }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true) }

    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        super.viewDidLoad();
        tableview.delegate = self
        tableview.dataSource = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        ScrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        gameMode.clipsToBounds = true
        gameMode.layer.cornerRadius = 13
        people.clipsToBounds = true
        people.layer.cornerRadius = 13
        tierRange.clipsToBounds = true
        tierRange.layer.cornerRadius = 13
        position.clipsToBounds = true
        position.layer.cornerRadius = 13
        micBool.clipsToBounds = true
        micBool.layer.cornerRadius = 13

        self.navigationController?.navigationBar.tintColor = UIColor.black
        
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
            mic.text = "가능"
        case 2:
            mic.text = "불가능"
        case 3:
            mic.text = "상관없음"
        default:
            return
        }
        
        let stShared = startt/10;
        let stRemaind = startt % 10;
        let edShared = endt/10;
        let edRemaind = endt % 10;
        
        if (startt == 1 && endt == 100) {
            tierRangeField.text = "모든티어"
        }
        else if (startt == 1) {
            tierRangeField.text = "~\(eachTier[edShared] + "\(10-edRemaind)" )"
        }
        else if (endt == 100) {
            tierRangeField.text = "\(eachTier[stShared] + "\(10-stRemaind)" )~";
        }
        else {
            tierRangeField.text = "\(eachTier[stShared] + "\(10-stRemaind)" ) ~ \(eachTier[edShared] + "\(10-edRemaind)" )"
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let startTime = format.date(from: boardInfo?["endTime"] as! String)
        
        let currentDate = Date()
        var useTime = Int(startTime!.timeIntervalSince(currentDate))
        if (useTime >= 0){
            if (useTime>=3600){
                if (useTime>=86400){
                    time.text = "\(useTime/86400)일 \((useTime/3600)%24)시간 \((useTime/60)%60)분후 만료"
                }
                else{
                    time.text = "\(useTime/3600)시간 \((useTime/60)%60)분후 만료"
                }
            }
            else{
                time.text = "\(useTime/60)분후 만료"
            }
        }
        else{
            time.text = "모집만료"
        }

        nickname.text = "\(boardInfo?["nickname"] as! String)"
        boardtitle.text = boardInfo?["title"] as! String
        gamemode.text = boardInfo?["gameMode"] as! String
        boardtext.text = boardInfo?["content"] as! String
        peoplenum.text = "\(headcount)명"
        
        if (Top == 1 || Top == 3) {
            positionLabel.text?.append("  탑")
        }
        if (Jungle == 1 || Jungle == 3) {
           
            positionLabel.text?.append("  정글")
        }
        if (Mid == 1 || Mid == 3) {
            positionLabel.text?.append("  미드")
        }
        if (Bottom == 1 || Bottom == 3) {
            positionLabel.text?.append("  원딜")
        }
        if (Support == 1 || Support == 3) {
            positionLabel.text?.append("  서폿")
        }
    }
    
    @objc func MyTapMethod(sender : UITapGestureRecognizer) {
        self.view.endEditing(true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tableview.reloadData();
        addBottomBorder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableview.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
                if let newvalue = change?[.newKey]{
                    let newsize = newvalue as! CGSize
                    self.tableviewheight.constant = newsize.height
                }
            }
        }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comments = commentsData {
            return comments.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentCell
        
        if let comments = commentsData {
            let v = comments[indexPath.row];
            if let cm = v["content"] as? String {
                cell.CommentTable.text = cm
            }
            if let nn = v["nickname"] as? String{
                cell.nicknameCell.text = nn
                cell.nicknameCell.font = UIFont.boldSystemFont(ofSize: 18)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
