//
//  PostInfo.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 12.02.2024.
//

import Foundation

class PostInfo : Codable{
    let authorFullName : String
    let domain : String
    let title : String
    let ups : Int
    let downs : Int
    let numComments : Int
    let createdUtc : Double
    let preview : Preview?
    var isSaved = true
    
    var timePassed : String {
        let currentUTC = Double(Date().timeIntervalSince1970)
        if (currentUTC - createdUtc)/60 < 1 { return "\(currentUTC - createdUtc)s" }
        else if (currentUTC - createdUtc)/3600 < 1 { return "\(Int((currentUTC - createdUtc)/60))m" }
        else if (currentUTC - createdUtc)/86400 < 1 { return "\(Int((currentUTC - createdUtc)/3600))h" }
        else if (currentUTC - createdUtc)/(86400 * 365) < 1 { return "\(Int((currentUTC - createdUtc)/86400))d" }
        else { return "\(Int((currentUTC - createdUtc)/(86400 * 365)))y" }
    }
    
    enum CodingKeys : String, CodingKey{
        case authorFullName = "author_fullname"
        case domain
        case title
        case ups
        case createdUtc = "created_utc"
        case downs
        case preview
        case numComments = "num_comments"
    }
    
}
