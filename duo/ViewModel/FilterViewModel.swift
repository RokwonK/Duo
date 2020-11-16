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
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    func positionResult(){
        
        if FilterView().Top?.tintColor == UIColor.black{
            FilterModel.sharedInstance.Position["top"]=2
        }
        else {FilterModel.sharedInstance.Position["top"]=1}
        
        if FilterView().Mid?.tintColor == UIColor.black{
            FilterModel.sharedInstance.Position["mid"]=2
        }
        else {FilterModel.sharedInstance.Position["mid"]=1}
        
        if FilterView().Jungle?.tintColor == UIColor.black{
            FilterModel.sharedInstance.Position["jungle"]=2
        }
        else {FilterModel.sharedInstance.Position["jungle"]=1}
        
        if FilterView().Dealer?.tintColor == UIColor.black{
            FilterModel.sharedInstance.Position["bottom"]=2
        }
        else {FilterModel.sharedInstance.Position["bottom"]=1}
        
        if FilterView().Support?.tintColor == UIColor.black{
            FilterModel.sharedInstance.Position["support"]=2
        }
        else {FilterModel.sharedInstance.Position["support"]=1}
    }
    
    func getPosts() {
        
        self.ad!.filterdata = []// 필터 설정할때마다 빈배열로 초기화
//        BaseFunc.fetch()
        let url = URL(string : BaseFunc.baseurl + "/post/lol/filter")!
        let req = AF.request(url,
                             method:.get,
                             parameters: [
                                "gameMode": FilterModel.sharedInstance.gameModeName,
                                "headCount": FilterModel.sharedInstance.headCount,
                                "wantTier": FilterModel.sharedInstance.Mytiernumber,
//                                "startTime": FilterModel.sharedInstance.Time,
                                "top": FilterModel.sharedInstance.Position["top"],
                                "mid":FilterModel.sharedInstance.Position["mid"],
                                "jungle": FilterModel.sharedInstance.Position["jungle"],
                                "bottom": FilterModel.sharedInstance.Position["bottom"],
                                "support": FilterModel.sharedInstance.Position["support"],
                                "talkon":FilterModel.sharedInstance.talkOn],
                             encoding: URLEncoding.queryString,
                             headers: ["Authorization": ad!.access_token, "Content-Type": "application/json"])
        
        // db에서 값 가져오기
        req.responseJSON {res in
            print(res)
            switch res.result {
            case.success(let value):
                if let datas = value as? Array<Dictionary<String,Any>> {
                    LoLMainBoard().postsData = datas
//                    for i in datas{
//                        self.ad!.filterdata.append(i);
//                        print("추가됨")
//                    }
                    print("온다여기")
                    print(datas)
                }
                else{
                    LoLMainBoard().postsData = []
                    print("else here")
                }
            case.failure(let error):
                print(error)
            }
        }
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
