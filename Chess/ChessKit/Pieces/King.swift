//
//  King.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

final public class King: Piece {

    public var color: Color
    public var moved: Bool
    
    required public init(color: Color, moved: Bool) {
        self.color = color
        self.moved = moved
    }
    
    func isChecked(board: Board) -> Bool {
        for enemeyPiece in board.currentPieces(color: color.opposite()) {
            if isThreatendBy(piece: enemeyPiece, board: board) {
                return true
            }
        }
        return false
    }
    
    public func possibleMoves(from: Position, board: Board) -> [Position] {
        var possibleMoves = [Position]()
        
        // Move forward
        let forward = from.by(movingY: 1)
        if forward.containedIn(board: board) && !board.has(color: color, at: forward) {
            possibleMoves.append(forward)
        }
        
        // Move left
        let left = from.by(movingX: -1)
        if left.containedIn(board: board) && !board.has(color: color, at: left) {
            possibleMoves.append(left)
        }
        
        // Move diagonal top left
        let diagonalTopLeft = from.by(movingX: -1, movingY: 1)
        if diagonalTopLeft.containedIn(board: board) && !board.has(color: color, at: diagonalTopLeft) {
            possibleMoves.append(diagonalTopLeft)
        }
        
        // Move diagonal bottom left
        let diagonalBottomLeft = from.by(movingX: -1, movingY: -1)
        if diagonalBottomLeft.containedIn(board: board) && !board.has(color: color, at: diagonalBottomLeft) {
            possibleMoves.append(diagonalBottomLeft)
        }
        
        // Move right
        let right = from.by(movingX: 1)
        if right.containedIn(board: board) && !board.has(color: color, at: right) {
            possibleMoves.append(right)
        }
        
        // Move diagonal top right
        let diagonalTopRight = from.by(movingX: 1, movingY: 1)
        if diagonalTopRight.containedIn(board: board) && !board.has(color: color, at: diagonalTopRight) {
            possibleMoves.append(diagonalTopRight)
        }
        
        // Move diagonal bottom right
        let diagonalBottomRight = from.by(movingX: 1, movingY: -1)
        if diagonalBottomRight.containedIn(board: board) && !board.has(color: color, at: diagonalBottomRight) {
            possibleMoves.append(diagonalBottomRight)
        }
        
        // Move back
        let back = from.by(movingY: -1)
        if back.containedIn(board: board) && !board.has(color: color, at: back) {
            possibleMoves.append(back)
        }

        return possibleMoves
    }
    
}
