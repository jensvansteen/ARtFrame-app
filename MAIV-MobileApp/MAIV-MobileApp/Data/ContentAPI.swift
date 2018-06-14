//
//  ContentAPI.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 10/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import Foundation

class ContentAPI {
    
    static var shared : ContentAPI = ContentAPI()
 
    func load<T : Codable>(into swiftType : T.Type, resource : String, ofType type : String = "json") -> T? {

        let path = Bundle.main.path(forResource: resource, ofType: type)
        let url = URL(fileURLWithPath: path!)

        guard let data = try? Data(contentsOf: url) else {return nil}

        let decoder = JSONDecoder()

        return try! decoder.decode(swiftType.self, from: data)

    }
    
    lazy var tours : Array<Tour> = {
        return load(into: Array<Tour>.self, resource: "tours") ?? []
    }()
    
    lazy var guides : Array<Guide> = {
        return load(into: Array<Guide>.self, resource: "guides") ?? []
    }()
    
    lazy var paintings : Array<Painting> = {
        return load(into: Array<Painting>.self, resource: "paintings") ?? []
    }()
    
    lazy var artists : Array<Artist> = {
        return load(into: Array<Artist>.self, resource: "artists") ?? []
    }()
    
}
