//
//  Theme.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import UIKit

final class Theme {

    let blackSquareColor: UIColor = .lightGray
    let whiteSquareColor: UIColor = .white
    let highlightedSquareColor: UIColor = UIColor.yellow.withAlphaComponent(0.5)
    let boarderColor: UIColor = .black
    
    let blackKing = UIImage(named: "BlackKing")!
    let blackQueen = UIImage(named: "BlackQueen")!
    let blackCastle = UIImage(named: "BlackCastle")!
    let blackKnight = UIImage(named: "BlackKnight")!
    let blackBishop = UIImage(named: "BlackBishop")!
    let blackPawn = UIImage(named: "BlackPawn")!

    let whiteKing = UIImage(named: "WhiteKing")!
    let whiteQueen = UIImage(named: "WhiteQueen")!
    let whiteCastle = UIImage(named: "WhiteCastle")!
    let whiteKnight = UIImage(named: "WhiteKnight")!
    let whiteBishop = UIImage(named: "WhiteBishop")!
    let whitePawn = UIImage(named: "WhitePawn")!
    
    func backgroundColor(square: Square) -> UIColor {
        switch square.color {
        case .white:
            return whiteSquareColor
        case .black:
            return blackSquareColor
        }
    }
    
    func highlightedColor() -> UIColor {
        return highlightedSquareColor
    }
    
    func image(piece: Piece) -> UIImage? {
        
        if let piece = piece as? King {
            return piece.color == .black ? blackKing : whiteKing
        }
        
        if let piece = piece as? Queen {
            return piece.color == .black ? blackQueen : whiteQueen
        }
        
        if let piece = piece as? Castle {
            return piece.color == .black ? blackCastle : whiteCastle
        }
        
        if let piece = piece as? Knight {
            return piece.color == .black ? blackKnight : whiteKnight
        }
        
        if let piece = piece as? Bishop {
            return piece.color == .black ? blackBishop : whiteBishop
        }
        
        if let piece = piece as? Pawn {
            return piece.color == .black ? blackPawn : whitePawn
        }
        
        return nil
    }
    
}
