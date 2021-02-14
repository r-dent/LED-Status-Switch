//
//  LEDStatusViewModel.swift
//  WLED Switch
//
//  Created by Roman Gille on 31.01.21.
//

import Foundation
import SwiftUI
import DynamicColor

class StatusEditViewModel: ObservableObject, Hashable {
    
    var title: String {
        didSet { updateStatus() }
    }
    var color: DynamicColor {
        didSet { updateStatus() }
    }
    var status: LEDStatus {
        _status.wrappedValue
    }

    private let _status: Binding<LEDStatus>

    init(_ status: Binding<LEDStatus>) {
        self._status = status
        title = status.wrappedValue.title
        color = status.wrappedValue.color
    }

    private func updateStatus() {
        _status.wrappedValue = LEDStatus(title: title, color: color)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title.hash)
    }

    static func == (lhs: StatusEditViewModel, rhs: StatusEditViewModel) -> Bool {
        lhs.title == rhs.title
    }
}
