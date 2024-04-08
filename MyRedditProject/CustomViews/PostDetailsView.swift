//
//  PostDetails.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 19.02.2024.
//

import Foundation
import UIKit
import SwiftUI

struct PostDetailsView: UIViewRepresentable {
    
    private var selectedPost: PostInfo
    
    init(selectedPost: PostInfo) {
        self.selectedPost = selectedPost
    }
    
    func makeUIView(context: Context) -> some UIView {
        let postView = PostView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                currentPost: self.selectedPost)
        postView.isUserInteractionEnabled = true
        postView.configure()
        postView.delegate = context.coordinator
        return postView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: UIViewController, PostViewDelegate {
        
        func didTapShare(_ post: PostInfo) {
            let items: [Any] = [post.url!]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(ac, animated: true)
            }
            //UIApplication.shared.wind rootViewController?.present(ac, animated: true)
        }
        
        func performSegue(_ selectedPost: PostInfo) {
            
        }
        
        
    }
   
    
}


