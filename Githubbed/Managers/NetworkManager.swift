//
//  NetworkManager.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 8.1.2024.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    let baseUrl = "https://api.github.com"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completion: @escaping([FollowerModel]?, String?) -> Void) {
        let urlEndpoint = baseUrl + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: urlEndpoint) else {
            completion(nil, "Invalid URL , Please try again")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(nil, "Unable to complete your request, Please try your internet connection.")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid responese from the server, Please try again.")
                return
            }
            
            guard let data = data else {
                completion(nil, "The error received from data is invalid, Please try again.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([FollowerModel].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, "The error received from data is invalid, Please try again.")
            }
            
        }
        
        task.resume()
    }
}
