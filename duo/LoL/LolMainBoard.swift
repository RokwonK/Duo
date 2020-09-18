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
    
    @IBOutlet weak var naviBarOutlet: UINavigationItem!
    @IBAction func popAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    @IBOutlet weak var popOutlet: UIBarButtonItem!
    @IBOutlet weak var filterOutlet: UIBarButtonItem!
    @IBOutlet var TableViewController: UITableView!
    var postsData : Array<Dictionary<String, Any>>?;
    let eachTier : Array<String> = ["i", "b", "s", "g", "p", "d","q", "m", "gm", "c"];
    let Ad = UIApplication.shared.delegate as? AppDelegate
    
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
        
        if Ad!.record > 0{
            postsData = Ad!.filterdata
        }
        if let posts = postsData {
            return posts.count;
        }
        return 0;
    }
    
    // 테이블 cell 하나하나의 값에 무엇이 들어가는지 정의
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Ad!.record > 0{
            postsData = Ad!.filterdata
        }
        let cell = TableViewController.dequeueReusableCell(withIdentifier: "LoLPostCell", for: indexPath) as! LoLPostCell
        cell.tier.layer.cornerRadius = 7;
        cell.tier.tintColor = UIColor.white;
        cell.tier.backgroundColor = UIColor.orange;
        cell.tier.layer.masksToBounds = true;
        
        cell.gameMode.layer.cornerRadius = 7;
        cell.gameMode.tintColor = UIColor.white;
        cell.gameMode.backgroundColor = UIColor.orange;
        cell.gameMode.layer.masksToBounds = true;
        
        cell.headCount.layer.cornerRadius = 7;
        cell.headCount.tintColor = UIColor.white;
        cell.headCount.backgroundColor = UIColor.orange;
        cell.headCount.layer.masksToBounds = true;
        
        cell.startTime.textColor = UIColor.lightGray;
        cell.micFillBtn.tintColor = UIColor.orange;
        cell.micNotBtn.tintColor = UIColor.lightGray;
        
        print(indexPath)
        let index = indexPath.row;
        if let posts = postsData {
            let v = posts[index];
            print(v)
            
            if let top = v["top"] as? Int {
                if (top == 2) {
                    cell.topBtn.isHidden = true;
                }
            }
            if let bottom = v["bottom"] as? Int {
                if (bottom == 2){
                    cell.bottomBtn.isHidden = true;
                }
            }
            if let mid = v["mid"] as? Int {
                if (mid == 2) {
                    cell.midBtn.isHidden = true;
                }
            }
            if let sup = v["support"] as? Int {
                if (sup == 2) {
                    cell.supportBtn.isHidden = true;
                }
            }
            if let jung = v["jungle"] as? Int {
                if (jung == 2) {
                    cell.jungleBtn.isHidden = true;
                }
            }
            
            if let talk = v["talkon"] as? Int {
                if (talk == 2) {
                    cell.micFillBtn.isHidden = true;
                }
                else {
                    cell.micNotBtn.isHidden = true;
                }
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
    
    @IBAction func filter (_sender : UIBarButtonItem){
        let storyBoard = self.storyboard!
        let filterpage = storyBoard.instantiateViewController(withIdentifier: "filter") as! Filterpage
        let navController = UINavigationController(rootViewController: filterpage)
        
        navController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    // 버튼을 직접 작성으로 만든 이유... 스토리보드로 만드니 크기조절을 못함...
    let upLoadBtn = UIButton()
    func upLoadBtnStyle() {
        upLoadBtn.setTitle("글 쓰기", for: .normal);
        upLoadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        upLoadBtn.setTitleColor(.white, for: .normal)
        upLoadBtn.backgroundColor = UIColor.orange;
        upLoadBtn.layer.cornerRadius = 18;
        self.view.addSubview(upLoadBtn);
        
        // 코드로 constraint 사용하기
        upLoadBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼의 x좌표를 superview의 x축 기준 가운데 정렬
        upLoadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        // 크기 조절
        upLoadBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        //upLoadBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true;
        
        // position : absolute
        if #available(iOS 11.0, *) {
            
            // 오른쪽 -140만큼 띄움 safeAreaLayoutGuid => bar랑 메뉴바 같은거 제외한 뷰
            upLoadBtn.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -( (self.view.frame.width - 100)/2 )).isActive = true
            upLoadBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        }
        else {
            upLoadBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
            upLoadBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        }
        
        // 클릭시 이벤트 지정, 터치한 컴포넌트에서 손을 땟을때 실행
        upLoadBtn.addTarget(self, action: #selector(upLoadPost), for: .touchUpInside)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewController.delegate = self
        TableViewController.dataSource = self
        
        filterOutlet.tintColor = UIColor.white;
        popOutlet.tintColor = UIColor.white;
        self.navigationController?.navigationBar.barTintColor = UIColor.orange;
        self.navigationController?.navigationBar.backgroundColor = UIColor.orange;
        
        upLoadBtnStyle();
        
        self.getPosts();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async {
            // 테이블 뷰에 그리기
            self.TableViewController.reloadData();
        }
    }
    
    // Selection Segue => Show
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if Ad!.record > 0{
            postsData = Ad!.filterdata
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
    
    //@ogjc => 각각의 변수, 함수 등에 적용하여 ObjectiveC의 접근을 가능하게 해준다.
    @objc func upLoadPost() {
        
        if let upLoadView = self.storyboard?.instantiateViewController(identifier: "UpLoadLoLPost") as? UpLoadLoLPost {
            
            // 네이베이션 바 만들어서 보내기
            let navController = UINavigationController(rootViewController: upLoadView);
            // 아래에서 위로 올라오게 = 전환 스타일
            navController.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
            // 화면을 꽉 채우게
            navController.modalPresentationStyle = .fullScreen
            
            present(navController, animated: true, completion: nil)
        }
    }
    
}
