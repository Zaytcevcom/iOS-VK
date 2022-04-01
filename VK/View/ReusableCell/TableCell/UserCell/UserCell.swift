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
    
    func configure(firstName: String, lastName: String, image: UIImage?)
    {
        self.userName.text = lastName + " " + firstName
        self.userImage.image = image
        
        let longGR = UILongPressGestureRecognizer(target: self, action: #selector(handlerLongPress(_:)))
        userImage.addGestureRecognizer(longGR)
        userImage.isUserInteractionEnabled = true
    }
    
    @objc func handlerLongPress(_ sender: UILongPressGestureRecognizer)
    {
        if (sender.state == .began) {
            
            UIView.animate(
                withDuration: 0.2,
                delay: 0) {
                    self.userImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                } completion: { _ in
                    
                    UIView.animate(
                        withDuration: 1,
                        delay: 0,
                        usingSpringWithDamping: 0.3,
                        initialSpringVelocity: 0.4
                    ) {
                        self.userImage.transform = .identity
                    }
                }
        }
    }
}
