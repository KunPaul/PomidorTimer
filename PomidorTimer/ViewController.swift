//
//  ViewController.swift
//  PomidorTimer
//
//  Created by Павел Кунгурцев on 20.05.2022.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    @IBAction func cancelButton(_ sender: Any) {
        stopAnimation()
        cancel.isEnabled = false
        cancel.alpha = 0.5
        start.setTitle("Начать  ", for: .normal)
        start.setTitleColor(UIColor.white, for: .normal)
        timer.invalidate()
        time = 1500
        isTimerStarted = false
        timeLabel.text = "25:00"
    }
    
    @IBAction func startButton(_ sender: Any) {
        cancel.isEnabled = true
        cancel.alpha = 1.0
        if !isTimerStarted {
            drawForeLayer()
            startResumeAnimation()
            startTimer()
            isTimerStarted = true
            start.setTitle("Пауза", for: .normal)
            start.setTitleColor(UIColor.black, for: .normal)
        } else  {
            
            pauseAnimation()
            timer.invalidate()
            isTimerStarted = false
            start.setTitle("Продолжить", for: .normal)
            start.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation()
    
    var timer = Timer()
    var isTimerStarted = false
    var isAnimationStarted = false
    var time = 1500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackLayer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
    
         if time < 1 {
            cancel.isEnabled = false
            cancel.alpha = 0.5
            start.setTitle("Пора отдохнуть", for: .normal)
            start.setTitleColor(UIColor.black, for: .normal)
             timer.invalidate()
             time = 300
             isTimerStarted = false
             timeLabel.text = "5:00"
        } else {
            time -= 1
            timeLabel.text = formatTimer()
        }
        
        
    }
    func formatTimer() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
// background
    func drawBackLayer() {
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 100,
                                              startAngle: -90.degreesToRadians,
                                              endAngle: 270.degreesToRadians,
                                              clockwise: true).cgPath
        backProgressLayer.strokeColor = UIColor.white.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 15
        view.layer.addSublayer(backProgressLayer)
    }
    
    func drawForeLayer() {
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 100,
                                              startAngle: -90.degreesToRadians,
                                              endAngle: 270.degreesToRadians,
                                              clockwise: true).cgPath
        foreProgressLayer.strokeColor = UIColor.red.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 15
        view.layer.addSublayer(foreProgressLayer)
    }
    
    func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }
    
    
    func startAnimation() {
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1500
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }
    
    func resetAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    
    func pauseAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }
    
    
    func resumeAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(),from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }
    
    func stopAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
    
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }

} // end of ViewCon

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

