//
//  Reactive+PreferencesService.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import RxSwift

extension Reactive where Base: PreferencesService {
    var isOnboarded: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, UserPreferences.onBoarded)
            .map { $0 ?? false }
    }
}
