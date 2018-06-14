//
//  paintings.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 10/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import Foundation

struct Painting: Codable {
    let name: String
    let artistid: String
    let year: String
    let id: String
    let questions: [QAndA]
}

struct QAndA: Codable {
    let question: String
    let g01: String
    let g02: String
    let g03: String
}
