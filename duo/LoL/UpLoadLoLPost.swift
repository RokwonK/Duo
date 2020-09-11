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
    
    
    
    let toolBarKeyboard = UIToolbar()
    let gameModeData : [String] = ["normal", "soloRank", "freeRank" , "custom", "knifeWind" ];
    let tierData : [String] = ["I4 ","I3","I2","I1","B4","B3","B2","B1","S4","S3","S2","S1","G4","G3","G2","G1","P4","P3","P2","P1","D4","D3","D2","D1","Master", "Grand Master", "Challenger"];
    let headCountData : [String] = ["1","2","3","4","5","6","7","8","9"];
    
    
    @IBAction func uploadAction(_ sender: Any) {
        //BaseFunc.baseurl;
        
    }
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var textContentView: UITextView!
    @IBOutlet weak var talkOnBtn: UIButton!
    @IBAction func positionAction(_ sender : UIButton) {
        if (sender.tintColor == UIColor.black) {
            sender.tintColor = UIColor.white;
            sender.backgroundColor = UIColor.blue;
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
        
        // 키보드 툴발 만들기
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(self.doneBtnClicked))
        let nilBar = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [nilBar, nilBar, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.gray;
        
        // Game Mode
        gameModeField.inputAccessoryView = toolBarKeyboard
        gameModeField.inputView = self.uploadGameMode;
        gameModeField.textColor = UIColor.blue;
        gameModeField.text = gameModeData[0];
        
        // Tier
        startTierField.inputAccessoryView = toolBarKeyboard
        startTierField.inputView = self.uploadStartTier;
        startTierField.textColor = UIColor.blue;
        startTierField.text = tierData[0];
        endTierField.inputAccessoryView = toolBarKeyboard
        endTierField.inputView = self.uploadEndTier;
        endTierField.textColor = UIColor.blue;
        endTierField.text = tierData[tierData.count-1];
        
        // Head Count
        headCountField.inputAccessoryView = toolBarKeyboard
        headCountField.inputView = self.uploadHeadCount
        headCountField.textColor = UIColor.blue;
        headCountField.text = headCountData[0];
        
        // Start Time
        let dateformat : DateFormatter = DateFormatter();
        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
        startTimeField.inputAccessoryView = toolBarKeyboard
        startTimeField.inputView = self.uploadStartTime
        startTimeField.textColor = UIColor.blue;
        startTimeField.text = dateformat.string(from: Date())
        
        // Position
        positionBtn.forEach{ (btn) in
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = UIColor.blue.cgColor;
            btn.layer.cornerRadius = 5;
            btn.tintColor = UIColor.black;
        }
        
        // talkon
        talkOnBtn.layer.borderWidth = 1
        talkOnBtn.layer.borderWidth = 1;
        talkOnBtn.layer.borderColor = UIColor.blue.cgColor;
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
        
    }
    
    
    // 스크린 터치시 키보드 내려가게 설정
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.ContentView.endEditing(true);
        self.ScrollView.endEditing(true);
    }
    
    
    
    // statusbar 보이게 설정
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
}


/*
  
*/
