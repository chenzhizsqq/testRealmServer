//
//  MyUtility.swift
//  ChildStudies
//
//  Created by chenzhizs on 2023/11/30.
//

import Foundation
import AVFoundation

// 公共类
public class MyUtility {
    
    //realm Version
    public static var realmVersion = 17
    
    //读取文字工具
    public static var synthesizer = AVSpeechSynthesizer()
    
    //读取文字的函数
    public static func text2speech(_ text: String,language:String = "zh-CN") {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.001
        utterance.pitchMultiplier = 1.0
        
        //声音停止
        synthesizer.stopSpeaking(at: .immediate)
        
        //声音播放
        synthesizer.speak(utterance)
    }
}
