//
//  Reactive+AVPlayer.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import RxSwift
import AVFoundation

extension Reactive where Base: AVPlayer {
    public var status: Observable<AVPlayer.Status> {
        return self.observe(AVPlayer.Status.self, #keyPath(AVPlayer.status))
            .map { $0 ?? .unknown }
    }
}

