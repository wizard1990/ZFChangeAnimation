//
//  ChangeAnimationView.swift
//  ZFChangeAnimation
//
//  Created by Yan Zhang on 12/21/15.
//  Copyright © 2015 Yan Zhang. All rights reserved.
//

import UIKit

//small
//let kRaduis: CGFloat = 20
//let kLineWidth: CGFloat = 20
//let kLineGapHeight: CGFloat = 5
//let kLineHeight: CGFloat = 2

//big
private let kRaduis: CGFloat = 50
private let kLineWidth: CGFloat = 50
private let kLineGapHeight: CGFloat = 10
private let kLineHeight: CGFloat = 8

private let kStep1Duration = 2.5
private let kStep2Duration = 2.5
private let kStep3Duration = 5.0
private let kStep4Duration = 5.0

private let kTopY = kRaduis - kLineGapHeight
private let kCenterY = kRaduis + kLineHeight
private let kBottomY = kRaduis + kLineGapHeight + 2 * kLineHeight
private let degreeToRadians: (Int -> Double) = {(M_PI * (Double($0)) / 180.0)}

private let kAnimationNameKey = "kAnimationName"
private enum AnimationStep: String {
    case step1 = "kAnimationStep1"
    case step2 = "kAnimationStep2"
    case step3 = "kAnimationStep3"
    case step4 = "kAnimationStep4"
}

public class ChangeAnimationView: UIView {

    private var topLineLayer: CAShapeLayer = CAShapeLayer()
    private var bottomLineLayer: CAShapeLayer = CAShapeLayer()
    private var changedLayer: CAShapeLayer = CAShapeLayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orangeColor()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func startAnimation() {
        changedLayer.removeAllAnimations()
        changedLayer.removeFromSuperlayer()
        topLineLayer.removeFromSuperlayer()
        bottomLineLayer.removeFromSuperlayer()

        initLayers()

        animationStep1()
    }

    public func resumeAnimation() {

    }

    public func stopAnimation() {

    }

    // override
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let step = AnimationStep(rawValue: anim.valueForKey(kAnimationNameKey) as? String ?? "") {
            switch step {
            case .step1:
                animationStep2()
            case .step2:
                changedLayer.removeFromSuperlayer()
            case .step3:
                break
            case .step4:
                break
            }
        }
    }

}

// layer methods
private extension ChangeAnimationView {

    // draw top and bottom lines
    func initLayers() {
        topLineLayer = CAShapeLayer()
        bottomLineLayer = CAShapeLayer()
        changedLayer = CAShapeLayer()

        let topLayer = CALayer()
        topLayer.frame = CGRectMake((bounds.width - kLineWidth) / 2, kTopY, kLineWidth, kLineHeight)
        layer.addSublayer(topLayer)

        let bottomLayer = CALayer()
        bottomLayer.frame = CGRectMake((bounds.width - kLineWidth) / 2, kBottomY, kLineWidth, kLineHeight)
        layer.addSublayer(bottomLayer)

        setupShapeLayer(topLineLayer)
        setupShapeLayer(bottomLineLayer)
        setupShapeLayer(changedLayer)
        changedLayer.fillColor = UIColor.clearColor().CGColor

        topLayer.addSublayer(topLineLayer)
        bottomLayer.addSublayer(bottomLineLayer)
        layer.addSublayer(changedLayer)

        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.addLineToPoint(CGPointMake(kLineWidth, 0))
        topLineLayer.path = path.CGPath
        bottomLineLayer.path = path.CGPath


        let startOriginX = center.x - kLineWidth / 2
        let endOriginX = center.x + kLineWidth / 2
        let solidChangedLinePath =  CGPathCreateMutable()
        CGPathMoveToPoint(solidChangedLinePath, nil, startOriginX, kCenterY)
        CGPathAddLineToPoint(solidChangedLinePath, nil, endOriginX, kCenterY)
        changedLayer.path = solidChangedLinePath
    }

    func setupShapeLayer(shapeLayer: CAShapeLayer) {
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.contentsScale = UIScreen.mainScreen().scale
        shapeLayer.lineWidth = kLineHeight
        shapeLayer.lineCap = kCALineCapRound
    }

    func pauseLayer(layer: CALayer) {
        layer.speed = 0
        let pausedTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.timeOffset = pausedTime
    }

    func resumeLayer(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1
        layer.timeOffset = 0
        layer.beginTime = 0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

}

// animation methods
private extension ChangeAnimationView {

    func animationStep1() {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = NSNumber(float: 1)
        strokeAnimation.toValue = NSNumber(float: 0.4)

        let pathAnimation = CABasicAnimation(keyPath: "position.x")
        pathAnimation.fromValue = NSNumber(float: 0)
        pathAnimation.toValue = NSNumber(float: -10)

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeAnimation, pathAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationGroup.duration = kStep1Duration
        animationGroup.delegate = self
        animationGroup.setValue(AnimationStep.step1.rawValue, forKey: kAnimationNameKey)
        changedLayer.strokeEnd = 0.4
        changedLayer.position.x = -10
        changedLayer.addAnimation(animationGroup, forKey: nil)
    }

    func animationStep2() {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = NSNumber(float: 0.4)
        strokeAnimation.toValue = NSNumber(float: 0)

        let translationAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        translationAnimation.fromValue = NSNumber(float: 0)
        translationAnimation.toValue = NSNumber(float: Float(1.2 * kLineWidth))



        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeAnimation, translationAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animationGroup.duration = kStep2Duration
        animationGroup.delegate = self
        animationGroup.setValue(AnimationStep.step2.rawValue, forKey: kAnimationNameKey)

        changedLayer.strokeEnd = 0.8
        changedLayer.setValue(NSNumber(float: -10), forKey: "transform.translation.x")
        changedLayer.addAnimation(animationGroup, forKey: nil)
    }

}