//
//  Position.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import UIKit

struct Position: Equatable {
    
    let x: Int
    let y: Int
    
    func by(movingY: Int) -> Position {
        return Position(x: x, y: y + movingY)
    }
    
    func by(movingX: Int) -> Position {
        return Position(x: x + movingX, y: y)
    }
    
    func by(movingX: Int, movingY: Int) -> Position {
        return Position(x: x + movingX, y: y + movingY)
    }
}

func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y 
}
