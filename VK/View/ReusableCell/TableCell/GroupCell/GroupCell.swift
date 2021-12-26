//
//  GroupCell.swift
//  VK
//
//  Created by Konstantin Zaytcev on 25.12.2021.
//

import UIKit

final class GroupCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    
    func configure(name: String, image: UIImage?)
    {
        self.groupName.text = name
        self.groupImage.image = image
    }
}
