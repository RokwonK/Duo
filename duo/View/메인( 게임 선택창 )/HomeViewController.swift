//
//  HomeViewController.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var lolView: UIView!
    @IBOutlet weak var bagView: UIView!
    @IBOutlet weak var overwatchView: UIView!
    @IBOutlet weak var pokemonView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        lolView.layer.cornerRadius = 10
        bagView.layer.cornerRadius = 10
        overwatchView.layer.cornerRadius = 10
        pokemonView.layer.cornerRadius = 10
        
        lolView.setShadow(color: UIColor.black.cgColor, width: 1, height: 1, opacity: 0.1, radius: 1.5)
        bagView.setShadow(color: UIColor.black.cgColor, width: 1, height: 1, opacity: 0.1, radius: 1.5)
        overwatchView.setShadow(color: UIColor.black.cgColor, width: 1, height: 1, opacity: 0.1, radius: 1.5)
        pokemonView.setShadow(color: UIColor.black.cgColor, width: 1, height: 1, opacity: 0.1, radius: 3)
    }

}
