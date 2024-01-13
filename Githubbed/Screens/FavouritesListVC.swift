//
//  FavouritesListVC.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 6.1.2024.
//

import UIKit

class FavouritesListVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        
        PersistanceManager.retrieveFavourites { result in
            switch result {
            case .success(let favourites):
                print(favourites)
            case .failure(let error):
                break
            }
        }
    }
}
