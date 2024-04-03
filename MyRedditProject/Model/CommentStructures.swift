
//
//  CommentStructures.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import Foundation


struct CommentsResponse : Codable {
    let data : CommentsData
}

struct CommentsData : Codable {
    let children : [CommentChildren]
}

struct CommentChildren : Codable {
    let data : CommentInfo
}

struct CommentInfo : Codable, Hashable{
    let id = UUID()
    let author : String?
    let createdUtc : Double?
    let commentText : String?
    let rating : Int?
    let link : String?
    let children: [String]?
    
    enum CodingKeys : String, CodingKey {
        case author
        case createdUtc = "created_utc"
        case commentText = "body"
        case rating = "score"
        case link = "permalink"
        case children
    }
    
    var timePassed : String {
        guard let createdUtc = createdUtc else { return "\\undefined\\"}
        return TimeManager.manager.getTimeForTextLabel(createdUtc: createdUtc)
    }
    
}
