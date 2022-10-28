//
//  AppStepper.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import RxSwift
import RxFlow
import RxRelay

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let appServices: AppServices
    private let bag = DisposeBag()

    init(withServices services: AppServices) {
        self.appServices = services
    }
    
    // emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
    func readyToEmitSteps() {
        appServices
            .preferencesService.rx
            .isOnboarded
            .map { AppStep.authenticaed(valid: $0) }
            .bind(to: steps)
            .disposed(by: bag)
    }
}
