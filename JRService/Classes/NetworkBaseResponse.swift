//
//  BaseResponseModel.swift
//  bdd
//
//  Created by xiaoyao on 2019/8/19.
//  Copyright © 2019 ddcx. All rights reserved.
//

import HandyJSON

class NetworkBaseResponse<T>: HandyJSON {
    var code: String?
    var msg: String?
    var success: Bool?
    var num: Int?
    var data:T?
    /// success 为false 弹窗显示信息
    var displayMsg: String?
    var currTimestamp = 0
    public required init() {
        
    }
}



