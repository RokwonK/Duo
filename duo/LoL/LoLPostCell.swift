//
//  LoLPostCell.swift
//  duo
//
//  Created by 김록원 on 2020/09/02.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class LoLPostCell : UITableViewCell {
    
    @IBOutlet weak var gameMode: UILabel!
    @IBOutlet weak var tier: UILabel!
    @IBOutlet weak var headCount: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var bottom: UILabel!
    @IBOutlet weak var mid: UILabel!
    @IBOutlet weak var support: UILabel!
    @IBOutlet weak var jungle: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse();
        top.backgroundColor = UIColor.white;
        bottom.backgroundColor = UIColor.white;
        mid.backgroundColor = UIColor.white;
        support.backgroundColor = UIColor.white;
        jungle.backgroundColor = UIColor.white;
        tier.layer.cornerRadius = 5;
        gameMode.layer.cornerRadius = 5;
        headCount.layer.cornerRadius = 5;
        tier.backgroundColor = UIColor.lightGray;
        gameMode.backgroundColor = UIColor.lightGray;
        headCount.backgroundColor = UIColor.lightGray;
        tier.layer.masksToBounds = true;
        gameMode.layer.masksToBounds = true;
        headCount.layer.masksToBounds = true;
    }
    
}
