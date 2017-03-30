//
//  BoardView.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import UIKit
import ChessKit
import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError

final class BoardView: UIView {

    let theme: Theme
    var board: Board
    var grid: [SquareView]
    var pieces: [PieceView]
    
    init(theme: Theme, board: Board, size: CGFloat) {
        self.theme = theme
        self.board = board
        self.grid = [SquareView](repeating: SquareView(theme: theme, square: Square(color: .white, piece: nil), board: board, boardView: nil), count: board.rows * board.columns)
        self.pieces = [PieceView]()
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(board.columns) * size, height: CGFloat(board.rows) * size))

        for column in 0...board.columns-1 {
            for row in 0...board.rows-1 {
                let frame = CGRect(x: CGFloat(column) * size, y: CGFloat(row) * size, width: size, height: size)
                let square = board[column,row]
                let squareView = SquareView(theme: theme, square: square, board: board, boardView: self)
                if let piece = square.piece {
                    let pieceView = PieceView(theme: theme, piece: piece, board: board)
                    pieces.append(pieceView)
                    squareView.pieceView = pieceView
                    pieceView.frame = frame
                }
                squareView.frame = frame
                self[column, row] = squareView
            }
        }

        grid.forEach { addSubview($0) }
        pieces.forEach { addSubview($0) }
        layer.backgroundColor = theme.boarderColor.cgColor
        layer.borderWidth = 1.0
        
        board.highlightedSquares.signal.observeValues { validMoves in
            self.grid.forEach { $0.highlighted = false }
            if let validMoves = validMoves, validMoves.count > 0 {
                validMoves.forEach { move in
                    self.square(at: move).highlighted = true
                }
            }
        }
        
        board.selectedPiece.signal.observeValues { selectedPiece in
            
        }
            
        board.boardChanges.signal.observeValues { changeSet in
            if let changeSet = changeSet {
                for movement in changeSet.movements {
                    let fromSquare = self.square(at: movement.from)
                    if let fromPieceView = fromSquare.pieceView {
                        fromSquare.pieceView = nil
                        let toSquare = self.square(at: movement.to)
                        if let toPieceView = toSquare.pieceView {
                            toPieceView.removeFromSuperview()
                        }
                        toSquare.pieceView = fromPieceView
                        UIView.animate(withDuration: 0.5) {
                            fromPieceView.frame = toSquare.frame
                        }
                    }
                }
            }
        }
    }
    
    subscript(column: Int, row: Int) -> SquareView {
        get { return grid[(row * board.columns) + column] }
        set { grid[(row * board.columns) + column] = newValue }
    }
    
    func square(at: Position) -> SquareView {
        return self[at.x, at.y]
    }
    
    func position(of square: SquareView) -> Position {
        for column in 0...board.columns-1 {
            for row in 0...board.rows-1 {
                let position = Position(x: column, y: row)
                let squareView = self.square(at: position)
                if squareView === square {
                    return position
                }
            }
        }
        fatalError("Trying to access a view outside of chessboard?")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(board:)")
    }
    
}

final class PieceView: UIView {

    let theme: Theme
    var piece: Piece
    var board: Board
    private var imageView: UIImageView
    private var button: UIButton
    
    init(theme: Theme, piece: Piece, board: Board) {
        self.theme = theme
        self.piece = piece
        self.board = board
        self.imageView = UIImageView(image: theme.image(piece: piece))
        self.button = UIButton(type: .custom)
        super.init(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        addSubview(button)
        imageView.snp.makeConstraints { make in
            make.top.left.width.height.equalTo(self)
        }
        button.snp.makeConstraints { make in
            make.top.left.width.height.equalTo(self)
        }
        button.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                if let selectedPosition = board.position(of: self.piece) {
                    board.tap(position: selectedPosition)
                }
        }
    }
    
    func showInvalidMove() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(piece:)")
    }
    
}

final class SquareView: UIView {
    
    let theme: Theme
    var square: Square
    var pieceView: PieceView?
    var board: Board
    weak var boardView: BoardView?
    let highlightedView: UIView
    var highlighted: Bool = false {
        didSet {
            highlightedView.backgroundColor = highlighted ? theme.highlightedSquareColor : .clear
        }
    }
    private var button: UIButton
    
    init(theme: Theme, square: Square, board: Board, boardView: BoardView?) {
        self.theme = theme
        self.square = square
        self.button = UIButton(type: .custom)
        self.board = board
        self.boardView = boardView
        self.highlightedView = UIView(frame: .zero)
        super.init(frame: .zero)
        backgroundColor = theme.backgroundColor(square: square)
        addSubview(highlightedView)
        highlightedView.snp.makeConstraints { make in
            make.top.left.width.height.equalTo(self)
        }
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.left.width.height.equalTo(self)
        }
        button.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                if let selectedPosition = self.boardView?.position(of: self) {
                    board.tap(position: selectedPosition)
                }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(theme: square: board: boardView:)")
    }
    
}
