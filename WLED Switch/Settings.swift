//
//  Settings.swift
//  WLED Switch
//
//  Created by Roman Gille on 28.01.21.
//

import Foundation

class Settings {

    private let userDefaults: UserDefaults = .standard

    private static let hostKey: String = "wledStatus.host"

    var host: String? {
        get { userDefaults.string(forKey: Self.hostKey) }
        set { userDefaults.set(newValue, forKey: Self.hostKey) }
    }
}
