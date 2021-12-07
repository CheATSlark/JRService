//
//  JRStoringKey.swift
//  23
//
//  Created by 焦瑞洁 on 2020/7/22.
//  Copyright © 2020 ddcx. All rights reserved.
//

public protocol JRStoringKey {
    
    var keyString: String { get }
    
    // 唯一标志符号
    var uniqueString: String { get }
}
