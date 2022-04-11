//
//  GroupCell.swift
//  VK
//
//  Created by Konstantin Zaytcev on 25.12.2021.
//

import UIKit
import Kingfisher

final class GroupCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    
    func configure(name: String, photo100: String)
    {
        self.groupName.text = name
        self.groupImage.kf.setImage(with: URL(string: photo100))
    }
}
