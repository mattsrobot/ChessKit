//
//  Bishop.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

final class Bishop: Piece {

    var color: Color
    var moved: Bool
    
    required init(color: Color, moved: Bool) {
        self.color = color
        self.moved = moved
    }
    
    class func horizontalAndVerticalMoves(from: Position, board: Board, color: Color) -> [Position] {
        var possibleMoves = [Position]()
        
        // Top Left
        let topLeftDiagonal = from.by(incrementingTopLeftDiagonal: 7)
        for position in topLeftDiagonal {
            if position.containedIn(board: board) {
                if board.has(color: color, at: position) {
                    break
                }
                if board.has(color: color.opposite(), at: position) {
                    possibleMoves.append(position)
                    break
                }
                possibleMoves.append(position)
            }
        }
        
        let topRightDiagonal = from.by(incrementingTopRightDiagonal: 7)
        for position in topRightDiagonal {
            if position.containedIn(board: board) {
                if board.has(color: color, at: position) {
                    break
                }
                if board.has(color: color.opposite(), at: position) {
                    possibleMoves.append(position)
                    break
                }
                possibleMoves.append(position)
            }
        }
        
        let bottomLeftDiagonal = from.by(incrementingBottomLeftDiagonal: 7)
        for position in bottomLeftDiagonal {
            if position.containedIn(board: board) {
                if board.has(color: color, at: position) {
                    break
                }
                if board.has(color: color.opposite(), at: position) {
                    possibleMoves.append(position)
                    break
                }
                possibleMoves.append(position)
            }
        }
        
        let bottomRightDiagonal = from.by(incrementingBottomRightDiagonal: 7)
        for position in bottomRightDiagonal {
            if position.containedIn(board: board) {
                if board.has(color: color, at: position) {
                    break
                }
                if board.has(color: color.opposite(), at: position) {
                    possibleMoves.append(position)
                    break
                }
                possibleMoves.append(position)
            }
        }
        
        return possibleMoves
    }
    
    func possibleMoves(from: Position, board: Board) -> [Position] {
       return Bishop.horizontalAndVerticalMoves(from: from, board: board, color: color)
    }
    
}
