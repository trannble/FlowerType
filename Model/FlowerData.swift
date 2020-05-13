//
//  FlowerData.swift
//  FlowerType
//
//  Created by Tran Le on 5/12/20.
//  Copyright © 2020 TL Inc. All rights reserved.

import Foundation

struct FlowerData: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [String: Results]
    let pageids: [String]
}

struct Results: Codable {
    let extract: String
}
