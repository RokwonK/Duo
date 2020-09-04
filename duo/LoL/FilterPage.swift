//
//  FilterPage.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class Filterpage : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start.delegate = self; start.dataSource = self; end.delegate = self; end.dataSource = self
        solo.layer.cornerRadius = 10; free.layer.cornerRadius = 10; custom.layer.cornerRadius = 10
        urf.layer.cornerRadius = 10; random.layer.cornerRadius = 10
        top.layer.cornerRadius = 10; mid.layer.cornerRadius = 10; jungle.layer.cornerRadius = 10
        dealer.layer.cornerRadius = 10; support.layer.cornerRadius = 10
    }
    
    @IBOutlet weak var solo: UIButton!
    @IBOutlet weak var free: UIButton!
    @IBOutlet weak var custom: UIButton!
    @IBOutlet weak var urf: UIButton!
    @IBOutlet weak var random: UIButton!
    
    @IBAction func button_process(sender : UIButton){
        if (sender.backgroundColor == UIColor.red){
            sender.backgroundColor = UIColor.white
        }
        else{
            sender.backgroundColor = UIColor.red
        }
    }
    
    @IBOutlet weak var peoplenum: UILabel!
    @IBAction func sliderValueChanged(sender: UISlider) {
        var value = Int(sender.value) //UISlider(sender)의 value를 Int로 캐스팅해서 current라는 변수로 보낸다.
        
        peoplenum.text = "\(value)"
        
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
    
}
