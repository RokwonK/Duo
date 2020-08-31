//
//  LolMainBoard.swift
//  duo
//
//  Created by 황윤재 on 2020/08/31.
//  Copyright © 2020 김록원. All rights reserved.
//

import UIKit

class LolMainBoardController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //섹션의 개수 => 이건일단 무조건 1로하면됨
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //행 개수 => 한 섹션에 보여질 게시물 수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // 추후에 변경필요
    }

    
    
    
}
