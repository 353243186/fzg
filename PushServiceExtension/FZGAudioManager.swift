//
//  FZGAudioManager.swift
//  PushServiceExtension
//
//  Created by JohnLee on 2018/9/30.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import AVFoundation
//成功block
typealias PlayCompletedHander = (_ completed: Bool) ->Void

class FZGAudioManager: NSObject, AVAudioPlayerDelegate {
    /// 单例管理语音播报 比较适用于多种类型语音播报管理
    public static let shared = FZGAudioManager()
    var player = AVAudioPlayer()
    var notiStrings = [String]()
    //hander
    private var playCompletedHander: PlayCompletedHander?
//    private override init() {
//        super.init()
//        player.volume = 1.0
//    }
    
    func playWithIsBroadCast(_ isBroadCast: String, amt: Double,  whenCompleted: @escaping PlayCompletedHander)  {
        var notiStrings = [String]()
        if isBroadCast == "1"{
            notiStrings.append("rs_pay")
        }else if isBroadCast == "2"{
            notiStrings.append("rs_refund")
        }
        
        let dfdf = parseAmt(amt)
        notiStrings.append(contentsOf: dfdf)
        notiStrings.append("元")
        guard notiStrings.count > 0 else{
            return
        }
        self.playCompletedHander = whenCompleted
        self.notiStrings = notiStrings
        play()
    }
    
    private func parseAmt(_ amt: Double) -> [String] {
//        let amtString = String.init(format: "%.2f", amt)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.init(rawValue: UInt(CFNumberFormatterRoundingMode.roundHalfDown.rawValue))!
        let amtString = formatter.string(from: NSNumber.init(value: amt))
        guard let amtStrings = amtString?.map({String($0)}) else {return [""]}
        
        return amtStrings
    }
    
    private func play() {
        let sourcesName = notiStrings[0]
        if let path = Bundle.main.path(forResource: sourcesName, ofType: "mp3"){
            let url = URL.init(fileURLWithPath: path)
            do {
                try player = AVAudioPlayer.init(contentsOf: url)
                player.volume = 1.0
                player.delegate = self
                self.notiStrings.removeFirst()
            } catch {
                print(error)
            }
        }
        // 播放当前资源
        self.player.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            guard self.notiStrings.count > 0 else{
                playCompletedHander?(true)
                return
            }
            play()
        }
    }
    
}
