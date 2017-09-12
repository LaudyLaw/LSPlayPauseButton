//
//  LSPlayPauseButton.swift
//  LSPlayPauseButton
//
//  Created by Pisen_LuoSong on 2017/9/7.
//  Copyright © 2017年 LuoSong. All rights reserved.
//

import UIKit

public enum PlayButtonState {
    case play
    case pause
}

public class LSPlayPauseButton: UIButton {
    
    //MARK: private properties
    fileprivate let triangleLayer = CAShapeLayer()
    fileprivate let leftLineLayer = CAShapeLayer()
    fileprivate let rightLineLayer = CAShapeLayer()
    fileprivate let circleLayer = CAShapeLayer()
    
    private var isAnimating = false
    private var frameWidth: CGFloat = 0.0
    //MARK: const vars
    fileprivate let kAnimationDuritionNormal = 0.5
    fileprivate let kAnimationDuritionPosition = 0.3
    
    fileprivate let kColorLine = UIColor(red: 12.0 / 255.0, green: 190.0 / 255.0, blue: 6.0 / 255.0, alpha: 1)
    
    fileprivate let kAnimationNameTriangle = "kAnimationNameTriangle"
    fileprivate let kAnimationNameRightLine = "kAnimationNameRightLine"
    
    //MARK: public properties
    public var buttonState = PlayButtonState.pause {
        didSet {
            if isAnimating {
                return
            }
            
            if buttonState == .play {
                isAnimating = true
                pauseToPlayLineAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionPosition, execute: { [weak self] in
                    self?.pauseToPlayNormalAnimation()
                })
            } else if buttonState == .pause {
                isAnimating = true
                playToPauseLineAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionPosition, execute: { [weak self] in
                    self?.playToPauseNormalAnimation()
                })
            }
            
