//
//  UpLoadLoLPost.swift
//  duo
//
//  Created by 김록원 on 2020/09/08.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire

class UpLoadLoLPost : UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let customcolor = UIColor(displayP3Red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
    let ad = UIApplication.shared.delegate as? AppDelegate
    var selectDate = Date();
    let toolBarKeyboard = UIToolbar()
    let gameModeData : [String] = ["모든 큐","일반", "듀오", "자유랭" , "커스텀", "칼바람" ];
    let tierData : [String] = ["Iron 4","Iron 3","Iron 2","Iron 1",
                               "Bronze 4","Bronze 3","Bronze 2","Bronze 1",
                               "Silver 4","Silver 3","Silver 2","Silver 1",
                               "Gold 4","Gold 3","Gold 2","Gold 1",
                               "Platinum 4","Platinum 3","Platinum 2","Platinum 1",
                               "Diamond 4","Diamond 3","Diamond 2","Diamond 1",
                               "Master", "Grand Master", "Challenger"];
    let tierDataToInt : [Int] = [6,7,8,9,16,17,18,19,26,27,28,29,36,37,38,39,46,47,48,49,56,57,58,59,70,80,90]
    let headCountData : [String] = ["1","2","3","4","5","6","7","8","9"]
    let talkonData :[String] = ["가능","불가능","상관없음"]
    var headCountValue : Int = 1
    let positionData : [String] = [ "모든 포지션","탑", "정글", "미드", "원딜", "서폿"]
    
    @IBAction func uploadAction(_ sender: Any) {
        
        if (textContentView.text!.count > 200){
            let alert = UIAlertController(title: nil , message: "게시글 최대 200자. 현재 \(textContentView.text!.count)자", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        else if (uploadTitle.text!.count > 30){
            let alert = UIAlertController(title: nil , message: "제목 최대 30자. 현재 \(uploadTitle.text!.count)자", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
            //BaseFunc.baseurl;
            let url = URL(string : BaseValue.baseurl + "/post/lol")!
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
//            let uploadedEndTime = dateformat.string(from: selectDate)
            var uploadedStartTier = 6;
            var uploadedEndTier = 90;
            var uploadedTop = 1;
            var uploadedBottom = 1;
            var uploadedMid = 1;
            var uploadedSupport = 1;
            var uploadedJungle = 1;
            var uploadedTalkon = 1;
            
            for (index, eachtier) in tierData.enumerated() {
                if (eachtier == startTierField.text) {
                    uploadedStartTier = tierDataToInt[index];
                }
                if (eachtier == endTierField.text) {
                    uploadedEndTier = tierDataToInt[index];
                }
            }
            
            
//            if topBtn.tintColor == customcolor { uploadedTop = 2; }
//            if bottomBtn.tintColor == customcolor { uploadedBottom = 2; }
//            if supportBtn.tintColor == customcolor { uploadedSupport = 2; }
//            if jungleBtn.tintColor == customcolor { uploadedJungle = 2; }
//            if midBtn.tintColor == customcolor { uploadedMid = 2; }
//            if talkOnBtn.tintColor == customcolor { uploadedTalkon = 2; }
            
            if (uploadedTop + uploadedMid + uploadedJungle + uploadedSupport + uploadedBottom == 10) {
                let alert = UIAlertController(title: "포지션을 하나 이상 선택해주세요", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default , handler: nil))
                present(alert, animated: true, completion: nil)
                return;
            }
            if (uploadTitle.text == "") {
                let alert = UIAlertController(title: "제목을 입력해주세요", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default , handler: nil))
                present(alert, animated: true, completion: nil)
                return;
            }
            if (textContentView.text == "" || textContentView.text == "내용 입력") {
                let alert = UIAlertController(title: "내용을 작성해주세요", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default , handler: nil))
                present(alert, animated: true, completion: nil)
                return;
            }
            
            
            
//            let req = AF.request(url,
//                                 method:.post,
//                                 parameters: [
//                                    "userId" : ad?.userID,
//                                    "userNickname" : ad?.nickname,
//                                    "gameMode" : gameModeField.text!,
//                                    "title" : uploadTitle.text!,
//                                    "startTier" : uploadedStartTier,
//                                    "endTier" : uploadedEndTier,
////                                    "endTime" : uploadedEndTime,
//                                    "headCount" : headCountValue,
//                                    "top" : uploadedTop,
//                                    "mid" : uploadedMid,
//                                    "bottom" : uploadedBottom,
//                                    "support" : uploadedSupport,
//                                    "jungle" : uploadedJungle,
//                                    "talkon" : talkonField.text!,
//                                    "content" : textContentView.text!
//                                 ],
//                                 encoding: JSONEncoding.default,
//                                 headers: ["Authorization": ad!.access_token, "Content-Type": "application/json"])
//            // db에서 값 가져오기
//            req.responseJSON {res in
//                switch res.result {
//                case.success(let value):
//                    print(value)
//                    if let datas = value as? Dictionary<String,Any> {
//                        if let msg = datas["msg"] as? String  {
//                            if (msg == "create success") {
//                                let alert = UIAlertController(title: "업로드 성공!", message: "", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "확인", style: .default ) { (action) in
//                                    self.dismiss(animated: true, completion: nil)
//                                })
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
        }
    }
    
    
//    @IBOutlet weak var topBtn: UIButton!
//    @IBOutlet weak var midBtn: UIButton!
//    @IBOutlet weak var jungleBtn: UIButton!
//    @IBOutlet weak var bottomBtn: UIButton!
//    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var textContentView: UITextView!
//    @IBOutlet weak var talkOnBtn: UIButton!
    
    @IBAction func positionAction(_ sender : UIButton) {
        if (sender.tintColor == customcolor) {
            sender.tintColor = UIColor.white;
            sender.backgroundColor = customcolor;
        }
        else {
            sender.tintColor = customcolor;
            sender.backgroundColor = UIColor.white;
        }
    }
//    @IBOutlet var positionBtn : [UIButton]!
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var talkonField: UITextField!
    //    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var headCountField: UITextField!
    @IBOutlet weak var endTierField: UITextField!
    @IBOutlet weak var startTierField: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var gameModeField: UITextField!
    @IBOutlet weak var uploadTitle: UITextField!
    @IBAction func uploadCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //키보드에 확인 버튼 실행
    @IBAction func doneBtnClicked(sender : Any) {
        self.view.endEditing(true);
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    // picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return gameModeData.count;
        }
        else if (pickerView.tag / 2 == 1){
            return tierData.count;
        }
//        else if (pickerView.tag == 4) {
//            return headCountData.count;
//        }
        else if (pickerView.tag == 4) {
            return talkonData.count
        }
        else{
            return positionData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return gameModeData[row]
        }
        else if (pickerView.tag / 2 == 1){
            return tierData[row];
        }
//        else if (pickerView.tag == 4) {
//            return headCountData[row];
//        }
        else if (pickerView.tag == 4){
            return talkonData[row]
        }
        else{
            return positionData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            gameModeField.text = gameModeData[row];
        }
        else if (pickerView.tag == 2){
            startTierField.text = tierData[row];
        }
        else if (pickerView.tag == 3){
            endTierField.text = tierData[row];
        }
        else if (pickerView.tag == 4){
            talkonField.text = talkonData[row]
        }
        else{
            positionField.text = positionData[row]
        }
//        else if (pickerView.tag == 4) {
//            headCountField.text = headCountData[row];
//        }
    }
    
