//
//  Queen.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

public final class Queen: Piece {

    public var color: Color
    public var moved: Bool
    
    required public init(color: Color, moved: Bool) {
        self.color = color
        self.moved = moved
    }
    
    public func possibleMoves(from: Position, board: Board) -> [Position] {
        var possibleMoves = [Position]()
        possibleMoves.append(contentsOf: Bishop.horizontalAndVerticalMoves(from: from, board: board, color: color))
        possibleMoves.append(contentsOf: Castle.horizontalAndVerticalMoves(from: from, board: board, color: color))
        return possibleMoves
    }
    
}
