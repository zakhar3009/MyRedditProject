//
//  PostTableCell.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 15.02.2024.
//

import Foundation
import UIKit


class PostTableCell : UITableViewCell{
    
    @IBOutlet private weak var postView: PostView!
    
    func configure(post: PostInfo){
        postView.currentPost = post
        postView.configure()
    }
    
    func setDelegate(_ vc: PostListViewController) {
        postView.delegate = vc
    }
}



