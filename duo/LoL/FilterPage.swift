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

    let ad = UIApplication.shared.delegate as? AppDelegate // appdelegate파일 참조
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //티어 picker
        start.delegate = self
        start.dataSource = self
        end.delegate = self
        end.dataSource = self
        //
        //둥글게둥글게
        GameModeButtons.forEach({$0.layer.cornerRadius = 10})
        top.layer.cornerRadius = 10;
        mid.layer.cornerRadius = 10;
        jungle.layer.cornerRadius = 10;
        dealer.layer.cornerRadius = 10;
        support.layer.cornerRadius = 10;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.ad!.filterdata = [] // 필터 설정할때마다 빈배열로 초기화
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
        return .knifeWind
    }
    
    enum GameModeNumber : Int{
        case soloRank
        case freeRank
        case normal
        case knifeWind
        case custom
        case all
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
    var headcount : Int = 1 //기본값 >>> 상관없음 적용누를때 기본값으로 1 설정하는거 맞나? 확인바람
    @IBAction func sliderValueChanged(sender: UISlider) {
        var value = Int(sender.value) //UISlider(sender)의 value를 Int로 캐스팅해서 current라는 변수로 보낸다.
        peoplenum.text = "\(value)"
        headcount = value
    }
    
    //티어 관련부분
    @IBOutlet weak var start: UIPickerView!
    @IBOutlet weak var end: UIPickerView!
    
    let tier = ["Iron","Bronze","Silver","Gold","Platinum","Dia","Master","GrandMaster","Challenger"]
    let tiernumber = [1,2,3,4]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return tier.count
        } else {
            return tiernumber.count
        }
    }
    
    var Mytier : String = ""
    var Mytiernumber : Int = 0
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            Mytier = tier[row]
            return "\(tier[row])"
        }
        else {
            Mytiernumber = tiernumber[row]
            return "\(tiernumber[row])"
        }
    }
    
    //datepicker
    var time : String = ""
    @IBAction func DatePicker (sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        time =  formatter.string(from: sender.date)
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
    var record : Int = 0 // 내가 구현한 로직상으론 일단 메인게시판화면에서 필터화면을 갔다온건지 아닌지 구분하기위한 변수. 0이면 안갔다온거고 1이면 갔다온거.
    //게임모드 식별하기위해 필요한 변수들
    var gamemodenum = 0
    var gamemodename = ""
    
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
        case 6:
            gamemodename = "all"
        default:
            gamemodename = "all"
        }
        positionresult()
        getPosts()
        let ad = UIApplication.shared.delegate as? AppDelegate
        ad!.record += 1
        self.dismiss(animated: true, completion: nil)
    }
    
    //토크온 기능
    var talkon = 3 //기본설정 상관없음
    @IBAction func `switch`(_ sender: UISwitch) {
        if sender.isOn {
            talkon = 1
        } else {
            talkon = 2
        }
    }
    
    //상관없음 버튼
    @IBAction func ApplyNothing(_ sender: UIButton) {
        gamemodename = "all"
        Mytiernumber = 11
        time = "2020-08-06T12:38:48.000Z" //예전시간으로 일단 설정해놈
        headcount = 11
        position = ["top":3,"mid":3, "jungle":3,"bottom":3,"support":3]
        talkon = 3
        getPosts()
        let ad = UIApplication.shared.delegate as? AppDelegate
        ad!.record += 1 // 필터화면 다녀간 흔적
        self.dismiss(animated: true, completion: nil)
        print("상관없음 적용버튼")
    }
    
    func getPosts() {
        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/lol/getPost/filter")!
        let req = AF.request(url,
                             method:.post,
                             parameters: ["userId": BaseFunc.userId, "userNickname": BaseFunc.userNickname,"gameMode": gamemodename,"wantTier": Mytiernumber,"startTime": time, "headCount": headcount,"top": position["top"],"mid":position["mid"],"jungle": position["jungle"],"bottom": position["bottom"],"support": position["support"],"talkon":talkon],
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
}
