//
//  LEDStatus.swift
//  WLED Switch
//
//  Created by Roman Gille on 25.01.21.
//

import Foundation
import SwiftUI

struct LEDStatus: Identifiable {

    var id: Int
    let title: String
    let color: NSColor
}

extension LEDStatus {

    static let free = LEDStatus(id: 0, title: "Free", color: .green)
    static let headphones = LEDStatus(id: 1, title: "Headphones", color: .blue)

    static let lowAttentionConversation = LEDStatus(
        id: 2,
        title: "Low attention call",
        color: NSColor(red: 255/255, green: 200/255, blue: 0/255, alpha: 1)
    )
    
    static let conversation = LEDStatus(id: 3, title: "In conversation", color: .red)

    static let all: [LEDStatus] = [.free, .headphones, .lowAttentionConversation, .conversation]
}


