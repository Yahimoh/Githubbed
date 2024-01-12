//
//  UserInfoVC.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 11.1.2024.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didTapGithubProfile()
    func didTapGetFollowers()
}

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GBDBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: self.username) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.addChildVC(childVC: GBDUserInfoHeaderVC(user: user), to: self.headerView)
                    let repoItemVC = GBDRepoItemVC(user: user)
                    repoItemVC.delegate = self
                    self.addChildVC(childVC: GBDRepoItemVC(user: user), to: self.itemViewOne)
                    self.addChildVC(childVC: GBDFollowerItemVC(user: user), to: self.itemViewTwo)
                    self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
                }
            case.failure(let error):
                self.presentGFAlertOnMainThread(title: "Error fetching user", message: "Can't fetch clicked user", buttonTitle: "Ok")
            }
        }
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        for viewItem in itemViews {
            view.addSubview(viewItem)
            viewItem.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewItem.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                viewItem.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func addChildVC(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGithubProfile() {
        // show safari view controller
    }
    
    func didTapGetFollowers() {
        // dismissvc
        // tell follower list screen the new user 
    }
}
