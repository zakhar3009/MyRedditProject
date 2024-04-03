//
//  PostFetcher.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 15.02.2024.
//

import Foundation

class PostFetcher{
    let subbredit: String
    let limit: Int
    var after: String?
    
    init(subbredit: String, limit: Int) {
        self.subbredit = subbredit
        self.limit = limit
    }
    
    func getPosts() async -> [PostInfo]?{
        do{
            //print(after)
            let response = try await Networking.manager.getResponse(subreddit: subbredit, limit: limit, after: after)
            self.after = response.data.after
            return response.data.children.map{ $0.data }
        } catch PostError.invalidURL {
            print("Invalid url")
        } catch PostError.invalidResponse {
            print("Invalid response")
        } catch PostError.invalidData {
            print("Invalid data")
        } catch {
            print("Other error")
        }
        return nil
    }
}
