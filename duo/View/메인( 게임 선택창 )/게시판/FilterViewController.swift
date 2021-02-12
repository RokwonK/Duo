//
//  FilterViewController.swift
//  duo
//
//  Created by 김록원 on 2021/02/12.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FilterViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    
    let viewModel = FilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIBinding()
    }
    
    func setupUIBinding() {
        dismissButton.rx
            .tap
            .subscribe(onNext : { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
        
    }
    
    

}
