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
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .green
        
        renderNavigationButtons()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
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
    // Number of cells per row
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(cellsPerRow)
    }
    
    // Create the cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        
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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        header.backgroundColor = .blue
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
}

//
// Fetch photos from iPhone
//
extension PhotoSelectionController {
    fileprivate func fetchPhotos() {
        let options = PHFetchOptions()
        options.fetchLimit = 10
        let photoAssets = PHAsset.fetchAssets(with: .image, options: options)
        
        photoAssets.enumerateObjects { (asset, count, stop) in
            let targetSize = CGSize(width: 200, height: 200)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, info) in
                guard let image = image else {return}
                self.images.append(image)
                
                if(count == photoAssets.count - 1) {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
