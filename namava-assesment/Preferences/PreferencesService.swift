//
//  PreferencesService.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import RxSwift

// manage user preferences
class PreferencesService {

    // sets the onBoarded preference to true
    func setOnboarded () {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: UserPreferences.onBoarded)
    }

    // removes the onBoarded preference
    func setNotOnboarded () {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserPreferences.onBoarded)
    }

    // Returns true if the user has already onboarded, false otherwise
    func isOnboarded () -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: UserPreferences.onBoarded)
    }
}

extension PreferencesService: ReactiveCompatible {}
