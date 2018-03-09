//
// Created by Akito Nozaki on 3/3/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import QuartzCore

extension CAAnimationGroup {
    func animation(startFrame: Int, endFrame: Int) {
        // convert start/end frame to offset and duration
        let (startTime, duration) = timeRange(startFrame: startFrame, endFrame: endFrame)
        
        // set the offset on the base animation to shift it.
        self.animations!.first!.timeOffset = startTime
        
        // then set the CAAnimationGroup's duration to clip it to the duration.
        self.duration = duration
        
        // repeat for ever
        self.repeatCount = .infinity
    }
    
    /**
     * Converts frame to sec offset.
     */
    func timeRange(startFrame: Int, endFrame: Int) -> (startTime: CFTimeInterval, duration: CFTimeInterval) {
        let startTime = timeOf(frame: startFrame)
        return (startTime, timeOf(frame: endFrame) - timeOf(frame: startFrame))
    }
    
    func timeOf(frame: Int) -> CFTimeInterval {
        return CFTimeInterval(frame) / animationFps()
    }
    
    func animationFps() -> CFTimeInterval {
        // CAAnimation duration / # of frames to get this value. However, 30fps is pretty common so hard coding.
        return 30.0
    }
}