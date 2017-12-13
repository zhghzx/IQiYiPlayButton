//
//  IQiYiPlayButton.swift
//  IQiYiPlayButton_Swift
//
//  Created by zhangxing on 2017/12/8.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

import UIKit

enum IQiYiPlayButtonState {
    case pause
    case play
}

class IQiYiPlayButton: UIButton, CAAnimationDelegate {
    //按钮状态
    var buttonState: IQiYiPlayButtonState? {
        willSet(newValue) {
            if self.isAnimating || newValue == nil {
                return;
            }
            self.isAnimating = true
            if newValue == .pause {
                //播放->暂停
                self.positiveLineAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(positionAnimationDuration)) {
                    self.positiveTransformAnimation()
                }
            }   else {
                //暂停->播放
                self.inverseTransformAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(transformanimationDuration)) {
                    self.inverseLineAnimation()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(positionAnimationDuration + transformanimationDuration)) {
            self.isAnimating = false
            }
        }
    }
    //变形时长
    let transformanimationDuration: CGFloat = 0.5
    //线条位移时长
    let positionAnimationDuration: CGFloat = 0.3
    //线条颜色
    let lineColor = UIColor(red:12/255.0, green:190/255.0, blue:6/255.0, alpha:1)
    //三角行动画名称
    let triangleAnimationName = "TriangleAnimationName"
    //右侧直线动画名称
    let rightLineAnimationName  = "RightLineAnimationName"
    //是否正在执行动画
    var isAnimating = false
    //右侧竖线
    var rightLineLayer: CAShapeLayer?
    //左侧竖线
    var leftLineLayer: CAShapeLayer?
    //三角形
    var triangLayer: CAShapeLayer?
    //弧线
    var arcLayer: CAShapeLayer?
    convenience init(frame: CGRect, state: IQiYiPlayButtonState) {
        self.init(frame: frame)
        buttonState = state
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -
    //MARK: 创建layer
    func setupUI() {
        self.setLeftLineLayer()
        self.setRightLineLayer()
        self.setTriangleLayer()
        self.setArcLayer()
    }
    
    func setLeftLineLayer() {
        let a = self.bounds.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.2 * a, y: 0))
        path.addLine(to: CGPoint(x: 0.2 * a, y: a))
        self.leftLineLayer = CAShapeLayer()
        if self.buttonState == .pause {
            self.leftLineLayer?.strokeEnd = 0
        }
        self.setupLayer(layer: self.leftLineLayer!, path: path.cgPath, lineCap: kCALineCapRound)
    }
    
    func setRightLineLayer() {
        let a = self.bounds.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.8 * a, y: a))
        path.addLine(to: CGPoint(x: 0.8 * a, y: 0))
        self.rightLineLayer = CAShapeLayer()
        self.setupLayer(layer: self.rightLineLayer!, path: path.cgPath, lineCap: kCALineCapRound)
        if self.buttonState == .pause {
            self.rightLineLayer?.strokeEnd = 0
        }
    }
    
    func setTriangleLayer() {
        let a = self.bounds.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.2 * a, y: 0.2 * a))
        path.addLine(to: CGPoint(x: 0.2 * a, y: 0))
        path.addLine(to: CGPoint(x: a, y: 0.5 * a))
        path.addLine(to: CGPoint(x: 0.2 * a, y: a))
        path.addLine(to: CGPoint(x: 0.2 * a, y: 0.2 * a))
        self.triangLayer = CAShapeLayer()
        if self.buttonState == .pause {
            self.triangLayer?.strokeEnd = 1
        } else {
            self.triangLayer?.strokeEnd = 0
        }
        self.setupLayer(layer: self.triangLayer!, path: path.cgPath, lineCap: kCALineCapRound)
    }
    
    func setArcLayer() {
        let a = self.bounds.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.8 * a, y: 0.8 * a))
        path.addArc(withCenter: CGPoint(x: 0.5 * a, y: 0.8 * a), radius: 0.3 * a, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: true)
        self.arcLayer = CAShapeLayer()
        self.arcLayer?.strokeEnd = 0
        self.setupLayer(layer: self.arcLayer!, path: path.cgPath, lineCap: kCALineCapButt)
    }
    
    func setupLayer(layer: CAShapeLayer, path: CGPath, lineCap: String) {
        layer.path = path
        layer.strokeColor = lineColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = lineCap
        layer.lineWidth = self.bounds.size.width * 0.2
        layer.lineJoin = kCALineJoinRound
        self.layer.addSublayer(layer)
    }
    
    //MARK: -
    //MARK: 动画
    //MARK:暂停->播放
    func inverseTransformAnimation() {
        //三角形
        self.strokeEndAnimationFrom(from: 1, to: 0, layer: self.triangLayer!, animationName: triangleAnimationName, duration: transformanimationDuration, delegate: self)
        //左侧竖线
        self.strokeEndAnimationFrom(from: 0, to: 1, layer: self.leftLineLayer!, animationName: nil, duration: transformanimationDuration / 2, delegate: nil)
        //弧线
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(transformanimationDuration / 2)) {
            self.arcStartAnimationFrom(from: 1, to: 0)
        }
        //逆向弧线 右侧竖线
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(transformanimationDuration * 0.75)) {
            //右侧竖线
            self.strokeEndAnimationFrom(from: 0, to: 1, layer: self.rightLineLayer!, animationName: self.rightLineAnimationName, duration: self.transformanimationDuration / 4, delegate: self)
            self.strokeEndAnimationFrom(from: 1, to: 0, layer: self.arcLayer!, animationName: nil, duration: self.transformanimationDuration / 4, delegate: nil)
        }
    }
    
    func strokeEndAnimationFrom(from: CGFloat, to: CGFloat, layer: CAShapeLayer, animationName: String?, duration: CGFloat, delegate: Any?) {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = CFTimeInterval(duration)
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.setValue(animationName, forKey: "animationName")
        animation.delegate = delegate as? CAAnimationDelegate
        layer.add(animation, forKey: nil)
    }
    
    func arcStartAnimationFrom(from: CGFloat, to: CGFloat) {
        let animation = CABasicAnimation.init(keyPath: "strokeStart")
        animation.duration = CFTimeInterval(transformanimationDuration / 4)
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        self.arcLayer?.add(animation, forKey: nil)
    }
    
    //竖线
    func inverseLineAnimation() {
        let a = self.bounds.size.width
        //左侧竖线位移
        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(x: 0.2 * a, y: 0.4 * a))
        leftPath.addLine(to: CGPoint(x: 0.2 * a, y: a))
        self.leftLineLayer?.path = leftPath.cgPath
        self.leftLineLayer?.add(self.pathAnimationWithDuration(duration: positionAnimationDuration / 2), forKey: nil)
        //右侧竖线缩放
        let rightPath = UIBezierPath()
        rightPath.move(to: CGPoint(x: 0.8 * a, y: 0.8 * a))
        rightPath.addLine(to: CGPoint(x: 0.8 * a, y: -0.2 * a))
        self.rightLineLayer?.path = rightPath.cgPath
        self.rightLineLayer?.add(self.pathAnimationWithDuration(duration: positionAnimationDuration / 2), forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(positionAnimationDuration / 2)) {
            //左侧竖线缩放
            let leftPath = UIBezierPath()
            leftPath.move(to: CGPoint(x: 0.2 * a, y: 0))
            leftPath.addLine(to: CGPoint(x: 0.2 * a, y: a))
            self.leftLineLayer?.path = leftPath.cgPath
            self.leftLineLayer?.add(self.pathAnimationWithDuration(duration: self.positionAnimationDuration / 2), forKey: nil)
            //右侧竖线位移
            let rightPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: 0.8 * a, y: a))
            rightPath.addLine(to: CGPoint(x: 0.8 * a, y: 0))
            self.rightLineLayer?.path = rightPath.cgPath
            self.rightLineLayer?.add(self.pathAnimationWithDuration(duration: self.positionAnimationDuration / 2), forKey: nil)
        }
    }
    
    func pathAnimationWithDuration(duration: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "path")
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    //MARK: 播放->暂停
    func positiveLineAnimation() {
        let a = self.bounds.size.width
        //左侧竖线缩放
        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(x: 0.2 * a, y: 0.4 * a))
        leftPath.addLine(to: CGPoint(x: 0.2 * a, y: a))
        self.leftLineLayer?.path = leftPath.cgPath
        self.leftLineLayer?.add(self.pathAnimationWithDuration(duration: positionAnimationDuration / 2), forKey: nil)
        //右侧竖线位移
        let rightPath = UIBezierPath()
        rightPath.move(to: CGPoint(x: 0.8 * a, y: 0.8 * a))
        rightPath.addLine(to: CGPoint(x: 0.8 * a, y: -0.2 * a))
        self.rightLineLayer?.path = rightPath.cgPath
        self.rightLineLayer?.add(self.pathAnimationWithDuration(duration: positionAnimationDuration / 2), forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(positionAnimationDuration / 2)) {
            //左侧竖线位移
            let leftPath = UIBezierPath()
            leftPath.move(to: CGPoint(x: 0.2 * a, y: 0.2 * a))
            leftPath.addLine(to: CGPoint(x: 0.2 * a, y: 0.8 * a))
            self.leftLineLayer?.path = leftPath.cgPath
            self.leftLineLayer?.add(self.pathAnimationWithDuration(duration: self.positionAnimationDuration / 2), forKey: nil)
            //右侧竖线缩放
            let rightPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: 0.8 * a, y: 0.8 * a))
            rightPath.addLine(to: CGPoint(x: 0.8 * a, y: 0.2 * a))
            self.rightLineLayer?.path = rightPath.cgPath
            self.rightLineLayer?.add(self.pathAnimationWithDuration(duration: self.positionAnimationDuration / 2), forKey: nil)
        }
    }
    
    func positiveTransformAnimation() {
        //三角形
        self.strokeEndAnimationFrom(from: 0, to: 1, layer: self.triangLayer!, animationName: triangleAnimationName, duration: transformanimationDuration, delegate: self)
        //右侧竖线
        self.strokeEndAnimationFrom(from: 1, to: 0, layer: self.rightLineLayer!, animationName: rightLineAnimationName, duration: transformanimationDuration / 4, delegate: self)
        //弧线
        self.strokeEndAnimationFrom(from: 0, to: 1, layer: self.arcLayer!, animationName: nil, duration: self.transformanimationDuration / 4, delegate: nil)
        //逆向弧线
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(transformanimationDuration / 4)) {
            self.arcStartAnimationFrom(from: 0, to: 1)
        }
        //左侧竖线
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(transformanimationDuration / 2)) {
            self.strokeEndAnimationFrom(from: 1, to: 0, layer: self.leftLineLayer!, animationName: nil, duration: self.transformanimationDuration / 2, delegate: nil)
        }
    }
    
    //MARK: -
    //MARK: CAAnimationDelegate
    func animationDidStart(_ anim: CAAnimation) {
        let name: String = anim.value(forKey: "animationName") as! String
        let isTriangle = name == triangleAnimationName
        let isRightLine = name == rightLineAnimationName
        if isTriangle {
            self.triangLayer?.lineCap = kCALineCapRound
        } else if isRightLine {
            self.rightLineLayer?.lineCap = kCALineCapRound
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let name: String = anim.value(forKey: "animationName") as! String
        let isTriangle = name == triangleAnimationName
        let isRightLine = name == rightLineAnimationName
        if isRightLine && self.buttonState == .pause {
            self.rightLineLayer?.lineCap = kCALineCapButt
        } else if isTriangle {
            self.triangLayer?.lineCap = kCALineCapButt
        }
    }
}
