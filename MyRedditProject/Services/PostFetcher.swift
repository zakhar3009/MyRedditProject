//
//  PostFetcher.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 15.02.2024.
//

import Foundation

class PostFetcher {
    let subbredit: String
    let limit: Int
    var after: String?
    
    init(subbredit: String, limit: Int) {
        self.subbredit = subbredit
        self.limit = limit
    }
    
    func getPosts() async -> [PostInfo]?{
        do {
            let response = try await Networking.manager.getPostResponse(subreddit: subbredit, limit: limit, after: after)
            self.after = response.data.after
            return response.data.children.map{ $0.data }
        } catch NetworkingErrors.invalidURL {
            print("Invalid url")
        } catch NetworkingErrors.invalidResponse {
            print("Invalid response")
        } catch NetworkingErrors.invalidData {
            print("Invalid data")
        } catch {
            print("Other error")
        }
        return nil
    }
}
