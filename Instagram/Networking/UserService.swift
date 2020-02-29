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
    private var userPath = "users"
    private var followPath = "following"
    
    //
    // Typealias
    //
    typealias FetchUserResult = (User?, String) -> Void
    typealias FetchUsersResult = ([User], String) -> Void
    typealias FollowUserResult = (Any, String) -> Void
    typealias GetFollowingUsersResult = ([String?], String) -> Void
    
    //
    // Internal methods
    //
    func fetchUser(_ userId: String, completion: @escaping FetchUserResult) {
        Database.database().reference().child(userPath).child(userId).observeSingleEvent(of: .value) { (snapshot, error) in
            if let error = error {
                print("Error in getting user data", error)
                self.errorMessage = "Error in fetching user data"
            }

            guard let userDataDictionary = snapshot.value as? [String: Any] else {return}
            
            let fetchedUser = User(name: userDataDictionary["username"] as! String, profileImageUrl: userDataDictionary["avatar_url"] as! String, id: userId, following: userDataDictionary["following"] as? [String?] ?? [])

            completion(fetchedUser, self.errorMessage)
        }
    }
    
    func getCurrentUserId() -> String? {
        guard let currentUser = Auth.auth().currentUser else {return ""}
        return currentUser.uid
    }
    
    func fetchUsers(completion: @escaping FetchUsersResult) {
        var users = [User]()
        
        Database.database().reference().child(userPath).observeSingleEvent(of: .value) { (snapshot, error) in
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
    
    func followUser(userId: String, user: User, completion: @escaping FollowUserResult) {
        guard let currentUserId = getCurrentUserId() else {return}
        var following = user.following
        following.append(userId)
        let values = ["following": following]
        
        Database.database().reference().child(userPath).child(currentUserId).updateChildValues(values) { (error, ref) in
            print("Follow", ref)
        }
    }
}
