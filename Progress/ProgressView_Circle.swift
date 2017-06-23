//
//  ProgressView_Circle.swift
//  ProgressBar
//
//  Created by Myron on 2017/6/16.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class ProgressView_Circle: ProgressView {

    // MARK: - Datas
    
    /** 倒数圈外圈距离 */
    @IBInspectable var space_outer: CGFloat = 2
    /** 倒数圈厚度 */
    @IBInspectable var space_width: CGFloat = 8
    
    /** 信息标签 */
    @IBOutlet var info_label: UILabel! = UILabel() {
        didSet {
            info_label.removeFromSuperview()
            addSubview(info_label)
        }
    }
    
    // MARK: - Sub Views Override Actions
    
    override func deploy_at_init() {
        DispatchQueue.main.async {            
            self.addSubview(self.info_label)
            self.info_label.textColor = UIColor.black
            self.info_label.sizeToFit()
        }
    }
    
    /** SubView: 更新背景图层操作 */
    override func update_background() {
        var layer: CALayer
        if let back = get(layer: "background") {
            layer = back
        }
        else {
            layer = CALayer()
            add(layer: layer, key: "background")
        }
        layer.frame = bounds
        layer.cornerRadius = bounds.width / 2
        layer.backgroundColor = color_back.cgColor
        
        info_label.center = CGPoint(
            x: bounds.width / 2, 
            y: bounds.height / 2
        )
    }
    
    // MARK: - Gesture
    
    /** 拖拽事件 */
    override func pan_action(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            break
        default:
            break
        }
        super.pan_action(sender)
    }
    
}
