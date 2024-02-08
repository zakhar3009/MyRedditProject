//
//  Post.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 08.02.2024.
//

import Foundation

class Post{
    
    private let authorID : String
    private var domain : String
    private var title : String
    private var ups : Int
    private var downs : Int
    private var numComments : Int
    private var createdUtc : Double
    private let imageURL : Preview
    var isSaved = true
    
    
    init(authorID: String, domain: String, title: String, ups: Int, downs: Int, numComments: Int, timePassed: Double, imageURL: Preview, isSaved: Bool = true) {
        self.authorID = authorID
        self.domain = domain
        self.title = title
        self.ups = ups
        self.downs = downs
        self.numComments = numComments
        self.timePassed = timePassed
        self.imageURL = imageURL
        self.isSaved = isSaved
    }
    
    var getDomain : String{
        return domain
    }
    var getTitle : String{
        return title
    }
    var getUps : Int{
        return ups
    }
    var getDowns : Int{
        return downs
    }
    var getNumComments : Int{
        return numComments
    }
    var getTimePassed
    
    
    
}
