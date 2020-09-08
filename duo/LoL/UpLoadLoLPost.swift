//
//  UpLoadLoLPost.swift
//  duo
//
//  Created by 김록원 on 2020/09/08.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class UpLoadLoLPost : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var uploadTitle: UITextField!
    let toolBarKeyboard = UIToolbar()
    
    
    
    func textViewSetup() {
        if uploadContent.text == "내용 입력" {
            uploadContent.text = "";
            uploadContent.textColor = UIColor.black;
        }
        else if uploadContent.text == "" {
            uploadContent.text = "내용 입력";
            uploadContent.textColor = UIColor.lightGray;
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetup()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if uploadContent.text == "" { textViewSetup() }
    }
    
    
    // lazy closuer - 지연 저장 프로퍼티 => addSubview에서 생성(성능, 공간 낭비를 줄임)
    lazy var uploadContent: UITextView = {
        
        let contentView : UITextView = UITextView(frame: CGRect(x: 15, y: uploadTitle.frame.maxY+5, width: self.view.frame.width-30, height: 300))
        contentView.delegate = self;
        
        // 강제로 placeholder 만들기
        contentView.text = "내용 입력"
        contentView.textColor = UIColor.lightGray;
        contentView.textAlignment = NSTextAlignment.left;
        
        // border 셋팅
        contentView.layer.borderWidth = 1;
        contentView.layer.cornerRadius = 5;
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        // 키보드에 확인 버튼 추가
        contentView.inputAccessoryView = toolBarKeyboard;
       
        return contentView;
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // naviBar 셋팅
        let statusBarheight = UIApplication.shared.statusBarFrame.height
        naviBar.frame = CGRect(x: 0, y: statusBarheight, width:self.naviBar.frame.maxX, height: self.naviBar.frame.maxY );
        
        // 키보드 툴발 만들기
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(self.doneBtnClicked))
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.gray;
        
        // 제목 textField
        uploadTitle.attributedPlaceholder = NSAttributedString(string : "제목");
        uploadTitle.frame = CGRect(x: 15, y: self.naviBar.frame.maxY + 15, width: self.view.frame.width-30, height: 30)
        uploadTitle.inputAccessoryView = toolBarKeyboard
        

        
        self.view.addSubview(self.uploadContent)
    }
    
    //키보드에 확인 버튼 추가
    @IBAction func doneBtnClicked(sender : Any) {
        self.view.endEditing(true);
    }
    
    // 스크린 터치시 키보드 내려가게 설정
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    // statusbar 보이게 설정
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
}
