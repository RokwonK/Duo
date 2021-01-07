//
//  LoLPostCell.swift
//  duo
//
//  Created by 김록원 on 2020/09/02.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class LoLPostCell : UITableViewCell {
    
    @IBOutlet weak var tableBox: UIView!
    
    @IBOutlet weak var tier: UIButton!
    @IBOutlet weak var headCount: UIButton!
    @IBOutlet weak var gameMode: UIButton!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var uploadTime: UILabel!
    
//    @IBOutlet weak var topBtn: UIButton!
//    @IBOutlet weak var jungleBtn: UIButton!
//    @IBOutlet weak var midBtn: UIButton!
//    @IBOutlet weak var bottomBtn: UIButton!
//    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var micFillBtn: UIButton!
    @IBOutlet weak var micNotBtn: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse();
//        self.topBtn.isHidden = false;
//        self.jungleBtn.isHidden = false;
//        self.midBtn.isHidden = false;
//        self.bottomBtn.isHidden = false;
//        self.supportBtn.isHidden = false;
        self.micFillBtn.isHidden = false;
        self.micNotBtn.isHidden = false;
    }
}
