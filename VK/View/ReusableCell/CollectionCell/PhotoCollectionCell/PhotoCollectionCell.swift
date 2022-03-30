//
//  PhotoCollectionCell.swift
//  VK
//
//  Created by Konstantin Zaytcev on 26.12.2021.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var isLiked: UIButton!
    
    var likedPhoto: Int = 0
    
    func configure(image: UIImage?, countLikes: Int, isLiked: Bool)
    {
        self.photoImage.image = image
        self.isLiked.setTitle(" \(countLikes)", for: .normal)
        self.isLiked.setTitleColor(.gray, for: .normal)
        
        if (isLiked) {
            self.isLiked.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.isLiked.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        self.isLiked.addTarget(self, action: #selector(likedPhoto(_:)), for: .touchUpInside)
    }
    
    @objc func likedPhoto(_ sender: UIButton)
    {
        let isLiked = !(sender.currentImage == UIImage(systemName: "heart.fill"))
        var countLikes = Int(sender.currentTitle!.trimmingCharacters(in: CharacterSet.whitespaces)) ?? 0
     
        if (isLiked) {
            self.isLiked.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            countLikes += 1
        } else {
            self.isLiked.setImage(UIImage(systemName: "heart"), for: .normal)
            countLikes -= 1
        }
        
        self.isLiked.setTitle(" \(countLikes)", for: .normal)
    }
    
}
