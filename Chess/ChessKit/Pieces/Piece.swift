//
//  Piece.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

public protocol Piece: class {
    
    var color: Color { get }
    var moved: Bool { get set }
        
    func canMove(from: Position, to: Position, board: Board) -> Bool
    func possibleMoves(from: Position, board: Board) -> [Position]
    func validMoves(from: Position, board: Board, check: Bool) -> [Position]
    init(color: Color, moved: Bool)
        
}

extension Piece {
    
    public func canMove(from: Position, to: Position, board: Board) -> Bool {
        return validMoves(from: from, board: board, check: true).filter { $0 == to }.count >= 1
    }
    
    func isThreatendBy(piece: Piece, board: Board) -> Bool {
        guard let ourPosition = board.position(of: self) else {
            return false
        }
        return piece.validMoves(board: board, check: false).filter { $0 == ourPosition }.count >= 1
    }
    
    func validMoves(board: Board, check: Bool) -> [Position] {
        return validMoves(from: board.position(of: self)!, board: board, check: check)
    }
    
    public func validMoves(from: Position, board: Board, check: Bool) -> [Position] {
        let valid = possibleMoves(from: from, board: board)
            .filter { move -> Bool in
                if !check {
                    return true
                }
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
