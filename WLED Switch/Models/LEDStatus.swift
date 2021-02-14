//
//  LEDStatus.swift
//  WLED Switch
//
//  Created by Roman Gille on 25.01.21.
//

import Foundation
import SwiftUI

struct LEDStatus: Identifiable {

    let id: Int
    var title: String
    var color: NSColor

    init(title: String, color: NSColor) {
        self.id = title.hash
        self.title = title
        self.color = color
    }
}

extension LEDStatus {

    static let free = LEDStatus(title: "Free", color: .green)
    static let headphones = LEDStatus(title: "Headphones", color: .blue)

    static let lowAttentionConversation = LEDStatus(
        title: "Low attention call",
        color: NSColor(red: 255/255, green: 200/255, blue: 0/255, alpha: 1)
    )
    
    static let conversation = LEDStatus(title: "In conversation", color: .red)

    static let all: [LEDStatus] = [.free, .headphones, .lowAttentionConversation, .conversation]
}

extension LEDStatus: Codable {

    enum Keys: CodingKey {
        case id, title, color
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        let colorComponents = try container.decode(Array<CGFloat>.self, forKey: .color)
        self.color = NSColor(array: colorComponents)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        let colorComponents: [CGFloat] = color.asArray
        try container.encode(colorComponents, forKey: .color)
    }
}


