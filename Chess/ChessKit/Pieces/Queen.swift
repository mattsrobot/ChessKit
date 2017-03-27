//
//  Queen.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

final class Queen: Piece {

    var color: Color
    var moved: Bool
    
    required init(color: Color, moved: Bool) {
        self.color = color
        self.moved = moved
    }
    
    func possibleMoves(from: Position, board: Board) -> [Position] {
        var possibleMoves = [Position]()
        possibleMoves.append(contentsOf: Bishop.horizontalAndVerticalMoves(from: from, board: board, color: color))
        possibleMoves.append(contentsOf: Castle.horizontalAndVerticalMoves(from: from, board: board, color: color))
        return possibleMoves
    }
    
}
