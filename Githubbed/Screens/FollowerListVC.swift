//
//  FollowerListVC.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 7.1.2024.
//

import UIKit

class FollowerListVC: UIViewController {

    enum Section { case main }
    
    var username: String!
    var followers: [FollowerModel] = []
    var page = 1
    var hasMoreFollowers = true
    
    var followerCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, FollowerModel>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        followerCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper().createThreeColumnFlowLayout(in: view))
        view.addSubview(followerCollectionView)
        followerCollectionView.delegate = self
        followerCollectionView.backgroundColor = .systemBackground
        followerCollectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func getFollowers(username: String, page: Int) {
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error bruh", message: error.rawValue, buttonTitle: "Ok")
                return
            case .success(let followerData):
                if followerData.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followerData)
                self.updateData()
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, FollowerModel>(collectionView: followerCollectionView, cellProvider: {( collectionView, indexPath, follower) -> UICollectionViewCell?  in
            let cell = self.followerCollectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowerModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {return}
            page += 1
            getFollowers(username: username, page: 2)
        }
    }
}
