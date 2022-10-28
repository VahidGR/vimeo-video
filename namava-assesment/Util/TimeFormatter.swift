//
//  TimeFormatter.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import Foundation

struct TimeFormatter {
    func getTimeFormat(off seconds: Int?) -> String? {
        guard let duration = seconds else {
            return nil
        }
        
        let (minutes, seconds) = secondsToMinutesSeconds(duration)
        return formatForTime(timeElement: minutes) + ":" + formatForTime(timeElement: seconds)
    }
    
    private func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    private func formatForTime(timeElement: Int) -> String {
        if timeElement < 10 {
            return "0" + String(timeElement)
        }
        return String(timeElement)
    }
}
