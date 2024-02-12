//
//  ViewController.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 07.02.2024.
//

import UIKit
import SDWebImage

class PostViewController: UIViewController {
    
    let networkingBrain = NetworkingManager()
    var currenPost : PostInfo?
   
    @IBAction func bookmarkPressed(_ sender: UIButton) {
        guard let currenPost else {return}
        
        currenPost.isSaved = !currenPost.isSaved
        if currenPost.isSaved {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var userInfo: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitle.adjustsFontSizeToFitWidth = true
        ratingLabel.adjustsFontSizeToFitWidth = true
        commentsLabel.adjustsFontSizeToFitWidth = true
        userInfo.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.minimumScaleFactor = 0.5
        Task{
            await showPost()
        }
    }
    
    
    
    func showPost() async {
        let networkingBrain = NetworkingManager()
        do {
            currenPost = try await networkingBrain.getPost()
            userInfo.text = "\(currenPost!.authorFullName) • \(currenPost!.timePassed) • \(currenPost!.domain)"
            postTitle.text = currenPost!.title.prefix(1).uppercased() + currenPost!.title.dropFirst()
            ratingLabel.text = "\(currenPost!.ups + currenPost!.downs)"
            commentsLabel.text = "\(currenPost!.numComments)"
            let imageUrl = currenPost!.preview.images[0].source.url.replacingOccurrences(of: "&amp;", with: "&")
            print(imageUrl)
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, options: .scaleDownLargeImages)
        } catch PostError.invalidURL {
            print("Invalid url")
        } catch PostError.invalidResponse {
            print("Invalid response")
        } catch PostError.invalidData {
            print("Invalid data")
        } catch {
            print("Other error")
        }
    }


}

