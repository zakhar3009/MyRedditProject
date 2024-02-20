//
//  ViewController.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 07.02.2024.
//

import UIKit
import SDWebImage

class PostListViewController: UIViewController {
    
    @IBOutlet private weak var postsTableView: UITableView!
    
    @IBOutlet private weak var onlySavedButton: UIBarButtonItem!
    
   
    @IBOutlet weak var navItem: UINavigationItem!
    
    let postFetcher = PostFetcher(subbredit: "iOS", limit: 10)
    var onlySavedMode = true
    
    struct Const{
        static let cellIdentifaer = "post_table_cell"
        static let goToDetailsSegueID = "go_to_details"
    }
    
    @IBAction func onlySavedBookmarkPressed(_ sender: Any) {
        onlySavedMode.toggle()
        let image = UIImage(systemName: onlySavedMode ? "bookmark.fill" : "bookmark")
        onlySavedButton.image = image
    }
    
    
    
    var posts = [PostInfo]()
    
    private var lastSelectedPost: PostInfo?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = "iOS"
        Task{
            if let data = await postFetcher.getPosts(){
                posts += data
            }
            postsTableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case Const.goToDetailsSegueID:
            let detailsVC = segue.destination as! PostDetails
            DispatchQueue.main.async {
                guard let selectedPost = self.lastSelectedPost else { return }
                detailsVC.configure(selectedPost: selectedPost)
            }
        default: break
        }
    }

}

extension PostListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifaer, for: indexPath) as! PostTableCell
        cell.postView.currentPost = posts[indexPath.row]
        cell.postView.configure()
        return cell
    }
}

extension PostListViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSelectedPost = self.posts[indexPath.row]
        self.performSegue(withIdentifier: Const.goToDetailsSegueID, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentLeft = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y
        if contentLeft < 500 {
            Task{
                //print(postFetcher.after)
                if let data = await postFetcher.getPosts(){
                    posts += data
                }
                postsTableView.reloadData()
            }
        }
        
    }
}


