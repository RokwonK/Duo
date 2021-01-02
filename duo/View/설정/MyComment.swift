//
//  MyComment.swift
//  duo
//
//  Created by 황윤재 on 2020/11/22.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire

class MyComment: UITableViewController{
    let ad = UIApplication.shared.delegate as? AppDelegate
    var commentsData : Array<Dictionary<String, Any>>?;
    
    @IBOutlet var tableview: UITableView!
    // 테이블의 갯수 정의
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let posts = commentsData {
            return posts.count;
        }
        return 0;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async {
            self.tableview.reloadData();
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentCell
        
        if let comments = commentsData {
            let v = comments[indexPath.row];
            if let cm = v["content"] as? String {
                cell.MyCommentCell.text = cm
                cell.MyCommentCell.font = UIFont.boldSystemFont(ofSize: 18)
            }
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        let url = URL(string : BaseFunc.baseurl + "/comment/me")!
        let req = AF.request(url,
                            method:.get,
                            parameters: ["userId": ad!.userID],
                            encoding: URLEncoding.queryString,
                            headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"]
                            )
        // db에서 값 가져오기
        req.responseJSON {res in
            print(res)
            switch res.result {
            case.success(let value):
                if let datas = value as? Array<Dictionary<String,Any>> {
                    self.commentsData = datas;
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
