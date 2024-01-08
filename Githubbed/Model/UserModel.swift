//
//  UserModel.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 8.1.2024.
//

import Foundation

struct UserModel: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publiGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
