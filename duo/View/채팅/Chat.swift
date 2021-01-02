//
//  File.swift
//  duo
//
//  Created by 황윤재 on 2020/12/11.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class ChatView : UIViewController{

    @IBOutlet weak var chattitle : UILabel!
    
    func addBottomBorder() {
        let thickness: CGFloat = 1.0
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.chattitle.frame.size.height - thickness, width: self.chattitle.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        chattitle.layer.addSublayer(bottomBorder)
        
    }
    override func viewDidLoad() {
        addBottomBorder()
    }
}
