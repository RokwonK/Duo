//
//  TableViewController.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class LolMainBoard: UITableViewController {
    
    @IBOutlet var TableViewController: UITableView!
    var postsData : Array<Dictionary<String, Any>>?;
    var userId : Int?;
    var userNickname : String?;
    
    
    
    func fetch() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        //Login entity 불러오는 동작
        let fetch_request = NSFetchRequest<NSManagedObject>(entityName: "LoginInfo")
        fetch_request.returnsObjectsAsFaults = false //데이터참조 오류 방지
        
        do {
            let userData : [NSManagedObject];
            let user : NSManagedObject?;
            try userData = context.fetch(fetch_request) //처음에 선언한 배열에 넣기
            user = userData[userData.count-1];
            if let us = user {
                if let usid = us.value(forKey: "id") as? Int{
                    userId = usid;
                    print(usid)
                }
                if let usnick = us.value(forKey: "nickname") as? String {
                    userNickname = usnick;
                    print(usnick)
                }
            }
            //print(user["data"])
        }
        catch let error as NSError {
            print("불러올수 없습니다. \(error), \(error.userInfo)")
        }
    }
    
    
    func getPosts() {
        fetch();
        let urlStr = "http://ec2-18-222-143-156.us-east-2.compute.amazonaws.com:3000/post/lol/getpost"
        let url = URL(string :urlStr)!
        let req = AF.request(url,
                            method:.post,
                            parameters: ["userId" : userId, "userNickname" : userNickname],
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
    
    // 테이블의 갯수 정의
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = postsData {
            return posts.count;
        }
        
        return 0;
    }
    
    
    // 테이블 cell 하나하나의 값에 무엇이 들어가는지 정의
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewController.dequeueReusableCell(withIdentifier: "LoLPostCell", for: indexPath) as! LoLPostCell
        
        let index = indexPath.row;
        if let posts = postsData {
            let row = posts[index];
            if let v = row as? Dictionary<String,Any> {
                if let gm = v["gameMode"] as? String{
                    cell.gameMode.text = gm;
                }
                
                print(v)
                
            }
        }
        
        
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPosts();
    }

    // MARK: - Table view data source

    
    @IBAction func filter (_sender : UIBarButtonItem){
        let storyBoard = self.storyboard!
        let filterpage = storyBoard.instantiateViewController(withIdentifier: "filter") as! Filterpage
        present(filterpage, animated: true, completion: nil)
    }
    
    // 세그 연결해야함 LoLPostCell 과 그 클래스를 segue show 연결하센
    // 연결하고 밑에 주석 푸센
    // Selection Segue => Show
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(11)
        if let id = segue.identifier, "Select" == id  {
            
            guard let controller = segue.destination as? SelectBoard else{return}
            print(33)
            if let posts = postsData {
                //print(posts)
                if let indexPath = TableViewController.indexPathForSelectedRow {
                    let row = posts[indexPath.row]
                    if let r = row as? Dictionary<String, Any> {
                        print(r)
                        controller.boardInfo = r;
                    }

                }
            }
            

        }
    }
    
    

    
}
