//
//  CommentListView.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import SwiftUI

struct CommentListView: View {
    
    private let fetcher: CommentFetcher
    private let subbredit: String
    private let postID: String
    private let limit: Int
    @State var comments: [CommentInfo] = []
    
    init(subbredit: String, postID: String, limit: Int) {
        self.subbredit = subbredit
        self.postID = postID
        self.limit = limit
        self.fetcher = CommentFetcher(subbredit: subbredit, postID: postID, limit: limit)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                LazyVStack(spacing: 0){
                    ForEach(Array(comments.enumerated()), id: \.element.id){ index, comment in
                        NavigationLink(value: comment) {
                            CommentView(comment: comment)
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
                .navigationTitle("Comments")
                .navigationDestination(for: CommentInfo.self) { comment in
                    CommentDetailsView(comment: comment)
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

