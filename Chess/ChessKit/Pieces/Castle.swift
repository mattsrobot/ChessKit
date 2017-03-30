//
//  Castle.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

public final class Castle: Piece {
    
    public var color: Color
    public var moved: Bool
    
    required public init(color: Color, moved: Bool) {
        self.color = color
        self.moved = moved
    }
    
    class func horizontalAndVerticalMoves(from: Position, board: Board, color: Color) -> [Position] {
        var possibleMoves = [Position]()
        
        let topVertical = from.by(incrementingVerticalTop: 7)
        for position in topVertical {
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
        
        let bottomVertical = from.by(incrementingVerticalBottom: 7)
        for position in bottomVertical {
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
        
        let rightHorizontal = from.by(incrementingHorizontalRight: 7)
        for position in rightHorizontal {
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
        
        let leftHorizontal = from.by(incrementingHorizontalLeft: 7)
        for position in leftHorizontal {
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
    
    public func possibleMoves(from: Position, board: Board) -> [Position] {
        return Castle.horizontalAndVerticalMoves(from: from, board: board, color: color)
    }

}
