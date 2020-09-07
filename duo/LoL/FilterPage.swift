//
//  FilterPage.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit
import Alamofire

class Filterpage : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start.delegate = self
        start.dataSource = self
        end.delegate = self
        end.dataSource = self
        top.layer.cornerRadius = 10;
        mid.layer.cornerRadius = 10;
        jungle.layer.cornerRadius = 10;
        dealer.layer.cornerRadius = 10;
        support.layer.cornerRadius = 10;
    }
    
    //게임모드 버튼 누를시 색상변경
    @IBOutlet var GameModeButtons: [UIButton]!
    @IBAction func ButtonSelected(_ sender: UIButton) {
        GameModeButtons.forEach({$0.backgroundColor = UIColor.white})
        sender.backgroundColor = UIColor.blue
        
    }
    
    //게임모드 결정
    
    func getGameModeType() -> GameModeNumber {
        for (index, button) in GameModeButtons.enumerated(){
            if button.backgroundColor == UIColor.blue{
                return GameModeNumber(rawValue: index) ?? .freeRank
            }
        }
        return .freeRank
    }
    
    enum GameModeNumber : Int{
        case soloRank
        case freeRank
        case normal
        case knifeWind
        case custom
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
    
    //인원수
    @IBOutlet weak var peoplenum: UILabel!
    var headcount : Int = 0
    @IBAction func sliderValueChanged(sender: UISlider) {
        var value = Int(sender.value) //UISlider(sender)의 value를 Int로 캐스팅해서 current라는 변수로 보낸다.
        peoplenum.text = "\(value)"
        headcount = value
    }
    
    //티어 관련부분
    @IBOutlet weak var start: UIPickerView!
    @IBOutlet weak var end: UIPickerView!
    
    let tier = ["아이언","브론즈","실버","골드","플레티넘","다이아","마스터","그랜드마스터","챌린저"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tier.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tier[row]
    }
    
    //선택된 시간 String타입으로 변환
    var time : String = ""
    @IBAction func DatePicker (sender: UIDatePicker){
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        time = formatter.string(from: datePickerView.date)
    }
    
    @IBOutlet weak var top: UIButton!
    @IBOutlet weak var mid: UIButton!
    @IBOutlet weak var jungle: UIButton!
    @IBOutlet weak var dealer: UIButton!
    @IBOutlet weak var support: UIButton!
    
    //포지션별 값
    var position = ["top":3,"mid":3, "jungle":3,"bottom":3,"support":3]
    //포지션 색상(선택여부)에따라 값 지정
    func positionresult(){
        if top.backgroundColor == UIColor.red{
            position["top"]=2
        }
        else if top.backgroundColor == UIColor.blue{
            position["top"]=1
        }
        if mid.backgroundColor == UIColor.red{
            position["mid"]=2
        }
        else if mid.backgroundColor == UIColor.blue{
            position["mid"]=1
        }
        if jungle.backgroundColor == UIColor.red{
            position["jungle"]=2
        }
        else if jungle.backgroundColor == UIColor.blue{
            position["jungle"]=1
        }
        if dealer.backgroundColor == UIColor.red{
            position["bottom"]=2
        }
        else if dealer.backgroundColor == UIColor.blue{
            position["bottom"]=1
        }
        if support.backgroundColor == UIColor.red{
            position["support"]=2
        }
        else if support.backgroundColor == UIColor.blue{
            position["support"]=1
        }
    }
    
    //적용버튼
    @IBAction func apply(_ sender: UIButton) {
        
        //        getPosts()
        dismiss(animated: true)
    }
    
    //토크온 기능
    var talkon = 3
    @IBAction func `switch`(_ sender: UISwitch) {
        if sender.isOn {
            talkon = 1
        } else {
            talkon = 2
        }
    }
    
    //    func getPosts() {
    //        BaseFunc.fetch();
    //        let url = URL(string : BaseFunc.baseurl + "/post/lol/getpost/filter")!
    //        let req = AF.request(url,
    //                            method:.post,
    //                            parameters: ["gameMode": getGameModeType(),"wantTier": 17,"startTime": time, "headcount": headcount,"top": position["top"],"mid":position["mid"],"jungle": position["jungle"],"bottom": position["bottom"],"support": position["support"],"talkon":talkon],
    //                            encoding: JSONEncoding.default)
    //        // db에서 값 가져오기
    //        req.responseJSON {res in
    //            switch res.result {
    //            case.success(let value):
    //
    //                if let datas = value as? Array<Dictionary<String,Any>> {
    //                    self.postsData = datas;
    //
    //                    DispatchQueue.main.async {
    //                        // 테이블 뷰에 그리기
    //                        self.TableViewController.reloadData();
    //                    }
    //                }
    //
    //            case .failure(let error):
    //                print(error)
    //            }
    //        }
    //    }
    
}
