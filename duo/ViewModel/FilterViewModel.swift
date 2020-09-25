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
        
        FilterModel.sharedInstance.AD!.filterdata = []// 필터 설정할때마다 빈배열로 초기화
        BaseFunc.fetch();
        let url = URL(string : BaseFunc.baseurl + "/post/lol/getpost/filter")!
        let req = AF.request(url,
                             method:.post,
                             parameters: ["userId": BaseFunc.userId, "userNickname": BaseFunc.userNickname,"gameMode": FilterModel.sharedInstance.gameModeName,"wantTier": FilterModel.sharedInstance.Mytiernumber,"startTime": FilterModel.sharedInstance.Time, "headCount": FilterModel.sharedInstance.headCount,"top": FilterModel.sharedInstance.Position["top"],"mid":FilterModel.sharedInstance.Position["mid"],"jungle": FilterModel.sharedInstance.Position["jungle"],"bottom": FilterModel.sharedInstance.Position["bottom"],"support": FilterModel.sharedInstance.Position["support"],"talkon":FilterModel.sharedInstance.talkOn],
                             encoding: JSONEncoding.default)
        
        // db에서 값 가져오기
        req.responseJSON {res in
            switch res.result {
            case.success(let value):
                if let datas = value as? Array<Dictionary<String,Any>> {
                    var i = 0
                    for i in datas{
                        FilterModel.sharedInstance.AD!.filterdata.append(i);
                    }
                    print(FilterModel.sharedInstance.AD!.filterdata)
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    lazy var uploadStartTime : UIDatePicker = {
        let startTimePicker : UIDatePicker = UIDatePicker();
        startTimePicker.timeZone = NSTimeZone.local;
        startTimePicker.addTarget(self, action: #selector(FilterView().timeChange), for: .valueChanged)
        startTimePicker.backgroundColor = UIColor.white;
        
        return startTimePicker;
    }()
    
}
