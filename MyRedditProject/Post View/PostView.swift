//
//  PostView.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 19.02.2024.
//

import Foundation
import UIKit

class PostView: UIView{
    
    var currentPost: PostInfo?
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var userInfo: UILabel!
    
    @IBOutlet private weak var postTitle: UILabel!
    
    @IBOutlet private weak var postImage: UIImageView!
    
    @IBOutlet private weak var ratingLabel: UILabel!
    
    @IBOutlet private weak var commentsLabel: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PostView", owner: self)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    
    @IBAction func bookmarkPressed(_ sender: UIButton) {
        guard let currentPost else {return}
        currentPost.isSaved.toggle()
        let image = UIImage(systemName: currentPost.isSaved ?
                            "bookmark.fill" :  "bookmark")
        sender.setImage(image, for: .normal)
    }
    
    func configure(){
        postTitle.adjustsFontSizeToFitWidth = true
        ratingLabel.adjustsFontSizeToFitWidth = true
        commentsLabel.adjustsFontSizeToFitWidth = true
        userInfo.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.minimumScaleFactor = 0.5
        guard let currentPost else { return }
        userInfo.text = "\(currentPost.authorFullName) • \(currentPost.timePassed) • \(currentPost.domain)"
        postTitle.text = currentPost.title.prefix(1).uppercased() + currentPost.title.dropFirst()
        ratingLabel.text = "\(currentPost.ups + currentPost.downs)"
        commentsLabel.text = "\(currentPost.numComments)"
        if let preview = currentPost.preview{
            let imageUrl = preview.images[0].source.url.replacingOccurrences(of: "&amp;", with: "&")
            //print(imageUrl)
            postImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, options: .scaleDownLargeImages)
        } else {
            postImage.image = UIImage(named: "Placeholder")
            postImage.contentMode = .scaleAspectFill
        }
    }
    
    
}
