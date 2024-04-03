//
//  CommentListView.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import SwiftUI

struct CommentListView: View {
    private let completion: (AnyView) -> Void
    private let fetcher: CommentFetcher
    private let subbredit: String
    private let post: PostInfo
    private let limit: Int
    @State var comments: [CommentInfo] = []
    
    init(subbredit: String, post: PostInfo, limit: Int, completion: @escaping (AnyView) -> Void) {
        self.subbredit = subbredit
        self.post = post
        self.limit = limit
        self.fetcher = CommentFetcher(subbredit: subbredit, postID: post.id, limit: limit)
        self.completion = completion
    }
    
    
    var body: some View {
        ScrollView{
            LazyVStack(spacing: 0){
                PostDetailsView(selectedPost: post)
                    .frame(height: 450)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 15)
                ForEach(Array(comments.enumerated()), id: \.element.id){ index, comment in
                        CommentView(comment: comment)
                        .onTapGesture {
                            completion(AnyView(CommentDetailsView(comment: comment)))
                        }
                    .onAppear {
                        Task{
                            if(self.fetcher.getMoreCommentsCount() > 0 && index >= comments.count - 3){
                                if let moreComments = await fetcher.getMoreComments(){
                                    comments += moreComments
                                    self.comments = comments
                                }
                            }
                        }
                    }
                    Divider()
                        .frame(height: 1.5)
                        .background(Color("BorderColor"))
                }
            }
        }
        .onAppear {
            Task{
                if let comments = await fetcher.getComments(){
                    self.comments += comments
                }
            }
        }
    }
}

