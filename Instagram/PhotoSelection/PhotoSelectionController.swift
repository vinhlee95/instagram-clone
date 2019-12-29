//
//  PhotoSelectionController.swift
//  Instagram
//
//  Created by Vinh Le on 12/28/19.
//  Copyright © 2019 Vinh Le. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectionController: UICollectionViewController {
    //
    // Variables
    //
    private let cellsPerRow: CGFloat = 4
    private let cellId = "cellId"
    private let sectionInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    private let headerId = "headerId"
    private var photosLimit = 20
    var images = [UIImage]()
    var selectedImage: UIImage?
    var photoAssets = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .green
        
        renderNavigationButtons()
        collectionView.register(PhotoSelectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoSelectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        fetchPhotos()
    }
    
    fileprivate func renderNavigationButtons() {
        navigationController?.navigationBar.tintColor = .darkGray
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancelButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(onNextButtonClick))
    }
    
    @objc func onCancelButtonClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onNextButtonClick() {
        dismiss(animated: true, completion: nil)
    }
}

//
// Configure cells for photo collection view
//
extension PhotoSelectionController {
    // Total amount of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // Create individual cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectionCell
        cell.photoImageView.image = images[indexPath.row]
        
        return cell
    }
}

//
// Configure sizing and insets for cell collection view
//
extension PhotoSelectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - cellsPerRow) / cellsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

//
// Configure header
//
extension PhotoSelectionController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectionCell
        header.photoImageView.image = self.selectedImage
        
        // Render header image with high resolution
        // e.g higher target sizes
        
        // Get index of the selected image
        guard let selectedImage = self.selectedImage else {return header}
        let index = images.firstIndex(of: selectedImage)
        
        // Get asset with corresponding index
        guard let selectedIndex = index else {return header}
        let selectedAsset = photoAssets[selectedIndex]
        
        // Request image with higher resolution from the asset
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 600, height: 600), contentMode: .default, options: nil) { (highResImage, hash) in
            header.photoImageView.image = highResImage
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
}

//
// Fetch photos from image library
//
extension PhotoSelectionController {
    fileprivate func fetchPhotos() {
        let options = getFetchOptions()
        let photoAssets = PHAsset.fetchAssets(with: .image, options: options)
        
        // Iterate through fetched photo assets
        // Get the image out of each asset by using PHImageManager
        // Store images in the images array
        photoAssets.enumerateObjects { (asset, count, stop) in
            let targetSize = CGSize(width: 200, height: 200)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, info) in
                guard let image = image else {return}
                self.images.append(image)
                self.photoAssets.append(asset)
                if(self.selectedImage == nil) {
                    self.selectedImage = image
                }
                
                if(count == photoAssets.count - 1) {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    fileprivate func getFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        options.fetchLimit = photosLimit
        
        // Sort images by creation date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
}

//
// Select 1 photo
//
extension PhotoSelectionController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
    }
}
