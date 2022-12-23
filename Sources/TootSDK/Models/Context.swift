// Created by konstantin on 02/11/2022
// Copyright (c) 2022. All rights reserved.

import Foundation

public struct Context: Codable, Hashable {
    public var ancestors: [Post]
    public var descendants: [Post]

    public init(ancestors: [Post], descendants: [Post]) {
        self.ancestors = ancestors
        self.descendants = descendants
    }
}
