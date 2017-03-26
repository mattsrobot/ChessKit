//
//  Castle.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

final class Castle: Piece {
    
    var color: Color
    var moved: Bool
    
    required init(color: Color, moved: Bool) {
        self.color = color
        self.moved = moved
    }
    
    func validMoves(from: Position, board: Board) -> [Position] {
        return [Position]()
    }

}
