//
//  CommentListView.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import SwiftUI

struct CommentListView: View {
    private let completion: (AnyView) -> Void
    private let post: PostInfo
    @ObservedObject private var commentsManager: CommentsListManager
    
    
    init(subbredit: String, post: PostInfo, limit: Int, completion: @escaping (AnyView) -> Void) {
        self.post = post
        self.completion = completion
        self.commentsManager = CommentsListManager(subbredit: subbredit,
                                                   limit: limit,
                                                   currentPost: post)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0){
                PostDetailsView(selectedPost: post)
                    .frame(height: 450)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 15)
                ForEach(Array(commentsManager.commentsForPost.enumerated()),
                        id: \.element.id){ index, comment in
                    CommentView(comment: comment)
                        .onTapGesture {
                            completion(AnyView(CommentDetailsView(comment: comment)))
                        }
                        .onAppear {
                            if(commentsManager.getMoreCommentsCount() > 0 && index >= commentsManager.commentsForPost.count - 3){
                                commentsManager.getMoreComments()
                            }
                        }
                    Divider()
                        .frame(height: 1.5)
                        .background(Color("BorderColor"))
                }
            }
        }
    }
}

