//
//  FaceView.swift
//  FaceIt
//
//  Created by Andrea Visini on 15/07/18.
//  Copyright © 2018 Andrea Visini. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    var scaleFactor: CGFloat = 0.9
    var pathWidth: CGFloat = 5.0
    var color: UIColor = UIColor.blue
    var mouthCurvature = 0.9
    var eyeOpen = false
    var eyeBrowTilt = -0.5
    
    
    private var skullCenter: CGPoint {
        return  CGPoint(x: bounds.midX, y: bounds.midY)
    }
    private var skullRadius: CGFloat {
        return min(bounds.size.width,bounds.size.height)/2 * scaleFactor
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2*Double.pi),
            clockwise: true
        )
        
        path.lineWidth = pathWidth
        return path
    }
    
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        if eyeOpen {
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = pathWidth
            return path
        }
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        
        var tilt = eyeBrowTilt
        
        switch eye {
        case .Left: tilt *= -1
        case .Right: break
        }
        
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y = skullRadius / Ratios.SkullRadiusToBrowOffset
        
        let path = UIBezierPath()
       // path.move(to: )
        path.lineWidth = pathWidth
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth/2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthHeight
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthWidth/3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthWidth/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = pathWidth
        
        return path
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
       
        color.set()
        
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        
    }
    
    
}
