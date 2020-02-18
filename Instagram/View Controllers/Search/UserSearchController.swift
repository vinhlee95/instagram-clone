//
//  UserSearchController.swift
//  Instagram
//
//  Created by Vinh Le on 2/18/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController {
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Type user name"
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: nil, height: nil)
    }
}
