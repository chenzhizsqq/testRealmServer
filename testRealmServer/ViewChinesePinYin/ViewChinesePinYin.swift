//
//  ViewChinesePinYin.swift
//  ChildStudies
//
//  Created by chenzhizs on 2023/11/06.
//

import SwiftUI
import Foundation
import RealmSwift

///看字选拼音
struct ViewChinesePinYin: View {
    
    //对应环境变量
    @EnvironmentObject var envModel: EnvironmentModel
    
    ///当前分数
    @State var intScore = 0
    
    ///是否在初始化
    @State private var bInit = true
    
    //4个时间选择栏的文字
    @State var answerDateArray = [String]()
    
    ///是否显示Pw页面
    @State private var showPwView = false
    
    @State private var showModal = false
    @State private var isSheetDismissed = false
    
    //记录到iOS机上的最高分数
    @AppStorage("scoreViewChinesePinYin") var scoreViewChinesePinYin = 0
    
    //错了扣多少分
    @AppStorage("pointsMistakes_ViewChinesePinYin") private var pointsMistakes = 1.0
    
    //错了再做一次
    @AppStorage("pointsMistakes_isOneMoreAgain") private var isOneMoreAgain = false
    
    //是否专门做音符
    @AppStorage("pointsMistakes_is专门做音符") private var is专门做音符 = false
    
    //是否 针对错误追加测试
    @AppStorage("ViewChinesePinYin_is针对错误追加测试") private var is针对错误追加测试 = false
    
    ///对错提示
    @State var strAnswerTips = ""
    
