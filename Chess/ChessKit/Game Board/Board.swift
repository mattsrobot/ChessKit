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
    func opposite() -> Color {
        switch self {
        case .white: return .black
        case .black: return .white
        }
    }
}

final class Square {
    let color:Color
    var piece: Piece?
    init(color: Color, piece: Piece?) {
        self.color = color
        self.piece = piece
    }
    func copy() -> Square {
        let copy = Square(color: color, piece: piece)
        return copy
    }
}

final class Board {

    var whiteKing:King!
    var blackKing:King!
    var grid: [Square]
    var highlightedSquares:Property<[Position]?>!
    let playerColor:Color
    let rows: Int = 8, columns: Int = 8
    let selectedPiece = MutableProperty<Piece?>(nil)
    let validMoves = MutableProperty<[Position]?>(nil)
    let boardChanges = MutableProperty<ChangeSet?>(nil)
    let checkWhite = MutableProperty(false)
    let checkBlack = MutableProperty(false)
    let drawWhite = MutableProperty(false)
    let drawBlack = MutableProperty(false)
    let whiteWins = MutableProperty(false)
    let blackWins = MutableProperty(false)
    let color = MutableProperty(Color.white)
    
    func copy() -> Board {
        // Poor copy implementation
        let board = Board(playerColor: playerColor)
        board.grid = self.grid.map { $0.copy() }
        let pieces = board.grid.flatMap { $0.piece }
        let kings = pieces.flatMap { $0 as? King}
        let whiteKing = kings.filter { $0.color == .white }.first!
        board.whiteKing = whiteKing
        let blackKing = kings.filter { $0.color == .black }.first!
        board.blackKing = blackKing
        return board
    }
    
    init(playerColor: Color) {
        self.playerColor = playerColor
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
                self.validMoves.value = selectedPiece.validMoves(from: selectedPosition, board: self, check: true)
            } else {
                self.validMoves.value = nil
            }
        }
        let validator = Signal.combineLatest(selectedPiece.signal, validMoves.signal).map { selected, validMoves -> [Position]? in
            var squaresToHighlight = validMoves
            if let selected = selected, let position = self.position(of: selected) {
                squaresToHighlight?.append(position)
            }
            return squaresToHighlight
        }
        self.highlightedSquares = Property(initial: nil, then: validator)
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
    
    func isCheckMate() -> (white: Bool, black: Bool) {
        
        let isCheckWhite = whiteKing.isChecked(board: self)
        var isCheckMateWhite = false

        if isCheckWhite {
            isCheckMateWhite = whiteKing.validMoves(board: self, check: true).count == 0
            if isCheckMateWhite {
                for pieces in currentPieces(color: .white) {
                    if pieces.validMoves(board: self, check: true).count >= 1 {
                        isCheckMateWhite = false
                        break
                    }
                }
            }
        }
        
        let isCheckBlack = blackKing.isChecked(board: self)
        var isCheckMateBlack = false
        
        if isCheckBlack {
            isCheckMateBlack = blackKing.validMoves(board: self, check: true).count == 0
            if isCheckMateBlack {
                for pieces in currentPieces(color: .black) {
                    if pieces.validMoves(board: self, check: true).count >= 1 {
                        isCheckMateBlack = false
                        break
                    }
                }
            }
        }
        
        return (white: isCheckMateWhite, black: isCheckMateBlack)
    }
    
    func isDraw(from: Position, to: Position) -> (white: Bool, black: Bool) {
        
        let isCheckWhite = whiteKing.isChecked(board: self)
        var isDrawWhite = false
        
        if !isCheckWhite {
            isDrawWhite = whiteKing.validMoves(board: self, check: false).count == 0
        }
        
        let isCheckBlack = blackKing.isChecked(board: self)
        var isDrawBlack = false

        if !isCheckBlack {
            isDrawBlack = whiteKing.validMoves(board: self, check: false).count == 0
        }

        return (white: isDrawWhite, black: isDrawBlack)
    }
    
    func isCheck(from: Position, to: Position) -> (white: Bool, black: Bool) {
        let boardCopy = self.copy()
        let piece = boardCopy.piece(at: from)
        boardCopy[from.x, from.y].piece = nil
        boardCopy[to.x, to.y].piece = piece
        var isCheckWhite = false
        for enemeyPiece in boardCopy.currentPieces(color: .black) {
            if boardCopy.whiteKing.isThreatendBy(piece: enemeyPiece, board: boardCopy) {
                isCheckWhite = true
                break
            }
        }
        var isCheckBlack = false
        for enemeyPiece in boardCopy.currentPieces(color: .white) {
            if boardCopy.blackKing.isThreatendBy(piece: enemeyPiece, board: boardCopy) {
                isCheckBlack = true
                break
            }
        }
        return (white: isCheckWhite, black: isCheckBlack)
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
    
    func has(color: Color, at: Position) -> Bool {
        if let pieace = self[at.x, at.y].piece {
            return pieace.color == color
        }
        return false
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
    
    func currentPieces(color: Color) -> [Piece] {
        return grid.flatMap { $0.piece }.filter { $0.color == color }
    }
    
    func initializePieces() {
        // Pawns
        for column in 0...columns-1 {
            self[column, 1].piece = Pawn(color: playerColor.opposite(), moved: false)
            self[column, 6].piece = Pawn(color: playerColor, moved: false)
        }
        
        // Kings
        self[4,0].piece = King(color: playerColor.opposite(), moved: false)
        
        if playerColor == .white {
            blackKing = self[4,0].piece as! King
        } else {
            whiteKing = self[4,0].piece as! King
        }
        
        self[4,7].piece = King(color: playerColor, moved: false)
        
        if playerColor == .white {
            whiteKing = self[4,7].piece as! King
        } else {
            blackKing = self[4,7].piece as! King
        }
        
        // Queens
        self[3,0].piece = Queen(color: playerColor.opposite(), moved: false)
        self[3,7].piece = Queen(color: playerColor, moved: false)
        
        // Castles
        self[0,0].piece = Castle(color: playerColor.opposite(), moved: false)
        self[7,0].piece = Castle(color: playerColor.opposite(), moved: false)
        self[0,7].piece = Castle(color: playerColor, moved: false)
        self[7,7].piece = Castle(color: playerColor, moved: false)
        
        // Knights
        self[1,0].piece = Knight(color: playerColor.opposite(), moved: false)
        self[6,0].piece = Knight(color: playerColor.opposite(), moved: false)
        self[1,7].piece = Knight(color: playerColor, moved: false)
        self[6,7].piece = Knight(color: playerColor, moved: false)
        
        // Bishops
        self[2,0].piece = Bishop(color: playerColor.opposite(), moved: false)
        self[5,0].piece = Bishop(color: playerColor.opposite(), moved: false)
        self[2,7].piece = Bishop(color: playerColor, moved: false)
        self[5,7].piece = Bishop(color: playerColor, moved: false)
        
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
        let mate = isCheckMate()
        if mate.white {
            blackWins.value = true
        }
        if mate.black {
            whiteWins.value = true
        }
    }
    
}
