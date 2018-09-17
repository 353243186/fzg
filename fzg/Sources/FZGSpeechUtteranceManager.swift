//
//  FZGSpeechUtteranceManager.swift
//  fzg
//
//  Created by JohnLee on 2018/9/8.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import AVFoundation

class FZGSpeechUtteranceManager: NSObject {
    /// 单例管理语音播报 比较适用于多种类型语音播报管理
    public static let shared = FZGSpeechUtteranceManager()
    
    var synthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance?
    var currentStrings = [String]()
    var voiceType = AVSpeechSynthesisVoice(language: "zh-CN")
    private override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
        } catch {
            print(error.localizedDescription)
        }
        synthesizer.delegate = self
    }
    
    /// 自定义语音播报方法
    /// 此处只举例播报一个String的情况（现在是多个）
    func speechWeather(with weather: String) {
//        if let _ = speechUtterance {
//            synthesizer.stopSpeaking(at: .immediate)
//        }
        // 将新增的包包内容放在数组末尾
        currentStrings.append(weather)
        
//        speechUtterance = AVSpeechUtterance(string: weather)
//        speechUtterance?.voice = voiceType
//        speechUtterance?.rate = 0.5
//        synthesizer.speak(speechUtterance!)
        play()
    }
    
    fileprivate func play() {
        if speechUtterance == nil && currentStrings.count > 0{
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error.localizedDescription)
            }
            speechUtterance = AVSpeechUtterance(string: currentStrings[0])
            speechUtterance?.voice = voiceType
            speechUtterance?.rate = 0.5
            print("----开始播放：\(currentStrings[0])")
            synthesizer.speak(speechUtterance!)
            
        }
    }
}

extension FZGSpeechUtteranceManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        speechUtterance = nil
        print("----播放结束：\(currentStrings.first ?? "")")
        // 移除已播放的，位于数组首位
        currentStrings.removeFirst()
        if currentStrings.count <= 0 {
            print("----关掉播放器")
            do {
                try AVAudioSession.sharedInstance().setActive(false, with: .notifyOthersOnDeactivation)
            } catch {
                print(error.localizedDescription)
            }
        }else{
            print("----继续播放")
            play()
        }
        
    }
    
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
//        <#code#>
//    }

}
