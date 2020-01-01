//
//  PhotoShareController.swift
//  Instagram
//
//  Created by Vinh Le on 12/29/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit

class PhotoShareController: UIViewController {
    //
    // Variables
    //
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        renderHeaderView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //
    // Image view
    //
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //
    // Text view
    //
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func renderHeaderView() {
        let headerView = UIView()
        view.addSubview(headerView)
        headerView.backgroundColor = .white
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: nil, height: 100)
        
        headerView.addSubview(imageView)
        imageView.image = selectedImage
        imageView.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, left: headerView.leftAnchor, right: nil, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 84, height: nil)
        
        headerView.addSubview(textView)
        textView.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, left: imageView.rightAnchor, right: headerView.rightAnchor, paddingTop: 0, paddingBottom: 8, paddingLeft: 0, paddingRight: 0, width: nil, height: nil)
    }
}
