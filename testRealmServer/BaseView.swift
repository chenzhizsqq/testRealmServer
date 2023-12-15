//
//  BaseView.swift
//  ChildStudies
//
//  Created by chenzhizs on 2022/08/26.
//

import SwiftUI

//view 的父类
struct BaseView<Content: View>: View {
    let content: Content
    
    //对应环境变量
    @EnvironmentObject var envModel: EnvironmentModel
    
    //ios端的画面长度、高度检查
    fileprivate func changeSize() {
        self.envModel.orientation = UIDevice.current.orientation
        let x1 = UIScreen.main.bounds.height
        let x2 = UIScreen.main.bounds.width
        if self.envModel.orientation.isPortrait {
            self.envModel.screenWidth = min(x1, x2)
            self.envModel.screenHeight = max(x1, x2)
        }else{
            self.envModel.screenWidth = max(x1, x2)
            self.envModel.screenHeight = min(x1, x2)
        }
        
        self.envModel.fontWidth = self.envModel.screenWidth/20
        self.envModel.fontHeight = self.envModel.screenHeight/20
        self.envModel.fontWidthPadding = self.envModel.screenWidth/30
        self.envModel.fontHeightPadding = self.envModel.screenHeight/80
        
        print("self.envModel.screenWidth \(self.envModel.screenWidth)")
        print("self.envModel.screenHeight \(self.envModel.screenHeight)")
        print("self.envModel.fontWidth  \(self.envModel.fontWidth )")
        print("self.envModel.fontHeight  \(self.envModel.fontHeight )")
        print("self.envModel.fontWidthPadding  \(self.envModel.fontWidthPadding )")
        print("self.envModel.fontHeightPadding  \(self.envModel.fontHeightPadding )")
    }
    
    func iosViewSizeCheck() {
        
        switch UIDevice.current.orientation {
        case .portrait:
            print("Device is in portrait mode.")
            changeSize()
        case .portraitUpsideDown:
            print("Device is in portrait upside-down mode.")
            changeSize()
        case .landscapeLeft:
            print("Device is in landscape left mode.")
            changeSize()
        case .landscapeRight:
            print("Device is in landscape right mode.")
            changeSize()
        default:
            print("Unknown mode")
        }
        
        
    }
    
    var body : some View {
        ZStack {
            content
                .onAppear(){
                    print("BaseView onAppear")
                    //添加对图像竖横放的监控
                    NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                        iosViewSizeCheck()
                    }
                    iosViewSizeCheck()
                }
                .onReceive(NotificationCenter.Publisher(center: .default, name: UIDevice.orientationDidChangeNotification)) { _ in
                    print("BaseView onReceive")
                    iosViewSizeCheck()
                }
                .onDisappear {
                    //取消对图像竖横放的监控
                    NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
                }
        }.onDisappear{
            //声音停止
            MyUtility.synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

