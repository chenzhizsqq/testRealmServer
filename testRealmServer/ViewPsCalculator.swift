//
//  ViewPsCount.swift
//  ChildStudies
//
//  Created by chenzhizs on 2022/12/02.
//

import SwiftUI

struct ViewPsCalculator: View {
    
    //对应环境变量
    @EnvironmentObject var envModel: EnvironmentModel
    
    let textSize = 100.0
    
    @State var strAnswer = ""
    @State var bAnswerRight = false
    @State var bAfterAnswer = false
    @State var nTestFront = Int.random(in: 5 ... 9)
    @State var nTestBack = Int.random(in: 5 ... 9)
    @Binding var showingSheet:Bool
    
    fileprivate func numberFunc(_ num : String) -> Button<Text> {
        return Button(action: {
            if(bAfterAnswer){
                
            }else{
                if(strAnswer.count == 0 && num == "0"){
                }else{
                    strAnswer.append(num)
                }
                if(strAnswer.count>1){
                    bAfterAnswer = true
                    if(nTestFront * nTestBack == Int(strAnswer)){
                        bAnswerRight = true
                    }else{
                        bAnswerRight = false
                    }
                }
            }
        }, label: {
            Text(String(num))
                .font(.system(size: textSize))
            
        })
    }
    
    var body: some View {
        HStack(alignment: .top){
            VStack(alignment: .center, spacing: 0.0) {
                
                HStack(alignment: .center, spacing: textSize) {
                    //题目
                    Text("\(nTestFront) ✖️ \(nTestBack) =")
                        .font(.system(size: textSize))
                    
                    //答案
                    Text(strAnswer)
                        .font(.system(size: textSize))
                        .frame(width: 150)
                }
                
                //选择的内容
                HStack(alignment: .center, spacing: textSize) {
                    numberFunc("7")
                    numberFunc("8")
                    numberFunc("9")
                }
                HStack(alignment: .center, spacing: textSize) {
                    
                    numberFunc("4")
                    numberFunc("5")
                    numberFunc("6")
                }
                HStack(alignment: .center, spacing: textSize) {
                    
                    numberFunc("1")
                    numberFunc("2")
                    numberFunc("3")
                }
                HStack(alignment: .center, spacing: textSize) {
                    numberFunc("0")
                }
                
                    
                
                //提示是否答对
                if(bAfterAnswer){
                
                    Button(action: {
                        bAfterAnswer = false
                        strAnswer = ""
                        if(bAnswerRight){
                            envModel.isPwOk = true
                            self.showingSheet.toggle()
                        }else{
                            nTestFront = Int.random(in: 5 ... 9)
                            nTestBack = Int.random(in: 5 ... 9)
                        }
                    }, label: {
                        Text(bAnswerRight == true ? "答对了":"答错了")
                            .font(.system(size: textSize))
                
                    })
                }else{
                    
                    Button(action: {
                    }, label: {
                        Text(" ")
                            .font(.system(size: textSize))
                
                    })
                }
            }
        }
        
    }
}

