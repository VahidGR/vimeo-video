//
//  AppStep.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import RxFlow

enum AppStep: Step {
    case authenticaed(valid: Bool)
    case showDetails(video: VideoListData)
}
