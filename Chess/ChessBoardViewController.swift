//
//  ChessBoardViewController.swift
//  Chess
//
//  Created by Matthew Wilkinson on 25/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import UIKit
import ChessKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError

final class ChessBoardViewController: UIViewController {

    var boardView: BoardView!
    var topPlayerView: PlayerView!
    var bottomPlayerView: PlayerView!
    
    private func showWinner(color: Color) {
        let alert = UIAlertController(title: "Checkmate",
                                      message: "\(color == .white ? "white" : "black") wins",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.loadBoard(board: Board(playerColor: .white))
        })
        show(alert, sender: nil)
    }
    
    private func removeGameViews() {
        if self.boardView != nil {
            self.boardView.removeFromSuperview()
        }
        if self.topPlayerView != nil {
            self.topPlayerView.removeFromSuperview()
        }
        if self.bottomPlayerView != nil {
            self.bottomPlayerView.removeFromSuperview()
        }
    }
    
    private func loadBoard(board: Board) {
        removeGameViews()    
        let theme = Theme()
        board.whiteWins.signal.observeValues { wins in
            if wins {
                self.showWinner(color: .white)
            }
        }
        board.blackWins.signal.observeValues { wins in
            if wins {
                self.showWinner(color: .black)
            }
        }
        board.initializePieces()
        let gridSize = min(400, min(view.frame.width, view.frame.height) - 20) / CGFloat(board.columns)
        let boardView = BoardView(theme: theme, board: board, size: gridSize)
        self.boardView = boardView
        view.addSubview(boardView)
        boardView.snp.makeConstraints { make in
            make.width.equalTo(boardView.frame.width)
            make.height.equalTo(boardView.frame.height)
            make.center.equalTo(view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBoard(board: Board(playerColor: .white))
    }
    
}

