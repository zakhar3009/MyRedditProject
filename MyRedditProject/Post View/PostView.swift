//
//  PostView.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 19.02.2024.
//

import Foundation
import UIKit

protocol PostViewDelegate: AnyObject {
    func didTapShare(_ post: PostInfo)
}

class PostView: UIView{
    
    var currentPost: PostInfo?
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var userInfo: UILabel!
    
    @IBOutlet private weak var postTitle: UILabel!
    
    @IBOutlet private weak var postImage: UIImageView!
    
    @IBOutlet private weak var ratingLabel: UILabel!
    
    @IBOutlet private weak var commentsLabel: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton!
    
    weak var delegate: PostViewDelegate?
    
    
    
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
    
    
    @IBAction func sharePressed(_ sender: Any) {
        guard let currentPost = currentPost else { return }
        delegate?.didTapShare(currentPost)
    }
    
    @IBAction func bookmarkPressed(_ sender: UIButton) {
        guard var currentPost else {return}
        currentPost.toggleSave()
        self.currentPost?.toggleSave()
        DataManager.manager.savePost(post: currentPost)
        let image = UIImage(systemName: currentPost.getIsSaved ?
                            "bookmark.fill" :  "bookmark")
        bookmarkButton.setImage(image, for: .normal)
    }
    
    func configure(){
        postTitle.adjustsFontSizeToFitWidth = true
        ratingLabel.adjustsFontSizeToFitWidth = true
        commentsLabel.adjustsFontSizeToFitWidth = true
        userInfo.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.minimumScaleFactor = 0.5
        guard let currentPost else { return }
        var authorFullName: String
        if let name = currentPost.authorFullName {
            authorFullName = name
        } else {
            authorFullName = "\\undefined\\"
        }
        userInfo.text = "\(authorFullName) • \(currentPost.timePassed) • \(currentPost.domain)"
        postTitle.text = currentPost.title.prefix(1).uppercased() + currentPost.title.dropFirst()
        ratingLabel.text = "\(currentPost.ups + currentPost.downs)"
        commentsLabel.text = "\(currentPost.numComments)"
        postImage.contentMode = .scaleAspectFit
        
        if let preview = currentPost.preview{
            let imageUrl = preview.images[0].source.url.replacingOccurrences(of: "&amp;", with: "&")
            postImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, options: .scaleDownLargeImages)
        } else {
            postImage.image = UIImage(named: "Placeholder")
        }
        if currentPost.getIsSaved {
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else {
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    
}
