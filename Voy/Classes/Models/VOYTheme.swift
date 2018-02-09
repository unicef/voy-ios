//
//  VOYTheme.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

class VOYTheme: Mappable {

    var id:Int!
    var project:String!
    var bounds:[[Double]]!
    var name:String!
    var description:String!
    var tags:[String]!
    var color:String!
    var pin:String!
    var reports_count:Int!
    var created_on:String!
    var allow_links:Bool!
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        project <- map["project"]
        bounds <- map["bounds"]
        name <- map["name"]
        description <- map["description"]
        tags <- map["tags"]
        color <- map["color"]
        pin <- map["pin"]
        reports_count <- map["reports_count"]
        created_on <- map["created_on"]
        allow_links <- map["allow_links"]
    }
    
    func map() -> Map {
        return Map(mappingType: .toJSON, JSON: self.toJSON())
    }
    
}