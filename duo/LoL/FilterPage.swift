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
    
   
    @IBOutlet var GameModeButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start.delegate = self; start.dataSource = self; end.delegate = self; end.dataSource = self
//        solo.layer.cornerRadius = 10; free.layer.cornerRadius = 10; custom.layer.cornerRadius = 10
//        urf.layer.cornerRadius = 10; random.layer.cornerRadius = 10
//        top.layer.cornerRadius = 10; mid.layer.cornerRadius = 10; jungle.layer.cornerRadius = 10
//        dealer.layer.cornerRadius = 10; support.layer.cornerRadius = 10
    }

    @IBAction func ButtonSelected(_ sender: UIButton) {
        GameModeButtons.forEach({$0.backgroundColor = UIColor.white})
        sender.backgroundColor = UIColor.blue
        
    }
    
    @IBAction func button_process(sender : UIButton){
        if sender.backgroundColor == UIColor.white{
            sender.backgroundColor == UIColor.blue
        }
        else if sender.backgroundColor == UIColor.blue{
            sender.backgroundColor == UIColor.red
        }
        else{
            sender.backgroundColor == UIColor.white
        }
    }
    
    @IBOutlet weak var peoplenum: UILabel!
    var headcount : Int = 0
    @IBAction func sliderValueChanged(sender: UISlider) {
        var value = Int(sender.value) //UISlider(sender)의 value를 Int로 캐스팅해서 current라는 변수로 보낸다.
        
        peoplenum.text = "\(value)"
        headcount = value
    }
    
    
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
    
    @IBOutlet weak var top: UIButton!
    @IBOutlet weak var mid: UIButton!
    @IBOutlet weak var jungle: UIButton!
    @IBOutlet weak var dealer: UIButton!
    @IBOutlet weak var support: UIButton!
    
    @IBAction func DatePicker (sender: UIDatePicker){
        
    }
    
    var position = ["top":3,"mid":3, "jungle":3,"bottom":3,"support":3]
    
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
    
    @IBAction func save(_ sender: UIButton) {
        
        getPosts()
        dismiss(animated: true)
    }
    
    func getGameModeType() -> GameModeNumber {
        for (index, button) in GameModeButtons.enumerated(){
            if button.backgroundColor == UIColor.red{
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

    func getPosts() {
        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/lol/getpost/filter")!
        let req = AF.request(url,
                            method:.post,
                            parameters: ["gameMode": getGameModeType(),"wantTier": 17,"startTime": "17:00", "headcount": headcount,"top": position["top"],"mid":position["mid"],"jungle": position["jungle"],"bottom": position["bottom"],"support": position["support"],"talkon":3],
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

}
