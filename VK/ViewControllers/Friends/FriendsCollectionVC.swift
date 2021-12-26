//
//  FriendsCollectionViewController.swift
//  VK
//
//  Created by Konstantin Zaytcev on 18.12.2021.
//

import UIKit

private let reuseIdentifier = "photoCollectionCell"

class FriendsCollectionVC: UICollectionViewController {

    var userModel: UserModel?
    var photos = [UserModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.collectionView.register(
            UINib(nibName: "PhotoCollectionCell", bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier
        )
        
        if (userModel != nil) {
            photos.append(userModel!)
        }
    
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            ) as? PhotoCollectionCell
        else {
            return UICollectionViewCell()
        }
        
        let currentItem = photos[indexPath.item]
        
        cell.configure(
            name: currentItem.name,
            image: currentItem.image
        )
    
        return cell
    }

}
