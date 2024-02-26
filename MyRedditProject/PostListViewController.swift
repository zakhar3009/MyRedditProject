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
    
    var headerView: UIView!
    
    var searchField: UITextField!
    
    var onlySavedMode = false
    
    struct Const{
        static let cellIdentifaer = "post_table_cell"
        static let goToDetailsSegueID = "go_to_details"
    }
    
    
    func configSearchItem(){
        headerView = UIView(frame: .init(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 44
        ))
        headerView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.layer.borderWidth = 0.5
        searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.textAlignment = .center
        headerView.addSubview(searchField)
        layoutSearchField()
        searchField.delegate = self
        searchField.placeholder = "Search saved posts"
    }
    
    func layoutSearchField() {
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: headerView.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            searchField.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchField.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
    }

    
    @IBAction func onlySavedBookmarkPressed(_ sender: Any) {
        onlySavedMode.toggle()
        let image = UIImage(systemName: onlySavedMode ? "bookmark.fill" : "bookmark")
        onlySavedButton.image = image
        if onlySavedMode{
            DataManager.manager.onlySavedMode(onlySavedMode)
            postsTableView.tableHeaderView = headerView
            postsTableView.reloadData()
        } else {
            postsTableView.tableHeaderView = nil
            DataManager.manager.onlySavedMode(false)
            postsTableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postsTableView.reloadData()
    }
    
    private var lastSelectedPost: PostInfo?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = "iOS"
        Task{
            await DataManager.manager.uploadPostsFromDevice()
            await DataManager.manager.downloadPostsFromNetwork()
            postsTableView.reloadData()
        }
        configSearchItem()
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
        DataManager.manager.getCurrentPosts().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifaer, for: indexPath) as! PostTableCell
        cell.configure(post: DataManager.manager.getCurrentPosts()[indexPath.row])
        cell.setDelegate(self)
        return cell
    }
}

extension PostListViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSelectedPost = DataManager.manager.getCurrentPosts()[indexPath.row]
        self.performSegue(withIdentifier: Const.goToDetailsSegueID, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentLeft = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y
        if contentLeft < 450 && !onlySavedMode{
            Task{
                await DataManager.manager.downloadPostsFromNetwork()
                postsTableView.reloadData()
            }
        }
        
    }
}

extension PostListViewController: PostViewDelegate {
    
    func didTapShare(_ post: PostInfo) {
        let items: [Any] = [post.url!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

extension PostListViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        DataManager.manager.filterByTitle(text: text)
        postsTableView.reloadData()
    }
    
    
}
