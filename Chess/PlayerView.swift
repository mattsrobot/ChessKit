//
//  PlayerView.swift
//  Chess
//
//  Created by Matthew Wilkinson on 27/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError

final class PlayerView: UIView {

    var profileImageView:UIImageView!
    var nameLabel:UILabel!
    var timeRemainingLabel:UILabel!
    var board:Board!
    var player:Player!
    
    init(player: Player, board: Board) {
        super.init(frame: .zero)
        self.player = player
        self.board = board
        profileImageView = UIImageView(frame: .zero)
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(65)
            make.top.left.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(player: board:)")
    }
    
}
