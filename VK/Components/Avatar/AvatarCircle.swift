//
//  AvatarCircle.swift
//  VK
//
//  Created by Konstantin Zaytcev on 03.01.2022.
//

import UIKit

@IBDesignable class AvatarCircle: UIImageView {
    
    @IBInspectable var borderColor: UIColor = .gray
    @IBInspectable var borderWidth: CGFloat = 1.5
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
