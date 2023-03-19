//
//  SpinnerView.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit

@IBDesignable
class SpinnerView: UIView {
    private var trackCircleLayer = CAShapeLayer()
    private var dynamicCircleLayer = CAShapeLayer()

    private var isPauseAnim: Bool = false

    var lineWidth: CGFloat = 2
    var dynamicStrokeColor: UIColor = .red {
        didSet {
            dynamicCircleLayer.strokeColor = dynamicStrokeColor.cgColor
        }
    }

    var trackStrokeColor: UIColor = .clear {
        didSet {
            trackCircleLayer.strokeColor = self.trackStrokeColor.cgColor
        }
    }

    override func didMoveToWindow() {
        animate()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setPath()
    }

    private func setPath() {
        trackCircleLayer.removeFromSuperlayer()
        trackCircleLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: self.lineWidth / 2, dy: self.lineWidth / 2)).cgPath
        trackCircleLayer.lineWidth = self.lineWidth
        trackCircleLayer.strokeColor = trackStrokeColor.cgColor
        trackCircleLayer.fillColor = nil
        layer.addSublayer(trackCircleLayer)

        dynamicCircleLayer.removeFromSuperlayer()
        dynamicCircleLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: self.lineWidth / 2, dy: self.lineWidth / 2)).cgPath
        dynamicCircleLayer.strokeColor = dynamicStrokeColor.cgColor
        dynamicCircleLayer.lineWidth = self.lineWidth
        dynamicCircleLayer.fillColor = nil
        dynamicCircleLayer.lineCap = .round

        layer.addSublayer(dynamicCircleLayer)
    }

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7)
            ]
        }
    }

    // MARK: - Public functions
    func animate() {
        guard isPauseAnim == false else {
            self.resumeAnimationLayer(layer: dynamicCircleLayer)
            self.resumeAnimationLayer(layer: self.layer)
            return
        }

        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateRotation(duration: totalSeconds, times: times, values: rotations)
    }

    func stopAnimate() {
        pauseAnimationLayer(layer: dynamicCircleLayer)
        pauseAnimationLayer(layer: self.layer)
    }

    // MARK: - Private functions
    private func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        dynamicCircleLayer.add(animation, forKey: animation.keyPath)
    }

    private func animateRotation(duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

    private func pauseAnimationLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime

        isPauseAnim = true
    }

    private func resumeAnimationLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause

        isPauseAnim = false
    }
}
