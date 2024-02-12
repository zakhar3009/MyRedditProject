//
//  Networking.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 08.02.2024.
//

import Foundation


public class NetworkingManager{
    
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
            return try JSONDecoder().decode(Response.self, from: data).data.children[0].data
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

