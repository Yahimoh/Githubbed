//
//  FavouritesListVC.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 6.1.2024.
//

import UIKit

class FavouritesListVC: UIViewController {
    
    let tableview = UITableView()
    var favourites: [FollowerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableview)
        tableview.frame = view.bounds
        tableview.rowHeight = 80
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(FavouritedUserCell.self, forCellReuseIdentifier: FavouritedUserCell.reuseID)
    }
    
    func getFavourites() {
        PersistanceManager.retrieveFavourites { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let favourites):
                
                if favourites.isEmpty {
                    self.showEmptyStateView(with: "No favourites?\nAdd one on the follower screen", in: self.view)
                }
                self.favourites = favourites
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.view.bringSubviewToFront(self.tableview)
                }
            case .failure(let error):
                self.presentGBDAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FavouritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: FavouritedUserCell.reuseID) as! FavouritedUserCell
        let favourite = favourites[indexPath.row]
        cell.set(favourite: favourite)
        return cell
    }
    
    
    
}
