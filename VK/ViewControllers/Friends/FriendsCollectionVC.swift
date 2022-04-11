//
//  FriendsCollectionViewController.swift
//  VK
//
//  Created by Konstantin Zaytcev on 18.12.2021.
//

import UIKit

private let reuseIdentifier = "photoCollectionCell"

class FriendsCollectionVC: UICollectionViewController {

    var userId: Int = 0
    var photos = [PhotoModel]()
    
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.collectionView.register(
            UINib(nibName: "PhotoCollectionCell", bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier
        )
        
        networkService.methodPhotosGet(userId: userId) { [weak self] result in
            switch result {
            case .success(let items):
                self?.photos = items
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
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
        
        cell.configure(model: currentItem)
    
        return cell
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        
        guard
            segue.identifier == "slidePhoto",
            let indexPath = collectionView.indexPathsForSelectedItems?.first
        else {
            return
        }
        
        guard
            let destination = segue.destination as? FriendsPhotoVC
        else {
            return
        }
        
        destination.photos = photos
        destination.index = indexPath.item
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        performSegue(withIdentifier: "slidePhoto", sender: nil)
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
