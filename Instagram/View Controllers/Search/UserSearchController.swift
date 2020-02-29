//
//  UserSearchController.swift
//  Instagram
//
//  Created by Vinh Le on 2/18/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController {
    //
    // Variables
    //
    var userService = UserService()
    var user: User?
    
    private var cellId = "cellId"
    private var users = [User]()
    private var filteredUsers = [User]()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Type user name"
        sb.delegate = self
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true // always scroll vertically
        collectionView.keyboardDismissMode = .onDrag // dismiss keyboard
        
        self.fetchUsers()
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: nil, height: nil)
        
        // Register cell
        collectionView.register(UserResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func fetchUsers() {
        userService.fetchUsers { (users, error) in
            let currentUserId = self.userService.getCurrentUserId()
            
            self.users = users.filter({ (user) -> Bool in
                return user.id != currentUserId
            })
            self.users.sort { (user, nextUser) -> Bool in
                return user.name.compare(nextUser.name) == .orderedAscending
            }
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }
    }
}

//
// Configure cells
//
extension UserSearchController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserResultCell
        cell.user = self.filteredUsers[indexPath.item]
        
        return cell
    }
}

//
// Configure sizing for cells
//
extension UserSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = CGFloat(56)
        
        return CGSize(width: width, height: height)
    }
}

//
// Filter users by search text
//
extension UserSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let formattedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if formattedSearchText.isEmpty {
            self.filteredUsers = self.users
        } else {
            self.filteredUsers = self.users.filter({ (user) -> Bool in
                return user.name.lowercased().contains(formattedSearchText)
            })
        }
        
        self.collectionView.reloadData()
    }
}

//
// Select a search result
// Navigate to that user's profile view
// and handle search bar and keyboard appearance
//
extension UserSearchController {
    override func viewDidAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Hide the search bar when navigating to user profile view
        searchBar.isHidden = true
        // Hide they keyboard
        searchBar.resignFirstResponder()
        
        let user = self.filteredUsers[indexPath.item]
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.id
        
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}
