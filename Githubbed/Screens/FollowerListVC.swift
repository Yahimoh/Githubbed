//
//  FollowerListVC.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 7.1.2024.
//

import UIKit

class FollowerListVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .systemGray4
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error bruh", message: error.rawValue, buttonTitle: "Ok")
                return
            case .success(let followerData):
                print("Followers.count = \(followerData.count)")
                print(followerData)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
