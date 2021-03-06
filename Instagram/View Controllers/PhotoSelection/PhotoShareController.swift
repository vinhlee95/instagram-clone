//
//  PhotoShareController.swift
//  Instagram
//
//  Created by Vinh Le on 12/29/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

class PhotoShareController: UIViewController {
    //
    // Variables
    //
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    var postService = PostService()
    static let newPostName = NSNotification.Name.init(rawValue: "newPost")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        renderHeaderView()
        renderRightNavigationButton()
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
    
    //
    // Right navigation button
    //
    fileprivate func renderRightNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain
            , target: self, action: #selector(onShareClick))
    }
    
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

//
// Handle sharing photo:
// * Upload image as data to Firebase Storage
// * Get download url of the image
// * Save download url to Firebase Database with pointer to user uid
//
extension PhotoShareController {
    @objc func onShareClick() {
        uploadImage { (url) in
            guard let userId = Auth.auth().currentUser?.uid else {return}
            let caption = self.textView.text ?? ""
            
            let dictionary = ["imageUrl": url, "caption": caption, "imageWidth": self.selectedImage?.size.width , "imageHeight": self.selectedImage?.size.height, "creationDate": Date().timeIntervalSince1970] as! [String: Any]
            let post = Post(user: nil, dictionary: dictionary)
            
            self.postService.createPost(userId: userId, post: post) { () in
                // Post a notification so that next view controller will
                // observe and handle data update accordingly
                NotificationCenter.default.post(name: PhotoShareController.newPostName, object: nil)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //
    // Upload image to Firebase Storage
    //
    fileprivate func uploadImage(completion: @escaping (_ url: String) -> Void) {
        guard let image = self.imageView.image else {return}
        
        let storageRef = Storage.storage().reference()
        let filename = NSUUID().uuidString
        let sharingPhotoRef = storageRef.child("post/\(filename)")
        guard let  uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        
        disableShareButton()
        
        sharingPhotoRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error in uploading image to Firebase", error)
                self.enableShareButton()
                return
            }
            
            sharingPhotoRef.downloadURL { (downloadUrl, error) in
                if let error = error {
                    print("Error in downloading url", error)
                    self.enableShareButton()
                    return
                }
                
                guard let url = downloadUrl?.absoluteString else {return}
                
                completion(url)
            }
        }
    }
}

//
// Enable and Disable Share button based on current uploading and saving process
//
extension PhotoShareController {
    fileprivate func disableShareButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    fileprivate func enableShareButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
