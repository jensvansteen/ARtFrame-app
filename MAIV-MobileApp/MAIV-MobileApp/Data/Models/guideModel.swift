//
//  guideModel.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 10/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import Foundation


struct Guide: Codable {
    let id: String
    let name: String
    let fullName: String
    let info: String
    let index: Int
}
