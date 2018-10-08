//
//  FZGSpeechUtteranceManager.swift
//  fzg
//
//  Created by JohnLee on 2018/9/8.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import AVFoundation

//成功block
typealias CompletedHander = (_ completed: Bool) ->Void

class FZGSpeechUtteranceManager: NSObject {
    /// 单例管理语音播报 比较适用于多种类型语音播报管理
    public static let shared = FZGSpeechUtteranceManager()
    
    var synthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance?
    var currentStrings = [String]()
    var voiceType = AVSpeechSynthesisVoice(language: "zh-CN")
    //失败hander
    private var completedHander: CompletedHander?
    
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
    func speechWeather(with weather: String, whenCompleted: @escaping CompletedHander) {
        self.completedHander = whenCompleted
        if let _ = speechUtterance {
            synthesizer.stopSpeaking(at: .immediate)
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        speechUtterance = AVSpeechUtterance(string: weather)
        speechUtterance?.voice = voiceType
        speechUtterance?.rate = 0.5
        synthesizer.speak(speechUtterance!)
    }
}

extension FZGSpeechUtteranceManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speechUtterance = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false, with: .notifyOthersOnDeactivation)
            completedHander?(true)
        } catch {
            print(error.localizedDescription)
        }
    }
}
