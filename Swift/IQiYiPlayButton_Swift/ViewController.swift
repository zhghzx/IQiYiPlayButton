//
//  ViewController.swift
//  IQiYiPlayButton_Swift
//
//  Created by zhangxing on 2017/12/8.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btn = IQiYiPlayButton.init(frame: CGRect(x: 100.0, y: 100.0, width: 50.0, height: 50.0), state: .pause)
        btn.addTarget(self, action: #selector(btnHandle(btn:)), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func btnHandle(btn: IQiYiPlayButton) {
        //这个判断是必须的
        if btn.isAnimating {
            return
        }
        if btn.buttonState == .play {
            btn.buttonState = .pause
        } else {
            btn.buttonState = .play
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

