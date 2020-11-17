//
//  FilterPage.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit

class FilterView : UIViewController, UITextViewDelegate, UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var exitButton: UIBarButtonItem!
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

    let toolBarKeyboard = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.navigationController?.navigationBar.frame
        let height: CGFloat = 200
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: (frame?.origin.x)!, y: (frame?.origin.y)!, width: bounds.width, height: bounds.height + height)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white;
        self.navigationController?.navigationBar.barStyle = .default;
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = "필터"
        exitButton.tintColor = UIColor.blue
        
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(self.doneBtnClicked))
        let nilBar = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [nilBar, nilBar, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.gray;
        
        //티어
        myTier.inputAccessoryView = toolBarKeyboard
        myTier.inputView = uploadStartTier;
        myTier.textColor = UIColor.blue;
        myTier.text = FilterModel().tierData[0];
        //게임모드버튼
        GameModeButtons.forEach{ (btn) in
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = UIColor.blue.cgColor;
            btn.layer.cornerRadius = 5;
            btn.tintColor = UIColor.blue;
        }
        //포지션버튼
        PositionButtons.forEach{ (btn) in
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = UIColor.blue.cgColor;
            btn.layer.cornerRadius = 5;
            btn.tintColor = UIColor.blue;
        }
        //인원수 표시 라벨
        peopleNum.layer.borderWidth = 1
        peopleNum.layer.borderColor = UIColor.blue.cgColor;
        peopleNum.layer.cornerRadius = 5;
        peopleNum.tintColor = UIColor.blue;
        
        // Start Time
//        let dateformat : DateFormatter = DateFormatter();
//        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
        
        
        //토크온
        talkOnButtons.forEach{(btn) in
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.blue.cgColor
            btn.layer.cornerRadius = 5
            btn.tintColor = UIColor.blue
        }
        
        //적용버튼
        applyBtn.layer.cornerRadius = 10;
        applyBtn.layer.borderWidth = 1;
        applyBtn.layer.borderColor = UIColor.blue.cgColor;
        applyBtn.backgroundColor = UIColor.blue;
        applyBtn.tintColor = UIColor.white;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
    @IBAction func popAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnClicked(sender : Any) {
        self.view.endEditing(true);
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var value = Int(sender.value)
        peopleNum.text = "\(value)"
        FilterModel.sharedInstance.headCount = value
    }
    
//    @objc func timeChange(_ sender : UIDatePicker) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        FilterModel.sharedInstance.Time =  formatter.string(from: sender.date)
//        let dateformat : DateFormatter = DateFormatter();
//        dateformat.dateFormat = "yyyy/MM/dd hh:mm";
//
//        let selected: String = dateformat.string(from: sender.date)
//
//
//    }
    
    @IBAction func gameModeAction(_ sender : UIButton) {
        if (sender.tintColor == UIColor.blue) {
            GameModeButtons.forEach{ (btn) in
                btn.tintColor = UIColor.blue
                btn.backgroundColor = UIColor.white
            }
            sender.tintColor = UIColor.white;
            sender.backgroundColor = UIColor.blue;
        }
        else {
            sender.tintColor = UIColor.blue;
            sender.backgroundColor = UIColor.white;
        }
    }
    
    @IBAction func positionAction(_ sender : UIButton) {
        if (sender.tintColor == UIColor.blue) {
            sender.tintColor = UIColor.white
            sender.backgroundColor = UIColor.blue;
        }
        else {
            sender.tintColor = UIColor.blue;
            sender.backgroundColor = UIColor.white;
        }
    }
    
    @IBAction func talkOnAction(_ sender : UIButton) {
        if (sender.tintColor == UIColor.blue) {
            talkOnButtons.forEach{ (btn) in
                btn.tintColor = UIColor.blue
                btn.backgroundColor = UIColor.white
            }
            sender.tintColor = UIColor.white;
            sender.backgroundColor = UIColor.blue;
            
        }
        else {
            sender.tintColor = UIColor.blue;
            sender.backgroundColor = UIColor.white;
        }
    }
    
    //적용버튼
    @IBAction func applyBtn(sender: UIButton) {
        
        for (index, eachtier) in FilterModel().tierData.enumerated() {
            if (eachtier == myTier.text) {
                FilterModel.sharedInstance.Mytiernumber = FilterModel().tierDataToInt[index];
            }
        }
        
        for (index,buttons) in GameModeButtons.enumerated(){
            if buttons.tintColor == UIColor.white{
                switch index{
                case 0:
                    FilterModel.sharedInstance.gameModeName = "soloRank"
                case 1:
                    FilterModel.sharedInstance.gameModeName = "freeRank"
                case 2:
                    FilterModel.sharedInstance.gameModeName = "normal"
                case 3:
                    FilterModel.sharedInstance.gameModeName = "knifeWind"
                case 4:
                    FilterModel.sharedInstance.gameModeName = "custom"
                default:
                    FilterModel.sharedInstance.gameModeName = "all"
                }
                break
            }
            FilterModel.sharedInstance.gameModeName = "all"
        }
        if talkOnTrue.tintColor == UIColor.white { FilterModel.sharedInstance.talkOn = 1}
        else if talkOnFalse.tintColor == UIColor.white{
            FilterModel.sharedInstance.talkOn = 2}
        else{FilterModel.sharedInstance.talkOn = 3}
        FilterViewModel().positionResult()
        FilterViewModel().getPosts()
        FilterModel.sharedInstance.AD!.record += 1
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FilterModel().tierData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return FilterModel().tierData[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myTier.text = FilterModel().tierData[row]
    }
    
    lazy var uploadStartTier : UIPickerView = {
        let tierPicker : UIPickerView = UIPickerView();
        tierPicker.delegate = self;
        tierPicker.dataSource = self;
        tierPicker.backgroundColor = UIColor.white;
        
        return tierPicker;
    }()
}
