//
//  NSColor+Mapping.swift
//  WLED Switch
//
//  Created by Roman Gille on 30.01.21.
//

import Foundation
import AppKit

extension NSColor {

    convenience init(array: [CGFloat]) {
        self.init(red: array[0], green: array[1], blue: array[2], alpha: 1)
    }

    var asArray: [CGFloat] {
        [self.redComponent, self.greenComponent, self.blueComponent]
    }
}
