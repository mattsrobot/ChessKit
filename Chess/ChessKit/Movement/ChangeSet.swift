//
//  ChangeSet.swift
//  Chess
//
//  Created by Matthew Wilkinson on 26/03/2017.
//  Copyright © 2017 Some Robots. All rights reserved.
//

import Foundation

public struct ChangeSet {
    public let movements: [(from: Position, to: Position)]
    
    public init(movements: [(from: Position, to: Position)]) {
        self.movements = movements
    }
    
}
