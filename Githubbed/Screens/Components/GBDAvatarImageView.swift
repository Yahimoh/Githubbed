//
//  GBDAvatarImageView.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 9.1.2024.
//

import UIKit

class GBDAvatarImageView: UIImageView {
    
    let placeholderImage = UIImage(named: "avatar.placeholder")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
