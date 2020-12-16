//
//  CircularProgressView.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 11/30/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    @IBOutlet weak var circleView: UIView!
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var textLayer = CATextLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCircleProgressView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCircleProgressView()
    }
    
    private func initCircleProgressView() {
        #warning(".xib file is empty")
        
        Bundle.main.loadNibNamed("CircularProgressView", owner: self, options: nil)
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width / 2
        
        trackLayer = createTrackLayer()
        
        layer.addSublayer(trackLayer)
        
        progressLayer = createProgressLayer()
        
        layer.addSublayer(progressLayer)
        
        textLayer = createTextLayer(textColor: UIColor.black)
        
        layer.addSublayer(textLayer)
        
        addSubview(circleView)
        
        circleView.frame = self.bounds
        circleView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
            didProgressUpdated()
        }
    }
    
    var progressColor = UIColor.white {
        didSet {
            print(progressColor.cgColor)
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.gray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    private func createCircularPath() -> UIBezierPath {
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2,
                                      startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        return circlePath
        
    }
    
    private func createTrackLayer() -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        
        let circlePath = createCircularPath()
        
        layer.path = circlePath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = trackColor.cgColor
        layer.lineWidth = 10.0
        layer.strokeEnd = 1.0
        
        return layer
    }
    
    private func createProgressLayer() -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        
        let circlePath = createCircularPath()
        
        layer.path = circlePath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressColor.cgColor
        layer.lineWidth = 10.0
        layer.strokeEnd = progress
        
        return layer
    }
    
    private func createTextLayer(textColor: UIColor) -> CATextLayer {
        
        let width = frame.size.width
        let height = frame.size.height
        
        let fontSize = min(width, height) / 4
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "\(Int(progress * 100))%"
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = textColor.cgColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: width / 4, y: (height - fontSize - offset) / 2, width: width / 2, height: height / 2)
        layer.alignmentMode = .center
        
        return layer
    }
    
    private func didProgressUpdated() {
        
        textLayer.string = "\(Int(progress * 100))%"
        progressLayer.strokeEnd = progress
        
        switch progress {
        case 0...0.35:
            progressLayer.strokeColor = UIColor.red.cgColor
            trackLayer.strokeColor = UIColor(red: 0.3255, green: 0.0902, blue: 0.2118, alpha: 1.0).cgColor
        case 0.36...0.74:
            progressLayer.strokeColor = UIColor.yellow.cgColor
            trackLayer.strokeColor = UIColor(red: 0.251, green: 0.2314, blue: 0.0941, alpha: 1.0).cgColor
        case 0.75...1:
            progressLayer.strokeColor = UIColor.green.cgColor
            trackLayer.strokeColor = UIColor(red: 0.1373, green: 0.2549, blue: 0.2196, alpha: 1.0).cgColor
        default:
            progressLayer.strokeColor = UIColor.gray.cgColor
        }
    }
    
    func setProgressWithAnimation(duration: TimeInterval) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = progress
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        progressLayer.strokeEnd = CGFloat(progress)
        
        progressLayer.add(animation, forKey: "animateprogress")
        
    }
}
