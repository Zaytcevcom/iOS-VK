//
//  PhotoCollectionCell.swift
//  VK
//
//  Created by Konstantin Zaytcev on 26.12.2021.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var photoName: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    func configure(name: String, image: UIImage?)
    {
        self.photoName.text = name
        self.photoImage.image = image
    }
}
