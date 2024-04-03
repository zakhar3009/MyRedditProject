//
//  PostStructures.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import Foundation

struct Response : Codable{
    let kind : String
    let data : PostData
}

struct PostData : Codable{
    let after: String?
    let children : [PostChildren]
}

struct PostChildren : Codable{
    let kind : String
    let data : PostInfo
}


struct Preview : Codable{
    let images : [PostImage]
}
struct PostImage : Codable{
    let source : Source
}

struct Source : Codable{
    let url : String
}

struct PostInfo : Codable {
    
    let authorFullName : String?
    let domain : String
    let title : String
    let ups : Int
    let downs : Int
    let numComments : Int
    let createdUtc : Double
    let preview : Preview?
    let permalink: String
    let id: String
    var isSaved = false
    
    var getIsSaved: Bool{
        return isSaved
    }
    
    var url: URL?{
        return URL(string: "https://www.reddit.com\(permalink)")
    }
    
    var timePassed : String {
        TimeManager.manager.getTimeForTextLabel(createdUtc: createdUtc)
    }
    
    mutating func toggleSave(){
        isSaved.toggle()
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
        case permalink
        case id
    }
    
}
