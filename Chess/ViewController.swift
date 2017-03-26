//
//  ChessBoardViewController.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import UIKit
import SnapKit

final class ChessBoardViewController: UIViewController {

    var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theme = Theme()
        let board = Board()
        board.initializePieces()
        let gridSize = min(400, min(view.frame.width, view.frame.height) - 40) / CGFloat(board.columns)
        let boardView = BoardView(theme: theme, board: board, size: gridSize)
        self.boardView = boardView
        view.addSubview(boardView)
        boardView.snp.makeConstraints { make in
            make.width.equalTo(boardView.frame.width)
            make.height.equalTo(boardView.frame.height)
            make.center.equalTo(view)
        }
    }
    
    
}

