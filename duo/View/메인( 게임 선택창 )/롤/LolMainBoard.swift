//
//  TableViewController.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit
import Alamofire

class LoLMainBoard: UITableViewController{
    static let sharedInstance = LoLMainBoard()
    let ad = UIApplication.shared.delegate as? AppDelegate
    
//    @IBOutlet weak var naviBarOutlet: UINavigationItem!
    @IBAction func popAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    @IBOutlet weak var popOutlet: UIBarButtonItem!
    @IBOutlet weak var filterOutlet: UIBarButtonItem!
    @IBOutlet var TableViewController: UITableView!
    var postsData : Array<Dictionary<String, Any>>?;
    let eachTier : Array<String> = ["I", "B", "S", "G", "P", "D","q", "M", "GM", "Ch"];

    
    func getPosts() {
//        BaseFunc.fetch();

//        let url = URL(string : BaseFunc.baseurl + "/post/lol")!
//        let req = AF.request(url,
//                            method:.get,
//                            parameters: ["limit": 100, "offset" : 0],
//                            encoding: URLEncoding.queryString,
//                            headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"]
//                            )
//        // db에서 값 가져오기
//        req.responseJSON {res in
//            print(res)
//            switch res.result {
//            case.success(let value):
//
//                if let datas = value as? Array<Dictionary<String,Any>> {
//                    self.postsData = datas;
//                    DispatchQueue.main.async {
//                        /*
//                         didset {
//                         }
//                         */
//                        self.TableViewController.reloadData();
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    func getPosts2() {
//        BaseFunc.fetch();
//        let url = URL(string : BaseFunc.baseurl + "/post/lol")!
//        let req = AF.request(url,
//                            method:.get,
//                            parameters: ["limit": 100, "offset" : 0],
//                            encoding: URLEncoding.queryString,
//                            headers: ["Authorization" : ad!.access_token, "Content-Type": "application/json"]
//                            )
//        // db에서 값 가져오기
//        req.responseJSON {res in
//            print(res)
//            switch res.result {
//            case.success(let value):
//
//                if let datas = value as? Array<Dictionary<String,Any>> {
//                    self.postsData = datas;
//                    DispatchQueue.main.async {
//                        self.TableViewController.reloadData();
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
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
        extension_cellSetting(cell);
        

        cell.tableBox.layer.cornerRadius = 10
        cell.tableBox.layer.borderWidth = 1.0
        cell.tableBox.layer.borderColor = UIColor.white.cgColor
        cell.tableBox.layer.shadowColor = UIColor.black.cgColor
        cell.tableBox.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.tableBox.layer.shadowOpacity = 0.16
        cell.tableBox.layer.shadowRadius = 6
        
        
        if let posts = postsData {
            let v = posts[indexPath.row];
            
//            if let top = v["top"] as? Int, top == 2 {
//                cell.topBtn.isHidden = true;
//            }
//            if let bottom = v["bottom"] as? Int, bottom == 2 {
//                cell.bottomBtn.isHidden = true;
//            }
//            if let mid = v["mid"] as? Int, mid == 2 {
//                cell.midBtn.isHidden = true;
//            }
//            if let sup = v["support"] as? Int, sup == 2 {
//                cell.supportBtn.isHidden = true;
//            }
//            if let jung = v["jungle"] as? Int, jung == 2 {
//                cell.jungleBtn.isHidden = true;
//            }
            
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
//                cell.title.font = UIFont.boldSystemFont(ofSize: 18)
            }
            
                //cell.startTime.text = "시작시간 : \(st)";
                
                // 각각 뽑기 위해서 Date객체로의 변환이 필요
            // MM-dd를 뽑고 같으면 오늘 다르면 내일
            // HH:mm을 뽑아서 사용자에게 보여줌
            
            // String => Date로 바꿈;
            let thisDateFormatter = DateFormatter();
            thisDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let et = thisDateFormatter.date(from: v["endTime"] as! String)
            let ut = thisDateFormatter.date(from: v["createdAt"] as! String)
            //                let thisDate = thisDateFormatter.date(from: et)!;
            //                thisDateFormatter.dateFormat = "MM-dd";
            //                let thisDateMMdd = thisDateFormatter.string(from : thisDate);
            
            //let nowDateFormatter = DateFormatter();
            let nowDate = Date()
            //                let nowDateMMdd = thisDateFormatter.string(from : nowDate);
            
            var useTime = Int(et!.timeIntervalSince(nowDate))
            if (useTime >= 0){
//                if (useTime>=3600){
//                    if (useTime>=86400){
//                        cell.endTime.text = "\(useTime/86400)일 \((useTime/3600)%24)시간 \((useTime/60)%60)분후 만료"
//                    }
//                    else{
//                        cell.endTime.text = "\(useTime/3600)시간 \((useTime/60)%60)분후 만료"
//                    }
//                }
//                else{
//                    cell.endTime.text = "\(useTime/60)분후 만료"
//                }
                cell.endTime.text = "모집중"
            }
            else{
                cell.endTime.text = "만료"
                
            }
            
            var timegap = Int(nowDate.timeIntervalSince(ut!))
            if (timegap>=3600){
                if (timegap>=86400){
                    cell.uploadTime.text = "\(timegap/86400)일 \((timegap/3600)%24)시간 \((timegap/60)%60)분전"
                }
                else{
                    cell.uploadTime.text = "\(timegap/3600)시간 \((timegap/60)%60)분전"
                }
            }
            else{
                cell.uploadTime.text = "\(timegap/60)분전"
            }
            
//                thisDateFormatter.dateFormat = "HH:mm";
//                let thisEndTime = thisDateFormatter.string(from : thisDate)
//                if (nowDateMMdd == thisDateMMdd) {
//                    cell.endTime.text = "오늘 \(thisEndTime)"
//                }
//                else {
//                    cell.endTime.text = "내일 \(thisEndTime)"
//                }
            
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
                    else if (edTier == 70 || edTier == 80 || edTier == 90)
                    {
                        cell.tier.setTitle("\(eachTier[stShared] + "\(10-stRemaind)" )~\(eachTier[edShared])", for: .normal);
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
        let filterpage = storyBoard.instantiateViewController(withIdentifier: "Filter") as! FilterView
        let navController = UINavigationController(rootViewController: filterpage)
        
        navController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    let upLoadBtn = UIButton()
    var lolMainBoardViewModel : LoLMainBoardViewModel!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewController.delegate = self
        TableViewController.dataSource = self
    
        lolMainBoardViewModel = LoLMainBoardViewModel();
        filterOutlet.image = UIImage(named: "filter")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        extension_upLoadBtnStyle(upLoadBtn);
        
        self.getPosts();
    }
    override func viewWillAppear(_ animated: Bool) {
//        if (ad!.record==1){
//            self.getPosts2()
//        }
//        else{
//            self.getPosts()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async {
            self.TableViewController.reloadData();
        }
    }
    
    // Selection Segue => Show
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
}
// MVVM
// LolMainBoard - override 함수 정의
// LoLMainBoardExtension - 디자인 관련 로직
// LOLMainBoardViewModel - @obj, 네트워킹 로직
// LoLMainBoardModel - Model 넣기
