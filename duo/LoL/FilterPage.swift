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
    @IBOutlet var talkOnButtons: [UIButton]!
    @IBOutlet weak var talkOnTrue: UIButton!
    @IBOutlet weak var talkOnFalse: UIButton!
    @IBOutlet weak var talkOnAny: UIButton!
    @IBOutlet weak var peopleNum: UILabel!
    @IBOutlet weak var Top: UIButton!
    @IBOutlet weak var Mid: UIButton!
    @IBOutlet weak var Jungle: UIButton!
    @IBOutlet weak var Dealer: UIButton!
    @IBOutlet weak var Support: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var myTier: UITextField!
    @IBOutlet weak var startTimeField: UITextField!
    
    var talkOn = 3 //기본설정 상관없음
    var headCount : Int = 1
    var Position = ["top":3,"mid":3, "jungle":3,"dealer":3, "support":3]
    var Time : String = ""
    var Mytiernumber : Int?
    var gameModeName : String =  ""
    
    let AD = UIApplication.shared.delegate as? AppDelegate // appdelegate파일 참조
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
        myTier.inputAccessoryView = toolBarKeyboard
        myTier.inputView = self.uploadStartTier;
        myTier.textColor = UIColor.orange;
        myTier.text = tierData[0];
        //게임모드버튼
        GameModeButtons.forEach{ (btn) in
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = UIColor.orange.cgColor;
            btn.layer.cornerRadius = 5;
            btn.tintColor = UIColor.black;
        }
        //포지션버튼
        PositionButtons.forEach{ (btn) in
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = UIColor.orange.cgColor;
        btn.layer.cornerRadius = 5;
        btn.tintColor = UIColor.black;
        }
        //인원수 표시 라벨
        peopleNum.layer.borderWidth = 1
        peopleNum.layer.borderColor = UIColor.orange.cgColor;
        peopleNum.layer.cornerRadius = 5;
        peopleNum.tintColor = UIColor.black;
        
        // Start Time
        let dateformat : DateFormatter = DateFormatter();
        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
        startTimeField.inputAccessoryView = toolBarKeyboard
        startTimeField.inputView = self.uploadStartTime
        startTimeField.textColor = UIColor.orange;
        startTimeField.text = dateformat.string(from: Date())
        
        //토크온
        talkOnButtons.forEach{(btn) in
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.orange.cgColor
            btn.layer.cornerRadius = 5
            btn.tintColor = UIColor.black
        }
        
        //적용버튼
        applyBtn.layer.cornerRadius = 10;
        applyBtn.layer.borderWidth = 1;
        applyBtn.layer.borderColor = UIColor.orange.cgColor;
        applyBtn.backgroundColor = UIColor.orange;
        applyBtn.tintColor = UIColor.white;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.AD!.filterdata = [] // 필터 설정할때마다 빈배열로 초기화
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tierData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tierData[row];
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myTier.text = tierData[row]
    }
    
    lazy var uploadStartTier : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.backgroundColor = UIColor.white;
        
        return tierPicker;
    }()
    
    lazy var uploadStartTime : UIDatePicker = {
        let startTimePicker : UIDatePicker = UIDatePicker();
        startTimePicker.timeZone = NSTimeZone.local;
        startTimePicker.addTarget(self, action: #selector(timeChange), for: .valueChanged)
        startTimePicker.backgroundColor = UIColor.white;
        
        return startTimePicker;
    }()

    //포지션 색상(선택여부)에따라 값 지정
    func positionResult(){
        if Top.tintColor == UIColor.black{
            Position["top"]=2
        }
        else {Position["top"]=1}
    
        if Mid.tintColor == UIColor.black{
            Position["mid"]=2
        }
        else {Position["mid"]=1}
        
        if Jungle.tintColor == UIColor.black{
            Position["jungle"]=2
        }
        else {Position["jungle"]=1}
        
        if Dealer.tintColor == UIColor.black{
            Position["dealer"]=2
        }
        else {Position["dealer"]=1}
        
        if Support.tintColor == UIColor.black{
            Position["support"]=2
        }
        else {Position["support"]=1}
    }

    func getPosts() {
        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/lol/getpost/filter")!
        let req = AF.request(url,
                             method:.post,
                             parameters: ["userId": BaseFunc.userId, "userNickname": BaseFunc.userNickname,"gameMode": gameModeName,"wantTier": Mytiernumber,"startTime": Time, "headCount": headCount,"top": Position["top"],"mid":Position["mid"],"jungle": Position["jungle"],"bottom": Position["dealer"],"support": Position["support"],"talkon":talkOn],
                             encoding: JSONEncoding.default)
        // db에서 값 가져오기
        req.responseJSON {res in
            switch res.result {
            case.success(let value):
                if let datas = value as? Array<Dictionary<String,Any>> {
                    var i = 0
                    for i in datas{
                        self.AD!.filterdata.append(i);
                    }
                    print(self.AD!.filterdata)
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
         peopleNum.text = "\(value)"
         headCount = value
     }
    
    @objc func timeChange(_ sender : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        Time =  formatter.string(from: sender.date)
        let dateformat : DateFormatter = DateFormatter();
        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
        
        let selected: String = dateformat.string(from: sender.date)
        self.startTimeField.text = selected;

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
    
    @IBAction func positionAction(_ sender : UIButton) {
        if (sender.tintColor == UIColor.black) {
            sender.tintColor = UIColor.white;
            sender.backgroundColor = UIColor.orange;
        }
           else {
               sender.tintColor = UIColor.black;
               sender.backgroundColor = UIColor.white;
           }
       }
    
    @IBAction func talkOnAction(_ sender : UIButton) {
        if (sender.tintColor == UIColor.black) {
           talkOnButtons.forEach{ (btn) in
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
    
    //적용버튼
    @IBAction func applyBtn(sender: UIButton) {
        
        for (index, eachtier) in tierData.enumerated() {
            if (eachtier == myTier.text) {
                Mytiernumber = tierDataToInt[index];
            }
        }
        
        for (index,buttons) in GameModeButtons.enumerated(){
            if buttons.tintColor == UIColor.white{
                switch index{
                case 4:
                    gameModeName = "soloRank"
                case 3:
                    gameModeName = "freeRank"
                case 2:
                    gameModeName = "normal"
                case 1:
                    gameModeName = "knifeWind"
                case 0:
                    gameModeName = "custom"
                default:
                    gameModeName = "all"
                }
                break
            }
            gameModeName = "all"
        }
        if talkOnTrue.tintColor == UIColor.white { talkOn = 1}
        else if talkOnFalse.tintColor == UIColor.white{
            talkOn = 2}
        else{talkOn = 3}
        positionResult()
        getPosts()
        AD!.record += 1
        self.dismiss(animated: true, completion: nil)
    }
}
