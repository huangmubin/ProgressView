//
//  ProgressView_Touch_Animation.swift
//  ProgressView
//
//  Created by 黄穆斌 on 2017/6/23.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

extension ProgressView {
    
    class Touch_Animation: UIView {
        
        var animation_layer_0: CALayer = CALayer()
        var animation_layer_1: CALayer = CALayer()
        var animation_layer_2: CALayer = CALayer()
        
        var animation_layers: [CALayer] {
            return [animation_layer_0, animation_layer_1, animation_layer_2]
        }
        
        // MARK: - Init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            deploy()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            deploy()
        }
        
        private func deploy() {
            self.backgroundColor = UIColor.lightGray
            self.layer.cornerRadius = bounds.width / 2
            
            for animation in animation_layers {
                animation.frame = bounds
                animation.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
                animation.cornerRadius = bounds.width / 2
                layer.addSublayer(animation)
            }
            
            self.alpha = 0
        }
        
        // MARK: - Frame
        
        override var backgroundColor: UIColor? {
            didSet {
                for animation in animation_layers {
                    animation.backgroundColor = (backgroundColor ?? UIColor.lightGray).withAlphaComponent(0.1).cgColor
                }
            }
        }
        
        override var frame: CGRect {
            didSet {
                if frame.size != oldValue.size {
                    update_size()
                }
            }
        }
        
        override var bounds: CGRect {
            didSet {
                if bounds.size != oldValue.size {
                    update_size()
                }
            }
        }
        
        func update_size() {
            for animation in animation_layers {
                animation.frame = CGRect(
                    x: (bounds.width - animation.bounds.width) / 2,
                    y: (bounds.height - animation.bounds.height) / 2,
                    width: animation.bounds.width,
                    height: animation.bounds.height
                )
                animation.cornerRadius = bounds.width / 2
            }
        }
        
        // MARK: - Animation
        
        func animation_start() {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
            })
            
            let group = CAAnimationGroup()
            
            let scale = CABasicAnimation(keyPath: "transform.scale")
            scale.fromValue = 1
            scale.toValue   = 6
            
            let opacity = CABasicAnimation(keyPath: "opacity")
            opacity.fromValue = 1
            opacity.toValue = 0
            
            group.animations = [scale, opacity]
            group.duration = 0.8
            group.repeatCount = 10000
            
            DispatchQueue.global().async {
                for animation in self.animation_layers {
                    DispatchQueue.main.async {
                        animation.add(group, forKey: nil)
                    }
                    Thread.sleep(forTimeInterval: 0.25)
                }
            }
        }
        
        func animation_end() {
            for animation in self.animation_layers {
                animation.removeAllAnimations()
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
    
}
