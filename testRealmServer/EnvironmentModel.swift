//
//  EnvironmentModel.swift
//  ChildStudies
//
//  Created by chenzhizs on 2022/08/26.
//

import SwiftUI

//环境变量
class EnvironmentModel:ObservableObject{
    
    //获取现在屏幕的状态，是竖着摆还是横着摆
    @Published var orientation:UIDeviceOrientation = UIDevice.current.orientation
    //获取屏幕的状态，宽
    @Published var screenWidth = UIScreen.main.bounds.width
    //获取屏幕的状态，高
    @Published var screenHeight = UIScreen.main.bounds.height
    
    ///字体的宽
    @Published var fontWidth = 30.0
    
    ///字体的高
    @Published var fontHeight = 30.0
    
    ///字体的距离横
    @Published var fontWidthPadding = 30.0
    
    ///字体的距离竖
    @Published var fontHeightPadding = 30.0
    
    //google 图片地址
    @Published var googlePicAddress = "https://www.google.co.jp/search?tbm=isch&q="
    
    //密码是否验证成功
    @Published var isPwOk = false
    
}
