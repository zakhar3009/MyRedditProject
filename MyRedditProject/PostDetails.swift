//
//  PostDetails.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 19.02.2024.
//

import Foundation
import UIKit

class PostDetails : UIViewController{
    
    @IBOutlet weak var postView: PostView!
    
    func configure(selectedPost: PostInfo){
        postView.currentPost = selectedPost
        postView.configure()
    }
    
}
