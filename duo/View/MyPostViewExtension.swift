//
//  MyPostViewExtension.swift
//  duo
//
//  Created by 황윤재 on 2020/11/16.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

extension MyPostView {
    
    
    func extension_cellSetting(_ cell : MyPostCell) {
        cell.tier.layer.cornerRadius = 7;
        cell.tier.tintColor = UIColor.white;
        cell.tier.backgroundColor = UIColor.blue;
        cell.tier.layer.masksToBounds = true;
        
        cell.gameMode.layer.cornerRadius = 7;
        cell.gameMode.tintColor = UIColor.white;
        cell.gameMode.backgroundColor = UIColor.blue;
        cell.gameMode.layer.masksToBounds = true;
        
        cell.headCount.layer.cornerRadius = 7;
        cell.headCount.tintColor = UIColor.white;
        cell.headCount.backgroundColor = UIColor.blue;
        cell.headCount.layer.masksToBounds = true;
        
        cell.startTime.textColor = UIColor.blue;
        cell.micFillBtn.tintColor = UIColor.blue;
        cell.micNotBtn.tintColor = UIColor.blue;
        
    }
    
}
