//
//  Settings.swift
//  WLED Switch
//
//  Created by Roman Gille on 28.01.21.
//

import Foundation

class Settings {

    let userDefaults: UserDefaults
    private static let encoder: JSONEncoder = { JSONEncoder() }()
    private static let decoder: JSONDecoder = { JSONDecoder() }()

    private static let hostKey: String = "wledStatus.host"
    private static let statesKey: String = "wledStatus.states"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var host: String? {
        get { userDefaults.string(forKey: Self.hostKey) }
        set { userDefaults.set(newValue, forKey: Self.hostKey) }
    }

    var states: Array<LEDStatus> {
        get {
            userDefaults
                .data(forKey: Self.statesKey)
                .flatMap { try? Self.decoder.decode(Array<LEDStatus>.self, from: $0) } ?? []
        }
        set {
            if let value = try? Self.encoder.encode(newValue) {
                userDefaults.set(value, forKey: Self.statesKey)
            } else {
                userDefaults.removeObject(forKey: Self.statesKey)
            }
        }
    }
}
