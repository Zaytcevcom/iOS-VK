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
    
//    var photos = [UserModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.collectionView.register(
            UINib(nibName: "PhotoCollectionCell", bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier
        )
    
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return photos.count
        return userModel?.photos.count ?? 0
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
        
//        let currentItem = photos[indexPath.item]
        let currentItem = userModel!.photos[indexPath.item]
        
        cell.configure(
            image: currentItem.image,
            countLikes: currentItem.countLikes,
            isLiked: currentItem.isLiked
        )
    
        return cell
    }

}

extension FriendsCollectionVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
    
        let spacing = 2.0
        let countItemsInRow = 3.0
        let width = (
            self.view.frame.size.width - spacing * (countItemsInRow - 1)
        ) / countItemsInRow
        
        return CGSize(width: width, height: width + 50)
    }
}
