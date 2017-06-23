//
//  ViewController.swift
//  ProgressView
//
//  Created by Myron on 2017/6/16.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progress_view: ProgressView!
    
    @IBOutlet weak var slider_label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBAction func slider_action(_ sender: UISlider) {
        slider_label.text = "\(sender.value)"
        progress_view.value = CGFloat(sender.value)
    }
    
    @IBAction func run_timer(_ sender: UIButton) {
        progress_view.timer_run()
    }
    
    @IBAction func end_timer(_ sender: UIButton) {
        progress_view.timer_end()
    }

}

class TableViewController: UITableViewController {
    
    
}
