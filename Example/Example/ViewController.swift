//
//  ViewController.swift
//  ButtonTest
//
//  Created by Pisen_LuoSong on 2017/9/7.
//  Copyright © 2017年 LuoSong. All rights reserved.
//

import LSPlayPauseButton
import UIKit

class ViewController: UIViewController {
    //MARK: private properties
    var iqiyiPlayPauseButton: LSPlayPauseButton?
    var youkuPlayPauseButton: LSPlayPauseButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        iqiyiPlayPauseButton = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        iqiyiPlayPauseButton?.center = CGPoint(x: view.center.x, y: view.bounds.height / 3.0)
        iqiyiPlayPauseButton?.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        view.addSubview(iqiyiPlayPauseButton!)
        
        youkuPlayPauseButton = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60), style: .youku)
        youkuPlayPauseButton?.center = CGPoint(x: view.center.x, y: view.bounds.height * 2.0 / 3.0)
        youkuPlayPauseButton?.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        view.addSubview(youkuPlayPauseButton!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @objc private func buttonClicked(_ button: LSPlayPauseButton) {
        if button == iqiyiPlayPauseButton || button == youkuPlayPauseButton {
            button.buttonState = button.buttonState == .play ? .pause : .play
        }
    }

}

