//
//  DataManager.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 21.02.2024.
//

import Foundation

class DataManager {
    
    let subbredit = "iOS"
    
    let limit = 10
    
    private let fetcher: PostFetcher
    
    private init() {
        self.fetcher = PostFetcher(subbredit: subbredit, limit: limit)
    }
    
    private var savedPosts = [PostInfo]()
    
    private let fileName = "SavedPosts.json"
    
    private let pathToDerictory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    static let manager = DataManager()
    
    
    
    private var currentPosts: [PostInfo] = []
    private var networkPosts: [PostInfo] = []
    
    func getCurrentPosts() -> [PostInfo]{
        currentPosts
    }
    func downloadPostsFromNetwork() async {
        guard let posts = await fetcher.getPosts() else { return }
        for var post in posts{
            if savedPosts.contains(where: { $0.id == post.id}){
                post.toggleSave()
            }
            networkPosts.append(post)
        }
        currentPosts = networkPosts
    }
    
    func onlySavedMode(_ isSavedMode: Bool){
        if isSavedMode {
            currentPosts = savedPosts
            //print(currentPosts)
        } else {
            currentPosts = networkPosts
        }
    }
    
    func savePostIfNeeded(post: PostInfo){
        for i in 0..<currentPosts.count{
            if currentPosts[i].id == post.id {
                currentPosts[i].toggleSave()
                break
            }
        }
        for i in 0..<networkPosts.count{
            if networkPosts[i].id == post.id {
                networkPosts[i].toggleSave()
                break
            }
        }

        if post.isSaved && !savedPosts.contains(where: { $0.id == post.id }){
            savedPosts.append(post)
        }
        else { savedPosts.removeAll(where: { $0.id == post.id }) }
    }
    
    func getSavedPosts() async -> [PostInfo]{
        return savedPosts
    }

    
    func uploadPostsFromDevice() async {
        do{
            async let data = try Data(contentsOf: pathToDerictory.appendingPathComponent(fileName))
            let posts = try await JSONDecoder().decode([PostInfo].self, from: data)
            savedPosts.append(contentsOf: posts)
            for i in 0..<savedPosts.count{
                savedPosts[i].toggleSave()
            }
        }catch{
            print("Uploading files is failed")
        }
    }
    
    func filterByTitle(text: String){
        if text == "" {
            currentPosts = savedPosts
            return
        }
        currentPosts = savedPosts.filter { $0.title.lowercased().contains(text.lowercased()) }
    }
    
    func savePostsToDevice(){
        let fileURL = pathToDerictory.appendingPathComponent(fileName)
        do {
            print(savedPosts)
            let jsonData = try JSONEncoder().encode(savedPosts)
            try jsonData.write(to: fileURL)
            print("Data saved successfully")
        } catch {
            print("Error while saving data")
        }
    }
}
