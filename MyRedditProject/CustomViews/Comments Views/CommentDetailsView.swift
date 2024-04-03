//
//  CommentDetailsView.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import SwiftUI

struct CommentDetailsView: View {
    let comment: CommentInfo?
    
    var body: some View {
        if let link = comment?.link {
            VStack{
                CommentView(comment: comment)
                    .padding(.bottom, 100)
                
                ShareLink(item: URL(string: "https://www.reddit.com\(link)")!) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.85, height: 60)
                        .background(Color("ShareButtonColor"))
                        .cornerRadius(15)
                }
            }
        }
        else {
            CommentView(comment: nil)
        }
    }
}
