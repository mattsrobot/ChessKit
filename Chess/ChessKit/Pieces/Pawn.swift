//
//  Pawn.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

final class Pawn: Piece {
    
    var color: Color
    var moved: Bool
    
    required init(color: Color, moved: Bool) {
        self.color = color
        self.moved = moved
    }
    
    func possibleMoves(from: Position, board: Board) -> [Position] {
        
        func moves(direction: Int) -> [Position] {
            
            var possibleMoves = [Position]()

            // Move forward
            let forward = from.by(movingY: 1 * direction)
            if !board.hasPiece(at: forward) {
                possibleMoves.append(forward)
            }
            
            // Double Move
            if !moved {
                let doubleForward = from.by(movingY: 2 * direction)
                if !board.hasPiece(at: doubleForward) {
                    possibleMoves.append(doubleForward)
                }
            }
            
            // Take left
            if from.x > 0 {
                let takeLeft = from.by(movingX: -1, movingY: 1 * direction)
                if let piece = board.piece(at: takeLeft) , piece.color != color {
                    possibleMoves.append(takeLeft)
                }
            }
            
            // Take Right
            if from.x < board.columns - 1 {
                let takeRight = from.by(movingX: 1, movingY: 1 * direction)
                if let piece = board.piece(at: takeRight) , piece.color != color {
                    possibleMoves.append(takeRight)
                }
            }
            
            return possibleMoves
        }
        
        switch color {
        case .black where from.y + 1 < board.rows - 1:
            // Black moves down
            return moves(direction: 1)
        case .white where from.y > 0:
            // White moves up
            return moves(direction: -1)
        default:
            return [Position]()
        }
    }
    
    func validMoves(from: Position, board: Board) -> [Position] {
        let valid = possibleMoves(from: from, board: board)
            .filter { move -> Bool in
                // Don't move forward if moving into Check
                let isCheck = board.isCheck(from: from, to: move)
                switch color {
                case .white where isCheck.white:
                    return false
                case .black where isCheck.black:
                    return false
                default:
                    return true
                }
            }
        return valid
    }
    
}
