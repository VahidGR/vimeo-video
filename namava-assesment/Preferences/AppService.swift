//
//  AppService.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import Foundation

protocol HasPreferencesService {
    var preferencesService: PreferencesService { get }
}

struct AppServices: HasPreferencesService {
    let preferencesService: PreferencesService
}
