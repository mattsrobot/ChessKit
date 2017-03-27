//
//  PawnSpec.swift
//  Chess
//
//  Created by Matthew Wilkinson on 26/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import XCTest
import Quick
import Nimble
import ReactiveSwift
import Mockingjay
import enum Result.NoError
@testable import Chess

class PawnSpec: QuickSpec {
    
    override func spec() {
        
        describe("Pawn") {
            
            var board: Board!
            
            beforeEach {
                board = Board(playerColor: .white)
                board.initializePieces()
            }
            
            it("can double move") {
                // GIVEN a black pawn at position 0,1
                let start = Position(x: 0, y: 1)
                let end = Position(x: 0, y: 3)
                let blackPawn = board.piece(at: start)!
                // WHEN pawn double moves
                let validMoves = blackPawn.validMoves(from: start, board: board, check: true)
                expect(blackPawn.moved).to(equal(false))
                expect(validMoves).to(contain(Position(x: 0, y: 2)))
                expect(validMoves).to(contain(end))
                board.movePieces(changeSet: ChangeSet(movements: [(from: start, to: end)]))
                // THEN pawn can no longer double move
                let validMove = Position(x: 0, y: 4)
                let invalidMove = Position(x: 0, y: 5)
                expect(blackPawn.moved).to(equal(true))
                expect(board.hasPiece(at: end)).to(equal(true))
                expect(board.hasPiece(at: start)).to(equal(false))
                expect(blackPawn.validMoves(from: end, board: board, check: true)).to(contain(validMove))
                expect(blackPawn.validMoves(from: end, board: board, check: true)).toNot(contain(invalidMove))
            }
            
            it("can move forward") {
                // GIVEN a black pawn at position 0,1
                let start = Position(x: 0, y: 1)
                let end = Position(x: 0, y: 2)
                let blackPawn = board.piece(at: start)!
                // WHEN pawn moves
                let validMoves = blackPawn.validMoves(from: start, board: board, check: true)
                expect(blackPawn.moved).to(equal(false))
                expect(validMoves).to(contain(end))
                board.movePieces(changeSet: ChangeSet(movements: [(from: start, to: end)]))
                // THEN pawn can no longer double move
                let validMove = Position(x: 0, y: 3)
                let invalidMove = Position(x: 0, y: 4)
                expect(blackPawn.moved).to(equal(true))
                expect(board.hasPiece(at: end)).to(equal(true))
                expect(board.hasPiece(at: start)).to(equal(false))
                expect(blackPawn.validMoves(from: end, board: board, check: true)).to(contain(validMove))
                expect(blackPawn.validMoves(from: end, board: board, check: true)).toNot(contain(invalidMove))
            }
            
        }
        
    }
    
}