//    @objc func timeChange(_ sender : UIDatePicker) {
//        selectDate = sender.date
//        let dateformat : DateFormatter = DateFormatter();
//        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
//
//        let selected: String = dateformat.string(from: sender.date)
//        self.endTimeField.text = selected;
//
//    }
    
    func textViewSetup() {
        if textContentView.text == "내용 입력" {
            textContentView.text = "";
            textContentView.textColor = UIColor.black;
        }
        else if textContentView.text == "" {
            textContentView.text = "내용 입력";
            textContentView.textColor = UIColor.lightGray;
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetup()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textContentView.text == "" { textViewSetup() }
    }
    

    lazy var uploadGameMode : UIPickerView = {
        let gamemodePicker : UIPickerView = UIPickerView();
        gamemodePicker.delegate = self;
        gamemodePicker.dataSource = self;
        gamemodePicker.tag = 1;
        gamemodePicker.backgroundColor = UIColor.white;
        
        
        return gamemodePicker;
    }();
    
    lazy var uploadPosition : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.tag = 5;
        tierPicker.backgroundColor = UIColor.white;
        
        return tierPicker;
    }()
    
    lazy var uploadStartTier : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.tag = 2;
        tierPicker.backgroundColor = UIColor.white;
        
        return tierPicker;
    }()
    
    lazy var uploadEndTier : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.tag = 3;
        tierPicker.backgroundColor = UIColor.white;
        
        return tierPicker;
    }()
    
    lazy var uploadTalkOn : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.tag = 4;
        tierPicker.backgroundColor = UIColor.white;
        
        return tierPicker;
    }()
    
//    lazy var uploadHeadCount : UIPickerView = {
//        let headCountPicker : UIPickerView = UIPickerView();
//        headCountPicker.delegate = self;
//        headCountPicker.dataSource = self;
//        headCountPicker.tag = 4;
//        headCountPicker.backgroundColor = UIColor.white;
//
//        return headCountPicker;
//    }()
    
