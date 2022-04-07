//
//  NavigationAnimators.swift
//  VK
//
//  Created by Konstantin Zaytcev on 03.04.2022.
//

import UIKit

final class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animateTime = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animateTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else {return}
        
        transitionContext.containerView.addSubview(destination.view)
        
        destination.view.frame = transitionContext.containerView.frame
        
        
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.frame.origin.y = 0
        destination.view.frame.origin.x = 0
        
        let transform = CGAffineTransform(rotationAngle: -1 * .pi / 2)
        destination.view.transform = transform
        
        UIView.animateKeyframes(
            withDuration: animateTime,
            delay: 0.0,
            options: .calculationModePaced) {
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.1) {
                        destination.view.transform = .identity
                    }
                
            } completion: { isComplete in
                transitionContext.completeTransition(isComplete && !transitionContext.transitionWasCancelled)
            }
    }
    
    
}

final class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animateTime = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animateTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else {return}
        
        transitionContext.containerView.insertSubview(destination.view, belowSubview: source.view)
        
        UIView.animateKeyframes(
            withDuration: animateTime,
            delay: 0.0,
            options: .calculationModePaced) {
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.1) {
                        
                        source.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
                        source.view.frame.origin.y = 0
                        source.view.frame.origin.x = 0
                        
                        let transform = CGAffineTransform(rotationAngle: -1 * .pi / 2)
                        source.view.transform = transform
                    }
                
            } completion: { isComplete in
                transitionContext.completeTransition(isComplete && !transitionContext.transitionWasCancelled)
            }
    }
    
    
}
