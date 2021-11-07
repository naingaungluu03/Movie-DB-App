//
//  GenreVO.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import Foundation

public class GenreVO : Codable {
    
    var name : String = "ACTION"
    var isSelected : Bool = false
    var id : Int = 0
    
    enum CodingKeys: String, CodingKey {
        case name,id
    }
    
    init(id: Int = 0 , name : String, isSelected : Bool){
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
    
}
