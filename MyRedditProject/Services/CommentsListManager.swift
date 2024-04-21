//
//  CommentsListManager.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 12.04.2024.
//

import Foundation

class CommentsListManager: ObservableObject {
    
    private var fetcher: CommentFetcher?
    private let subbredit: String
    private let limit: Int
    @Published var commentsForPost: [CommentInfo] = []
    
    var currentPost: PostInfo? {
        didSet {
            commentsForPost = []
            self.fetcher = CommentFetcher(subbredit: subbredit,
                                          postID: currentPost!.id,
                                          limit: limit)
            Task {
                commentsForPost = await self.fetcher?.getComments() ?? []
            }
        }
    }
    
    init(subbredit: String, limit: Int, currentPost: PostInfo) {
        self.subbredit = subbredit
        self.limit = limit
        self.currentPost = currentPost
        self.fetcher = CommentFetcher(subbredit: subbredit,
                                      postID: currentPost.id,
                                      limit: limit)
        Task {
            let comments = await self.fetcher?.getComments() ?? []
            await MainActor.run {
                self.commentsForPost = comments
            }
        }
    }
    
    func getMoreComments() {
        Task {
            guard let moreComments = await self.fetcher?.getMoreComments()
            else { return }
            await MainActor.run {
                self.commentsForPost += moreComments
            }
        }
    }
    
    func getMoreCommentsCount() -> Int {
        self.fetcher?.getMoreCommentsCount() ?? 0
    }
    
}
