//
//  CaptchaButton.swift
//  CashMore
//
//  Created by Tim on 2023/6/2.
//

import UIKit

public class CaptchaButton: UIButton {
    var time = 60
    var resendTitle = ""
    var becomeDeathTime: Date!
    var becomeActiveTime: Date!
    var codeTimer: DispatchSourceTimer!
    func addNotification(isAdd:Bool) {
        if isAdd {
            NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)
            
        } else {
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
    
    @objc func becomeActive() {
        becomeActiveTime = Date()
        if becomeDeathTime != nil {
            let difference:Int = Int(becomeActiveTime.timeIntervalSince(becomeDeathTime))
            time = time - difference
        }
    }
    
    @objc func becomeDeath() {
        becomeDeathTime = Date()
    }
    
    func codeCountdown(isCodeTimer:Bool) {
        if isCodeTimer {
            addNotification(isAdd: true)
            isEnabled = false
            codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
            codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
            codeTimer.setEventHandler { [self] in
                time = time - 1
                if time < 0 {
                    codeTimer.cancel()
                    DispatchQueue.main.async { [weak self] in
                        self?.isEnabled = true
                        self?.setTitle(self?.resendTitle ?? "" , for: .normal)
                        self?.time = 60
                        self?.addNotification(isAdd: false)
                    }
                    return
                }
                
                DispatchQueue.main.async {[unowned self] in
                    self.setTitle("\(self.time)s", for: .normal)
                }
            }
            
            if #available(iOS 10.0, *) {
                codeTimer.activate()
            } else {
                codeTimer.resume()
            }
        } else {
            if codeTimer != nil {
                codeTimer.cancel()
                addNotification(isAdd: false)
                time = 60
                self.isEnabled = true
                self.setTitle(resendTitle, for: .normal)
            }
        }
    }
}
