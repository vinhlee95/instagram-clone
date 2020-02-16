//
//  Extensions.swift
//  Instagram
//
//  Created by Vinh Le on 11/17/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, width: CGFloat?, height: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true;
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true;
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true;
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true;
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UILabel {
    func addAttributeText(primaryText: String, secondaryText: String) {
        let attributedText = NSMutableAttributedString(string: "\(primaryText)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                
        attributedText.append(NSAttributedString(string: secondaryText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
    
        self.attributedText = attributedText
        self.numberOfLines = 0
        self.textAlignment = NSTextAlignment.center
    }
}

//
// Set image for an image view based on url
//
var imageCache = [String: UIImage]()

extension UIImageView {
    func download(from url: String, _ origin: String? = nil) {
        guard let url = URL(string: url) else {return}
        
        if let cachedImage = imageCache[url.absoluteString] {
            self.image = imageCache[url.absoluteString]
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error in downloading image", error)
                return
            }
            
            // Prevent async image rendering to change orders
            if url.absoluteString != origin {
                return
            }
            
            guard let data = data else {return}
            let dataImage = UIImage(data: data)
            
            imageCache[url.absoluteString] = dataImage
            
            DispatchQueue.main.async {
                guard let image = dataImage else {return}
                self.image = image
            }
        }.resume()
    }
}
