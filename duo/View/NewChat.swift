//
//  File.swift
//  duo
//
//  Created by 황윤재 on 2020/12/11.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class NewChat : UIViewController{
    
    @IBOutlet weak var tbar : UILabel!
    
    func addBottomBorder() {
        let thickness: CGFloat = 1.0
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.tbar.frame.size.height - thickness, width: self.tbar.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        tbar.layer.addSublayer(bottomBorder)
        
    }
    override func viewDidLoad() {
        addBottomBorder()
    }
}
