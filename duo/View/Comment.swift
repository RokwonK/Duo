//
//  Comment.swift
//  duo
//
//  Created by 황윤재 on 2020/11/15.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire

class Comment : UITableViewController{
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    var postsData : Array<Dictionary<String, Any>>?;
    @IBOutlet var TableViewController: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad();
        print(SelectBoard().postID)
        
        let url = URL(string : BaseFunc.baseurl + "/comment/lol")!
        let req = AF.request(url,
                            method:.get,
                            parameters: ["postId": SelectBoard().postID],
                            encoding: URLEncoding.queryString,
                            headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"]
                            )
        // db에서 값 가져오기
        req.responseJSON {res in
            print(res)
            switch res.result {
            case.success(let value):
                
                if let datas = value as? Array<Dictionary<String,Any>> {
                    self.postsData = datas;
                    DispatchQueue.main.async {
                        self.TableViewController.reloadData();
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async {
            self.TableViewController.reloadData();
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let posts = postsData {
            return posts.count;
        }
        return 0;
    }
    
    // 테이블 cell 하나하나의 값에 무엇이 들어가는지 정의
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewController.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        if let posts = postsData {
            let v = posts[indexPath.row];
            
            if let hc = v["content"] as? String {
                cell.CommentTable.text = hc
                cell.CommentTable.font = UIFont.boldSystemFont(ofSize: 18)
            }
            
        }
        
        return cell
    }

    
}
