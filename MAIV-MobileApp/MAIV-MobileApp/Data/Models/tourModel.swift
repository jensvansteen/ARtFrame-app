//
//  tourModel.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 08/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import Foundation

struct Tour: Codable {
    let id: String
    let title: String
    let img: String
    let text: String
    let paintings: [String]
    let completed: Int
    let highlighted: Bool
}
