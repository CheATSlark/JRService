//
//  JRStorable.swift
//  23
//
//  Created by 焦瑞洁 on 2020/7/22.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation

public protocol JRStorable {
    
//    associatedtype ResponseType
    
    /// 是否读取缓
    var allowsStorage: (String) -> Bool { get }
    
    /// 是否允许存储，
    var needCached: Bool { get }
    
    /// 是否需要更新立即缓存,
    /// 若立即更新，则显示缓存数据后，立即请求新的数据
    /// 若不立即更新，则等到缓存失效后，再去请求新的数据
    var updateImmediate: Bool { get }
    
    /// 读取缓存的响应数据
    ///
    /// - Parameter key: 缓存的键
    /// - Returns: 缓存的响应数据
    /// - Throws: 读取缓存可能产生的错误
    func cachedResponse(for key: JRStoringKey) throws -> String
    
    /// 存储缓存的响应数据
    ///
    /// - Parameters:
    ///   - cachedResponse: 缓存的响应数据
    ///   - key: 缓存的键
    /// - Throws: 存储缓存可能产生的错误
    func storeCachedResponse(_ cachedResponse: String, for key: JRStoringKey) throws
    
    /// 移除缓存的响应数据
    ///
    /// - Parameter key: 缓存的键
    /// - Throws: 移除缓存可能产生的错误
    func removeCachedResponse(for key: JRStoringKey) throws
    
    /// 移除所有的缓存数据
    ///
    /// - Throws: 移除缓存可能产生的错误
    func removeAllCachedResponses() throws
}

struct StoryListModel: Codable {
    let topStories: [StoryItemModel]
    
    enum CodingKeys: String, CodingKey {
        case topStories = "top_stories"
    }
}

struct StoryItemModel: Codable {
    let id: String
    let title: String
    let image: String
}
