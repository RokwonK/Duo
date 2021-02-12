//
//  LoLBoardCell.swift
//  duo
//
//  Created by 김록원 on 2021/02/12.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

class LoLBoardCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    let mainColor : CGColor = .init(srgbRed: 50/255, green: 110/255, blue: 249/255, alpha: 1)
    
    static func getHeight() -> CGFloat {
        return 24 + 15 + 16 + 56 + 16 + 1 + 8 + 20 + 8 + 15 + 24 + 16 + 8
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUILayer()
    }
    
    func setupUILayer() {
        stackView.layer.cornerRadius = 5
        cellView.layer.cornerRadius = 10
        cellView.setShadow(color: .init(srgbRed: 0, green: 0, blue: 0, alpha: 1) , width: 1, height: 1, opacity: 0.2, radius: 3)
    }

}
