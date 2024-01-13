//
//  PersistanceManager.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 13.1.2024.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    
    enum keys {
        static let favourites = "favourites"
    }
    
    static func updateWith(favourite: FollowerModel, actionType: PersistanceActionType, completion: @escaping(GBDError?) -> Void) {
        retrieveFavourites { result in
            switch result {
            case .success(let favourites):
                var retrievedFavourites = favourites
                
                switch actionType {
                case .add:
                    guard !retrievedFavourites.contains(favourite) else {
                        completion(.alreadyFavouritedUser)
                        return
                    }
                    retrievedFavourites.append(favourite)
                case .remove:
                    retrievedFavourites.removeAll {$0.login == favourite.login}
                }
                
                completion(saveFavourites(favourites: retrievedFavourites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func retrieveFavourites(completion: @escaping(Result<[FollowerModel], GBDError>) -> Void ) {
        guard let favouritesData = defaults.object(forKey: keys.favourites) as? Data else {
            completion(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([FollowerModel].self, from: favouritesData)
            completion(.success(favourites))
        } catch {
            completion(.failure(.unableToFavourite))
        }
    }
    
    static func saveFavourites(favourites: [FollowerModel]) -> GBDError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }
}
