//
//  ProgressView_Circle_Calibration.swift
//  ProgressBar
//
//  Created by Myron on 2017/6/16.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class ProgressView_Circle_Calibration: ProgressView_Circle {
    
    // MARK: - Data
    
    /** 刻度的数量 */
    @IBInspectable var calibration_count: Int = 72
    
    @IBInspectable var calibration_width: CGFloat = 1
    
    // MARK: - Sub Views Override Actions
    
    /** SubView: 初始化操作，只在视图加载的时候调用一次 */
    override func deploy_at_init() {
        super.deploy_at_init()
        self.backgroundColor = UIColor.clear
    }
    
    /** SubView: 更新内容图层操作 */
    override func update_content() {
        clear(condition: { (key, layer) in
            return key.hasPrefix("content_layer")
        })
        let angle = CGFloat.pi * 2 / CGFloat(calibration_count)
        for i in 0 ..< calibration_count {
            let path = UIBezierPath()
            path.move(
                to: CGPoint(
                    x: bounds.width / 2,
                    y: space_outer
                )
            )
            path.addLine(
                to: CGPoint(
                    x: bounds.width / 2,
                    y: space_outer + space_width
                )
            )
            path.lineCapStyle = CGLineCap.square
            
            let shape = CAShapeLayer()
            shape.frame = bounds
            shape.path = path.cgPath
            shape.lineWidth = calibration_width
            shape.lineCap = kCALineCapRound
            shape.strokeColor = color_tint.cgColor
            shape.setAffineTransform(
                CGAffineTransform(rotationAngle: CGFloat(i) * angle)
            )
            
            add(layer: shape, key: "content_layer_\(i)")
        }
    }
    /** SubView: 更新颜色 */
    override func update_colors() {
        get(layer: "background")?.backgroundColor = color_back.cgColor
        let time = Int(value * CGFloat(calibration_count) + 0.5)
        for i in 0 ..< time {
            get(shape_layer: "content_layer_\(i)")?.strokeColor  = color_tint.cgColor
        }
        for i in time ..< calibration_count {
            get(shape_layer: "content_layer_\(i)")?.strokeColor  = color_sub.cgColor
        }
    }
    /** SubView: 更新内容图层操作 */
    override func update_progress(value: CGFloat) {
        let time = Int(value * CGFloat(calibration_count) + 0.5)
        for i in 0 ..< time {
            get(shape_layer: "content_layer_\(i)")?.strokeColor  = color_tint.cgColor
        }
        for i in time ..< calibration_count {
            get(shape_layer: "content_layer_\(i)")?.strokeColor  = color_sub.cgColor
        }
        
        if let text = delegate?.progress?(view: self, info_label_change: value) {
            info_label.text = text
            info_label.sizeToFit()
            info_label.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        }
        else {
            let min = Int(value * CGFloat(timer_long) / 60000)
            let sec = Int(value * CGFloat(timer_long) / 1000) % 60
            info_label.text = "\(min > 9 ? "\(min)" : "0\(min)") : \(sec > 9 ? "\(sec)" : "0\(sec)")"
            info_label.sizeToFit()
            info_label.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        }
    }
    
    

}
