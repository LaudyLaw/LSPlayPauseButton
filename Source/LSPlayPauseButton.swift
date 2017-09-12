//
//  LSPlayPauseButton.swift
//  LSPlayPauseButton
//
//  Created by Pisen_LuoSong on 2017/9/7.
//  Copyright © 2017年 LuoSong. All rights reserved.
//

import UIKit


/// The style of play pause button
///
/// - iqiyi: iqiyi (http://www.iqiyi.com)
/// - youku: youku (http://www.youku.com)
public enum LSPlayButtonStyle {
    case iqiyi
    case youku
}

/// The state of play pause button
///
/// - play: play
/// - pause: pause
public enum LSPlayButtonState {
    case play
    case pause
}

public class LSPlayPauseButton: UIButton {
    
    //MARK: private properties
    fileprivate let triangleLayer = CAShapeLayer()
    fileprivate let leftLineLayer = CAShapeLayer()
    fileprivate let rightLineLayer = CAShapeLayer()
    fileprivate let circleLayer = CAShapeLayer()
    
    fileprivate let youkuLeftLineLayer = CAShapeLayer()
    fileprivate let youkuLeftCircleLayer = CAShapeLayer()
    fileprivate let youkuRightLineLayer = CAShapeLayer()
    fileprivate let youkuRightCircleLayer = CAShapeLayer()
    
    fileprivate let youkuTriangleLayer = CALayer()
    
    private var isAnimating = false
    private var frameWidth: CGFloat = 0.0
    fileprivate var buttonStyle: LSPlayButtonStyle = .iqiyi
    //MARK: const vars
    fileprivate let kAnimationDuritionNormal = 0.5
    fileprivate let kAnimationDuritionPosition = 0.3
    fileprivate let kAnimationDuritionYouku = 0.35
    
    fileprivate let kColorLine = UIColor(red: 12.0 / 255.0, green: 190.0 / 255.0, blue: 6.0 / 255.0, alpha: 1)
    fileprivate let kColorYoukuBlue = UIColor(red: 87.0 / 255.0, green: 157.0 / 255.0, blue: 254.0 / 255.0, alpha: 1)
    fileprivate let kColorYoukuLightBlue = UIColor(red: 87.0 / 255.0, green: 188.0 / 255.0, blue: 253.0 / 255.0, alpha: 1)
    fileprivate let kColorYoukuRed = UIColor(red: 228.0 / 255.0, green: 35.0 / 255.0, blue: 6.0 / 255.0, alpha: 0.8)
    
    fileprivate let kAnimationNameTriangle = "kAnimationNameTriangle"
    fileprivate let kAnimationNameRightLine = "kAnimationNameRightLine"
    
    //MARK: public properties
    public var buttonState = LSPlayButtonState.pause {
        didSet {
            if isAnimating {
                return
            }
            
            if buttonState == .play {
                isAnimating = true
                if buttonStyle == .iqiyi {
                    pauseToPlayLineAnimation()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionPosition, execute: { [weak self] in
                        self?.pauseToPlayNormalAnimation()
                    })
                } else if buttonStyle == .youku {
                    youkuPauseToPlayAnimation()
                }
            } else if buttonState == .pause {
                isAnimating = true
                if buttonStyle == .iqiyi {
                    playToPauseLineAnimation()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionPosition, execute: { [weak self] in
                        self?.playToPauseNormalAnimation()
                    })
                } else if buttonStyle == .youku {
                    youkuPlayToPauseAnimation()
                }
            }
            
