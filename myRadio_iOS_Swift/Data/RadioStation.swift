//
//  RadioStation.swift
//  myRadio_iOS_Swift
//
//  Created by Add on 21.07.2021.
//

import UIKit

struct RadioStation: Codable { 
    
    var name: String
    var streamURL: String
    var imageURL: String
    var desc: String
    var longDesc: String
    
    init(name: String, streamURL: String, imageURL: String, desc: String, longDesc: String = "") {
        self.name = name
        self.streamURL = streamURL
        self.imageURL = imageURL
        self.desc = desc
        self.longDesc = longDesc
    }
    
    
}


