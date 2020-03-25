//
//  CommentsController.swift
//  Instagram
//
//  Created by Vinh Le on 3/21/20.
//  Copyright © 2020 Vinh Le. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
    var post: Post?
    private var userService = UserService()
    private var commentService = CommentService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "Comments"
        collectionView.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        tabBarController?.tabBar.isHidden = false
        containerView.removeFromSuperview()
    }
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your comment"
        return textField
    }()
    
    let sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(submitComment), for: .touchUpInside)
        return sendButton
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        containerView.addSubview(self.sendButton)
        self.sendButton.anchor(top: containerView.topAnchor, bottom: containerView.layoutMarginsGuide.bottomAnchor, left: nil, right: containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: nil, height: nil)
        
        containerView.addSubview(self.textField)
        self.textField.anchor(top: containerView.topAnchor, bottom: containerView.layoutMarginsGuide.bottomAnchor, left: containerView.leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: nil, height: nil)
        
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func submitComment() {
        guard let userId = userService.getCurrentUserId() else {return}
        guard let postId = self.post?.id else {return}
        
        let commentDictionary = ["body": textField.text, "userId": userId, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        let comment = Comment(dictionary: commentDictionary)
        commentService.createComment(postId: postId, comment: comment) {
            self.textField.resignFirstResponder()
            self.textField.text = ""
        }
    }
}
