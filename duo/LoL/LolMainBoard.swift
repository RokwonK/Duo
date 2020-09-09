//
//  TableViewController.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire

class LolMainBoard: UITableViewController{
    
    @IBOutlet var TableViewController: UITableView!
    var postsData : Array<Dictionary<String, Any>>?;
    let eachTier : Array<String> = ["i", "b", "s", "g", "p", "d", "m", "gm", "c"];
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    func getPosts() {
        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/lol/getpost")!
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
    
    // 테이블의 갯수 정의
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ad!.record > 0{
            postsData = ad!.filterdata
        }
        if let posts = postsData {
            return posts.count;
        }
        return 0;
    }
    
    
    // 테이블 cell 하나하나의 값에 무엇이 들어가는지 정의
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ad!.record > 0{
            postsData = ad!.filterdata
        }
        let cell = TableViewController.dequeueReusableCell(withIdentifier: "LoLPostCell", for: indexPath) as! LoLPostCell
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
    
    // Selection Segue => Show
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ad!.record > 0{
            postsData = ad!.filterdata
        }
        if let id = segue.identifier, "Select" == id  {
            guard let controller = segue.destination as? SelectBoard else{return}
            if let posts = postsData {
                if let indexPath = TableViewController.indexPathForSelectedRow {
                    let row = posts[indexPath.row]
                    if let r = row as? Dictionary<String, Any> {
                        controller.boardInfo = r;
                    }
                }
            }
        }
    }
 
    @IBAction func filter (_sender : UIBarButtonItem){
        let storyBoard = self.storyboard!
        let filterpage = storyBoard.instantiateViewController(withIdentifier: "filter") as! Filterpage
        self.present(filterpage, animated: true, completion: nil)
    }
    
    // 버튼을 직접 작성으로 만든 이유... 스토리보드로 만드니 크기조절을 못함...
    let upLoadBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewController.delegate = self
        TableViewController.dataSource = self
        
        upLoadBtn.setTitle("글 쓰기", for: .normal);
        upLoadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        upLoadBtn.setTitleColor(.white, for: .normal)
        upLoadBtn.backgroundColor = UIColor.gray;
        upLoadBtn.layer.cornerRadius = 18;
        self.view.addSubview(upLoadBtn);
        
        upLoadBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼의 x좌표를 superview의 x축 기준 가운데 정렬
        upLoadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        // 크기 조절
        upLoadBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        //upLoadBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true;
        
        // position : absolute
        if #available(iOS 11.0, *) {
            
            // 오른쪽 -140만큼 띄움 safeAreaLayoutGuid => bar랑 메뉴바 같은거 제외한 뷰
            upLoadBtn.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 210-self.view.frame.width).isActive = true
            upLoadBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        }
        else {
            upLoadBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
            upLoadBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        }
        
        // 클릭시 이벤트 지정, 터치한 컴포넌트에서 손을 땟을때 실행
        upLoadBtn.addTarget(self, action: #selector(upLoadPost), for: .touchUpInside)
        self.getPosts();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        DispatchQueue.main.async {
            // 테이블 뷰에 그리기
            self.TableViewController.reloadData();
        }
        print("viewdidappear 도달")
    }
    
    //@ogjc => 각각의 변수, 함수 등에 적용하여 ObjectiveC의 접근을 가능하게 해준다.
    @objc func upLoadPost() {
        
        if let upLoadView = self.storyboard?.instantiateViewController(identifier: "UpLoadLoLPost") as? UpLoadLoLPost {
            // 아래에서 위로 올라오게
            upLoadView.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
            // 화면을 꽉 채우게
            upLoadView.modalPresentationStyle = .currentContext
            present(upLoadView, animated: true, completion: nil)
        }
        
        // 제목과 메세지 지정
//        let alert = UIAlertController(title: "업로드 성공!", message: "", preferredStyle: .alert)
//
//        // 확인버튼 만들기
//        alert.addAction(UIAlertAction(title: "확인"
//            , style: .default , handler: nil))
//
//        // 화면에 띄우기
//        present(alert, animated: true, completion: nil)
    }
}
