//
//  Knight.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

final class Knight: Piece {

    var color: Color
    var moved: Bool
    
    required init(color: Color, moved: Bool) {
        self.color = color
        self.moved = moved
    }
    
    func possibleMoves(from: Position, board: Board) -> [Position] {
        var possibleMoves = [Position]()

        let topLeft = from.by(movingX: -1, movingY: 2)
        if topLeft.containedIn(board: board) && !board.has(color: color, at: topLeft) {
            possibleMoves.append(topLeft)
        }
        
        let topRight = from.by(movingX: 1, movingY: 2)
        if topRight.containedIn(board: board) && !board.has(color: color, at: topRight) {
            possibleMoves.append(topRight)
        }
        
        let middleRightTop = from.by(movingX: 2, movingY: -1)
        if middleRightTop.containedIn(board: board) && !board.has(color: color, at: middleRightTop) {
            possibleMoves.append(middleRightTop)
        }
        
        let middleRightBottom = from.by(movingX: 2, movingY: 1)
        if middleRightBottom.containedIn(board: board) && !board.has(color: color, at: middleRightBottom) {
            possibleMoves.append(middleRightBottom)
        }
        
        let bottomRight = from.by(movingX: 1, movingY: -2)
        if bottomRight.containedIn(board: board) && !board.has(color: color, at: bottomRight) {
            possibleMoves.append(bottomRight)
        }
        
        let bottomLeft = from.by(movingX: -1, movingY: -2)
        if bottomLeft.containedIn(board: board) && !board.has(color: color, at: bottomLeft) {
            possibleMoves.append(bottomLeft)
        }
        
        let middleLeftTop = from.by(movingX: -2, movingY: -1)
        if middleLeftTop.containedIn(board: board) && !board.has(color: color, at: middleLeftTop) {
            possibleMoves.append(middleLeftTop)
        }
        
        let middleLeftBottom = from.by(movingX: -2, movingY: 1)
        if middleLeftBottom.containedIn(board: board) && !board.has(color: color, at: middleLeftBottom) {
            possibleMoves.append(middleLeftBottom)
        }
        
        return possibleMoves
    }
    
}
