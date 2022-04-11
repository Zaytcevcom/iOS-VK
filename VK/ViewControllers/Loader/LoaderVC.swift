//
//  LoaderVC.swift
//  VK
//
//  Created by Konstantin Zaytcev on 27.03.2022.
//

import UIKit

class LoaderVC: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view1.layer.cornerRadius = view1.frame.height / 2
        view2.layer.cornerRadius = view2.frame.height / 2
        view3.layer.cornerRadius = view3.frame.height / 2
        
        blockLoader()
        // Do any additional setup after loading the view.
    }
    
    let loopMax = 1
    var loopCount = 0
    
    func blockLoader()
    {
        let duration = 0.3
        let color: UIColor = .clear
        let colorSecond: UIColor = UIColor(
            red: 51 / 255,
            green: 150 / 255,
            blue: 255 / 255,
            alpha: 1
        )
        
        UIView.transition(
            with: view1,
            duration: duration,
            options: []
        ) {
            self.view1.backgroundColor = colorSecond
        } completion: { isCompleted in
            
            // End point 1
            UIView.transition(
                with: self.view1,
                duration: duration,
                options: []
            ) {
                self.view1.backgroundColor = color
            } completion: { isCompleted in
                
            }
            
            // Start point 2
            UIView.transition(
                with: self.view2,
                duration: duration,
                options: []
            ) {
                self.view2.backgroundColor = colorSecond
            } completion: { isCompleted in
                
                UIView.transition(
                    with: self.view2,
                    duration: duration,
                    options: []
                ) {
                    self.view2.backgroundColor = color
                } completion: { isCompleted in
                    
                    // End point 2
                    UIView.transition(
                        with: self.view2,
                        duration: duration,
                        options: []
                    ) {
                        self.view2.backgroundColor = color
                    } completion: { isCompleted in
                        
                    }
                    
                }
                
                // Start point 3
                UIView.transition(
                    with: self.view3,
                    duration: duration,
                    options: []
                ) {
                    self.view3.backgroundColor = colorSecond
                } completion: { isCompleted in
                    
                    UIView.transition(
                        with: self.view3,
                        duration: duration,
                        options: []
                    ) {
                        self.view3.backgroundColor = color
                    } completion: { isCompleted in
                        
                        self.loopCount += 1
                        
                        if (self.loopCount < self.loopMax) {
                            self.blockLoader()
                            return
                        }
                        
                        self.performSegue(withIdentifier: "toLogin", sender: nil)
                        
                    }
                }
            }
        }
    }

}
