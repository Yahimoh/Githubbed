//
//  UserInfoVC.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 11.1.2024.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didTapGithubProfile(for user: UserModel)
    func didTapGetFollowers(for user: UserModel)
}

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GBDBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var username: String!
    weak var delegate: FollowerListVCDelegate!

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
                    self.configureUIElements(with: user)
                }
            case.failure(let error):
                self.presentGFAlertOnMainThread(title: "Error fetching user", message: "Can't fetch clicked user", buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: UserModel) {
        let repoItemVC = GBDRepoItemVC(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GBDFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.addChildVC(childVC: repoItemVC, to: self.itemViewOne)
        self.addChildVC(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
        self.addChildVC(childVC: GBDUserInfoHeaderVC(user: user), to: self.headerView)
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
    func didTapGithubProfile(for user: UserModel) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this github user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: UserModel) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers 😭", buttonTitle: "")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
}
