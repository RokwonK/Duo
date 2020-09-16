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
    
    
    var selectDate = Date();
    let toolBarKeyboard = UIToolbar()
    let gameModeData : [String] = ["normal", "soloRank", "freeRank" , "custom", "knifeWind" ];
    let tierData : [String] = ["I4 ","I3","I2","I1","B4","B3","B2","B1","S4","S3","S2","S1","G4","G3","G2","G1","P4","P3","P2","P1","D4","D3","D2","D1","Master", "Grand Master", "Challenger"];
    let tierDataToInt : [Int] = [6,7,8,9,16,17,18,19,26,27,28,29,36,37,38,39,46,47,48,49,56,57,58,59,70,80,90]
    let headCountData : [String] = ["1","2","3","4","5","6","7","8","9"];
    
    
    @IBAction func uploadAction(_ sender: Any) {
        //BaseFunc.baseurl;
        let url = URL(string : BaseFunc.baseurl + "/post/lol/uploadpost")!
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let uploadedStartTime = dateformat.string(from: selectDate)
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
        
        
        if topBtn.tintColor == UIColor.black { uploadedTop = 2; }
        if bottomBtn.tintColor == UIColor.black { uploadedBottom = 2; }
        if supportBtn.tintColor == UIColor.black { uploadedSupport = 2; }
        if jungleBtn.tintColor == UIColor.black { uploadedJungle = 2; }
        if midBtn.tintColor == UIColor.black { uploadedMid = 2; }
        if talkOnBtn.tintColor == UIColor.black { uploadedTalkon = 2; }
        
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
        
        
        
        let req = AF.request(url,
                            method:.post,
                            parameters: [
                                "userId" : BaseFunc.userId,
                                "userNickname" : BaseFunc.userNickname,
                                "gameMode" : gameModeField.text!,
                                "startTier" : uploadedStartTier,
                                "endTier" : uploadedEndTier,
                                "startTime" : uploadedStartTime,
                                "headCount" : Int(headCountField.text!)!,
                                "top" : uploadedTop,
                                "mid" : uploadedMid,
                                "bottom" : uploadedBottom,
                                "support" : uploadedSupport,
                                "jungle" : uploadedJungle,
                                "talkon" : uploadedTalkon,
                                "title" : uploadTitle.text!,
                                "content" : textContentView.text!
                            ],
                            encoding: JSONEncoding.default)
        // db에서 값 가져오기
        req.responseJSON {res in
            switch res.result {
            case.success(let value):
                print(value)
                if let datas = value as? Dictionary<String,Any> {
                    if let msg = datas["msg"] as? String  {
                        if (msg == "create success") {
                            let alert = UIAlertController(title: "업로드 성공!", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default ) { (action) in
                                self.dismiss(animated: true, completion: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBOutlet weak var topBtn: UIButton!
    @IBOutlet weak var midBtn: UIButton!
    @IBOutlet weak var jungleBtn: UIButton!
    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var textContentView: UITextView!
    @IBOutlet weak var talkOnBtn: UIButton!
    
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
    @IBOutlet var positionBtn : [UIButton]!
    @IBOutlet weak var startTimeField: UITextField!
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
        else if (pickerView.tag == 4) {
            return headCountData.count;
        }
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return gameModeData[row]
        }
        else if (pickerView.tag / 2 == 1){
            return tierData[row];
        }
        else if (pickerView.tag == 4) {
            return headCountData[row];
        }
        return "d"
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
        else if (pickerView.tag == 4) {
            headCountField.text = headCountData[row];
        }
    }
    
    @objc func timeChange(_ sender : UIDatePicker) {
        selectDate = sender.date
        let dateformat : DateFormatter = DateFormatter();
        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
        
        let selected: String = dateformat.string(from: sender.date)
        self.startTimeField.text = selected;

    }
    
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
        
        return gamemodePicker;
    }();
    
    lazy var uploadStartTier : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.tag = 2;
        return tierPicker;
    }()
    
    lazy var uploadEndTier : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.tag = 3;
        return tierPicker;
    }()
    
    lazy var uploadHeadCount : UIPickerView = {
        let headCountPicker : UIPickerView = UIPickerView();
        headCountPicker.delegate = self;
        headCountPicker.dataSource = self;
        headCountPicker.tag = 4;
        
        return headCountPicker;
    }()
    
    lazy var uploadStartTime : UIDatePicker = {
        let startTimePicker : UIDatePicker = UIDatePicker();
        startTimePicker.timeZone = NSTimeZone.local;
        startTimePicker.addTarget(self, action: #selector(timeChange), for: .valueChanged)
        
        return startTimePicker;
    }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange;
        self.navigationController?.navigationBar.barStyle = .black;
        self.navigationController?.navigationBar.isTranslucent = false;
        
        // 키보드 툴발 만들기
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(self.doneBtnClicked))
        let nilBar = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [nilBar, nilBar, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.gray;
        
        // Game Mode
        gameModeField.inputAccessoryView = toolBarKeyboard
        gameModeField.inputView = self.uploadGameMode;
        gameModeField.textColor = UIColor.orange;
        gameModeField.text = gameModeData[0];
        
        // Tier
        startTierField.inputAccessoryView = toolBarKeyboard
        startTierField.inputView = self.uploadStartTier;
        startTierField.textColor = UIColor.orange;
        startTierField.text = tierData[0];
        endTierField.inputAccessoryView = toolBarKeyboard
        endTierField.inputView = self.uploadEndTier;
        endTierField.textColor = UIColor.orange;
        endTierField.text = tierData[tierData.count-1];
        
        // Head Count
        headCountField.inputAccessoryView = toolBarKeyboard
        headCountField.inputView = self.uploadHeadCount
        headCountField.textColor = UIColor.orange;
        headCountField.text = headCountData[0];
        
        // Start Time
        let dateformat : DateFormatter = DateFormatter();
        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
        startTimeField.inputAccessoryView = toolBarKeyboard
        startTimeField.inputView = self.uploadStartTime
        startTimeField.textColor = UIColor.orange;
        startTimeField.text = dateformat.string(from: Date())
        
        // Position
        positionBtn.forEach{ (btn) in
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = UIColor.orange.cgColor;
            btn.layer.cornerRadius = 5;
            btn.tintColor = UIColor.black;
        }
        
        // talkon
        talkOnBtn.layer.borderWidth = 1
        talkOnBtn.layer.borderWidth = 1;
        talkOnBtn.layer.borderColor = UIColor.orange.cgColor;
        talkOnBtn.layer.cornerRadius = 5;
        talkOnBtn.tintColor = UIColor.black;
        
        // 제목 textField
        uploadTitle.attributedPlaceholder = NSAttributedString(string : "제목");
        uploadTitle.inputAccessoryView = toolBarKeyboard
        uploadTitle.font = UIFont.systemFont(ofSize: 18)
        
        // 내용
        textContentView.text = "내용 입력"
        textContentView.textColor = UIColor.lightGray;
        textContentView.textAlignment = NSTextAlignment.left;
        textContentView.layer.borderWidth = 1;
        textContentView.layer.cornerRadius = 5;
        textContentView.layer.borderColor = UIColor.lightGray.cgColor;
        textContentView.inputAccessoryView = toolBarKeyboard;
        textContentView.delegate = self;
        
        // upload 버튼
        uploadBtn.layer.cornerRadius = 10;
        uploadBtn.layer.borderWidth = 1;
        uploadBtn.layer.borderColor = UIColor.orange.cgColor;
        uploadBtn.backgroundColor = UIColor.orange;
        uploadBtn.tintColor = UIColor.white;
        
        
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


/*
  
*/
