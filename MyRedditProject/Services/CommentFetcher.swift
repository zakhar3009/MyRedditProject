//
//  CommentFetcher.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import Foundation

class CommentFetcher {
    let subbredit: String
    let postID: String
    let limit: Int
    private var moreCommentsIDs: [String]?
    
    init(subbredit: String, postID: String, limit: Int) {
        self.subbredit = subbredit
        self.postID = postID
        self.limit = limit
    }
    
    func getComments() async -> [CommentInfo]?{
        do {
            var comments = try await Networking.manager.getFirstComments(subreddit: subbredit, postID: postID, limit: limit)
            if comments.count > limit {
                moreCommentsIDs = comments.last!.children
                comments.removeLast()
            }
            return comments
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
    
    func getMoreComments() async -> [CommentInfo]?{
        do {
            if moreCommentsIDs != nil {
                let comments = try await Networking.manager.getMoreComments(postID: postID, commentsIDs: Array(moreCommentsIDs![moreCommentsIDs!.count >= limit ? 0..<limit : 0..<moreCommentsIDs!.count]))
                for _ in 0..<comments.count {
                    if moreCommentsIDs?.first != nil {
                        moreCommentsIDs?.removeFirst()
                    }
                }
                return comments
            } else {
                return nil
            }
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
    
    func getMoreCommentsCount() -> Int {
        guard let res = moreCommentsIDs?.count else { return 0 }
        return res
    }
}
