//
//  PostDetails.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 19.02.2024.
//

import Foundation
import UIKit
import SwiftUI

class PostDetails : UIViewController {
    
    @IBOutlet private weak var postView: PostView!
    
    @IBOutlet weak var containerView: UIView!
    var selectedPost: PostInfo!
    
    override func viewDidLoad() {
        postView.isUserInteractionEnabled = true
        postView.currentPost = selectedPost
        postView.configure()
        postView.delegate = self
        
        let swiftUIViewController: UIViewController = UIHostingController(rootView: CommentListView(
                                                                              subbredit: DataManager.manager.subbredit,
                                                                              postID: selectedPost.id,
                                                                              limit: DataManager.manager.limit))
        let swiftUIView: UIView = swiftUIViewController.view
        self.containerView.addSubview(swiftUIView)
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
        ])
        swiftUIViewController.didMove(toParent: self)
    }
   
    
}

extension PostDetails: PostViewDelegate {
    func performSegue(_ selectedPost: PostInfo) {
    }
    
    func didTapShare(_ post: PostInfo) {
        let items: [Any] = [post.url!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

