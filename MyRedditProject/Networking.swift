//
//  Networking.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 08.02.2024.
//

import Foundation


public class Networking{
    
    static let manager = Networking()
    private init() {}
    
    private func createUrl(subreddit : String, limit : Int, after: String?) -> URL?{
        guard let startPath = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json") else {return nil}
        return startPath
            .appending(queryItems: [URLQueryItem(name: "limit", value: "\(limit)"),
                                   URLQueryItem(name: "after", value: after)])
        
    }
    
    func getResponse(subreddit: String, limit: Int, after: String?) async throws -> Response{
        guard let reqURL = createUrl(subreddit: subreddit, limit: limit, after: after) else {
            throw PostError.invalidURL
        }
        //print(reqURL)
        let (data, response) = try await URLSession.shared.data(from: reqURL)
        //print(String(data: data, encoding: .utf8))
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw PostError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            return response
        } catch {
            //print(String(data: data, encoding: .utf8)!)
            throw PostError.invalidData
        }
    }
}



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

