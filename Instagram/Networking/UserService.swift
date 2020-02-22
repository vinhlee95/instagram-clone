//
//  UserService.swift
//  Instagram
//
//  Created by Vinh Le on 12/14/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//
import Firebase

class UserService {
    //
    // Variables
    //
    var errorMessage = ""
    
    //
    // Typealias
    //
    typealias FetchUserResult = (User?, String) -> Void
    typealias FetchUsersResult = ([User], String) -> Void
    
    //
    // Internal methods
    //
    func fetchUser(_ userId: String, completion: @escaping FetchUserResult) {
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot, error) in
            if let error = error {
                print("Error in getting user data", error)
                self.errorMessage = "Error in fetching user data"
            }
            guard let userDataDictionary = snapshot.value as? [String: String] else {return}
            
            let fetchedUser = User(name: userDataDictionary["username"] ?? "", profileImageUrl: userDataDictionary["avatar_url"] ?? "", id: userId)
            
            completion(fetchedUser, self.errorMessage)
        }
    }
    
    func fetchUsers(completion: @escaping FetchUsersResult) {
        var users = [User]()
        
        Database.database().reference().child("users").observeSingleEvent(of: .value) { (snapshot, error) in
            if let error = error {
                print("Error in fetching all users", error)
                self.errorMessage = "Error in fetching all users"
            }
            
            guard let userDictionaries = snapshot.value as? [String: Any] else {return}
            userDictionaries.forEach { (key, value) in
                guard let userDictionary = value as? [String: String] else {return}
                let fetchedUser = User(name: userDictionary["username"]!, profileImageUrl: userDictionary["avatar_url"]!, id: key)
                users.append(fetchedUser)
            }
            
            completion(users, self.errorMessage)
        }
    }
}
