//
//  Position.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

public struct Position: Equatable {
    
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public func by(movingY: Int) -> Position {
        return Position(x: x, y: y + movingY)
    }
    
    public func by(incrementingTopLeftDiagonal: Int) -> [Position] {
        var positions = [Position]()
        for increment in 1...incrementingTopLeftDiagonal {
            positions.append(Position(x: x - increment, y: y - increment))
        }
        return positions
    }
    
    public func by(incrementingTopRightDiagonal: Int) -> [Position] {
        var positions = [Position]()
        for increment in 1 ... incrementingTopRightDiagonal {
            positions.append(Position(x: x + increment, y: y - increment))
        }
        return positions
    }
    
    public func by(incrementingBottomLeftDiagonal: Int) -> [Position] {
        var positions = [Position]()
        for increment in 1...incrementingBottomLeftDiagonal {
            positions.append(Position(x: x - increment, y: y + increment))
        }
        return positions
    }
    
    public func by(incrementingBottomRightDiagonal: Int) -> [Position] {
        var positions = [Position]()
        for increment in 1 ... incrementingBottomRightDiagonal {
            positions.append(Position(x: x + increment, y: y + increment))
        }
        return positions
    }
    
    public func by(incrementingHorizontalRight: Int) -> [Position] {
        var positions = [Position]()
        for increment in 1...incrementingHorizontalRight {
            positions.append(Position(x: x + increment, y: y))
        }
        return positions
    }
    
    public func by(incrementingHorizontalLeft: Int) -> [Position] {
        var positions = [Position]()
        for increment in 1...incrementingHorizontalLeft {
            positions.append(Position(x: x - increment, y: y))
        }
        return positions
    }
    
    public func by(incrementingVerticalTop: Int) -> [Position] {
        var positions = [Position]()
        for increment in 1...incrementingVerticalTop {
            positions.append(Position(x: x, y: y + increment))
        }
        return positions
    }
    
    public func by(incrementingVerticalBottom: Int) -> [Position] {
        var positions = [Position]()
        for increment in 1...incrementingVerticalBottom {
            positions.append(Position(x: x, y: y - increment))
        }
        return positions
    }
    
    public func by(movingX: Int) -> Position {
        return Position(x: x + movingX, y: y)
    }
    
    public func by(movingX: Int, movingY: Int) -> Position {
        return Position(x: x + movingX, y: y + movingY)
    }
    
    public func containedIn(board: Board) -> Bool {
        return x < board.columns && y < board.rows && x >= 0 && y >= 0
    }
}

public func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y 
}
