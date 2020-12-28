//
//  UIButton+Extension.swift
//  duo
//
//  Created by 김록원 on 2020/12/29.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

extension UIButton {
    func setShadow(color : CGColor, width : Int, height : Int, opacity : Float, radius : CGFloat) {
        
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width : width,height : height )
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    
}
