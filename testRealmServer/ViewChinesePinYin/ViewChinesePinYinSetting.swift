//
//  ViewChinesePinYinSetting.swift
//  ChildStudies
//
//  Created by chenzhizs on 2023/11/20.
//

import SwiftUI

struct ViewChinesePinYinSetting: View {
    
    
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
    
    var body: some View {
        Form {
            Group{
                
                Text("错了扣多少分：\(Int(self.pointsMistakes))")
                Slider(value: $pointsMistakes , in: 1.0...10.0, step: 1.0, onEditingChanged: {_ in
                    print("错了扣多少分：\(Int(self.pointsMistakes))")
                })
            }
            
            Group{
                
                Toggle("错了再做一次", isOn: $isOneMoreAgain)
                
                Toggle("是否专门做音符", isOn: $is专门做音符)
                
                Toggle("是否针对错误追加测试", isOn: $is针对错误追加测试)
                
            }
        }
    }
}

//struct ViewChinesePinYinSetting_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewChinesePinYinSetting()
//    }
//}
