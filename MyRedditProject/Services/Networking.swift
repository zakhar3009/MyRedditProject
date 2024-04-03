//
//  Networking.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 08.02.2024.
//

import Foundation


public class Networking {
    
    static let manager = Networking()
    private init() {}
    
    private func createUrl(subreddit : String, limit : Int, after: String?) -> URL?{
        guard let startPath = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json") else {return nil}
        return startPath
            .appending(queryItems: [URLQueryItem(name: "limit", value: "\(limit)"),
                                   URLQueryItem(name: "after", value: after)])
        
    }
    
    private func createFirstCommentsUrl(subreddit : String, postID: String, limit: Int) -> URL?{
        guard let startPath = URL(string: "https://www.reddit.com/r/\(subreddit)/comments/\(postID)/.json") else {return nil}
        print(startPath)
        return startPath.appending(queryItems: [URLQueryItem(name: "depth", value: "1"),
                                                URLQueryItem(name: "limit", value: "\(limit)")])
    }
    
    private func createMoreCommentsUrl(postID: String, commentsIDs: [String]) -> URL?{
        guard let startPath = URL(string: "https://www.reddit.com/api/morechildren.json") else { return nil }
        return startPath.appending(queryItems: [URLQueryItem(name: "link_id", value: "t3_\(postID)"),
                                                URLQueryItem(name: "children", value: commentsIDs.joined(separator: ",") ),
                                                URLQueryItem(name: "depth", value: "0"),
                                                URLQueryItem(name: "limit_children", value: "true"),
                                                ])
    }
    
    func getPostResponse(subreddit: String, limit: Int, after: String?) async throws -> Response {
        guard let reqURL = createUrl(subreddit: subreddit, limit: limit, after: after) else {
            throw NetworkingErrors.invalidURL
        }
        print(reqURL)
        let (data, response) = try await URLSession.shared.data(from: reqURL)
        //print(String(data: data, encoding: .utf8))
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw NetworkingErrors.invalidResponse
        }
        do {
            //print(String(data: data, encoding: .utf8)!)
            let response = try JSONDecoder().decode(Response.self, from: data)
            return response
        } catch {
            //print(String(data: data, encoding: .utf8)!)
            throw NetworkingErrors.invalidData
        }
    }
    
    func getFirstComments(subreddit: String, postID: String, limit: Int) async throws -> [CommentInfo] {
        guard let reqURL = createFirstCommentsUrl(subreddit: subreddit, postID: postID, limit: limit) else {
            throw NetworkingErrors.invalidURL
        }
        print(reqURL)
        let (data, response) = try await URLSession.shared.data(from: reqURL)
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw NetworkingErrors.invalidResponse
        }
        do {
            let response = try JSONSerialization.jsonObject(with: data) as! [[String: Any]]
            let commentData = try JSONSerialization.data(withJSONObject: response[1])
            let commentsResponse = try JSONDecoder().decode(CommentsResponse.self, from: commentData)
            return commentsResponse.data.children.map{ $0.data }
        } catch {
            throw NetworkingErrors.invalidData
        }
    }
    
    func getMoreComments(postID: String, commentsIDs: [String]) async throws -> [CommentInfo] {
        guard let reqUrl = createMoreCommentsUrl(postID: postID, commentsIDs: commentsIDs) else {
            throw NetworkingErrors.invalidURL
        }
        print(reqUrl)
        let (data, response) = try await URLSession.shared.data(from: reqUrl)
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw NetworkingErrors.invalidResponse
        }
        //print(String(data: data, encoding: .utf8))
        do {
            let response = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            guard let jqueryArray = response["jquery"] as? [[Any]] else { throw NetworkingErrors.invalidData }
            guard let array = (jqueryArray[10][3] as? [Any]) else { throw NetworkingErrors.invalidData }
            let commentsData = try JSONSerialization.data(withJSONObject: array[0])
            let commentsChildren = try JSONDecoder().decode([CommentChildren].self, from: commentsData)
            return commentsChildren.map { $0.data }
        } catch {
            throw NetworkingErrors.invalidData
        }
    }
    
    
}





