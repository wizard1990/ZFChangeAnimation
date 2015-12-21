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

private let kStep1Duration = 0.5
private let kStep2Duration = 0.5
private let kStep3Duration = 5.0
private let kStep4Duration = 5.0

private let kTopY = kRaduis - kLineGapHeight
private let kCenterY = kRaduis + kLineHeight
private let kBottomY = kRaduis + kLineGapHeight + 2 * kLineHeight
private let degreeToRadians: (Int -> Double) = {(M_PI * (Double($0)) / 180.0)}

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

}

// calculation methods
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

}

// animations
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
        animationGroup.setValue("animationStep1", forKey: "animationName")
        changedLayer.strokeEnd = 0.4
        changedLayer.position.x = -10
        changedLayer.addAnimation(animationGroup, forKey: "centerLineShift")
    }
}