            let totalAnimationDurition = kAnimationDuritionPosition + kAnimationDuritionNormal
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + totalAnimationDurition) { [weak self] in
                self?.isAnimating = false
            }
        }
    }
    
    //MARK: lifecycle
    public init(frame: CGRect, state: PlayButtonState = .play) {
        super.init(frame: frame)
        frameWidth = frame.width
        
        createUI()
        if state != buttonState {
            buttonState = state
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: private methods
    private func createUI() {
        createTriangle()
        createLeftLine()
        createRightLine()
        createCircle()
    }
    
    private func createTriangle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.2))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: 0.0))
        path.addLine(to: CGPoint(x: frameWidth, y: frameWidth * 0.5))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.2))
        
        config(layer: triangleLayer, path: path)
        triangleLayer.lineCap = kCALineCapButt
        triangleLayer.strokeEnd = 0.0
    }
    
    private func createLeftLine() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.2, y: 0.0))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth))
        
        config(layer: leftLineLayer, path: path)
    }
    
    private func createRightLine() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.8, y: 0.0))
        path.addLine(to: CGPoint(x: frameWidth * 0.8, y: frameWidth))
        
        config(layer: rightLineLayer, path: path)
    }
    
    private func createCircle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.8, y: frameWidth * 0.8))
        path.addArc(withCenter: CGPoint(x: frameWidth * 0.5, y: frameWidth * 0.8), radius: frameWidth * 0.3, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: true)
        
        config(layer: circleLayer, path: path)
        circleLayer.strokeEnd = 0.0
    }
    
    private func config(layer: CAShapeLayer, path: UIBezierPath) {
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = kColorLine.cgColor
        layer.lineWidth = frameWidth * 0.2
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(layer)
    }
    
    //MARK: Animation Implemation
    private func pauseToPlayNormalAnimation() {
        strokeEndAnimation(from: 0.0, to: 1.0, on: triangleLayer, name: kAnimationNameTriangle, duration: kAnimationDuritionNormal, delegate: self)
        strokeEndAnimation(from: 1.0, to: 0.0, on: rightLineLayer, name: kAnimationNameRightLine, duration: kAnimationDuritionNormal / 4.0, delegate: self)
        strokeEndAnimation(from: 0.0, to: 1.0, on: circleLayer, name: nil, duration: kAnimationDuritionNormal / 4.0, delegate: self)
        
        var deadline = DispatchTime.now() + kAnimationDuritionNormal * 0.25
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            self?.circleStartAnimation(from: 0.0, to: 1.0)
        }
        deadline = DispatchTime.now() + kAnimationDuritionNormal * 0.5
        DispatchQueue.main.asyncAfter(deadline: deadline) {  [weak self] in
            if let strongSelf = self {
                strongSelf.strokeEndAnimation(from: 1.0, to: 0.0, on: strongSelf.leftLineLayer, name: nil, duration: strongSelf.kAnimationDuritionNormal * 0.5, delegate: nil)
            }
        }
    }
    
    private func playToPauseNormalAnimation() {
        strokeEndAnimation(from: 1.0, to: 0.0, on: triangleLayer, name: kAnimationNameTriangle, duration: kAnimationDuritionNormal, delegate: self)
        strokeEndAnimation(from: 0.0, to: 1.0, on: leftLineLayer, name: nil, duration: kAnimationDuritionNormal * 0.5, delegate: nil)
        var deadline = DispatchTime.now() + kAnimationDuritionNormal * 0.5
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            if let strongSelf = self {
                strongSelf.circleStartAnimation(from: 1.0, to: 0.0)
            }
        }
        deadline = DispatchTime.now() + kAnimationDuritionNormal * 0.75
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            if let strongSelf = self {
                strongSelf.strokeEndAnimation(from: 0.0, to: 1.0, on: strongSelf.rightLineLayer, name: strongSelf.kAnimationNameRightLine, duration: strongSelf.kAnimationDuritionNormal * 0.25, delegate: strongSelf)
                strongSelf.strokeEndAnimation(from: 1.0, to: 0.0, on: strongSelf.circleLayer, name: nil, duration: strongSelf.kAnimationDuritionNormal * 0.25, delegate: nil)
            }
        }
    }
    
    @discardableResult private func strokeEndAnimation(from: CGFloat, to: CGFloat, on layer: CALayer, name: String?, duration: Double, delegate: CAAnimationDelegate?) -> CABasicAnimation {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = CFTimeInterval(duration)
        strokeEndAnimation.fromValue = from
        strokeEndAnimation.toValue = to
        strokeEndAnimation.fillMode = kCAFillModeForwards
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.setValue(name, forKey: "animationName")
        strokeEndAnimation.delegate = delegate
        layer.add(strokeEndAnimation, forKey: nil)
        
        return strokeEndAnimation
    }
    
    private func circleStartAnimation(from: CGFloat, to: CGFloat) {
        let circleAnimation = CABasicAnimation(keyPath: "strokeStart")
        circleAnimation.duration = kAnimationDuritionNormal * 0.25
        circleAnimation.fromValue = from
        circleAnimation.toValue = to
        circleAnimation.fillMode = kCAFillModeForwards
        circleAnimation.isRemovedOnCompletion = false
        
        circleLayer.add(circleAnimation, forKey: nil)
    }
    
    private func pauseToPlayLineAnimation() {
        let leftPath1 = UIBezierPath()
        leftPath1.move(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.4))
        leftPath1.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth))
        leftLineLayer.path = leftPath1.cgPath
        leftLineLayer.add(pathAnimation(with: kAnimationDuritionPosition * 0.5), forKey: nil)
        
        let rightPath1 = UIBezierPath()
        rightPath1.move(to: CGPoint(x: frameWidth * 0.8, y: frameWidth * 0.8))
        rightPath1.addLine(to: CGPoint(x: frameWidth * 0.8, y: -(frameWidth * 0.2)))
        rightLineLayer.path = rightPath1.cgPath
        rightLineLayer.add(pathAnimation(with: kAnimationDuritionPosition * 0.5), forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionPosition * 0.5) { [weak self] in
            if let strongSelf = self {
                let leftPath2 = UIBezierPath()
                leftPath2.move(to: CGPoint(x: strongSelf.frameWidth * 0.2, y: strongSelf.frameWidth * 0.2))
                leftPath2.addLine(to: CGPoint(x: strongSelf.frameWidth * 0.2, y: strongSelf.frameWidth * 0.8))
                strongSelf.leftLineLayer.path = leftPath2.cgPath
                strongSelf.leftLineLayer.add(strongSelf.pathAnimation(with: strongSelf.kAnimationDuritionPosition * 0.5), forKey: nil)
                
                let rightPath2 = UIBezierPath()
                rightPath2.move(to: CGPoint(x: strongSelf.frameWidth * 0.8, y: strongSelf.frameWidth * 0.8))
                rightPath2.addLine(to: CGPoint(x: strongSelf.frameWidth * 0.8, y: strongSelf.frameWidth * 0.2))
                strongSelf.rightLineLayer.path = rightPath2.cgPath
                strongSelf.rightLineLayer.add(strongSelf.pathAnimation(with: strongSelf.kAnimationDuritionPosition * 0.5), forKey: nil)
            }
        }
    }
    
    private func playToPauseLineAnimation() {
        let leftPath1 = UIBezierPath()
        leftPath1.move(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.4))
        leftPath1.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth))
        leftLineLayer.path = leftPath1.cgPath
        leftLineLayer.add(pathAnimation(with: kAnimationDuritionPosition * 0.5), forKey: nil)
        
        let rightPath1 = UIBezierPath()
        rightPath1.move(to: CGPoint(x: frameWidth * 0.8, y: frameWidth * 0.8))
        rightPath1.addLine(to: CGPoint(x: frameWidth * 0.8, y: -(frameWidth * 0.2)))
        rightLineLayer.path = rightPath1.cgPath
        rightLineLayer.add(pathAnimation(with: kAnimationDuritionPosition * 0.5), forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionPosition * 0.5) { [weak self] in
            if let strongSelf = self {
                let leftPath2 = UIBezierPath()
                leftPath2.move(to: CGPoint(x: strongSelf.frameWidth * 0.2, y: 0.0))
                leftPath2.addLine(to: CGPoint(x: strongSelf.frameWidth * 0.2, y: strongSelf.frameWidth))
                strongSelf.leftLineLayer.path = leftPath2.cgPath
                strongSelf.leftLineLayer.add(strongSelf.pathAnimation(with: strongSelf.kAnimationDuritionPosition * 0.5), forKey: nil)
                
                let rightPath2 = UIBezierPath()
                rightPath2.move(to: CGPoint(x: strongSelf.frameWidth * 0.8, y: strongSelf.frameWidth))
                rightPath2.addLine(to: CGPoint(x: strongSelf.frameWidth * 0.8, y: 0.0))
                strongSelf.rightLineLayer.path = rightPath2.cgPath
                strongSelf.rightLineLayer.add(strongSelf.pathAnimation(with: strongSelf.kAnimationDuritionPosition * 0.5), forKey: nil)
            }
        }
    }
    
    private func pathAnimation(with duration: Double) -> CABasicAnimation {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.duration = CFTimeInterval(duration)
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        
        return pathAnimation
    }
}

extension LSPlayPauseButton: CAAnimationDelegate {
    public func animationDidStart(_ anim: CAAnimation) {
        let animationName = anim.value(forKey: "animationName") as? String
        if animationName == kAnimationNameTriangle {
            triangleLayer.lineCap = kCALineCapRound
        } else if animationName == kAnimationNameRightLine {
            rightLineLayer.lineCap = kCALineCapRound
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let animationName = anim.value(forKey: "animationName") as? String
        if buttonState == .play && animationName == kAnimationNameRightLine {
            rightLineLayer.lineCap = kCALineCapButt
        } else if animationName == kAnimationNameTriangle {
            triangleLayer.lineCap = kCALineCapButt
        }
    }
}
