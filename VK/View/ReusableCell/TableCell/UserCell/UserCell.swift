//
//  UserCell.swift
//  VK
//
//  Created by Konstantin Zaytcev on 25.12.2021.
//

import UIKit

final class UserCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    func configure(name: String, image: UIImage?)
    {
        self.userName.text = name
        self.userImage.image = image
    }
}
