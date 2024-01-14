//
//  ErrorMessage.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 9.1.2024.
//

import Foundation

enum GBDError: String, Error {
    case invalidUsername = "Inputted username created a wrong request. Please try again."
    case unableToComplete = "Unable to complete your request. Please try again."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case userHasNoFollowers = "This user doesn't have any followers. Go follow them 💕"
    case unableToFavourite = "There was an error favouriting this user. Please try again"
    case alreadyFavouritedUser = "This user is already favourited ❤️"
}