    ///要测试的单词
    @State var questionStringArray =            ["走","秋","气","了","树","叶","片","大",
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
    
    ///抽中的单词
    @State var selectedWord = "大"
    
    ///抽中的单词 后 的答案
    @State var selectedWordAnswer = "da"
    
    //中文拼音 的数据
    @ObservedResults(ChinesePinYinItemGroup.self) var itemGroups
    
    //中文拼音 的数据 Log
    fileprivate func realmDbLog() {
        /*
        print("*** itemGroups")
        print(itemGroups)
         itemGroups.forEach { ChinesePinYinItemGroup in
            print("*** ChinesePinYinItemGroup")
            print(ChinesePinYinItemGroup)
            print("*** ChinesePinYinItemGroup.items")
            print(ChinesePinYinItemGroup.items)
            print("*** ChinesePinYinItemGroup.id")
            print(ChinesePinYinItemGroup.id)
            print("*** ChinesePinYinItemGroup._id")
            print(ChinesePinYinItemGroup._id)
            print("*** ChinesePinYinItemGroup.objectSchema")
            print(ChinesePinYinItemGroup.objectSchema)
            print("*** ChinesePinYinItemGroup.objectSchema.className")
            print(ChinesePinYinItemGroup.objectSchema.className)
            print("*** ChinesePinYinItemGroup.objectSchema.description")
            print(ChinesePinYinItemGroup.objectSchema.description)
            ChinesePinYinItemGroup.items.forEach { ChinesePinYinItem in
                
                
                print("--- ChinesePinYinItem")
                print(ChinesePinYinItem)
                print("--- ChinesePinYinItem.id")
                print(ChinesePinYinItem.id)
                print("--- ChinesePinYinItem._id")
                print(ChinesePinYinItem._id)
                print("--- ChinesePinYinItem.objectSchema")
                print(ChinesePinYinItem.objectSchema)
                print("--- ChinesePinYinItem.objectSchema.className")
                print(ChinesePinYinItem.objectSchema.className)
                print("--- ChinesePinYinItem.objectSchema.description")
                print(ChinesePinYinItem.objectSchema.description)
                
            }
        }
         */
    }
    
    ///读取 Realm 的数据，把数据放到本view中
    fileprivate func loadRealmDb() {
        if(itemGroups.count>0){
            questionStringArray.removeAll()
            itemGroups.forEach { ChinesePinYinItemGroup in
                ChinesePinYinItemGroup.items.forEach { ChinesePinYinItem in
                    questionStringArray.append(ChinesePinYinItem.name)
                }
            }
        }
    }
    
    // MARK: - 初始化
    init() {
        
        answerArrayNewRandom()
        
        //realmDbLog()
    }
    
    func answerArrayNewRandom() {
        if(is专门做音符){
            answerArrayNewRandom_专门做音符()
        }else{
            answerArrayNewRandom_不是音符的随机()
        }
    }
    
    //选择的答案数据，重新做一组数据 真正随机
    fileprivate func answerArrayNewRandom_不是音符的随机() {
        if(isOneMoreAgain && strAnswerTips == "😞"){
            if(selectedWord.isEmpty){
                selectedWord = questionStringArray.randomElement() ?? ""
            }
        }else{
            selectedWord = questionStringArray.randomElement() ?? ""
        }
        
        selectedWordAnswer = selectedWord.pinyinS
        
        answerDateArray = []
        answerDateArray.append(selectedWordAnswer)
        answerDateArray.append("".getRandomPinyinS)
        answerDateArray.append("".getRandomPinyinS)
        answerDateArray.append("".getRandomPinyinS)
        answerDateArray.shuffle()
    }
    
    //选择的答案数据，重新做一组数据  专门做音符
    func answerArrayNewRandom_专门做音符() {
        if(isOneMoreAgain && strAnswerTips == "😞"){
            if(selectedWord.isEmpty){
                selectedWord = questionStringArray.randomElement() ?? ""
            }
        }else{
            var _next = questionStringArray.randomElement() ?? ""
            if(questionStringArray.count>1){
                while(selectedWord == _next){
                    _next = questionStringArray.randomElement() ?? ""
                }
            }
            selectedWord = _next
        }
        
        selectedWordAnswer = selectedWord.pinyinS
        
        let getPinyinSArray = selectedWord.getPinyinSArray
        
        answerDateArray = []
        getPinyinSArray.forEach { str in
            answerDateArray.append(str)
        }
    }
    
    var initView: some View {
        // 縦並にViewを並べるレイアウト
        VStack(alignment: .center, spacing: 0.0){
            
            NavigationLink(destination:
                            ViewPinYinItemSetting()) {
                    Text("测试的 （汉字和拼音） 的设置")
                    .padding( 30)
                }
            if(envModel.isPwOk){
                
//                Button(action: {
//                    self.showSettingView.toggle()
//                }, label: {
//                    Text("设置")
//                })
                NavigationLink(destination:
                    ViewChinesePinYinSetting()) {
                        Text("设置")
                        .padding( 30)
                    }
            }else{
                Button(action: {
                    self.showPwView.toggle()
                }, label: {
                    Text("密码")
                        .padding( 30)
                })
            }
            
            Divider()   // 仕切り線の挿入
            
            Button(action: {
                answerArrayNewRandom()
                
                MyUtility.text2speech(selectedWord + " 。。。 ，" + selectedWordAnswer)
                
                bInit = false
            }, label: {
                Text("开始")
                    .font(.system(size: 50))
                
            })
        }
    }
    
    var body: some View {
        BaseView(content:
                    VStack {
            
            if(bInit){
                initView
            }else{
                
                Text(String(intScore) + "点")
                    .font(.system(size: 50))
                    .padding( 30)
                
                Button(action: {
                    MyUtility.text2speech(" 。" + selectedWord)
                }, label: {
                    Text("📢")
                        .font(.system(size: 50))
                    
                })
                
                Text(selectedWord)
                    .font(.system(size: 100))
                    .padding( 30)
                
                //回答答案栏
                HStack{
                    ForEach(answerDateArray, id: \.self) { str in
                        eachAnswerShowView(str: str)
                    }
                    if(is专门做音符){
                        Button {
                            var _t = ""
                            if(answerDateArray.count>0){
                                for i in 1..<answerDateArray.count  {
                                    _t.append("。"+answerDateArray[i])
                                }
                            }
                            MyUtility.text2speech(_t)
                        } label: {
                            Text("📢")
                                .font(.system(size: 50))
                        }

                    }
                }
                //回答答案栏
            }
            
            
            
        }
                 
        )
        .onAppear{
            ///读取 Realm 的数据，把数据放到本view中
            loadRealmDb()
        }
        .sheet(isPresented: $showPwView, onDismiss: {
            //弹出的视图，退出后，做相对应的动作
            //envModel.isPwOk = true
        }){
            ViewPsCalculator(showingSheet: $showPwView)
        }
    }
    
    //每一个答案选择栏
    func eachAnswerShowView(str : String) -> some View {
        
        ZStack {
            Button(action: {
                self.showModal.toggle()
                if(str == selectedWordAnswer){
                    strAnswerTips = "🤗"
                    intScore += 1
                    
                    //scoreViewChinesePinYin = intScore
                    if(scoreViewChinesePinYin < intScore){
                        scoreViewChinesePinYin = intScore
                    }
                }else{
                    strAnswerTips = "😞"
                    intScore -= Int(pointsMistakes)
                    if(intScore < 0){
                        intScore = 0
                    }
                    if(is针对错误追加测试 == true){
                        questionStringArray.append(selectedWord)
                    }
                }
            }, label: {
                Text(str)
                    .font(.system(size: 50))
                    .padding( 30)
            })
            .sheet(isPresented: $showModal, onDismiss: {
                //弹出的视图，退出后，做相对应的动作
                answerArrayNewRandom()
                
                MyUtility.text2speech(selectedWord + " 。。。 ，" + selectedWordAnswer)
                self.isSheetDismissed = true
            }) {
                // 这里可以放弹出的视图
                Text(String(intScore) + "点")
                    .font(.system(size: 50))
                    .padding( 30)
                
                Button(action: {
                    MyUtility.text2speech(selectedWord + " 。。。 ，" + selectedWordAnswer)
                }, label: {
                    Text("📢")
                        .font(.system(size: 50))
                    
                })
                
                Text(selectedWord)
                    .font(.system(size: 100))
                    .padding( 30)
                
                Text(strAnswerTips)
                    .font(.system(size: 50))
                    .padding( 30)
                
                Text(selectedWordAnswer)
                    .font(.system(size: 50))
                    .padding( 30)
            }
        }
    }
}

//struct ViewChinesePinYin_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewChinesePinYin()
//    }
//}
