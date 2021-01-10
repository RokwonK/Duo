//
//  FilterPageViewModel.swift
//  duo
//
//  Created by 황윤재 on 2020/09/22.
//  Copyright © 2020 김록원. All rights reserved.
//
import UIKit
import Alamofire

class FilterViewModel {
    
    static let sharedInstance = FilterViewModel()
    let customcolor = UIColor(displayP3Red: 250/255, green: 90/255, blue: 90/255, alpha: 1)
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    func getPosts() {
        
//        print(FilterModel.sharedInstance.gameModeName,
//              FilterModel.sharedInstance.headCount,
//              FilterModel.sharedInstance.Mytiernumber!,
//              FilterModel.sharedInstance.Position["top"]!,
//              FilterModel.sharedInstance.Position["mid"]!,
//              FilterModel.sharedInstance.Position["jungle"]!,
//              FilterModel.sharedInstance.Position["bottom"]!,
//              FilterModel.sharedInstance.Position["support"]!,
//              FilterModel.sharedInstance.talkOn)
//        self.ad!.filterdata = []// 필터 설정할때마다 빈배열로 초기화
////        BaseFunc.fetch()
//        let url = URL(string : BaseFunc.baseurl + "/post/lol/filter")!
//        let req = AF.request(url,
//                             method:.get,
//                             parameters: [
//                                "gameMode": FilterModel.sharedInstance.gameModeName,
//                                "headCount": FilterModel.sharedInstance.headCount,
//                                "wantTier": FilterModel.sharedInstance.Mytiernumber!,
////                                "startTime": FilterModel.sharedInstance.Time,
//                                "top": FilterModel.sharedInstance.Position["top"]!,
//                                "mid":FilterModel.sharedInstance.Position["mid"]!,
//                                "jungle": FilterModel.sharedInstance.Position["jungle"]!,
//                                "bottom": FilterModel.sharedInstance.Position["bottom"]!,
//                                "support": FilterModel.sharedInstance.Position["support"]!,
//                                "talkon":FilterModel.sharedInstance.talkOn,
//                                "limit":50,
//                                "offset" : 0],
//                             encoding: URLEncoding.queryString,
//                             headers: ["Authorization": ad!.access_token, "Content-Type": "application/json"])
//        
//        // db에서 값 가져오기
//        req.responseJSON {res in
//            print(res)
//            switch res.result {
//            case.success(let value):
//                if let datas = value as? Array<Dictionary<String,Any>> {
//                    LoLMainBoard().postsData = datas
//                    for i in datas{
//                        self.ad!.filterdata.append(i);
//                        print("추가됨")
//                    }
//                    print("온다여기")
//                    print(datas)
//                }
//                else{
//                    LoLMainBoard().postsData = []
//                    print("else here")
//                }
//            case.failure(let error):
//                print(error)
//            }
//        }
    }
    
    
//    lazy var uploadStartTime : UIDatePicker = {
//        let startTimePicker : UIDatePicker = UIDatePicker();
//        startTimePicker.timeZone = NSTimeZone.local;
//        startTimePicker.addTarget(self, action: #selector(FilterView().timeChange), for: .valueChanged)
//        startTimePicker.backgroundColor = UIColor.white;
//
//        return startTimePicker;
//    }()
//
}