//    lazy var uploadendTime : UIDatePicker = {
//        let endTimePicker : UIDatePicker = UIDatePicker();
//        endTimePicker.timeZone = NSTimeZone.local;
//        endTimePicker.addTarget(self, action: #selector(timeChange), for: .valueChanged)
//        endTimePicker.backgroundColor = UIColor.white;
//
//        return endTimePicker;
//    }()
    
    @IBAction func sliderChange(_ sender: UISlider) {
        headCountValue = Int(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let frame = self.navigationController?.navigationBar.frame
        let height: CGFloat = 200
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: (frame?.origin.x)!, y: (frame?.origin.y)!, width: bounds.width, height: bounds.height + height)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white;
        self.navigationController?.navigationBar.barStyle = .default;
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]

        // 키보드 툴바 만들기
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(self.doneBtnClicked))
        let nilBar = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [nilBar, nilBar, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.gray;
        
        // Game Mode
        gameModeField.inputAccessoryView = toolBarKeyboard
        gameModeField.inputView = self.uploadGameMode;
        gameModeField.textColor = customcolor;
        gameModeField.text = "모든 큐"
        gameModeField.layer.borderWidth = 1
        gameModeField.layer.borderColor = customcolor.cgColor
        gameModeField.layer.cornerRadius = 5
        
        // Position
        positionField.inputAccessoryView = toolBarKeyboard
        positionField.inputView = self.uploadPosition;
        positionField.textColor = customcolor;
        positionField.text = "모든 포지션"
        positionField.layer.borderWidth = 1
        positionField.layer.borderColor = customcolor.cgColor
        positionField.layer.cornerRadius = 5
        
        
        // Tier
        startTierField.inputAccessoryView = toolBarKeyboard
        startTierField.inputView = self.uploadStartTier;
        startTierField.textColor = customcolor;
        startTierField.text = tierData[0];
        startTierField.layer.borderWidth = 1
        startTierField.layer.borderColor = customcolor.cgColor
        startTierField.layer.cornerRadius = 5
        
        
        endTierField.inputAccessoryView = toolBarKeyboard
        endTierField.inputView = self.uploadEndTier;
        endTierField.textColor = customcolor;
        endTierField.text = tierData[tierData.count-1];
        endTierField.layer.borderWidth = 1
        endTierField.layer.borderColor = customcolor.cgColor
        endTierField.layer.cornerRadius = 5
        
        
        // Head Count
//        headCountField.inputAccessoryView = toolBarKeyboard
//        headCountField.inputView = self.uploadHeadCount
//        headCountField.textColor = UIColor.lightGray;
//        headCountField.text = headCountData[0];
        
        // Start Time
//        let dateformat : DateFormatter = DateFormatter();
//        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
//        endTimeField.inputAccessoryView = toolBarKeyboard
//        endTimeField.inputView = self.uploadendTime
//        endTimeField.textColor = UIColor.lightGray;
//        endTimeField.text = dateformat.string(from: Date())
        
        // Position Btn
//        positionBtn.forEach{ (btn) in
//            btn.layer.borderWidth = 1;
//            btn.layer.borderColor = customcolor.cgColor;
//            btn.layer.cornerRadius = 5;
//            btn.tintColor = customcolor;
//        }
        
        // talkon
        talkonField.inputAccessoryView = toolBarKeyboard
        talkonField.inputView = self.uploadTalkOn
        talkonField.textColor = customcolor;
        talkonField.text = talkonData[0]
        talkonField.layer.borderWidth = 1
        talkonField.layer.borderColor = customcolor.cgColor
        talkonField.layer.cornerRadius = 5
        
        
//        talkOnBtn.layer.borderWidth = 1
//        talkOnBtn.layer.borderWidth = 1;
//        talkOnBtn.layer.borderColor = customcolor.cgColor;
//        talkOnBtn.layer.cornerRadius = 5;
//        talkOnBtn.tintColor = customcolor;
        
        let customtextColor = UIColor(displayP3Red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
        
        // 제목 textField
        uploadTitle.attributedPlaceholder = NSAttributedString(string : "제목",attributes: [NSAttributedString.Key.foregroundColor: customtextColor]);
        uploadTitle.inputAccessoryView = toolBarKeyboard
        uploadTitle.textColor = UIColor.black
        uploadTitle.layer.borderColor = customcolor.cgColor
        uploadTitle.layer.borderWidth = 1
        uploadTitle.layer.cornerRadius = 5
        
        // 내용
        textContentView.text = "내용 입력"
        textContentView.textColor = customtextColor
        textContentView.textAlignment = NSTextAlignment.left;
        textContentView.layer.borderWidth = 1;
        textContentView.layer.cornerRadius = 5;
        textContentView.layer.borderColor = customcolor.cgColor;
        textContentView.inputAccessoryView = toolBarKeyboard;
        textContentView.delegate = self;

        // Scroll View 에서 스크린 터치시 키보드 내려가게
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        ScrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    // 화면 터치 시 콜백함수
    @objc func MyTapMethod(sender : UITapGestureRecognizer) {
        self.view.endEditing(true);
    }
    
    // statusbar 보이게 설정
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
