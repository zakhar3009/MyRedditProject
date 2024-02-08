//
//  Networking.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 08.02.2024.
//

import Foundation


public class NetworkingBrain{
    
    func createUrl(subreddit : String, limit : Int) -> URL?{
        guard let startPath = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json?") else {return nil}
        return startPath.appending(queryItems: [URLQueryItem(name: "limit", value: "\(limit)")])
    }
    
    func getPost() async throws -> PostInfo{
        guard let reqURL = createUrl(subreddit: "ios", limit: 1) else {
            throw PostError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: reqURL)
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw PostError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Response.self, from: data).data.children[0].data
        } catch {
            throw PostError.invalidData
        }
    }
}



struct Response : Codable{
    let kind : String
    let data : PostData
}

struct PostData : Codable{
    let children : [PostChildren]
}

struct PostChildren : Codable{
    let kind : String
    let data : PostInfo
}

class PostInfo : Codable{
    let authorFullName : String
    let domain : String
    let title : String
    let ups : Int
    let downs : Int
    let numComments : Int
    let createdUtc : Double
    let preview : Preview
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

struct Preview : Codable{
    let enabled : Bool
    let images : [Image]
}
struct Image : Codable{
    let source : Source
}

struct Source : Codable{
    let url : String
}


enum PostError : Error{
    case invalidURL
    case invalidResponse
    case invalidData
}

