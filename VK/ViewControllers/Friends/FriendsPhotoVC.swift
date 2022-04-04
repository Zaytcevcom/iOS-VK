//
//  FriendsPhotoVC.swift
//  VK
//
//  Created by Konstantin Zaytcev on 30.03.2022.
//

import UIKit

class FriendsPhotoVC: UIViewController {

    var photos = [PhotoModel]()
    var index: Int = 0
    
    private var propertyAnimator: UIViewPropertyAnimator!
    private var isAnimated = false
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoImageHide: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImage.image = photos[index].image
        photoImage.frame.size.width = view.frame.width
        photoImageHide.frame.size.width = view.frame.width
        
        photoImage.isUserInteractionEnabled = true
        photoImageHide.isUserInteractionEnabled = true
        
        setTitle()
        setSwipeRecognizer()
    }
    
    @objc func handlerSwipe1(_ sender: UISwipeGestureRecognizer) {
        
        let duration = 0.3
        let padding = 5.0
        
        if (sender.direction == .right) {
            
            if (index <= 0) {
                return
            }
            
            photoImage.image = photos[index].image
            photoImageHide.image = photos[index - 1].image
            photoImageHide.frame.origin.x = photoImage.frame.origin.x - photoImage.frame.width - padding
            index -= 1
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: []
            ) {
                self.photoImageHide.frame.origin.x = 0
                self.photoImage.frame.origin.x = self.photoImageHide.frame.origin.x + self.photoImage.frame.width + padding
            } completion: { _ in
                self.photoImage.image = self.photos[self.index].image
                self.photoImage.frame.origin.x = 0
                self.setTitle()
            }
            
        } else if (sender.direction == .left) {
            
            if (index + 1 >= photos.count) {
                return
            }
            
            photoImage.image = photos[index].image
            photoImageHide.image = photos[index + 1].image
            photoImageHide.frame.origin.x = photoImage.frame.origin.x + photoImage.frame.width + padding
            index += 1
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: []
            ) {
                self.photoImageHide.frame.origin.x = 0
                self.photoImage.frame.origin.x = self.photoImageHide.frame.origin.x - self.photoImage.frame.width - padding
            } completion: { _ in
                self.photoImage.image = self.photos[self.index].image
                self.photoImage.frame.origin.x = 0
                self.setTitle()
            }
            
        } else if (sender.direction == .down) {
            
            self.navigationController?.popViewController(animated: true)
            //self.dismiss(animated: true, completion: nil) - без segue
        }
    
    }
    
    @objc func handlerSwipe2(_ sender: UISwipeGestureRecognizer) {
        
        let padding = 5.0
        
        if (sender.direction == .right) {
            
            if (index <= 0) {
                return
            }
            
            photoImage.image = photos[index].image
            photoImageHide.image = photos[index - 1].image
            photoImageHide.frame.origin.x = photoImage.frame.origin.x - photoImage.frame.width - padding
            index -= 1
            
        } else if (sender.direction == .left) {
            
            if (index + 1 >= photos.count) {
                return
            }
            
            photoImage.image = photos[index].image
            photoImageHide.image = photos[index + 1].image
            photoImageHide.frame.origin.x = photoImage.frame.origin.x + photoImage.frame.width + padding
            index += 1
            
        } else if (sender.direction == .down) {
            
            self.navigationController?.popViewController(animated: true)
            return
            //self.dismiss(animated: true, completion: nil) - без segue
        }
        
        UIView.animateKeyframes(
            withDuration: 0.6,
            delay: 0,
            options: []) {
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 1) {
                        self.photoImage.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                    }
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.3,
                    relativeDuration: 1) {
                        self.photoImageHide.frame.origin.x = 0
                    }
                
            } completion: { _ in
                self.photoImage.image = self.photos[self.index].image
                self.photoImage.transform = .identity
                self.setTitle()
            }
    
    }
    
    func setTitle()
    {
        title = "Фото \(index + 1) / \(photos.count)"
    }
    
    func setSwipeRecognizer()
    {
        let swipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(handlerSwipe2(_:)))
        swipeRightGR.direction = .right
        
        let swipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(handlerSwipe2(_:)))
        swipeLeftGR.direction = .left
        
        let swipeDownGR = UISwipeGestureRecognizer(target: self, action: #selector(handlerSwipe2(_:)))
        swipeDownGR.direction = .down
        
        view.addGestureRecognizer(swipeRightGR)
        view.addGestureRecognizer(swipeLeftGR)
        view.addGestureRecognizer(swipeDownGR)
    }
}
