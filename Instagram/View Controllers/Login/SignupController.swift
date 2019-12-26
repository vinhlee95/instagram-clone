//
//  ViewController.swift
//  Instagram
//
//  Created by Vinh Le on 11/17/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleUploadProfileImage() {
       let imagePickerController = UIImagePickerController()
       imagePickerController.delegate = self
       imagePickerController.allowsEditing = true
       imagePickerController.mediaTypes = ["public.image"]
       
       self.present(imagePickerController, animated: true, completion: nil)
   }
}

class SignupController: UIViewController {
    
    // Plus button
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plush_photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleUploadProfileImage), for: .touchUpInside)
        
        return button
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage, for: .normal)
        } else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage, for: .normal)
        }
        
        // Add styling for the image button
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
    
    // User name text field
    let usernameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "User name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textfield.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    // Email text field
    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your email"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textfield.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    // Password text field
    let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textfield.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    // Sign up button
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleInputChange() {
        let isEmailValid = !emailTextField.text!.isEmpty
        let isPasswordValid = !passwordTextField.text!.isEmpty
        let isUsernameValid = !usernameTextField.text!.isEmpty
        
        // Disable the button and add disabled-blue background color
        guard isEmailValid && isPasswordValid && isUsernameValid else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            return
        }
        
        // Enable the button and add bolder blue background
        signupButton.isEnabled = true
        signupButton.backgroundColor = UIColor.rgb(red: 77, green: 166, blue: 255)
    }
    
    @objc func handleSignup() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let profileImage = plusPhotoButton.imageView?.image else {return}
        guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
                self.handleError(error: err, title: "Sign up failed")
                return
            }

            let user = authResult!.user
            print("User created: \(user.uid)")
            
            // Upload profile image
            self.uploadImage(uploadData) { (profileImageUrl) in
                self.saveUserData(user, profileImageUrl, completion: {
                    // Setup view controller
                    let mainTabBarController = UIApplication.shared.windows.first!.rootViewController as! MainTabBarController
                    mainTabBarController.setupViewController()
                    
                    // Go to user profile view
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    let toLoginButton: UIButton = {
        let toLoginButton = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already had an account? ", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray
        ])
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.rgb(red: 77, green: 166, blue: 255)
        ]))
        toLoginButton.setAttributedTitle(attributedTitle, for: .normal)
        toLoginButton.addTarget(self, action: #selector(onToLoginButtonClick), for: .touchUpInside)
        
        return toLoginButton
    }()
    
    @objc func onToLoginButtonClick() {
        let loginController = LoginController()
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton)
        view.backgroundColor = .white
        
        plusPhotoButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 40, paddingBottom: 60, paddingLeft: 0, paddingRight: 0, width: 140, height: 160)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        // Init input text fields
        setInputFields()
        
        // Render to login view button
        view.addSubview(toLoginButton)
        toLoginButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -20, paddingLeft: 20, paddingRight: 20, width: nil, height: nil)
    }
    
    func handleError(error: Error, title: String) {
        print("ERROR \(error.localizedDescription)")
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setInputFields() {
        // create a stack view
        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField, emailTextField, passwordTextField, signupButton
        ])
    
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        // Add Stack view to view
        view.addSubview(stackView)
        
        // Add constraints
        stackView.anchor(top: plusPhotoButton.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: nil, height: 160)
    }
    
    func uploadImage(_ imageData: Data, completion: @escaping (_ uploadedUrl: String) -> Void) {
        let profileImageName = NSUUID().uuidString
        
        Storage.storage().reference().child("profile_images").child(profileImageName).putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error in uploading user profile image", error)
                return
            }
            
            let imagesRef = Storage.storage().reference().child("profile_images")
            let spaceRef = imagesRef.child("/\(profileImageName)")
            
            spaceRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error in getting profile image download url", error)
                }
                
                guard let profileImageUrl = url?.absoluteString else {return}
                
                completion(profileImageUrl)
            }
        }
    }
    
    func saveUserData(_ user: Any, _ profileImageUrl: String, completion: @escaping () -> Void) {
        let values = ["username": usernameTextField.text ?? "", "avatar_url": profileImageUrl] as [String : Any]
        
        Database.database().reference().child("users").child((user as AnyObject).uid).setValue(values)
        {
            (error, erf) in
            if let err = error {
                print("Fail to save user data", err)
                return
            }
            
            print("Saved user data to the database")
            completion()
        }
    }
}
