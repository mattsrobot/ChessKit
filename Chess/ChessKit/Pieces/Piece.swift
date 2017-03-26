//
//  Piece.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

protocol Piece: class {
    
    var color: Color { get }
    var moved: Bool { get set }
    
    func move(from: Position, to: Position, board: Board)
    
    func canMove(from: Position, to: Position, board: Board) -> Bool
    
    func validMoves(from: Position, board: Board) -> [Position]
    
    init(color: Color, moved: Bool)
    
}

extension Piece {
    
    func canMove(from: Position, to: Position, board: Board) -> Bool {
        return validMoves(from: from, board: board).filter { position -> Bool in
            position == to
        }.count == 1
    }
    
}
