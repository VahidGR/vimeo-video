//
//  DetailViewModel.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/27/22.
//

import RxFlow
import RxRelay
import RxSwift

struct DetailViewModel: Stepper {
    
    var steps = PublishRelay<Step>()
    var bag = DisposeBag()
    
    var video: VideoListData!
    
}
