//
//  BoardView.swift
//  Chess
//
//  Created by Matthew Wilkinson on 27/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Cocoa
import SnapKit
import ChessKit
import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError

final class BoardView: NSView {
    
    let theme: Theme
    var board: Board
    var grid: [SquareView]
    var pieces: [PieceView]
    
    init(theme: Theme, board: Board, size: CGFloat) {
        self.theme = theme
        self.board = board
        self.pieces = [PieceView]()
        self.grid = [SquareView]()
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("use init(theme: board: size:)")
    }
    
}

final class SquareView: NSView {
    
    let theme: Theme
    var square: Square
    var pieceView: PieceView?
    var board: Board
    weak var boardView: BoardView?
    let highlightedView: NSView
    var highlighted: Bool = false {
        didSet {
            highlightedView.layer?.backgroundColor = highlighted ? theme.highlightedSquareColor.cgColor : NSColor.clear.cgColor
        }
    }
    private var button: NSButton
    
    init(theme: Theme, square: Square, board: Board, boardView: BoardView?) {
        self.theme = theme
        self.square = square
        self.button = NSButton(frame: .zero)
        self.board = board
        self.boardView = boardView
        self.highlightedView = NSView(frame: .zero)
        super.init(frame: .zero)
        button.isTransparent = true
        layer?.backgroundColor = theme.backgroundColor(square: square).cgColor
        addSubview(highlightedView)
        highlightedView.snp.makeConstraints { make in
            make.top.left.width.height.equalTo(self)
        }
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.left.width.height.equalTo(self)
        }
//        var syncBrewAction: Action<BrewState, NSData, NSError>!
//        button.target = CocoaAction(syncBrewAction, input: nil)
//        button.action = CocoaAction.selector

//        button.reactive
//            .controlEvents(.touchUpInside)
//            .observeValues { _ in
//                if let selectedPosition = self.boardView?.position(of: self) {
//                    board.tap(position: selectedPosition)
//                }
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(theme: square: board: boardView:)")
    }
}

final class PieceView: NSView {
    
}
