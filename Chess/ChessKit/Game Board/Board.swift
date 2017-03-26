//
//  Board.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError

enum Color {
    case white
    case black
}

final class Square {
    let color:Color
    var piece: Piece?
    init(color: Color, piece: Piece?) {
        self.color = color
        self.piece = piece
    }
}

final class Board {

    let rows: Int = 8, columns: Int = 8
    var grid: [Square]
    
    let selectedPiece = MutableProperty<Piece?>(nil)
    let validMoves = MutableProperty<[Position]?>(nil)
    let boardChanges = MutableProperty<ChangeSet?>(nil)
    
    init() {
        self.grid = [Square](repeating: Square(color: .white, piece: nil), count: rows * columns)
        for column in 0...columns-1 {
            for row in 0...rows-1 {
                let square:Square
                if column % 2 == 0 {
                    square = Square(color: row % 2 == 0 ? .white : .black, piece: nil)
                } else {
                    square = Square(color: row % 2 == 0 ? .black : .white, piece: nil)
                }
                self[column, row] = square
            }
        }
        selectedPiece.signal.observeValues { selectedPiece in
            if let selectedPiece = selectedPiece , let selectedPosition = self.position(of: selectedPiece)  {
                self.validMoves.value = selectedPiece.validMoves(from: selectedPosition, board: self)
            } else {
                self.validMoves.value = nil
            }
        }
    }
    
    func tap(position tappedPosition: Position) {
        // a. selecting a piece
        // b. taking a piece
        // c. castling
        // d. unselecting
        // e. invalid move
        // f. moving a piece
        if let tappedPiece = piece(at: tappedPosition) {
            if let selectedPiece = selectedPiece.value {
                if selectedPiece === tappedPiece {
                    // d. unselecting
                    self.selectedPiece.value = nil
                } else if selectedPiece.color == tappedPiece.color {
                    // a. selecting a piece
                    self.selectedPiece.value = tappedPiece
                } else {
                    if let from = position(of: selectedPiece),
                        let to = position(of: tappedPiece) {
                        if selectedPiece.canMove(from: from, to: to, board: self) {
                            let changeSet = ChangeSet(movements: [(from: from, to: to)])
                            movePieces(changeSet: changeSet)
                        } else {
                            // e. invalid move
                            //showInvalidMove()
                        }
                    }
                }
            } else {
                 // a. selecting a piece
                selectedPiece.value = tappedPiece
            }
        } else {
            if let selectedPiece = selectedPiece.value,
                let from = position(of: selectedPiece) {
                if selectedPiece.canMove(from: from, to: tappedPosition, board: self) {
                    // a. moving a piece
                    let changeSet = ChangeSet(movements: [(from: from, to: tappedPosition)])
                    movePieces(changeSet: changeSet)
                } else {
                    // b. invalid move
                    //showInvalidMove()
                }
            } else {
                // b. invalid move
                //showInvalidMove()
            }
        }
    }
    
    func isCheckMate(from: Position, to: Position) -> Bool {
        return false
    }
    
    func isDraw(from: Position, to: Position) -> Bool {
        return false
    }
    
    func isCheck(from: Position, to: Position) -> (white: Bool, black: Bool) {
        return (white: false, black: false)
    }
    
    func indexIsValid(column: Int, row: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    func piece(at: Position) -> Piece? {
        return self[at.x, at.y].piece
    }
    
    func hasPiece(at: Position) -> Bool {
        return self[at.x, at.y].piece != nil
    }
    
    func position(of: Piece) -> Position? {
        for column in 0...columns-1 {
            for row in 0...rows-1 {
                if let piece = self[column, row].piece {
                    if piece === of {
                        return Position(x: column, y: row)
                    }
                }
            }
        }
        return nil
    }
    
    subscript(column: Int, row: Int) -> Square {
        get { return grid[(row * columns) + column] }
        set { grid[(row * columns) + column] = newValue }
    }
    
    func initializePieces() {
        // Pawns
        for column in 0...columns-1 {
            self[column, 1].piece = Pawn(color: .black, moved: false)
            self[column, 6].piece = Pawn(color: .white, moved: false)
        }
        
        // Kings
        self[4,0].piece = King(color: .black, moved: false)
        self[4,7].piece = King(color: .white, moved: false)
        
        // Queens
        self[3,0].piece = Queen(color: .black, moved: false)
        self[3,7].piece = Queen(color: .white, moved: false)
        
        // Castles
        self[0,0].piece = Castle(color: .black, moved: false)
        self[7,0].piece = Castle(color: .black, moved: false)
        self[0,7].piece = Castle(color: .white, moved: false)
        self[7,7].piece = Castle(color: .white, moved: false)
        
        // Knights
        self[1,0].piece = Knight(color: .black, moved: false)
        self[6,0].piece = Knight(color: .black, moved: false)
        self[1,7].piece = Knight(color: .white, moved: false)
        self[6,7].piece = Knight(color: .white, moved: false)
        
        // Bishops
        self[2,0].piece = Bishop(color: .black, moved: false)
        self[5,0].piece = Bishop(color: .black, moved: false)
        self[2,7].piece = Bishop(color: .white, moved: false)
        self[5,7].piece = Bishop(color: .white, moved: false)
        
    }
    
    func movePieces(changeSet: ChangeSet) {
        for movement in changeSet.movements {
            if let fromPiece = piece(at: movement.from) {
                fromPiece.moved = true
                self[movement.from.x, movement.from.y].piece = nil
                self[movement.to.x, movement.to.y].piece = fromPiece
            }
        }
        boardChanges.value = changeSet
        selectedPiece.value = nil
    }
    
}
