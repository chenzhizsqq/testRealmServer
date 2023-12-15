//
//  ChinesePinYinItem.swift
//  ChildStudies
//
//  Created by chenzhizs on 2023/11/21.
//

import Foundation
import RealmSwift
import SwiftUI

///要测试的单词
let questionStringArray =
["走","秋","气","了","树","叶","片","大",
 "飞","会","个","的","船","两","头","在",
 "里","看","见","闪","星","江","南","可",
 "采","莲","鱼","东","西","北","尖","说",
 "春","青","蛙","夏","弯","地","就","冬",
 "男","女","开","关","正","反","远","有",
 "色","近","听","无","声","去","还","来",
 "多","少","黄","牛","只","猫","边","鸭",
 "苹","果","杏","桃","书","包","尺","作",
 "业","本","笔","刀"
]

///拼音的单韵母 的 各种发音
let pyA = "aāáǎà"
let pyO = "oōóǒò"
let pyE = "eēéěè"
let pyI = "iīíǐì"
let pyU = "uūúǔù"
let pyV = "üǖǘǚǜ"
    

extension ChinesePinYinItem {
    static let item1 = ChinesePinYinItem(value: ["name": "一年级上册1", "isFavorite": false])
    static let item2 = ChinesePinYinItem(value: ["name": "一年级上册2", "isFavorite": false])
    static let item3 = ChinesePinYinItem(value: ["name": "一年级上册3", "isFavorite": false])
    
    static let sample = ChinesePinYinItem(value: ["name": "sample", "isFavorite": false])
}

/// An individual item. Part of an `ItemGroup`.
final class ChinesePinYinItem: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Item. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    
    /// The name of the Item, By default, a random name is generated.
    @Persisted var name = "\(questionStringArray.randomElement()!)"
    
    /// A flag indicating whether the user "favorited" the item.
    @Persisted var isFavorite = false
    
    /// Users can enter a description, which is an empty string by default
    @Persisted var itemDescription = ""
    
    /// 反向指向ChinesePinYinItemGroup 的 items 的那个变量，用作说明本class是属于ChinesePinYinItemGroup的下一层
    @Persisted(originProperty: "items") var group: LinkingObjects<ChinesePinYinItemGroup>
}

/// Represents a collection of items.
final class ChinesePinYinItemGroup: Object, ObjectKeyIdentifiable {
    /// The unique ID of the ItemGroup. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId   //_id为主键
    /// 主题名字
    @Persisted var title = ""  //主题名字
    /// The collection of Items in this group.
    @Persisted var items = RealmSwift.List<ChinesePinYinItem>()
}


extension ChinesePinYinItemGroup {
    static let itemGroup = ChinesePinYinItemGroup()
    
    static var previewRealm: Realm {
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            // Check to see whether the in-memory realm already contains an ItemGroup.
            // If it does, we'll just return the existing realm.
            // If it doesn't, we'll add an ItemGroup and append the Items.
            let realmObjects = realm.objects(ChinesePinYinItemGroup.self)
            if realmObjects.count == 1 {
                return realm
            } else {
                try realm.write {
                    realm.add(itemGroup)
                    //itemGroup.items.removeAll()
                    itemGroup.items.append(objectsIn: [ChinesePinYinItem.item1, ChinesePinYinItem.item2, ChinesePinYinItem.item3])
                }
                return realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}
