//
//  GBDFollowerItemVC.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 12.1.2024.
//

import UIKit

class GBDFollowerItemVC: GBDItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get followers")
    }
}
