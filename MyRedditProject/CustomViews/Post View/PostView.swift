//
//  PostView.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 19.02.2024.
//

import Foundation
import UIKit

protocol PostViewDelegate: AnyObject, UIViewController{
    func didTapShare(_ post: PostInfo)
    func performSegue(_ selectedPost: PostInfo)
}

class PostView: UIView {
    
    var currentPost: PostInfo?
    
    @IBOutlet private weak var bookmarkButton: UIButton!
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var userInfo: UILabel!
    
    @IBOutlet private weak var postTitle: UILabel!
    
    @IBOutlet private weak var postImage: UIImageView!
    
    @IBOutlet private weak var ratingLabel: UILabel!
    
    @IBOutlet private weak var commentsLabel: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton!
    
    weak var delegate: PostViewDelegate?
    
    init(frame: CGRect, currentPost: PostInfo) {
        self.currentPost = currentPost
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
    
    @objc
    func savePost(){
        guard var currentPost else { return }
        currentPost.toggleSave()
        self.currentPost?.toggleSave()
        DataManager.manager.savePostIfNeeded(post: currentPost)
        let image = UIImage(systemName: currentPost.getIsSaved ?
                            "bookmark.fill" :  "bookmark")
        bookmarkButton.setImage(image, for: .normal)
    }
    
    @objc
    func savePostWithDoubleTap(){
        if let currentPost {
            if !currentPost.isSaved { savePost() }
        }
        let bookmarkViewWidth = self.postImage.frame.width * 0.2
        let bookmarkViewHeight = self.postImage.frame.height * 0.45
        let bookmarkView = Bookmark(frame: CGRect(
            x: postImage.frame.midX - bookmarkViewWidth/2,
            y: postImage.frame.height/2 - bookmarkViewHeight/2,
            width: bookmarkViewWidth,
            height: bookmarkViewHeight)
        )
        bookmarkView.isHidden = true
        bookmarkView.translatesAutoresizingMaskIntoConstraints = false
        postImage.addSubview(bookmarkView)
        UIView.transition(with: postImage,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations: {
            bookmarkView.isHidden = false
        }, completion: { _ in
            UIView.transition(with: self.postImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                bookmarkView.isHidden = true
            })
        })
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
        } else {
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        postImage.isUserInteractionEnabled = true
        let singleTapRecongizer = UITapGestureRecognizer(target: self, action: #selector(performSegue))
        singleTapRecongizer.numberOfTapsRequired = 1
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(savePostWithDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(singleTapRecongizer)
        self.postImage.addGestureRecognizer(doubleTapRecognizer)
        singleTapRecongizer.require(toFail: doubleTapRecognizer)
        bookmarkButton.addTarget(self, action: #selector(savePost), for: .touchUpInside)
    }
    
    @objc
    func performSegue(){
        guard let currentPost else { return }
        delegate?.performSegue(currentPost)
    }
    
}

extension PostView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
}
