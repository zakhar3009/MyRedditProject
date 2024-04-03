//
//  CommentView.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import SwiftUI

struct CommentView: View {
    let comment: CommentInfo?
    
    var body: some View {
        VStack (alignment: .leading){
            HStack (){
                Text("u/\(comment?.author ?? "undefined")")
                    .font(.system(size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(comment?.timePassed ?? "undefined")")
                    .font(.system(size: 22))
            }
            
            Text("\(comment?.commentText ?? "undefined")")
                .multilineTextAlignment(.leading)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .minimumScaleFactor(0.6)
                .padding(.vertical, 15)

            Spacer()
            HStack(spacing: 7){
                
                Image(systemName: "arrowshape.up.fill")
                    .resizable()
                    .foregroundStyle(Color("RatingImageColor"))
                    .frame(width: 20, height: 25)
                Text("\(comment?.rating ?? 0)")
                    .scaledToFill()
                    .fontWeight(.semibold)
            }
            .padding(.bottom, 15)
        }
        .foregroundColor(Color("FontColor"))
        .padding(.all, 15)
        .frame(maxWidth: .infinity, maxHeight: 350)
        .background(Color("BackgroundColor"))
    }
}
