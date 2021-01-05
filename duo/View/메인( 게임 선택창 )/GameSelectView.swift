//
//  GameTab.swift
//  duo
//
//  Created by 황윤재 on 2020/08/25.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class GameSelectView : UIViewController{
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var lol: UIButton!
    @IBOutlet weak var overwatch: UIButton!
    @IBOutlet weak var battleground: UIButton!
    @IBOutlet weak var none: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(ad!.access_token)
//        introText.text = "어떤게임의 듀오를 구하시나요?"
//        let attributedStr = NSMutableAttributedString(string: introText.text!)
//        attributedStr.addAttribute(.foregroundColor, value: UIColor(displayP3Red: 250/255, green: 90/255, blue: 90/255, alpha: 1), range: (introText.text! as NSString).range(of: "듀오"))
//        introText.attributedText = attributedStr
        
        searchBar.layer.cornerRadius = 15
//        searchBar.layer.masksToBounds = true
//        searchBar.clipsToBounds = true
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        searchBar.layer.shadowOpacity = 0.2
        searchBar.layer.shadowRadius = 6
//        searchBar.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 134, green: 134, blue: 134, alpha: 1)])
        
        lol.layer.borderWidth = 1.0
        lol.layer.borderColor = UIColor.white.cgColor
        lol.layer.cornerRadius = 10
        lol.layer.shadowColor = UIColor.black.cgColor
        lol.layer.shadowOffset = CGSize(width: 0, height: 3)
        lol.layer.shadowOpacity = 0.2
        lol.layer.shadowRadius = 6
        
        
        overwatch.layer.borderWidth = 1.0
        overwatch.layer.borderColor = UIColor.white.cgColor
        overwatch.layer.cornerRadius = 10
        overwatch.layer.shadowColor = UIColor.black.cgColor
        overwatch.layer.shadowOffset = CGSize(width: 0, height: 3)
        overwatch.layer.shadowOpacity = 0.2
        overwatch.layer.shadowRadius = 6
        
        battleground.layer.borderWidth = 1.0
        battleground.layer.borderColor = UIColor.white.cgColor
        battleground.layer.cornerRadius = 10
        battleground.layer.shadowColor = UIColor.black.cgColor
        battleground.layer.shadowOffset = CGSize(width: 0, height: 3)
        battleground.layer.shadowOpacity = 0.2
        battleground.layer.shadowRadius = 6
        
        
        none.layer.borderWidth = 1.0
        none.layer.borderColor = UIColor.white.cgColor
        none.layer.cornerRadius = 10
        none.layer.shadowColor = UIColor.black.cgColor
        none.layer.shadowOffset = CGSize(width: 0, height: 3)
        none.layer.shadowOpacity = 0.2
        none.layer.shadowRadius = 6
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ad!.record = 0
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
}
