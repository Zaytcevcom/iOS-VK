//
//  PhotoCollectionCell.swift
//  VK
//
//  Created by Konstantin Zaytcev on 26.12.2021.
//

import UIKit
import Kingfisher

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
    
    func configure(model: PhotoModel)
    {
        self.photoImage.kf.setImage(with: URL(string: (model.sizes.last?.url)!))
        self.isLiked.setTitle(" \(model.likes.count)", for: .normal)
        self.isLiked.setTitleColor(.gray, for: .normal)
        
        if (model.likes.userLikes == 1) {
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
     
        UIView.performWithoutAnimation {
            
            if (isLiked) {
                self.isLiked.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                countLikes += 1
            } else {
                self.isLiked.setImage(UIImage(systemName: "heart"), for: .normal)
                countLikes -= 1
            }
    
            self.isLiked.setTitle(" \(countLikes)", for: .normal)
            self.isLiked.layoutIfNeeded()
            
            UIImageView.animate(
                withDuration: 0.2,
                delay: 0) {
                    self.isLiked.imageView!.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                } completion: { _ in
                    
                    UIView.animate(
                        withDuration: 1,
                        delay: 0,
                        usingSpringWithDamping: 0.3,
                        initialSpringVelocity: 0.4
                    ) {
                        self.isLiked.imageView!.transform = .identity
                    }
                }
        }
        
        

    }
    
}
