//
//  TimerRepeatable.swift
//  codechunks
//
//  Created by Artem Demchenko on 4/30/17.
//  Copyright © 2017 artdmk. All rights reserved.
//

import Foundation

protocol TimerRepeatable: class {
    
    var timer: Timer! {get set}
    
    func startTimer(every: TimeInterval, repeats: Bool)
    func stopTimer()
    func handlerAfterTick()
    func isTimerValid() -> Bool
}

extension TimerRepeatable {
    
    func startTimer(every: TimeInterval, repeats: Bool = true) -> Void {
        if (timer?.isValid ?? false) {
            return
        }
        let runLoop = RunLoop.current
        let newTimer = Timer.scheduledTimer(timeInterval: every, target: self, selector: Selector(("handlerAfterTick")), userInfo: nil, repeats: repeats)
        runLoop.add(newTimer, forMode: RunLoopMode.commonModes)
        timer = newTimer
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func isTimerValid() -> Bool {
        if let timer = timer, timer.isValid {
            return true
        }
        return false
    }
    
}
