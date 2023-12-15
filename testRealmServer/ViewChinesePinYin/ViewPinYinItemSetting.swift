//
//  ViewPinYinItemSetting.swift
//  ChildStudies
//
//  Created by chenzhizs on 2023/11/21.
//

import SwiftUI
import RealmSwift
import AVFoundation



/// Represents a screen where you can edit the item's name.
struct ViewChinesePinYinItemDetails: View {
    //中文拼音 的数据
    @ObservedRealmObject var item: ChinesePinYinItem

    //把汉字转为拼音，并存到数据库中
    fileprivate func hanzi2py_save2db() {
        let thawItem = item.thaw()
        try! thawItem?.realm!.write{
            thawItem?.itemDescription = item.name.pinyinS
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            //Enter a new name:
            Text("输入汉字:")
                .font(.system(size: 50))
            // Accept a new name
            TextField("汉字", text: $item.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 50).fill(Color.white))
                .accentColor(.yellow)
                .ignoresSafeArea()
                .font(.system(size: 50))
                .onChange(of: item.name) { newValue in
                    // 处理输入值发生变化的逻辑
                    hanzi2py_save2db()
                    
                }
                .navigationBarTitle("是否关注")
                .navigationBarItems(leading:  Toggle(isOn: $item.isFavorite) {
                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                })
            
            Button(action: {
                hanzi2py_save2db()
            }, label: {
                Text("把字转换成拼音:")
                    .font(.system(size: 50))
                
            })
            Text("\(item.itemDescription)")
                .font(.system(size: 50))
        }.padding()
    }
}

/// Represents an Item in a list.
struct ViewPinYinItemRow: View {
    @ObservedRealmObject var item: ChinesePinYinItem

    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
        NavigationLink(destination: ViewChinesePinYinItemDetails(item: item)) {
            VStack(alignment: .leading){
                HStack{
                    Text(item.itemDescription)
                }
                HStack{
                    Text(item.name)
                    if item.isFavorite {
                        // If the user "favorited" the item, display a heart icon
                        Image(systemName: "heart.fill")
                    }
                }
            }
            
        }
    }
}

// MARK: 各种 Views
/// The screen containing a list of items in an ItemGroup. Implements functionality for adding, rearranging,
/// and deleting items in the ItemGroup.
struct ViewPinYinItems: View {
    @ObservedRealmObject var itemGroup: ChinesePinYinItemGroup

    /// The button to be displayed on the top left.
    var leadingBarButton: AnyView?
    
    @State var searchName = ""
    
    func newChinesePinYinItem(_ text: String) -> ChinesePinYinItem{
        //马上转换成拼音
        let _pinyin = text.pinyinS
        return ChinesePinYinItem(value: ["name": text, "isFavorite": false, "itemDescription": _pinyin])
    }
    
    ///配置默认数据的单词
    let reload_data_Array =
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
    
    fileprivate func AllDataDelete() {
        let thawedItem = itemGroup.thaw()
        
        if thawedItem?.isInvalidated == false { //ensure it's a valid item
            
            let thawedRealm = thawedItem!.realm! //get the realm it belongs to
            
            try! thawedRealm.write {
                thawedItem?.items.removeAll()
            }
        }
    }
    
    fileprivate func reloadDefData() {
        let thawedItem = itemGroup.thaw()
        
        if thawedItem?.isInvalidated == false { //ensure it's a valid item
            
            let thawedRealm = thawedItem!.realm! //get the realm it belongs to
            
            try! thawedRealm.write {
                for i in 0..<reload_data_Array.count{
                    let mChinesePinYinItem = ChinesePinYinItem()
                    mChinesePinYinItem.name = reload_data_Array[i]
                    thawedItem?.items.append(mChinesePinYinItem)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    AllDataDelete()
                    reloadDefData()
                } label: {
                    Text("重置默认数据")
                }
                if(!itemGroup.items.isEmpty){
                    Button {
                        AllDataDelete()
                    } label: {
                        Text("清空当前数据")
                    }
                    // The list shows the items in the realm.
                    List {
                        ForEach(itemGroup.items) { item in
                            ViewPinYinItemRow(item: item)
                        }.onDelete(perform: $itemGroup.items.remove)
                            .onMove(perform: $itemGroup.items.move)
                    }
                    .listStyle(GroupedListStyle())
                    .navigationBarTitle("要测试拼音的汉字库", displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(
                        leading: self.leadingBarButton,
                        // Edit button on the right to enable rearranging items
                        trailing: EditButton())
                    // Action bar at bottom contains Add button.
                }
                HStack {
                    TextField("searchName", text: $searchName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(RoundedRectangle(cornerRadius: 50).fill(Color.white))
                        .accentColor(.yellow)
                        .ignoresSafeArea()
                    Button(action: {
                        // The bound collection automatically
                        // handles write transactions, so we can
                        // append directly to it.
                        let item1 = newChinesePinYinItem(searchName)
                        $itemGroup.items.append(item1)
                        
                        //Button输入后，就把searchName TextField清空
                        searchName = ""
                    }) { Image(systemName: "plus") }
                }.padding()
            }
        }
    }
}

struct ViewPinYinItemSetting: View {
    // Implicitly use the default realm's objects(ItemGroup.self)
    @ObservedResults(ChinesePinYinItemGroup.self) var itemGroups
    @State var searchName = ""
    var body: some View {

        VStack{
            HStack{
                
                TextField("添加", text: $searchName)
                Button {
                    
                    let realm = try! Realm()
                    
                    do{
                      let _itemGroup = ChinesePinYinItemGroup()
                      try realm.write{
                          _itemGroup.title = searchName
                          realm.add(_itemGroup)
                          _itemGroup.items.append(objectsIn: [ChinesePinYinItem.sample])
                          searchName = ""
                      }
                    }catch let error {
                        fatalError("Can't 添加 item data: \(error.localizedDescription)")
                    }
                } label: {
                    Text("添加")
                }
            }.padding(10)

            if(itemGroups.isEmpty){
                Text("itemGroups.isEmpty")
            }else{
                
                List {
                    
                    ForEach(itemGroups) { itemGroup in
                        NavigationLink(destination:
                            ViewPinYinItems(itemGroup: itemGroup)) {
                            Text(itemGroup.title=="" ? "默认\(itemGroup.id)":itemGroup.title)
                                .padding( 30)
                        }
                    }.onDelete(perform: $itemGroups.remove)
                }
            }
        }
//        if let itemGroup = itemGroups.first {
//            // Pass the ItemGroup objects to a view further
//            // down the hierarchy
//            ViewPinYinItems(itemGroup: itemGroup)
//        } else {
//            // For this small app, we only want one itemGroup in the realm.
//            // You can expand this app to support multiple itemGroups.
//            // For now, if there is no itemGroup, add one here.
//            ProgressView().onAppear {
//                $itemGroups.append(ChinesePinYinItemGroup())
//            }
//        }
    }
}

//struct ViewPinYinItemSetting_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewPinYinItemSetting()
//    }
//}
