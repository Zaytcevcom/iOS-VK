//
//  FriendsPhotoVC.swift
//  VK
//
//  Created by Konstantin Zaytcev on 30.03.2022.
//

import UIKit
import Alamofire

class FriendsPhotoVC: UIViewController {

    var photos = [PhotoModel]()
    var index: Int = 0
    
    private var propertyAnimator: UIViewPropertyAnimator!
    private var isAnimated = false
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoImageHide: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImage.kf.setImage(with: URL(string: (photos[index].sizes.last?.url)!))
        photoImage.frame.size.width = view.frame.width
        photoImageHide.frame.size.width = view.frame.width
        
        photoImage.isUserInteractionEnabled = true
        photoImageHide.isUserInteractionEnabled = true
        
        setTitle()
        setSwipeRecognizer()
    }
    
    @objc func handlerSwipe(_ sender: UISwipeGestureRecognizer) {
        
        let padding = 5.0
        
        if (sender.direction == .right) {
            
            if (index <= 0) {
                return
            }
            
            photoImage.kf.setImage(with: URL(string: (photos[index].sizes.last?.url)!))
            photoImageHide.kf.setImage(with: URL(string: (photos[index - 1].sizes.last?.url)!))
            photoImageHide.frame.origin.x = photoImage.frame.origin.x - photoImage.frame.width - padding
            index -= 1
            
        } else if (sender.direction == .left) {
            
            if (index + 1 >= photos.count) {
                return
            }
            
            photoImage.kf.setImage(with: URL(string: (photos[index].sizes.last?.url)!))
            photoImageHide.kf.setImage(with: URL(string: (photos[index + 1].sizes.last?.url)!))
            photoImageHide.frame.origin.x = photoImage.frame.origin.x + photoImage.frame.width + padding
            index += 1
            
        } else if (sender.direction == .down) {
            
            self.navigationController?.popViewController(animated: true)
            return
            //self.dismiss(animated: true, completion: nil) - без segue
        }
        
        UIView.animateKeyframes(
            withDuration: 0.5,
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
                self.photoImage.kf.setImage(with: URL(string: (self.photos[self.index].sizes.last?.url)!))
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
        let swipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(handlerSwipe(_:)))
        swipeRightGR.direction = .right
        
        let swipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(handlerSwipe(_:)))
        swipeLeftGR.direction = .left
        
        let swipeDownGR = UISwipeGestureRecognizer(target: self, action: #selector(handlerSwipe(_:)))
        swipeDownGR.direction = .down
        
        view.addGestureRecognizer(swipeRightGR)
        view.addGestureRecognizer(swipeLeftGR)
        view.addGestureRecognizer(swipeDownGR)
    }
}
