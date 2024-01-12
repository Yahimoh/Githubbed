//
//  GBDRepoItemVC.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 12.1.2024.
//

import UIKit

class GBDRepoItemVC: GBDItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
}
