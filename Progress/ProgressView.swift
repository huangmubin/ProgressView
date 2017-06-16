//
//  ProgressView.swift
//  ProgressBar
//
//  Created by Myron on 2017/6/15.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

// MARK: - Progress View Delegate

/** 进度视图代理协议 */
@objc protocol ProgressView_Delegate {
    
    /** 点击事件回调 */
    @objc optional func progress(view: ProgressView, gesture_tap_action: UITapGestureRecognizer)
    /** 拖拽事件回调 */
    @objc optional func progress(view: ProgressView, gesture_pan_action: UIPanGestureRecognizer)
    
    /** 值变化事件回调 */
    @objc optional func progress(view: ProgressView, value_changed value: CGFloat)
    /** 值变化时 Info_label 的调整 */
    @objc optional func progress(view: ProgressView, info_label_change value: CGFloat) -> String
}

// MARK: - Progress View

/** 
 进度视图基类，基本断定视图各个图层内容。
 */
class ProgressView: UIView {
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect.zero)
        deploy()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        deploy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        deploy()
    }
    
    private func deploy() {
        tap_gesture = UITapGestureRecognizer(target: self, action: #selector(tap_action(_:)))
        pan_gesture = UIPanGestureRecognizer(target: self, action: #selector(pan_action(_:)))
        addGestureRecognizer(tap_gesture)
        addGestureRecognizer(pan_gesture)
        
        DispatchQueue.main.async {
            self.deploy_at_init()
            self.update_background()
            self.update_content()
            self.update_progress(value: 0)
        }
    }
    
    deinit {
        timer_end()
    }
    
    // MARK: - Override
    
    override var frame: CGRect {
        didSet {
            if frame.size != oldValue.size {
                update_background()
                update_content()
            }
        }
    }
    
    override var bounds: CGRect {
        didSet {
            if bounds.size != oldValue.size {
                update_background()
                update_content()
            }
        }
    }
    
    // MARK: - Datas
    
    /** 进度值，范围： 0 ... 1 */
    private var _value: CGFloat = 0 {
        didSet {
            if _value != oldValue {
                update_progress(value: _value)
                delegate?.progress?(
                    view: self,
                    value_changed: _value
                )
            }
        }
    }
    /** 进度值，范围： 0 ... 1 */
    final var value: CGFloat {
        set {
            _value = newValue < 0 ? 0 : (newValue > 1 ? 1 : newValue)
        }
        get {
            return _value
        }
    }
    
    /** 代理对象 */
    @IBOutlet weak var delegate_link: NSObject?
    /** 代理对象 */
    var delegate: ProgressView_Delegate? {
        return delegate_link as? ProgressView_Delegate
    }
    
    // MARK: - Sub Layers
    
    /** layers 关系 */
    private var content_layers: [String: CALayer] = [:]
    
    /** 添加子 layer */
    final func add(layer: CALayer, key: String) {
        self.layer.addSublayer(layer)
        content_layers[key] = layer
    }
    
    /** 获取 CALayer */
    final func get(layer key: String) -> CALayer? {
        return content_layers[key]
    }
    
    /** 获取 CAShapeLayer */
    final func get(shape_layer key: String) -> CAShapeLayer? {
        return content_layers[key] as? CAShapeLayer
    }
    
    /** 删除 layer */
    final func clear(condition: ((String, CALayer) -> Bool)?) {
        if let condition = condition {
            for (key, layer) in content_layers {
                if condition(key, layer) {
                    layer.removeFromSuperlayer()
                    content_layers[key] = nil
                }
            }
        }
        else {
            for (_, layer) in content_layers {
                layer.removeFromSuperlayer()
            }
            content_layers.removeAll()
        }
    }
    
    // MARK: - Gesture
    
    /** 单击事件 */
    var tap_gesture: UITapGestureRecognizer!
    /** 拖拽事件 */
    var pan_gesture: UIPanGestureRecognizer!
    
    /** 单击事件 */
    func tap_action(_ sender: UITapGestureRecognizer) {
        delegate?.progress?(
            view: self,
            gesture_tap_action: sender
        )
    }
    
    /** 拖拽事件 */
    func pan_action(_ sender: UIPanGestureRecognizer) {
        delegate?.progress?(
            view: self,
            gesture_pan_action: sender
        )
    }
    
    // MARK: - Timer
    
    /** 计时器调用的间距时间.(单位：毫秒) */
    @IBInspectable var timer_step: Int = 1000
    
    /** 计时器的最大时长.(单位：毫秒) */
    @IBInspectable var timer_long: Int = 60000
    
    /** 计时器 */
    private var timer: DispatchSourceTimer?
    
    /** 计时器运行 */
    final func timer_run() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(
                flags: DispatchSource.TimerFlags(rawValue: 1),
                queue: DispatchQueue.main
            )
            timer?.scheduleRepeating(
                wallDeadline: DispatchWallTime.now(),
                interval: DispatchTimeInterval.milliseconds(timer_step)
            )
            timer?.setEventHandler(handler: { [weak self] in
                if let step = self?.timer_step, let long = self?.timer_long {
                    self?.value += (CGFloat(step) / CGFloat(long))
                }
            })
            timer?.resume()
        }
    }
    
    /** 计时器停止 */
    final func timer_end() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    // MARK: - Colors
    
    /** 主题颜色 */
    @IBInspectable var color_tint: UIColor = UIColor.black
    /** 辅助颜色 */
    @IBInspectable var color_sub: UIColor = UIColor.lightGray
    /** 背景颜色 */
    @IBInspectable var color_back: UIColor = UIColor.white
    /** 边线颜色 */
    @IBInspectable var color_line: UIColor = UIColor.black
    /** 其他颜色 */
    @IBInspectable var color_other: UIColor = UIColor.blue
    
    // MARK: - Sub Views Override Actions
    
    /** 更新整个界面 */
    func update() {
        update_background()
        update_content()
        update_progress(value: value)
    }
    
    /** SubView: 初始化操作，只在视图加载的时候调用一次 */
    func deploy_at_init() { }
    /** SubView: 更新背景图层操作 */
    func update_background() { }
    /** SubView: 更新内容图层操作 */
    func update_content() { }
    /** SubView: 更新颜色 */
    func update_colors() { }
    /** SubView: 更新内容图层操作 */
    func update_progress(value: CGFloat) { }
    
    
}
