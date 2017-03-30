//
//  Theme.swift
//  Chess
//
//  Created by Matthew Wilkinson on 27/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Cocoa
import ChessKit

final class Theme {

    let blackSquareColor: NSColor = .lightGray
    let whiteSquareColor: NSColor = .white
    let highlightedSquareColor: NSColor = NSColor.yellow.withAlphaComponent(0.5)
    let boarderColor: NSColor = .black

    func backgroundColor(square: Square) -> NSColor {
        switch square.color {
        case .white:
            return whiteSquareColor
        case .black:
            return blackSquareColor
        }
    }
}