            let totalAnimationDurition = kAnimationDuritionPosition + kAnimationDuritionNormal
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + totalAnimationDurition) { [weak self] in
                self?.isAnimating = false
            }
        }
    }
    
    //MARK: lifecycle
    public init(frame: CGRect, style: LSPlayButtonStyle = .iqiyi, state: LSPlayButtonState = .pause) {
        super.init(frame: frame)
        frameWidth = frame.width
        buttonStyle = style
        
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
        if buttonStyle == .iqiyi {
            createTriangle()
            createLeftLine()
            createRightLine()
            createCircle()
        } else if buttonStyle == .youku {
            createYoukuLeftLine()
            createYoukuLeftCircle()
            createYoukuRightLine()
            createYoukuRightCircle()
            createYoukuCenterTriangle()
        }
    }
    
    //MARK: UI style of iQiYi
    private func createTriangle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.2))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: 0.0))
        path.addLine(to: CGPoint(x: frameWidth, y: frameWidth * 0.5))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.2))
        
        config(layer: triangleLayer, with: path)
        triangleLayer.lineCap = kCALineCapButt
        triangleLayer.strokeEnd = 0.0
    }
    
    private func createLeftLine() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.2, y: 0.0))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth))
        
        config(layer: leftLineLayer, with: path)
    }
    
    private func createRightLine() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.8, y: 0.0))
        path.addLine(to: CGPoint(x: frameWidth * 0.8, y: frameWidth))
        
        config(layer: rightLineLayer, with: path)
    }
    
    private func createCircle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.8, y: frameWidth * 0.8))
        path.addArc(withCenter: CGPoint(x: frameWidth * 0.5, y: frameWidth * 0.8), radius: frameWidth * 0.3, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: true)
        
        config(layer: circleLayer, with: path)
        circleLayer.strokeEnd = 0.0
    }
    
    private func config(layer: CAShapeLayer, with path: UIBezierPath) {
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = kColorLine.cgColor
        layer.lineWidth = frameWidth * 0.2
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(layer)
    }
    
    //MARK: UI style of YouKu
    private func createYoukuLeftLine() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.9))
        path.addLine(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.1))
        
        youkuConfig(layer: youkuLeftLineLayer, with: path)
    }
    
    private func createYoukuLeftCircle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.2, y: frameWidth * 0.9))
        let startAngle = acos(4.0 / 5.0) + Double.pi / 2
        let endAngle = startAngle - Double.pi
        path.addArc(withCenter: CGPoint(x: frameWidth * 0.5, y: frameWidth * 0.5), radius: frameWidth * 0.5, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
        
        youkuConfig(layer: youkuLeftCircleLayer, with: path)
        youkuLeftCircleLayer.strokeColor = kColorYoukuLightBlue.cgColor
        youkuLeftCircleLayer.strokeEnd = 0.0
    }
    
    private func createYoukuRightLine() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.8, y: frameWidth * 0.1))
        path.addLine(to: CGPoint(x: frameWidth * 0.8, y: frameWidth * 0.9))
        
        youkuConfig(layer: youkuRightLineLayer, with: path)
    }
    
    private func createYoukuRightCircle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frameWidth * 0.8, y: frameWidth * 0.1))
        let startAngle = -asin(4.0 / 5.0)
        let endAngle = startAngle - Double.pi
        path.addArc(withCenter: CGPoint(x: frameWidth * 0.5, y: frameWidth * 0.5), radius: frameWidth * 0.5, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
        
        youkuConfig(layer: youkuRightCircleLayer, with: path)
        youkuRightCircleLayer.strokeColor = kColorYoukuLightBlue.cgColor
        youkuRightCircleLayer.strokeEnd = 0.0
    }
    
    private func createYoukuCenterTriangle() {
        youkuTriangleLayer.bounds = CGRect(x: 0.0, y: 0.0, width: frameWidth * 0.4, height: frameWidth * 0.35)
        youkuTriangleLayer.position = CGPoint(x: frameWidth * 0.5, y: frameWidth * 0.55)
        youkuTriangleLayer.opacity = 0.0
        layer.addSublayer(youkuTriangleLayer)
        
        let triangleWidth = youkuTriangleLayer.bounds.width
        let triangleHeight = youkuTriangleLayer.bounds.height
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0.0, y: 0.0))
        path1.addLine(to: CGPoint(x: triangleWidth / 2.0, y: triangleHeight))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: triangleWidth, y: 0.0))
        path2.addLine(to: CGPoint(x: triangleWidth / 2.0, y: triangleHeight))
        
        let shapeLayer1 = CAShapeLayer()
        youkuConfig(layer: shapeLayer1, with: path1, on: youkuTriangleLayer)
        shapeLayer1.strokeColor = kColorYoukuRed.cgColor
        shapeLayer1.strokeEnd = 1.0
        
        let shapeLayer2 = CAShapeLayer()
        youkuConfig(layer: shapeLayer2, with: path2, on: youkuTriangleLayer)
        shapeLayer2.strokeColor = kColorYoukuRed.cgColor
        shapeLayer2.strokeEnd = 1.0
    }
    
    private func youkuConfig(layer: CAShapeLayer, with path: UIBezierPath) {
        youkuConfig(layer: layer, with: path, on: self.layer)
    }
    
    private func youkuConfig(layer: CAShapeLayer, with path: UIBezierPath, on supperLayer: CALayer) {
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = kColorYoukuBlue.cgColor
        layer.lineWidth = frameWidth * 0.18
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        
        supperLayer.addSublayer(layer)
    }
    
    //MARK: Animation Implemation of iQiYi
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
    
    //MARK: Animation implemation of YouKu
    private func rotateAnimation(isClockwise: Bool) {
        var startAngle = 0.0
        var endAngle = -(Double.pi / 2.0)
        var animationDuration = kAnimationDuritionYouku * 0.75
        if isClockwise {
            startAngle = -(Double.pi / 2.0)
            endAngle = 0.0
            animationDuration = kAnimationDuritionYouku
        }
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.duration = animationDuration
        rotateAnimation.fromValue = startAngle
        rotateAnimation.toValue = endAngle
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.setValue("rotateAnimation", forKey: "animationName")
        layer.add(rotateAnimation, forKey: nil)
    }
    
    private func triangleAlphaAnimation(from: CGFloat, to: CGFloat, duration: Double) {
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.duration = CFTimeInterval(duration)
        alphaAnimation.fromValue = from
        alphaAnimation.toValue = to
        alphaAnimation.fillMode = kCAFillModeForwards
        alphaAnimation.isRemovedOnCompletion = false
        alphaAnimation.setValue("alphaAnimation", forKey: "animationName")
        youkuTriangleLayer.add(alphaAnimation, forKey: nil)
    }
    
    private func youkuPauseToPlayAnimation() {
        strokeEndAnimation(from: 1.0, to: 0.0, on: youkuLeftLineLayer, name: nil, duration: kAnimationDuritionYouku / 2.0, delegate: nil)
        strokeEndAnimation(from: 1.0, to: 0.0, on: youkuRightLineLayer, name: nil, duration: kAnimationDuritionYouku / 2.0, delegate: nil)
        strokeEndAnimation(from: 0.0, to: 1.0, on: youkuLeftCircleLayer, name: nil, duration: kAnimationDuritionYouku, delegate: nil)
        strokeEndAnimation(from: 0.0, to: 1.0, on: youkuRightCircleLayer, name: nil, duration: kAnimationDuritionYouku, delegate: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionYouku * 0.25) { [weak self] in
            if let strongSelf = self {
                strongSelf.rotateAnimation(isClockwise: false)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionYouku * 0.5) { [weak self] in
            if let strongSelf = self {
                strongSelf.triangleAlphaAnimation(from: 0.0, to: 1.0, duration: strongSelf.kAnimationDuritionYouku * 0.5)
            }
        }
    }
    
    private func youkuPlayToPauseAnimation() {
        strokeEndAnimation(from: 1.0, to: 0.0, on: youkuRightCircleLayer, name: nil, duration: kAnimationDuritionYouku, delegate: nil)
        strokeEndAnimation(from: 1.0, to: 0.0, on: youkuLeftCircleLayer, name: nil, duration: kAnimationDuritionYouku, delegate: nil)
        triangleAlphaAnimation(from: 1.0, to: 0.0, duration: kAnimationDuritionYouku * 0.5)
        rotateAnimation(isClockwise: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuritionYouku * 0.5) { [weak self] in
            if let strongSelf = self {
                strongSelf.strokeEndAnimation(from: 0.0, to: 1.0, on: strongSelf.youkuLeftLineLayer, name: nil, duration: strongSelf.kAnimationDuritionYouku * 0.5, delegate: nil)
                strongSelf.strokeEndAnimation(from: 0.0, to: 1.0, on: strongSelf.youkuRightLineLayer, name: nil, duration: strongSelf.kAnimationDuritionYouku * 0.5, delegate: nil)
            }
        }
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
