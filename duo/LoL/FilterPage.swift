//
//  FilterPage.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit
import Alamofire

class Filterpage : UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var GameModeButtons: [UIButton]!
    @IBOutlet var PositionButtons: [UIButton]!
    @IBOutlet weak var talkOnBtn: UIButton!
    @IBOutlet weak var peoplenum: UILabel!
    @IBOutlet weak var top: UIButton!
    @IBOutlet weak var mid: UIButton!
    @IBOutlet weak var jungle: UIButton!
    @IBOutlet weak var dealer: UIButton!
    @IBOutlet weak var support: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var mytier: UITextField!
    
    var talkon = 2 //기본설정 상관없음
    var record : Int = 0 // 필터화면을 갔다온건지 아닌지 구분하기위한 변수. 0이면 안갔다온거고 1이면 갔다온거.
    var gamemodenum = 0 //게임모드 식별
    var gamemodename = "" //게임모드 식별
    var headcount : Int = 1
    var position = ["top":3,"mid":3, "jungle":3,"bottom":3,"support":3]
    var time : String = ""
    var Mytier : String = ""
    var Mytiernumber : Int = 0
    
    let ad = UIApplication.shared.delegate as? AppDelegate // appdelegate파일 참조
//    let tier = ["Iron","Bronze","Silver","Gold","Platinum","Dia","Master","GrandMaster","Challenger"]
//    let tiernumber = [1,2,3,4]
    let toolBarKeyboard = UIToolbar()
    let tierData : [String] = ["Iron 4","Iron 3","Iron 2","Iron 1","Bronze 4","Bronze 3","Bronze 2","Bronze 1","Silver 4","Silver 3","Silver 2","Silver 1","Gold 4","Gold 3","Gold 2","Gold 1","Platinum 4","Platinum 3","Platinum 2","Platinum 1","Diamond 4","Diamond 3","Diamond 2","Diamond 1","Master", "Grand Master", "Challenger"]
    let tierDataToInt : [Int] = [6,7,8,9,16,17,18,19,26,27,28,29,36,37,38,39,46,47,48,49,56,57,58,59,70,80,90]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(self.doneBtnClicked))
        let nilBar = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [nilBar, nilBar, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.gray;
        
        //티어
        mytier.inputAccessoryView = toolBarKeyboard
        mytier.inputView = self.uploadStartTier;
        mytier.textColor = UIColor.orange;
        mytier.text = tierData[0];
        
        GameModeButtons.forEach{ (btn) in
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = UIColor.orange.cgColor;
            btn.layer.cornerRadius = 5;
            btn.tintColor = UIColor.black;
        }
        
        PositionButtons.forEach{ (btn) in
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = UIColor.orange.cgColor;
        btn.layer.cornerRadius = 5;
        btn.tintColor = UIColor.black;
        }
        
        peoplenum.layer.borderWidth = 1
        peoplenum.layer.borderColor = UIColor.orange.cgColor;
        peoplenum.layer.cornerRadius = 5;
        peoplenum.tintColor = UIColor.black;
        
        //토크온
        talkOnBtn.layer.borderWidth = 1
        talkOnBtn.layer.borderColor = UIColor.orange.cgColor;
        talkOnBtn.layer.cornerRadius = 5;
        talkOnBtn.tintColor = UIColor.black;
        
        applyBtn.layer.cornerRadius = 10;
        applyBtn.layer.borderWidth = 1;
        applyBtn.layer.borderColor = UIColor.orange.cgColor;
        applyBtn.backgroundColor = UIColor.orange;
        applyBtn.tintColor = UIColor.white;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.ad!.filterdata = [] // 필터 설정할때마다 빈배열로 초기화
    }
    
    //게임모드 결정
    func getGameModeType() -> GameModeNumber {
        for (index, button) in GameModeButtons.enumerated(){
            if button.tintColor == UIColor.white{
                return GameModeNumber(rawValue: index) ?? .freeRank
            }
        }
        return .knifeWind
    }
    enum GameModeNumber : Int{
        case soloRank
        case freeRank
        case normal
        case knifeWind
        case custom
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    // picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tierData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tierData[row];
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mytier.text = tierData[row]
    }
    
    lazy var uploadStartTier : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.backgroundColor = UIColor.white;
        
        return tierPicker;
    }()

    //포지션 색상(선택여부)에따라 값 지정
    func positionresult(){
        if top.tintColor == UIColor.black{
            position["top"]=2
        }
        else {position["top"]=1}
    
        if mid.tintColor == UIColor.black{
            position["mid"]=2
        }
        else {position["mid"]=1}
        
        if jungle.tintColor == UIColor.black{
            position["jungle"]=2
        }
        else {position["jungle"]=1}
        
        if dealer.tintColor == UIColor.black{
            position["dealer"]=2
        }
        else {position["dealer"]=1}
        
        if support.tintColor == UIColor.black{
            position["support"]=2
        }
        else {position["support"]=1}
    }

    func getPosts() {
        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/lol/getpost/filter")!
        let req = AF.request(url,
                             method:.post,
                             parameters: ["userId": BaseFunc.userId, "userNickname": BaseFunc.userNickname,"gameMode": gamemodename,"wantTier": Mytiernumber,"startTime": time, "headCount": headcount,"top": position["top"],"mid":position["mid"],"jungle": position["jungle"],"bottom": position["bottom"],"support": position["support"],"talkon":talkon] as [String : Any],
                             encoding: JSONEncoding.default)
        // db에서 값 가져오기
        req.responseJSON {res in
            switch res.result {
            case.success(let value):
                if let datas = value as? Array<Dictionary<String,Any>> {
                    var i = 0
                    for i in datas{
                        self.ad!.filterdata.append(i);
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func doneBtnClicked(sender : Any) {
        self.view.endEditing(true);
    }
    
    @IBAction func Exit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
     @IBAction func sliderValueChanged(sender: UISlider) {
         var value = Int(sender.value)
         peoplenum.text = "\(value)"
         headcount = value
     }
    
    // 포지션 버튼 누를시 색상변경
     @IBAction func button_process(sender : UIButton){
         if sender.backgroundColor == UIColor.white{
             sender.backgroundColor = UIColor.blue
         }
         else if sender.backgroundColor == UIColor.blue{
             sender.backgroundColor = UIColor.red
         }
         else{
             sender.backgroundColor = UIColor.white
         }
     }
    
    @IBAction func DatePicker (sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        time =  formatter.string(from: sender.date)
    }
    
    @IBAction func gameModeAction(_ sender : UIButton) {
        if (sender.tintColor == UIColor.black) {
            GameModeButtons.forEach{ (btn) in
                btn.tintColor = UIColor.black
                btn.backgroundColor = UIColor.white
            }
            sender.tintColor = UIColor.white;
            sender.backgroundColor = UIColor.orange;
            
        }
           else {
               sender.tintColor = UIColor.black;
               sender.backgroundColor = UIColor.white;
           }
       }
    
    @IBAction func position_talkon_Action(_ sender : UIButton) {
        if (sender.tintColor == UIColor.black) {
            sender.tintColor = UIColor.white;
            sender.backgroundColor = UIColor.orange;
            
        }
           else {
               sender.tintColor = UIColor.black;
               sender.backgroundColor = UIColor.white;
           }
       }
    
    
    //적용버튼
    @IBAction func apply(sender: UIButton) {
        switch Mytier{
        case "Iron":
            Mytiernumber += 10
        case "Bronze":
            Mytiernumber += 20
        case "Silver":
            Mytiernumber += 30
        case "Gold":
            Mytiernumber += 40
        case "Platinum":
            Mytiernumber += 50
        case "Dia":
            Mytiernumber += 60
        case "Master":
            Mytiernumber += 70
        case "GrandMaster":
            Mytiernumber += 80
        case "Challenger":
            Mytiernumber += 90
        default:
            return
        }
        gamemodenum = getGameModeType().rawValue
        switch gamemodenum{
        case 1:
            gamemodename = "soloRank"
        case 2:
            gamemodename = "freeRank"
        case 3:
            gamemodename = "normal"
        case 4:
            gamemodename = "knifeWind"
        case 5:
            gamemodename = "custom"
        default:
            gamemodename = "all"
        }
        if talkOnBtn.tintColor == UIColor.black { talkon = 2; }
        positionresult()
        getPosts()
        ad!.record += 1
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func MyTapMethod(sender : UITapGestureRecognizer) {
        self.view.endEditing(true);
    }
}
