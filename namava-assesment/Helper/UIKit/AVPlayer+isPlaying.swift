//
//  AVPlayer+isPlaying.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
