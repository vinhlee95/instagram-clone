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
    private var cellId = "cellId"
    var userService = UserService()
    private var users = [User]()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Type user name"
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true // always scroll vertically
        self.fetchUsers()
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: nil, height: nil)
        
        // Register cell
        collectionView.register(UserResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func fetchUsers() {
        userService.fetchUsers { (users, error) in
            self.users = users
            self.collectionView.reloadData()
        }
    }
}

//
// Configure cells
//
extension UserSearchController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserResultCell
        cell.user = self.users[indexPath.item]
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
