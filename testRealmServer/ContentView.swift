//
//  ContentView.swift
//  testRealmServer
//
//  Created by chenzhizs on 2023/12/15.
//

import SwiftUI

struct ContentView: View {
    
    //对应环境变量
    @EnvironmentObject var envModel: EnvironmentModel
    
    var body: some View {
        BaseView(content:
                    NavigationView{
            
            ScrollView{
                VStack {
                    Group{
                        //ViewChinesePinYin
                        NavigationLink(destination:
                                        ViewChinesePinYin()) {
                            Text("看字选拼音")
                        }
                    }
                }
            }
        }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)  //隐藏Bar
            .frame(width: envModel.screenWidth, height: envModel.screenHeight)
            .onAppear {
                envModel.isPwOk = false
            }
            .onDisappear{
                envModel.isPwOk = false
            }
                 )
    }
}

//#Preview {
//    ContentView()
//}
