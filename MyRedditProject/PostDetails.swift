//
//  PostDetails.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 19.02.2024.
//

import Foundation
import UIKit

class PostDetails : UIViewController {
    
    @IBOutlet weak var postView: PostView!
    
    var selectedPost: PostInfo?
    
    override func viewDidLoad() {
        postView.isUserInteractionEnabled = true
        postView.currentPost = selectedPost
        postView.configure()
        postView.delegate = self
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

